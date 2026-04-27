class RestaurantModel {
  final String id;
  final String ownerId;
  final String name;
  final String? image;
  final String address;
  final Map<String, double> location; // {lat, lng}
  final double deliveryFee;
  final double minOrder;
  final bool isOpen;
  final String? zoneId;
  final double rating;

  RestaurantModel({
    required this.id,
    required this.ownerId,
    required this.name,
    this.image,
    required this.address,
    required this.location,
    this.deliveryFee = 0.0,
    this.minOrder = 0.0,
    this.isOpen = false,
    this.zoneId,
    this.rating = 0.0,
  });

  factory RestaurantModel.fromMap(String docId, Map<String, dynamic> map) {
    return RestaurantModel(
      id: docId,
      ownerId: map['ownerId'] ?? '',
      name: map['name'] ?? '',
      image: map['image'],
      address: map['address'] ?? '',
      location: Map<String, double>.from(map['location'] ?? {'lat': 0.0, 'lng': 0.0}),
      deliveryFee: (map['deliveryFee'] ?? 0.0).toDouble(),
      minOrder: (map['minOrder'] ?? 0.0).toDouble(),
      isOpen: map['isOpen'] ?? false,
      zoneId: map['zoneId'],
      rating: (map['rating'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ownerId': ownerId,
      'name': name,
      'image': image,
      'address': address,
      'location': location,
      'deliveryFee': deliveryFee,
      'minOrder': minOrder,
      'isOpen': isOpen,
      'zoneId': zoneId,
      'rating': rating,
    };
  }
}
