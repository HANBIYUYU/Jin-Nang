import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';

class MainShell extends StatelessWidget {
  const MainShell({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    // ClipRRect + DecoratedBox 分离，解决 border+radius 在同一 Container 上渲染异常
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(32),
        topRight: Radius.circular(32),
      ),
      child: Container(
        height: 84,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.black, width: 4),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              context: context,
              icon: Icons.book,
              label: 'Study',
              index: 0,
              selectedColor: AppColors.straw14,
            ),
            _buildNavItem(
              context: context,
              icon: Icons.build,
              label: 'Toolbox',
              index: 1,
              selectedColor: AppColors.baliHai30,
            ),
            _buildNavItem(
              context: context,
              icon: Icons.person,
              label: 'My',
              index: 2,
              selectedColor: AppColors.oldRose15,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required int index,
    required Color selectedColor,
  }) {
    final isSelected = navigationShell.currentIndex == index;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          // 用 borderRadius 限制 ripple 扩散区域
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            );
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 固定外层尺寸，防止 icon 大小变化引发布局抖动
              SizedBox(
                width: 56,
                height: 56,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? selectedColor : Colors.white,
                      border: Border.all(
                        color: AppColors.morandiText,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.morandiText,
                                offset: const Offset(4, 4),
                                blurRadius: 0,
                              ),
                            ]
                          : null,
                    ),
                    child: Icon(
                      icon,
                      size: 24, // 固定 icon 尺寸，不再随 isSelected 变化
                      color: isSelected ? AppColors.morandiText : AppColors.naturalGray19,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: isSelected ? AppColors.morandiText : AppColors.naturalGray19,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
