
// lib/presentation/screens/products/products_by_category_screen.dart (Simplified)
import 'package:flutter/material.dart';

import '../../../data/models/category_model.dart';

class ProductsByCategoryScreen extends StatelessWidget {
  final Category category;

  const ProductsByCategoryScreen({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.arabicName),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'منتجات فئة ${category.arabicName}\n(سيتم تطويرها لاحقاً)',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}