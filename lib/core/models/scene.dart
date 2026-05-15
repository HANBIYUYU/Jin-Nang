class Scene {
  final int id;
  final String nameEn;
  final String nameZh;
  final String subtitleEn;
  final String colorHex;
  final bool isUnlockedDefault;

  const Scene({
    required this.id,
    required this.nameEn,
    required this.nameZh,
    required this.subtitleEn,
    required this.colorHex,
    required this.isUnlockedDefault,
  });

  factory Scene.fromJson(Map<String, dynamic> j) => Scene(
        id: j['id'] as int,
        nameEn: j['name_en'] as String,
        nameZh: j['name_zh'] as String,
        subtitleEn: j['subtitle_en'] as String,
        colorHex: j['color_hex'] as String,
        isUnlockedDefault: (j['is_unlocked_default'] as int) == 1,
      );
}
