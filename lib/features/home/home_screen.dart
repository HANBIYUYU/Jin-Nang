import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.springWood14,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 39),
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
              _buildTitleText(),
            ],
          ),
        ),
        const SizedBox(width: 16),
        _buildUserAvatar(),
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

Widget _buildTitleText() {
  const style = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w900,
    fontFamily: 'Arial Black',
    color: AppColors.morandiText,
    height: 37.8 / 36,
    letterSpacing: -0.9,
  );

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildStrokedText('Ready to', style),
      _buildStrokedText('Level Up?', style),
    ],
  );
}

Widget _buildStrokedText(String text, TextStyle style) {
  // 带阴影的样式
  final shadowStyle = style.copyWith(
    shadows: [
      const Shadow(
        color: AppColors.lavenderPurple,
        offset: Offset(3, 3),
        blurRadius: 0,
      ),
    ],
  );

  return Stack(
    children: [
      // 底层：描边层（不加阴影，避免描边也被偏移）
      Text(
        text,
        style: style.copyWith(
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.0
            ..color = AppColors.lavenderPurple,
        ),
      ),
      // 顶层：填充层 + 紫色偏移阴影
      Text(text, style: shadowStyle),
    ],
  );
}

  Widget _buildUserAvatar() {
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
  }

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
          _buildStatIcon(Icons.local_fire_department),
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
          _buildStatIcon(Icons.emoji_events),
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

  /// 统计卡片里的小圆形图标容器（原先两个卡片都用 fire icon，rank 改为 trophy）
  Widget _buildStatIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.morandiText, width: 1.5),
        // 用 999 替换魔法数字 26715300
        borderRadius: BorderRadius.circular(999),
      ),
      child: Icon(
        icon,
        size: 16,
        color: AppColors.morandiText,
      ),
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
                builder: (context) => GestureDetector(
                  onTap: () => context.go('/toolbox/vocab-learning'),
                  child: _buildMissionCard(
                    title: 'Vocab\nLearning',
                    subtitle: '50 words',
                    color: AppColors.straw14,
                    icon: Icons.book,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Builder(
                builder: (context) => GestureDetector(
                  onTap: () => context.go('/toolbox/dialogue-practice'),
                  child: _buildMissionCard(
                    title: 'Dialogue\nPractice',
                    subtitle: '10 mins',
                    color: AppColors.baliHai30,
                    icon: Icons.chat,
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
    required IconData icon,
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
          _buildMissionIcon(icon),
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

  Widget _buildMissionIcon(IconData icon) {
    // 修复：外层容器尺寸与内部 icon 匹配，使用明确的正方形尺寸
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
        child: Icon(
          icon,
          size: 22,
          color: AppColors.morandiText,
        ),
      ),
    );
  }
}
