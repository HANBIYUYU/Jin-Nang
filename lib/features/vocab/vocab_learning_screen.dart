import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

class VocabLearningScreen extends StatelessWidget {
  const VocabLearningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.springWood14,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            children: [
              const SizedBox(height: 39),
              _buildHeader(context),
              const SizedBox(height: 48),
              Expanded(
                child: ListView(
                  children: [
                    _buildSceneCard(
                      context: context,
                      title: 'Restaurant',
                      subtitle: 'Master ordering food and drinks.',
                      icon: Icons.restaurant,
                      color: AppColors.baliHai30,
                      isLocked: false,
                      onTap: () => context.go('/toolbox/vocab-card'),
                    ),
                    const SizedBox(height: 24),
                    _buildSceneCard(
                      context: context,
                      title: 'Supermarket',
                      subtitle: 'Shopping lists and checkout.',
                      icon: Icons.shopping_cart,
                      color: AppColors.lavenderPurple,
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
        // 返回按钮
        GestureDetector(
          onTap: () => context.go('/toolbox'),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.baliHai30,
              border: Border.all(color: AppColors.morandiText, width: 2.389),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.arrow_back,
              size: 20,
              color: AppColors.morandiText,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.baliHai30,
              border: Border.all(color: AppColors.morandiText, width: 2.389),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.morandiText,
                  offset: Offset(4, 4),
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
        ),
      ],
    );
  }

  Widget _buildSceneCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isLocked,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLocked ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          constraints: const BoxConstraints(minHeight: 100),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isLocked ? AppColors.whisper15 : color,
            border: Border.all(
              color: isLocked
                  ? AppColors.shark40.withValues(alpha: 0.2)
                  : AppColors.morandiText,
              width: 2.389,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: isLocked
                ? null
                : const [
                    BoxShadow(
                      color: AppColors.morandiText,
                      offset: Offset(4, 4),
                      blurRadius: 0,
                    ),
                  ],
          ),
          child: Stack(
            children: [
              Row(
                children: [
                  _buildIconContainer(icon, color, isLocked),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: isLocked
                                ? AppColors.shark40.withValues(alpha: 0.4)
                                : AppColors.morandiText,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: isLocked
                                ? AppColors.shark40.withValues(alpha: 0.3)
                                : AppColors.stormGray32,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (isLocked)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: AppColors.mercury25,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.lock,
                      size: 16,
                      color: AppColors.shark40,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconContainer(IconData icon, Color color, bool isLocked) {
    return Container(
      width: 68,
      height: 68,
      decoration: BoxDecoration(
        // 修复：非锁定图标容器用半透明白底而非完全覆盖颜色
        color: isLocked ? Colors.white : Colors.white.withValues(alpha: 0.4),
        border: Border.all(
          // 修复：统一使用 withValues() 替代弃用的 withOpacity()
          color: isLocked
              ? AppColors.shark40.withValues(alpha: 0.2)
              : AppColors.morandiText,
          width: 2.5,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Icon(
          icon,
          // 修复：icon 尺寸从 32 调整为 28，避免紧贴容器边缘
          size: 28,
          color: isLocked
              ? AppColors.shark40.withValues(alpha: 0.25)
              : AppColors.morandiText,
        ),
      ),
    );
  }
}
