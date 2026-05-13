import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/title_section.dart';
import '../../widgets/selectable_card.dart';

class ToolboxScreen extends StatelessWidget {
  const ToolboxScreen({super.key});

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
              const SizedBox(height: 48),
              const TitleSection(
                title: 'TOOLBOX',
                subtitle: 'Useful phrases for real life.',
              ),
              const SizedBox(height: 40),
              Expanded(
                child: ListView(
                  children: [
                    SelectableCard(
                      title: 'Restaurant',
                      subtitle: 'Ordering food & drinks.',
                      color: AppColors.baliHai30,
                      icon: Icons.restaurant,
                      onTap: () => context.go('/toolbox/vocab-card'),
                    ),
                    const SizedBox(height: 24),
                    const SelectableCard(
                      title: 'Supermarket',
                      subtitle: 'Shopping lists & checkout.',
                      color: AppColors.lavenderPurple,
                      icon: Icons.shopping_cart,
                    ),
                    const SizedBox(height: 24),
                    const SelectableCard(
                      title: 'Airport',
                      subtitle: 'Check-in, boarding & more.',
                      color: AppColors.straw14,
                      icon: Icons.flight,
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
