/// 全局字体常量
///
/// 统一在此管理，方便后续替换或降级。
/// 英文使用 Inter，中文使用 LXGW WenKai（通过 fontFamilyFallback 自动分发）
class AppFonts {
  AppFonts._();

  /// 英文字体 — Inter（字形更紧凑现代）
  static const String english = 'Inter';

  /// 中文字体 — LXGW 文楷（霞鹜文楷，本地加载）
  /// 注意：family name 必须和字体文件内部名称一致（含空格）
  static const String chinese = 'LXGW WenKai';
}
