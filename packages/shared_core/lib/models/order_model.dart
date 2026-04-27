enum OrderStatus { PENDING, ACCEPTED, PICKED, DELIVERED, CANCELLED }

class OrderModel {
  final String orderId;
  final String customerId;
  final String restaurantId;
  final String? riderId;
  final List<dynamic> items; 
  final String paymentMethod;
  final OrderStatus orderStatus;
  final double subTotal;
  final double deliveryFee;
  final double total;
  final String type; // 'DELIVERY' ou 'DINE_IN'
  final String? tableNumber;
  final DateTime createdAt;

  OrderModel({
    required this.orderId,
    required this.customerId,
    required this.restaurantId,
    this.riderId,
    required this.items,
    required this.paymentMethod,
    required this.orderStatus,
    required this.subTotal,
    required this.deliveryFee,
    required this.total,
    required this.type,
    this.tableNumber,
    required this.createdAt,
  });

  factory OrderModel.fromMap(String id, Map<String, dynamic> map) {
    return OrderModel(
      orderId: id,
      customerId: map['customerId'] ?? '',
      restaurantId: map['restaurantId'] ?? '',
      riderId: map['riderId'],
      items: map['items'] ?? [],
      paymentMethod: map['paymentMethod'] ?? 'CASH',
      orderStatus: OrderStatus.values.firstWhere((e) => e.name == map['orderStatus'], orElse: () => OrderStatus.PENDING),
      subTotal: (map['subTotal'] ?? 0.0).toDouble(),
      deliveryFee: (map['deliveryFee'] ?? 0.0).toDouble(),
      total: (map['total'] ?? 0.0).toDouble(),
      type: map['type'] ?? 'DELIVERY',
      tableNumber: map['tableNumber'],
      createdAt: map['createdAt'] != null ? (map['createdAt'] as dynamic).toDate() : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'customerId': customerId,
      'restaurantId': restaurantId,
      'riderId': riderId,
      'items': items,
      'paymentMethod': paymentMethod,
      'orderStatus': orderStatus.name,
      'subTotal': subTotal,
      'deliveryFee': deliveryFee,
      'total': total,
      'type': type,
      'tableNumber': tableNumber,
      'createdAt': createdAt,
    };
  }
}
