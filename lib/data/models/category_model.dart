class Category {
  final String objectId;
  final String name;
  final String arabicName;
  final String description;
  final String arabicDescription;
  final String image;
  final int displayOrder;
  final bool isActive;
  final DateTime createdAt;
  int productCount;

  Category({
    required this.objectId,
    required this.name,
    required this.arabicName,
    required this.description,
    required this.arabicDescription,
    required this.image,
    required this.displayOrder,
    required this.isActive,
    required this.createdAt,
    this.productCount = 0,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      objectId: json['objectId'] ?? '',
      name: json['name'] ?? '',
      arabicName: json['arabicName'] ?? '',
      description: json['description'] ?? '',
      arabicDescription: json['arabicDescription'] ?? '',
      image: json['image'] ?? '',
      displayOrder: json['displayOrder'] ?? 0,
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      productCount: json['productCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'objectId': objectId,
      'name': name,
      'arabicName': arabicName,
      'description': description,
      'arabicDescription': arabicDescription,
      'image': image,
      'displayOrder': displayOrder,
      'isActive': isActive,
      'productCount': productCount,
    };
  }
}