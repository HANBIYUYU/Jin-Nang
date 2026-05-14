import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../widgets/app_header.dart';
import '../../../widgets/app_safe_area.dart';
import '../../../widgets/pressable.dart';

// 关卡数据
class _LevelInfo {
  final int id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool isUnlocked;
  final int starCount;
  final int totalStars;

  const _LevelInfo({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.isUnlocked,
    required this.starCount,
    required this.totalStars,
  });
}

class DialoguePracticeScreen extends StatelessWidget {
  const DialoguePracticeScreen({super.key});

  static const _levels = [
    _LevelInfo(
      id: 1,
      title: 'Level 1',
      subtitle: 'Vocab Match',
      icon: Icons.extension,
      color: AppColors.baliHai30,
      isUnlocked: true,
      starCount: 3,
      totalStars: 3,
    ),
    _LevelInfo(
      id: 2,
      title: 'Level 2',
      subtitle: 'Listen & Choose',
      icon: Icons.hearing,
      color: AppColors.lavenderPurple,
      isUnlocked: true,
      starCount: 2,
      totalStars: 3,
    ),
    _LevelInfo(
      id: 3,
      title: 'Level 3',
      subtitle: 'Fill in Blanks',
      icon: Icons.edit_note,
      color: AppColors.straw14,
      isUnlocked: false,
      starCount: 0,
      totalStars: 3,
    ),
    _LevelInfo(
      id: 4,
      title: 'Challenge',
      subtitle: 'Scenario Sort',
      icon: Icons.emoji_events,
      color: AppColors.oldRose15,
      isUnlocked: false,
      starCount: 0,
      totalStars: 3,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.springWood14,
      child: AppSafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            children: [
              const SizedBox(height: 48),
              AppHeader(
                title: 'Dialogue Practice',
                onBack: () => context.go('/study'),
              ),
              const SizedBox(height: 32),
              _buildProgressSummary(),
              const SizedBox(height: 32),
              Expanded(
                child: ListView(
                  children: [
                    ..._levels.map((level) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildLevelCard(context, level),
                        )),
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

  Widget _buildProgressSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.morandiText, width: 2.389),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.morandiText,
            offset: Offset(4, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.straw14,
              border: Border.all(color: AppColors.morandiText, width: 2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.emoji_events,
              size: 28,
              color: AppColors.morandiText,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Progress',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: AppColors.morandiText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '2 / 4 levels completed',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.morandiText.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: List.generate(4, (i) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Icon(
                        i < 2 ? Icons.star : Icons.star_border,
                        size: 16,
                        color: i < 2 ? AppColors.straw14 : AppColors.mercury25,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelCard(BuildContext context, _LevelInfo level) {
    return Pressable(
      onPressed: level.isUnlocked
          ? () => context.go('/study/level/${level.id}')
          : null,
      child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: level.isUnlocked ? level.color : AppColors.whisper15,
            border: Border.all(
              color: level.isUnlocked
                  ? AppColors.morandiText
                  : AppColors.shark40.withValues(alpha: 0.2),
              width: 2.389,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: level.isUnlocked
                ? const [
                    BoxShadow(
                      color: AppColors.morandiText,
                      offset: Offset(4, 4),
                      blurRadius: 0,
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: level.isUnlocked
                      ? Colors.white.withValues(alpha: 0.4)
                      : Colors.white,
                  border: Border.all(
                    color: level.isUnlocked
                        ? AppColors.morandiText
                        : AppColors.shark40.withValues(alpha: 0.2),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Icon(
                    level.isUnlocked ? level.icon : Icons.lock,
                    size: 24,
                    color: level.isUnlocked
                        ? AppColors.morandiText
                        : AppColors.shark40.withValues(alpha: 0.3),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      level.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: level.isUnlocked
                            ? AppColors.morandiText
                            : AppColors.shark40.withValues(alpha: 0.4),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      level.subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: level.isUnlocked
                            ? AppColors.stormGray32
                            : AppColors.shark40.withValues(alpha: 0.3),
                      ),
                    ),
                    if (level.isUnlocked && level.starCount > 0) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: List.generate(level.totalStars, (i) {
                          return Icon(
                            i < level.starCount ? Icons.star : Icons.star_border,
                            size: 14,
                            color: i < level.starCount
                                ? AppColors.straw14
                                : AppColors.mercury25,
                          );
                        }),
                      ),
                    ],
                  ],
                ),
              ),
              if (level.isUnlocked)
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColors.morandiText,
                )
              else
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: AppColors.mercury25,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock,
                    size: 14,
                    color: AppColors.shark40,
                  ),
                ),
            ],
          ),
        ),
      );
  }
}

