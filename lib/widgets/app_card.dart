import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'pressable.dart';

/// 粗边框 + 硬阴影卡片容器。
///
/// 统一应用内的卡片样式：2.389 边框 + 4px 硬阴影 + 16 圆角。
class AppCard extends StatelessWidget {
  final Color color;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double? borderWidth;
  final double? borderRadius;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.color,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderWidth,
    this.borderRadius,
    this.boxShadow,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
          color: AppColors.morandiText,
          width: borderWidth ?? 2.389,
        ),
        borderRadius: BorderRadius.circular(borderRadius ?? 16),
        boxShadow: boxShadow ??
            const [
              BoxShadow(
                color: AppColors.morandiText,
                offset: Offset(4, 4),
                blurRadius: 0,
              ),
            ],
      ),
      child: child,
    );

    if (onTap != null) {
      return Pressable(
        onPressed: onTap,
        child: card,
      );
    }

    return card;
  }
}
