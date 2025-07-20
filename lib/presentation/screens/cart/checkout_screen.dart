// lib/presentation/screens/cart/checkout_screen.dart (Simplified)
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/models/cart_model.dart';

class CheckoutScreen extends StatelessWidget {
  final List<CartItem> cartItems;

  const CheckoutScreen({Key? key, required this.cartItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إتمام الطلب'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'شاشة إتمام الطلب\n(سيتم تطويرها لاحقاً)',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
