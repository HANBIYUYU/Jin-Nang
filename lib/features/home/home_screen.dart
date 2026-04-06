import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.xxl * 2), // ~96px
            _buildTitle(context),
            const SizedBox(height: AppSpacing.xxl * 2),
            Expanded(
              child: ListView(
                children: [
                  _buildFeatureCard(
                    context: context,
                    title: 'Vocabulary Learning',
                    bgColor: AppColors.neutralGray02, // Changed from hardcoded color to Figma value
                  ),
                  const SizedBox(height: AppSpacing.lg), // 24px
                  _buildFeatureCard(
                    context: context,
                    title: 'Dialogue Practice',
                    bgColor: AppColors.neutralGray03,
                  ),
                  // Add padding to bottom to allow scrolling past nav bar if needed
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      "Study",
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.displayLarge,
    );
  }

  Widget _buildFeatureCard({
    required BuildContext context,
    required String title,
    required Color bgColor,
  }) {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        // Aligned with the original code's spacing, but using AppSpacing where possible
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.neutralGray01,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
