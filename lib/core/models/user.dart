class UserProfile {
  final String displayName;
  final String rank;
  final String levelLabel;
  final int streakDays;
  final int totalWordsSeen;
  final double avgScore;

  const UserProfile({
    required this.displayName,
    required this.rank,
    required this.levelLabel,
    required this.streakDays,
    required this.totalWordsSeen,
    required this.avgScore,
  });

  factory UserProfile.fromJson(Map<String, dynamic> j) => UserProfile(
        displayName: j['display_name'] as String,
        rank: j['rank'] as String,
        levelLabel: j['level_label'] as String,
        streakDays: j['streak_days'] as int,
        totalWordsSeen: j['total_words_seen'] as int,
        avgScore: (j['avg_score'] as num).toDouble(),
      );
}
