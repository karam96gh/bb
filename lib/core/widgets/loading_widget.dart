// lib/presentation/widgets/loading_widget.dart
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSimpleGrid(),
      ],
    );
  }

  Widget _buildSimpleGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return _buildLoadingCard();
      },
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant.withOpacity(0.7),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 2,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Brand placeholder
                Container(
                  width: 60,
                  height: 12,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),

                const SizedBox(height: 8),

                // Title placeholder
                Container(
                  width: double.infinity,
                  height: 14,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),

                const SizedBox(height: 4),

                Container(
                  width: 120,
                  height: 14,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),

                const SizedBox(height: 12),

                // Price placeholder
                Container(
                  width: 80,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}