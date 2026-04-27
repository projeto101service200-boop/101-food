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

  // Criar um novo pedido
  Future<String> createOrder(OrderModel order) async {
    DocumentReference ref = await _db.collection('orders').add(order.toMap());
    
    // Notificação para Restaurante e Garçom se for pedido de mesa
    if ((order.toMap()['type'] ?? '') == 'DINE_IN') {
      await _db.collection('notifications').add({
        'restaurantId': order.restaurantId,
        'type': 'DINE_IN',
        'message': 'Novo pedido na Mesa ${order.toMap()['tableNumber']}',
        'orderId': ref.id,
        'createdAt': FieldValue.serverTimestamp(),
        'read': false,
      });
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
