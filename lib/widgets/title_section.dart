import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// 页面标题组件：大标题 + 副标题，统一阴影样式。
///
/// 用于 ToolboxScreen、HomeScreen 等页面的顶部标题区。
class TitleSection extends StatelessWidget {
  final String title;
  final String subtitle;

  const TitleSection({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w900,
            color: AppColors.morandiText,
            height: 37.8 / 36,
            letterSpacing: -0.9,
            shadows: [
              Shadow(
                color: AppColors.lavenderPurple,
                offset: Offset(3, 3),
                blurRadius: 0,
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.morandiText.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}
