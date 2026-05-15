import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/di.dart';
import '../../core/models/scene.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/app_safe_area.dart';
import '../../widgets/title_section.dart';
import '../../widgets/selectable_card.dart';

class ToolboxScreen extends StatefulWidget {
  const ToolboxScreen({super.key});

  @override
  State<ToolboxScreen> createState() => _ToolboxScreenState();
}

class _ToolboxScreenState extends State<ToolboxScreen> {
  List<Scene>? _scenes;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadScenes();
  }

  Future<void> _loadScenes() async {
    try {
      final scenes = await Di.api.getScenes();
      if (!mounted) return;
      setState(() => _scenes = scenes);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    }
  }

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
              const SizedBox(height: 48),
              const TitleSection(title: 'TOOLBOX', subtitle: 'Useful phrases for real life.'),
              const SizedBox(height: 40),
              Expanded(child: _buildBody(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_error != null) {
      return Center(
        child: Text(_error!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.semanticRed, fontWeight: FontWeight.w600)),
      );
    }
    if (_scenes == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView(
      children: [
        ..._scenes!.map((scene) => Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: SelectableCard(
                title: scene.nameEn,
                subtitle: scene.subtitleEn,
                color: _colorFromHex(scene.colorHex),
                icon: _iconForScene(scene.nameEn),
                onTap: scene.isUnlockedDefault
                    ? () => context.go('/toolbox/vocab-card/${scene.id}')
                    : null,
              ),
            )),
        const SizedBox(height: 48),
      ],
    );
  }

  IconData _iconForScene(String name) {
    switch (name.toLowerCase()) {
      case 'restaurant': return Icons.restaurant;
      case 'supermarket': return Icons.shopping_cart;
      case 'airport': return Icons.flight;
      default: return Icons.place;
    }
  }

  Color _colorFromHex(String hex) {
    final value = int.tryParse(hex.replaceFirst('#', ''), radix: 16);
    return value != null ? Color(0xFF000000 | value) : AppColors.baliHai30;
  }
}
