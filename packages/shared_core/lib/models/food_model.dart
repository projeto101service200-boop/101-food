class FoodVariation {
  final String title;
  final double price;

  FoodVariation({required this.title, required this.price});

  factory FoodVariation.fromMap(Map<String, dynamic> map) {
    return FoodVariation(
      title: map['title'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() => {'title': title, 'price': price};
}

class FoodModel {
  final String id;
  final String restaurantId;
  final String categoryId;
  final String name;
  final String description;
  final String? image;
  final double basePrice;
  final List<FoodVariation> variations;
  final List<String> addons;
  final bool isAvailable;

  FoodModel({
    required this.id,
    required this.restaurantId,
    required this.categoryId,
    required this.name,
    required this.description,
    this.image,
    required this.basePrice,
    this.variations = const [],
    this.addons = const [],
    this.isAvailable = true,
  });

  factory FoodModel.fromMap(String docId, Map<String, dynamic> map) {
    return FoodModel(
      id: docId,
      restaurantId: map['restaurantId'] ?? '',
      categoryId: map['categoryId'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      image: map['image'],
      basePrice: (map['basePrice'] ?? 0.0).toDouble(),
      variations: (map['variations'] as List? ?? [])
          .map((v) => FoodVariation.fromMap(v))
          .toList(),
      addons: List<String>.from(map['addons'] ?? []),
      isAvailable: map['isAvailable'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'restaurantId': restaurantId,
      'categoryId': categoryId,
      'name': name,
      'description': description,
      'image': image,
      'basePrice': basePrice,
      'variations': variations.map((v) => v.toMap()).toList(),
      'addons': addons,
      'isAvailable': isAvailable,
    };
  }
}
