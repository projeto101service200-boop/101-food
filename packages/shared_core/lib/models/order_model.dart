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
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
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
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
