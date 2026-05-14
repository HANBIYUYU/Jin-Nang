import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_fonts.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/app_safe_area.dart';
import '../../widgets/pressable.dart';
import '../../widgets/title_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.springWood14,
      child: AppSafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildWelcomeSection(),
              const SizedBox(height: 29),
              _buildStatsCards(),
              const SizedBox(height: 16),
              Expanded(
                child: _buildMissionsSection(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBottomBlueCard('Yo! Alex 👋'),
              const SizedBox(height: 9),
              const TitleSection(
                title: 'Ready to\nLevel Up?',
                subtitle: 'Learn Chinese, one scene at a time.',
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        //_buildUserAvatar(),
      ],
    );
  }

  Widget _buildBottomBlueCard(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.baliHai30,
        border: Border.all(color: AppColors.morandiText, width: 2.389),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: AppColors.morandiText,
            offset: Offset(4, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w900,
          color: AppColors.morandiText,
          letterSpacing: 0.35,
        ),
      ),
    );
  }

  /*Widget _buildUserAvatar() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.oldRose15,
        // 用 999 代替超大魔法数字，效果相同且语义更清晰
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.morandiText, width: 2),
      ),
      child: const Icon(
        Icons.person,
        size: 28,
        color: AppColors.morandiText,
      ),
    );
  }*/

  Widget _buildStatsCards() {
    return Row(
      children: [
        Expanded(child: _buildStreakCard()),
        const SizedBox(width: 16),
        Expanded(child: _buildRankCard()),
      ],
    );
  }

  Widget _buildStreakCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.lavenderPurple,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatImage('assets/icon/fire.png'),
          const SizedBox(height: 5),
          const Text(
            'STREAK',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              color: AppColors.morandiText,
            ),
          ),
          const SizedBox(height: 5),
          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontFamily: AppFonts.english,
                fontFamilyFallback: [AppFonts.chinese],
              ),
              children: [
                TextSpan(
                  text: '12 ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.morandiText,
                  ),
                ),
                TextSpan(
                  text: 'Days',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.morandiText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.straw14,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatImage('assets/icon/cup.png'),
          const SizedBox(height: 5),
          const Text(
            'RANK',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              color: AppColors.morandiText,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Gold',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: AppColors.morandiText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatImage(String assetPath) {
    return Container(
      width: 32,
      height: 32,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.morandiText, width: 1.5),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Image.asset(assetPath),
    );
  }

  Widget _buildMissionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 修复：标题改为左对齐
        const Text(
          'MISSIONS',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: AppColors.morandiText,
            letterSpacing: -0.65,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView(
            children: [
              Builder(
                builder: (context) => Pressable(
                  onPressed: () => context.go('/study/vocab-scene'),
                  child: _buildMissionCard(
                    title: 'Vocab\nLearning',
                    subtitle: '50 words',
                    color: AppColors.straw14,
                    iconPath: 'assets/icon/study.png',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Builder(
                builder: (context) => Pressable(
                  onPressed: () => context.go('/study/dialogue-practice'),
                  child: _buildMissionCard(
                    title: 'Dialogue\nPractice',
                    subtitle: '10 mins',
                    color: AppColors.baliHai30,
                    iconPath: 'assets/icon/dialogue_learning.png',
                  ),
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMissionCard({
    required String title,
    required String subtitle,
    required Color color,
    required String iconPath,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
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
          _buildMissionIcon(iconPath),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: AppColors.morandiText,
                    height: 25 / 20,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.morandiText.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionIcon(String iconPath) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.morandiText, width: 2),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: AppColors.morandiText,
            offset: Offset(4, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Center(
        child: Image.asset(iconPath, width: 22, height: 22),
      ),
    );
  }
}
