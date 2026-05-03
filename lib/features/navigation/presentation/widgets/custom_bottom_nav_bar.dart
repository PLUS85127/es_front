import 'package:flutter/material.dart';
import 'package:es_control/core/theme/app_theme.dart';
import 'package:es_control/core/theme/theme_extension.dart';

class CustomBottomNavBar extends StatelessWidget {
  final bool isAdminMode;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<IconData> personalIcons;
  final List<IconData> adminIcons;

  const CustomBottomNavBar({
    super.key,
    required this.isAdminMode,
    required this.currentIndex,
    required this.onTap,
    required this.personalIcons,
    required this.adminIcons,
  });

  @override
  Widget build(BuildContext context) {
    final currentIcons = isAdminMode ? adminIcons : personalIcons;

    return Container(
      margin: const EdgeInsets.only(bottom: 15, left: 20, right: 15),
      height: 60,
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(context.isDark ? 0.2 : 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            currentIcons.length,
            (index) => _buildNavItem(context, currentIcons[index], index),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, int index) {
    final bool isActive = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        padding: const EdgeInsets.all(8),
        color: Colors.transparent,
        child: Icon(
          icon,
          size: isActive ? 28 : 24,
          color: isActive
              ? (context.isDark ? AppTheme.yellowDecorative : AppTheme.navyBlue)
              : (context.isDark ? Colors.white38 : Colors.black45),
        ),
      ),
    );
  }
}
