import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../widgets/pressable.dart';

class MainShell extends StatelessWidget {
  const MainShell({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  static const _navItems = [
    _NavItemData(
      iconPath: 'assets/icon/study.png',
      label: 'STUDY',
      selectedColor: AppColors.straw14,
    ),
    _NavItemData(
      iconPath: 'assets/icon/toolbox.png',
      label: 'TOOLBOX',
      selectedColor: AppColors.baliHai30,
    ),
    _NavItemData(
      iconPath: 'assets/icon/my.png',
      label: 'MY',
      selectedColor: AppColors.oldRose15,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      height: 92,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        border: Border(
          top: BorderSide(color: Colors.black, width: 4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, -4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_navItems.length, (index) {
          return _buildNavItem(
            context: context,
            data: _navItems[index],
            index: index,
          );
        }),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required _NavItemData data,
    required int index,
  }) {
    final isSelected = navigationShell.currentIndex == index;

    return Expanded(
      child: Pressable(
        feedback: PressFeedback.defaultFeedback,
        onPressed: () {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 52,
                height: 52,
                child: Center(
                  child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(
                      begin: isSelected ? 0 : 0.12,
                      end: isSelected ? 0.12 : 0,
                    ),
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOutBack,
                    builder: (context, angle, child) {
                      return Transform.rotate(
                        angle: angle,
                        alignment: Alignment.center,
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: isSelected ? data.selectedColor : Colors.white,
                            border: Border.all(
                              color: AppColors.morandiText,
                              width: 2.5,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: isSelected
                                ? const [
                                    BoxShadow(
                                      color: AppColors.morandiText,
                                      offset: Offset(3, 3),
                                      blurRadius: 0,
                                    ),
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: Image.asset(
                              data.iconPath,
                              width: 22,
                              height: 22,
                              color: isSelected
                                  ? AppColors.morandiText
                                  : AppColors.naturalGray19,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                data.label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                  color: isSelected
                      ? AppColors.morandiText
                      : AppColors.naturalGray19,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
    );
  }
}


class _NavItemData {
  final String iconPath;
  final String label;
  final Color selectedColor;

  const _NavItemData({
    required this.iconPath,
    required this.label,
    required this.selectedColor,
  });
}
