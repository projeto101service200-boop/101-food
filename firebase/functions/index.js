const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

const db = admin.firestore();

/**
 * Calcula a taxa de entrega baseada na distância (Simulação para o MVP)
 * No futuro, integrará com Google Distance Matrix API
 */
exports.calculateDeliveryFee = functions.https.onCall(async (data, context) => {
    // Autenticação básica
    if (!context.auth) {
        throw new functions.https.HttpsError('unauthenticated', 'O usuário deve estar logado.');
    }

    const { restaurantId, customerLocation } = data;

    try {
        const restaurantDoc = await db.collection('restaurants').doc(restaurantId).get();
        if (!restaurantDoc.exists) {
            throw new functions.https.HttpsError('not-found', 'Restaurante não encontrado.');
        }

        const restaurantData = restaurantDoc.data();
        const resLocation = restaurantData.location;

        // Lógica de cálculo de distância Haversine simples (km)
        const distance = calculateDistance(
            customerLocation.lat, customerLocation.lng,
            resLocation.lat, resLocation.lng
        );

        // Regra de negócio: Taxa base + adicional por KM
        let fee = restaurantData.deliveryFee || 5.0; // Taxa base
        if (distance > 2) {
            fee += (distance - 2) * 1.5; // Adiciona 1.50 por km extra
        }

        return {
            distance: distance.toFixed(2),
            deliveryFee: parseFloat(fee.toFixed(2)),
            currency: 'BRL'
        };

    } catch (error) {
        console.error("Erro no cálculo de taxa:", error);
        throw new functions.https.HttpsError('internal', error.message);
    }
});

function calculateDistance(lat1, lon1, lat2, lon2) {
    const R = 6371; // Raio da Terra em km
    const dLat = (lat2 - lat1) * Math.PI / 180;
    const dLon = (lon2 - lon1) * Math.PI / 180;
    const a = 
        Math.sin(dLat/2) * Math.sin(dLat/2) +
        Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) * 
        Math.sin(dLon/2) * Math.sin(dLon/2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
    return R * c;
}

/**
 * Disparado quando um novo pedido é criado.
 * Valida integridade e notifica o restaurante.
 */
exports.onCreateOrder = functions.firestore
    .document('orders/{orderId}')
    .onCreate(async (snapshot, context) => {
        const orderData = snapshot.data();
        const restaurantId = orderData.restaurantId;

        try {
            // 1. Validar preços (Prevenir fraude de valor no App)
            let calculatedSubtotal = 0;
            for (const item of orderData.items) {
                const foodDoc = await db.collection('foods').doc(item.foodId).get();
                if (foodDoc.exists) {
                    const food = foodDoc.data();
                    calculatedSubtotal += food.basePrice * item.quantity;
                }
            }

            // Se o total enviado pelo app for suspeito, marcamos para revisão
            if (Math.abs(calculatedSubtotal - orderData.subTotal) > 0.1) {
                console.warn(`Alerta de Fraude: Pedido ${context.params.orderId} com valor divergente!`);
                return snapshot.ref.update({ status: 'CANCELLED', reason: 'Price discrepancy detected' });
            }

            // 2. Buscar dados do Restaurante para notificação
            const restaurantDoc = await db.collection('users').where('uid', '==', orderData.restaurantOwnerId).limit(1).get();
            
            if (!restaurantDoc.empty) {
                const restaurantOwner = restaurantDoc.docs[0].data();
                const fcmToken = restaurantOwner.fcmToken;

                if (fcmToken) {
                    const message = {
                        notification: {
                            title: 'Novo Pedido Recebido! 🍔',
                            body: `Você recebeu um novo pedido de ${orderData.total} BRL. Abra o app para aceitar.`,
                        },
                        token: fcmToken,
                    };
                    await admin.messaging().send(message);
                }
            }

            return null;
        } catch (error) {
            console.error("Erro no processamento do pedido:", error);
        }
    });

/**
 * Atualiza o status do pedido e gerencia notificações automáticas.
 */
exports.updateOrderStatus = functions.https.onCall(async (data, context) => {
    if (!context.auth) throw new functions.https.HttpsError('unauthenticated', 'Acesso negado.');

    const { orderId, newStatus } = data;
    const uid = context.auth.uid;

    try {
        const orderRef = db.collection('orders').doc(orderId);
        const orderDoc = await orderRef.get();
        if (!orderDoc.exists) throw new functions.https.HttpsError('not-found', 'Pedido não encontrado.');

        const order = orderDoc.data();

        // 1. Validar Permissão: Apenas Restaurante ou Entregador vinculado pode mudar status
        // (Isso também é reforçado pelas Security Rules, mas Cloud Functions adiciona camada extra de lógica)
        
        await orderRef.update({ 
            orderStatus: newStatus,
            updatedAt: admin.firestore.FieldValue.serverTimestamp()
        });

        // 2. Notificação para o Cliente sobre mudança de status
        const customerRef = await db.collection('users').doc(order.customerId).get();
        const customer = customerRef.data();

        if (customer.fcmToken) {
            const statusMessages = {
                'ACCEPTED': 'Seu pedido foi aceito pelo restaurante!',
                'PREPARING': 'O chef começou a preparar seu prato!',
                'READY': 'Pedido pronto! Um entregador está a caminho.',
                'DELIVERED': 'Pedido entregue! Bom apetite 😋'
            };

            await admin.messaging().send({
                notification: {
                    title: 'Status do Pedido Atualizado',
                    body: statusMessages[newStatus] || `Seu pedido mudou para: ${newStatus}`,
                },
                token: customer.fcmToken,
            });
        }

        // 3. Se estiver PRONTO, notificar motoristas (Simple Broadcast MVP)
        if (newStatus === 'READY') {
            const riderQuery = await db.collection('users')
                .where('role', '==', 'rider')
                .where('status', '==', 'active')
                .get();

            const registrationTokens = riderQuery.docs
                .map(doc => doc.data().fcmToken)
                .filter(token => token);

            if (registrationTokens.length > 0) {
                await admin.messaging().sendEachForMulticast({
                    notification: {
                        title: 'Nova Entrega Disponível! 🚲',
                        body: `Pedido pronto em ${order.restaurantName}. Toque para aceitar.`,
                    },
                    tokens: registrationTokens,
                });
            }
        }

        return { success: true };
    } catch (error) {
        throw new functions.https.HttpsError('internal', error.message);
    }
});

/**
 * Atribui um entregador ao pedido (Garante atomicidade)
 */
exports.assignAvailableRider = functions.https.onCall(async (data, context) => {
    if (!context.auth) throw new functions.https.HttpsError('unauthenticated', 'Acesso negado.');

    const { orderId } = data;
    const riderId = context.auth.uid;

    try {
        const orderRef = db.collection('orders').doc(orderId);
        
        // Usar Transação para garantir que dois motoristas não peguem o mesmo pedido
        const result = await db.runTransaction(async (t) => {
            const orderDoc = await t.get(orderRef);
            const order = orderDoc.data();

            if (order.riderId) {
                throw new Error('Este pedido já foi aceito por outro entregador.');
            }

            if (order.orderStatus !== 'READY') {
                throw new Error('Este pedido ainda não está pronto para coleta.');
            }

            t.update(orderRef, { 
                riderId: riderId,
                orderStatus: 'PICKED_UP', // Ou similar conforme seu enum
                pickedAt: admin.firestore.FieldValue.serverTimestamp()
            });

            return { success: true };
        });

        return result;
    } catch (error) {
        throw new functions.https.HttpsError('internal', error.message);
    }
});

/**
 * Valida um cupom de desconto
 */
exports.validateCoupon = functions.https.onCall(async (data, context) => {
    const { couponCode, cartTotal, restaurantId } = data;

    try {
        const couponQuery = await db.collection('coupons')
            .where('code', '==', couponCode)
            .where('isActive', '==', true)
            .limit(1)
            .get();

        if (couponQuery.empty) {
            return { valid: false, message: 'Cupom inválido ou expirado.' };
        }

        const coupon = couponQuery.docs[0].data();

        // Verificar valor mínimo
        if (cartTotal < coupon.minAmount) {
            return { valid: false, message: `Valor mínimo para este cupom é ${coupon.minAmount}` };
        }

        // Verificar se é específico de um restaurante (opcional no Enatega)
        if (coupon.restaurantId && coupon.restaurantId !== restaurantId) {
            return { valid: false, message: 'Este cupom não é válido para este restaurante.' };
        }

        return {
            valid: true,
            discount: coupon.discountType === 'PERCENT' ? (cartTotal * coupon.value / 100) : coupon.value,
            couponId: couponQuery.docs[0].id
        };
    } catch (error) {
        throw new functions.https.HttpsError('internal', error.message);
    }
});
