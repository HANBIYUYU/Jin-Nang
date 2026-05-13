import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../widgets/app_header.dart';
import '../../../widgets/selectable_card.dart';

/// 词汇学习 —— 场景选择页（Select a scene）
///
/// 从 Study Tab 的 Vocab Learning 卡片进入，
/// 选择场景后才进入词汇学习页。
class VocabSceneScreen extends StatelessWidget {
  const VocabSceneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.springWood14,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              AppHeader(
                title: 'Vocab Learning',
                titleColor: AppColors.straw14,
                onBack: () => context.go('/study'),
              ),
              const SizedBox(height: 32),
              const Text(
                'Select a scene',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: AppColors.morandiText,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView(
                  children: [
                    SelectableCard(
                      title: 'Restaurant',
                      subtitle: 'Master ordering food and drinks.',
                      icon: Icons.local_cafe,
                      color: AppColors.baliHai30,
                      onTap: () => context.go('/study/vocab-learning'),
                    ),
                    const SizedBox(height: 24),
                    const SelectableCard(
                      title: 'Supermarket',
                      subtitle: 'Shopping lists and checkout.',
                      icon: Icons.shopping_cart,
                      color: AppColors.lavenderPurple,
                    ),
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

}
