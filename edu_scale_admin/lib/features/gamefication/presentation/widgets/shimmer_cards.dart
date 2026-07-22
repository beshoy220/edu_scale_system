import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../../core/themes/themes.dart';

class ShimmerCards extends StatelessWidget {
  const ShimmerCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Column(
        children: [
          // Shimmer for BigStatCard
          Shimmer(
            color: Colors.grey,
            child: Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppStyle.colors.grey,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title shimmer
                  Container(
                    width: 180,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppStyle.colors.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  SizedBox(height: 6),
                  // Subtitle shimmer
                  Container(
                    width: 220,
                    height: 16,
                    decoration: BoxDecoration(
                      color: AppStyle.colors.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  SizedBox(height: 18),
                  Row(
                    children: [
                      // Left side: "Competitions" + number
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 80,
                              height: 14,
                              decoration: BoxDecoration(
                                color: AppStyle.colors.surface,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              width: 60,
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppStyle.colors.surface,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 20,
                        width: 1,
                        decoration: BoxDecoration(
                          color: AppStyle.colors.surface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      // Right side: chart bars (4 fake bars)
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildShimmerBar(50),
                              _buildShimmerBar(80),
                              _buildShimmerBar(60),
                              _buildShimmerBar(90),
                              _buildShimmerBar(40),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 12),

          // Shimmer for the two StatCards in a row
          Row(
            children: [
              Expanded(child: _buildShimmerStatCard()),
              SizedBox(width: 12),
              Expanded(child: _buildShimmerStatCard()),
            ],
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildShimmerBar(double heightPercent) {
    return Column(
      children: [
        Container(
          width: 18,
          height: heightPercent,
          decoration: BoxDecoration(
            color: AppStyle.colors.surface,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        SizedBox(height: 2),
        Container(
          width: 30,
          height: 12,
          decoration: BoxDecoration(
            color: AppStyle.colors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerStatCard() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppStyle.colors.grey,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 48,
            decoration: BoxDecoration(
              color: AppStyle.colors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
              color: AppStyle.colors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ],
      ),
    );
  }
}
