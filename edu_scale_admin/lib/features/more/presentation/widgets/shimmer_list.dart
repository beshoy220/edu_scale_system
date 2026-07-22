import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../../core/themes/themes.dart';

class ShimmerList extends StatelessWidget {
  const ShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      // color: AppStyle.colors.black,
      enabled: true,
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: List.generate(3, (index) => _buildShimmerTile()),
      ),
    );
  }

  Widget _buildShimmerTile() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppStyle.colors.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          // Icon placeholder
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: AppStyle.colors.grey,
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          const SizedBox(width: 16),
          // Text placeholders
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppStyle.colors.grey,
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 120,
                  height: 12,
                  decoration: BoxDecoration(
                    color: AppStyle.colors.grey,
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ],
            ),
          ),

          // Right side value placeholder
          // Container(width: 60, height: 14, color: AppStyle.colors.grey),
        ],
      ),
    );
  }
}
