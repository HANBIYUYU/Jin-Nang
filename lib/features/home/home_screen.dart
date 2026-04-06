import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 27),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: AppSpacing.xxl),
            _buildTitle(context),
            const Spacer(),
            _buildFeatureCard(
              context: context,
              title: "Vocabulary Learning",
              bgColor: AppColors.cardBgLight,
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildFeatureCard(
              context: context,
              title: "Dialogue Practice",
              bgColor: AppColors.cardBgDark,
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return SizedBox(
      height: 80,
      width: double.infinity,
      child: Text(
        "Study",
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.displayLarge,
      ),
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
        padding: const EdgeInsets.only(left: 26, bottom: 24),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ),
    );
  }
}
