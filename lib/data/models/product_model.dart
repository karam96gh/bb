// lib/data/models/product_model.dart
import 'dart:ui';

import 'package:flutter/material.dart';

class Product {
  final String objectId;
  final String name;
  final String arabicName;
  final String description;
  final String arabicDescription;
  final String categoryId;
  final String categoryName;
  final String brand;
  final double price;
  final List<String> images;
  final List<ProductColor> colors;
  final List<String> skinTypes;
  final Map<String, int> suitableFor;
  final List<String> features;
  final String ingredients;
  final String usage;
  final List<String> benefits;
  final List<String> problemsSolved;
  final List<String> occasion;
  final String finish;
  final bool isActive;
  final String stockStatus;
  final double rating;
  final int reviewsCount;
  final DateTime createdAt;

  Product({
    required this.objectId,
    required this.name,
    required this.arabicName,
    required this.description,
    required this.arabicDescription,
    required this.categoryId,
    this.categoryName = '',
    required this.brand,
    required this.price,
    required this.images,
    required this.colors,
    required this.skinTypes,
    required this.suitableFor,
    required this.features,
    required this.ingredients,
    required this.usage,
    required this.benefits,
    required this.problemsSolved,
    required this.occasion,
    required this.finish,
    required this.isActive,
    required this.stockStatus,
    required this.rating,
    required this.reviewsCount,
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      objectId: json['objectId'] ?? '',
      name: json['name'] ?? '',
      arabicName: json['arabicName'] ?? '',
      description: json['description'] ?? '',
      arabicDescription: json['arabicDescription'] ?? '',
      categoryId: json['category']?['objectId'] ?? '',
      categoryName: json['category']?['arabicName'] ?? '',
      brand: json['brand'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      images: List<String>.from(json['images'] ?? []),
      colors: (json['colors'] as List? ?? [])
          .map((color) => ProductColor.fromJson(color))
          .toList(),
      skinTypes: List<String>.from(json['skinTypes'] ?? []),
      suitableFor: Map<String, int>.from(json['suitableFor'] ?? {}),
      features: List<String>.from(json['features'] ?? []),
      ingredients: json['ingredients'] ?? '',
      usage: json['usage'] ?? '',
      benefits: List<String>.from(json['benefits'] ?? []),
      problemsSolved: List<String>.from(json['problems_solved'] ?? []),
      occasion: List<String>.from(json['occasion'] ?? []),
      finish: json['finish'] ?? '',
      isActive: json['isActive'] ?? true,
      stockStatus: json['stockStatus'] ?? 'in_stock',
      rating: (json['rating'] ?? 0).toDouble(),
      reviewsCount: json['reviewsCount'] ?? 0,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'objectId': objectId,
      'name': name,
      'arabicName': arabicName,
      'description': description,
      'arabicDescription': arabicDescription,
      'category': {'__type': 'Pointer', 'className': 'Categories', 'objectId': categoryId},
      'brand': brand,
      'price': price,
      'images': images,
      'colors': colors.map((color) => color.toJson()).toList(),
      'skinTypes': skinTypes,
      'suitableFor': suitableFor,
      'features': features,
      'ingredients': ingredients,
      'usage': usage,
      'benefits': benefits,
      'problems_solved': problemsSolved,
      'occasion': occasion,
      'finish': finish,
      'isActive': isActive,
      'stockStatus': stockStatus,
      'rating': rating,
      'reviewsCount': reviewsCount,
    };
  }

  // Helper methods
  bool get isInStock => stockStatus == 'in_stock';
  bool get isOutOfStock => stockStatus == 'out_of_stock';
  String get displayPrice => '${price.toStringAsFixed(0)} ر.س';
  String get ratingText => rating > 0 ? rating.toStringAsFixed(1) : 'جديد';

  // Check if product is suitable for specific skin type
  bool isSuitableForSkinType(String skinType) {
    return skinTypes.contains(skinType) || suitableFor[skinType] != null;
  }

  // Get suitability score for skin type
  int getSuitabilityScore(String skinType) {
    return suitableFor[skinType] ?? 0;
  }
}

class ProductColor {
  final String name;
  final String arabicName;
  final String hexCode;
  final bool isAvailable;

  ProductColor({
    required this.name,
    required this.arabicName,
    required this.hexCode,
    this.isAvailable = true,
  });

  factory ProductColor.fromJson(Map<String, dynamic> json) {
    return ProductColor(
      name: json['name'] ?? '',
      arabicName: json['arabicName'] ?? '',
      hexCode: json['hexCode'] ?? '#000000',
      isAvailable: json['isAvailable'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'arabicName': arabicName,
      'hexCode': hexCode,
      'isAvailable': isAvailable,
    };
  }

  // Helper to get Color object
  Color get color {
    try {
      return Color(int.parse(hexCode.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Colors.grey;
    }
  }
}