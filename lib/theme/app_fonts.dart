/// 全局字体常量
///
/// 统一在此管理，方便后续替换或降级。
/// 使用系统默认无衬线字体（Windows: 微软雅黑 / macOS: 苹方）
class AppFonts {
  AppFonts._();

  /// 英文字体 — 使用 Inter (和设计稿完全一致)
  static const String english = 'Inter';

  /// 中文字体 — 使用系统默认
  static const String? chinese = null;
}
