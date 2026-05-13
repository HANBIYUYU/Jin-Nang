import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';

/// 词汇学习 —— 场景选择页（Select a scene）
///
/// 从 Study Tab 的 Vocab Learning 卡片进入，
/// 选择场景后才进入词汇学习页。
class VocabSceneScreen extends StatelessWidget {
  const VocabSceneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.springWood14,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              _buildHeader(context),
              const SizedBox(height: 32),
              const Text(
                'Select a scene',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: AppColors.morandiText,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView(
                  children: [
                    _buildSceneCard(
                      context: context,
                      title: 'Restaurant',
                      subtitle: 'Master ordering food and drinks.',
                      icon: Icons.local_cafe,
                      isLocked: false,
                      onTap: () => context.go('/study/vocab-learning'),
                    ),
                    const SizedBox(height: 24),
                    _buildSceneCard(
                      context: context,
                      title: 'Supermarket',
                      subtitle: 'Shopping lists and checkout.',
                      icon: Icons.shopping_cart,
                      isLocked: true,
                    ),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => context.go('/study'),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.morandiText, width: 2.5),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.morandiText,
                  offset: Offset(3, 3),
                  blurRadius: 0,
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back,
              color: AppColors.morandiText,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.straw14,
            border: Border.all(color: AppColors.morandiText, width: 2.5),
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: AppColors.morandiText,
                offset: Offset(3, 3),
                blurRadius: 0,
              ),
            ],
          ),
          child: const Text(
            'Vocab Learning',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: AppColors.morandiText,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSceneCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isLocked,
    VoidCallback? onTap,
  }) {
    final color = isLocked ? AppColors.naturalGray19 : Colors.white;

    return GestureDetector(
      onTap: isLocked ? null : onTap,
      child: Opacity(
        opacity: isLocked ? 0.5 : 1.0,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: color,
            border: Border.all(
              color: AppColors.morandiText,
              width: 2.5,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: AppColors.morandiText,
                offset: Offset(4, 4),
                blurRadius: 0,
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: isLocked
                      ? AppColors.naturalGray19.withValues(alpha: 0.15)
                      : AppColors.baliHai30,
                  border: Border.all(
                    color: AppColors.morandiText,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: isLocked ? AppColors.naturalGray19 : AppColors.morandiText,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: isLocked
                            ? AppColors.naturalGray19
                            : AppColors.morandiText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isLocked
                            ? AppColors.naturalGray19.withValues(alpha: 0.5)
                            : AppColors.morandiText.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              if (isLocked)
                const Icon(
                  Icons.lock,
                  size: 24,
                  color: AppColors.naturalGray19,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
