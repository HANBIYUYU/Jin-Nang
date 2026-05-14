import 'package:flutter/material.dart';

/// 统一的安全区域包装器
///
/// 在所有页面顶部额外留出 12dp 间距，避免内容过于贴近状态栏/刘海。
class AppSafeArea extends StatelessWidget {
  final Widget child;

  const AppSafeArea({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.only(top: 12),
      child: child,
    );
  }
}
