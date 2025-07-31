// lib/presentation/widgets/product_card.dart - مُصلح
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../data/models/product_model.dart';
import '../../logic/providers/cart_provider.dart';
import '../../logic/providers/uth_provider.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final bool showAddToCart;

  const ProductCard({
    Key? key,
    required this.product,
    this.onTap,
    this.showAddToCart = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            _buildProductImage(context),

            // Product Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Brand
                    Text(
                      product.brand,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 2),

                    // Product Name
                    Flexible(
                      child: Text(
                        product.arabicName,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Rating and Reviews
                    if (product.rating > 0)
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 12,
                            color: AppColors.warning,
                          ),
                          const SizedBox(width: 2),
                          Flexible(
                            child: Text(
                              '${product.ratingText} (${product.reviewsCount})',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: AppColors.onSurfaceVariant,
                                fontSize: 9,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                    const Spacer(),

                    // Price and Colors
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 2,
                          child: Text(
                            product.displayPrice,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (product.colors.isNotEmpty)
                          Flexible(
                            flex: 1,
                            child: _buildColorIndicators(),
                          ),
                      ],
                    ),

                    if (showAddToCart) ...[
                      const SizedBox(height: 6),
                      _buildAddToCartButton(context),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        child: Stack(
          children: [
            // Main Image
            product.images.isNotEmpty
                ? CachedNetworkImage(
              imageUrl: product.images.first,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              placeholder: (context, url) => Container(
                color: AppColors.surfaceVariant,
                child: Center(
                  child: Icon(
                    Icons.image,
                    color: AppColors.onSurfaceVariant,
                    size: 30,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: AppColors.surfaceVariant,
                child: Center(
                  child: Icon(
                    Icons.broken_image,
                    color: AppColors.onSurfaceVariant,
                    size: 30,
                  ),
                ),
              ),
            )
                : Container(
              color: AppColors.surfaceVariant,
              child: Center(
                child: Icon(
                  Icons.shopping_bag,
                  color: AppColors.onSurfaceVariant,
                  size: 30,
                ),
              ),
            ),

            // Stock Status Overlay
            if (product.isOutOfStock)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'غير متوفر',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorIndicators() {
    final displayColors = product.colors.take(3).toList();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...displayColors.map((color) {
          return Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.only(left: 1),
            decoration: BoxDecoration(
              color: color.color,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.grey.withOpacity(0.3),
                width: 0.5,
              ),
            ),
          );
        }).toList(),
        if (product.colors.length > 3)
          Text(
            '+${product.colors.length - 3}',
            style: const TextStyle(
              fontSize: 8,
              color: AppColors.onSurfaceVariant,
            ),
          ),
      ],
    );
  }

  Widget _buildAddToCartButton(BuildContext context) {
    return Consumer2<CartProvider, AuthProvider>(
      builder: (context, cartProvider, authProvider, child) {
        return SizedBox(
          width: double.infinity,
          height: 28,
          child: ElevatedButton(
            onPressed: product.isOutOfStock ? null : () => _addToCart(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 4),
            ),
            child: const Text(
              'إضافة للسلة',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      },
    );
  }

  void _addToCart(BuildContext context) {
    final authProvider = context.read<AuthProvider>();

    // Check if user is authenticated
    if (!authProvider.isAuthenticated) {
      _showLoginRequiredDialog(context);
      return;
    }

    if (product.colors.isEmpty) {
      // Add directly if no color options
      _performAddToCart(context, '');
    } else {
      // Show color selection
      _showColorSelection(context);
    }
  }

  void _showLoginRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تسجيل الدخول مطلوب'),
        content: const Text('لإضافة المنتجات للسلة، يجب تسجيل الدخول أولاً'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Navigate to profile/login screen
              Navigator.of(context).pushNamed('/login'); // تأكد من إضافة route
            },
            child: Text(
              'تسجيل الدخول',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  void _showColorSelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'اختاري اللون',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: product.colors.map((color) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      _performAddToCart(context, color.arabicName);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.surfaceVariant,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: color.color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            color.arabicName,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _performAddToCart(BuildContext context, String selectedColor) async {
    final cartProvider = context.read<CartProvider>();
    final authProvider = context.read<AuthProvider>();

    // التحقق من تسجيل الدخول
    if (!authProvider.isAuthenticated || authProvider.userId.isEmpty) {
      print('❌ User not authenticated - userId: ${authProvider.userId}');
      _showLoginRequiredDialog(context);
      return;
    }

    print('🛒 Adding product for user: ${authProvider.userId}');

    final success = await cartProvider.addToCart(
      authProvider.userId, // استخدام المعرف الحقيقي
      product,
      selectedColor,
      addedFrom: 'browse',
    );

    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم إضافة ${product.arabicName} للسلة'),
          backgroundColor: AppColors.success,
          action: SnackBarAction(
            label: 'عرض السلة',
            textColor: Colors.white,
            onPressed: () {
              // Navigate to cart tab
              DefaultTabController.of(context)?.animateTo(1);
            },
          ),
        ),
      );
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(cartProvider.error ?? 'فشل في إضافة المنتج'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}