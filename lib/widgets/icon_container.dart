import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// 带粗边框的图标容器方块。
///
/// 用于卡片内的左侧图标、统计小图标等场景。
class IconContainer extends StatelessWidget {
  final IconData icon;
  final double size;
  final double iconSize;
  final double borderRadius;
  final double borderWidth;
  final Color? backgroundColor;
  final Color? iconColor;
  final List<BoxShadow>? boxShadow;

  const IconContainer({
    super.key,
    required this.icon,
    this.size = 56,
    this.iconSize = 24,
    this.borderRadius = 14,
    this.borderWidth = 2,
    this.backgroundColor,
    this.iconColor,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white.withValues(alpha: 0.4),
        border: Border.all(
          color: AppColors.morandiText,
          width: borderWidth,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: boxShadow,
      ),
      child: Center(
        child: Icon(
          icon,
          size: iconSize,
          color: iconColor ?? AppColors.morandiText,
        ),
      ),
    );
  }
}
