import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/restaurant_model.dart';
import '../models/food_model.dart';
import '../models/order_model.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- Restaurantes ---
  
  // Buscar restaurantes abertos e ativos
  Stream<List<RestaurantModel>> getActiveRestaurants() {
    return _db
        .collection('restaurants')
        .where('isOpen', '==', true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => RestaurantModel.fromMap(doc.id, doc.data()))
            .toList());
  }

  // Buscar restaurante por ID
  Future<RestaurantModel?> getRestaurantById(String id) async {
    DocumentSnapshot doc = await _db.collection('restaurants').doc(id).get();
    if (doc.exists) {
      return RestaurantModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  // --- Produtos (Foods) ---

  // Buscar produtos de um restaurante
  Stream<List<FoodModel>> getFoodsByRestaurant(String restaurantId) {
    return _db
        .collection('foods')
        .where('restaurantId', '==', restaurantId)
        .where('isAvailable', '==', true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FoodModel.fromMap(doc.id, doc.data()))
            .toList());
  }

  // --- Pedidos (Orders) ---

  // --- Gestão de Mesas e Dine-in ---

  // --- Controle de Estoque (Inventory) ---

  Future<void> updateInventory(List<Map<String, dynamic>> items) async {
    for (var item in items) {
      final name = item['name'] as String;
      final quantity = item['quantity'] as int;

      // Busca item no estoque pelo nome (simplificado)
      final query = await _db.collection('inventory').where('name', isEqualTo: name).get();
      if (query.docs.isNotEmpty) {
        final doc = query.docs.first;
        final currentStock = doc.data()['stock'] as int;
        await doc.reference.update({
          'stock': currentStock - quantity,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    }
  }

  // --- Pagamentos (Payments) ---

  Future<Map<String, dynamic>> generatePix(double amount) async {
    // Simula geração de QR Code Pix
    await Future.delayed(const Duration(seconds: 1));
    return {
      'payload': '00020126580014BR.GOV.BCB.PIX0136velox-pix-key-1235204000053039865408.005802BR5913VELOX DELIVERY6008SAO PAULO62070503***6304E882',
      'qrCodeUrl': 'https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=velox-pix-simulation',
      'expiresAt': DateTime.now().add(const Duration(minutes: 30)).toIso8601String(),
    };
  }

  // Atualizar status de uma mesa
  Future<void> updateTableStatus(String tableId, String status) async {
    await _db.collection('tables').doc(tableId).update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Notificar garçom (Chamar Garçom)
  Future<void> notifyWaiter({
    required String restaurantId,
    required String tableNumber,
    required String type, // 'CALL_WAITER' ou 'BILL_REQUEST'
    String? message,
  }) async {
    await _db.collection('notifications').add({
      'restaurantId': restaurantId,
      'tableNumber': tableNumber,
      'type': type,
      'message': message ?? (type == 'CALL_WAITER' ? 'Solicitado na Mesa $tableNumber' : 'Pedido de conta na Mesa $tableNumber'),
      'createdAt': FieldValue.serverTimestamp(),
      'read': false,
    });
  }

  // Criar um novo pedido
  Future<String> createOrder(OrderModel order) async {
    DocumentReference ref = await _db.collection('orders').add(order.toMap());
    
    final orderData = order.toMap();
    
    // Notificação para Restaurante e Garçom se for pedido de mesa
    if ((orderData['type'] ?? '') == 'DINE_IN') {
      await notifyWaiter(
        restaurantId: order.restaurantId,
        tableNumber: orderData['tableNumber'] ?? '?',
        type: 'DINE_IN',
        message: 'Novo pedido na Mesa ${orderData['tableNumber']}',
      );

      // Opcional: Atualizar mesa para 'busy/new_order'
      // Precisamos do ID da mesa. Se não tivermos, buscamos pelo número.
    }
    
    return ref.id;
  }

  // Método auxiliar para streams genéricos (usado no app cliente)
  Stream<QuerySnapshot> getCollection(String path) {
    return _db.collection(path).snapshots();
  }

  // Stream de pedidos do cliente (Tempo Real)
  Stream<List<OrderModel>> getCustomerOrders(String customerId) {
    return _db
        .collection('orders')
        .where('customerId', '==', customerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => OrderModel.fromMap(doc.id, doc.data()))
            .toList());
  }
}
