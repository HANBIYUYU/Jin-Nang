import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/title_section.dart';

class ToolboxScreen extends StatelessWidget {
  const ToolboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.springWood14,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),
              const TitleSection(
                title: 'TOOLBOX',
                subtitle: 'Useful phrases for real life.',
              ),
              const SizedBox(height: 40),
              Expanded(
                child: ListView(
                  children: [
                    _buildToolCard(
                      context: context,
                      title: 'Restaurant',
                      subtitle: 'Ordering food & drinks.',
                      color: AppColors.baliHai30,
                      icon: Icons.restaurant,
                      isLocked: false,
                      onTap: () => context.go('/toolbox/vocab-card'),
                    ),
                    const SizedBox(height: 24),
                    _buildToolCard(
                      context: context,
                      title: 'Supermarket',
                      subtitle: 'Shopping lists & checkout.',
                      color: AppColors.lavenderPurple,
                      icon: Icons.shopping_cart,
                      isLocked: true,
                    ),
                    const SizedBox(height: 24),
                    _buildToolCard(
                      context: context,
                      title: 'Airport',
                      subtitle: 'Check-in, boarding & more.',
                      color: AppColors.straw14,
                      icon: Icons.flight,
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

  Widget _buildToolCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required Color color,
    required IconData icon,
    required bool isLocked,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLocked ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          // 移除硬编码高度，改为内容自适应 + 最小高度
          constraints: const BoxConstraints(minHeight: 100),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            // 修复：非锁定状态正确使用传入的 color 参数
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
        color: isLocked ? Colors.white : Colors.white.withValues(alpha: 0.4),
        border: Border.all(
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
          size: 30,
          color: isLocked
              ? AppColors.shark40.withValues(alpha: 0.25)
              : AppColors.morandiText,
        ),
      ),
    );
  }
}
