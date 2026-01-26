import 'package:flutter/material.dart';
import 'package:studymate/core/theme/app_theme.dart';

/// Bottom Navigation Bar của app
class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Focus Screen is index 1 -> Dark Mode
    final isDark = currentIndex == 1;
    final backgroundColor = isDark ? const Color(0xFF0E0E12) : Colors.white;
    final activeItemColor = isDark ? Colors.white : AppColors.primaryDark;
    final inactiveItemColor = isDark
        ? Colors.white.withValues(alpha: 0.4)
        : AppColors.primaryDark.withValues(alpha: 0.6);
    final activeBgColor = isDark
        ? Colors.white.withValues(alpha: 0.1)
        : AppColors.primaryDark.withValues(alpha: 0.12);

    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: isDark
            ? []
            : [
                const BoxShadow(
                  color: Color(0x11000000),
                  blurRadius: 16,
                  offset: Offset(0, -4),
                ),
              ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavIcon(
            icon: Icons.home_rounded,
            isSelected: currentIndex == 0,
            onTap: () => onTap(0),
            activeColor: activeItemColor,
            inactiveColor: inactiveItemColor,
            activeBgColor: activeBgColor,
          ),
          _NavIcon(
            icon: Icons.qr_code_scanner_rounded,
            isSelected: currentIndex == 1,
            onTap: () => onTap(1),
            activeColor: activeItemColor,
            inactiveColor: inactiveItemColor,
            activeBgColor: activeBgColor,
          ),
          _NavIcon(
            icon: Icons.calendar_month_rounded,
            isSelected: currentIndex == 2,
            onTap: () => onTap(2),
            activeColor: activeItemColor,
            inactiveColor: inactiveItemColor,
            activeBgColor: activeBgColor,
          ),
          _NavIcon(
            icon: Icons.person_outline_rounded,
            isSelected: currentIndex == 3,
            onTap: () => onTap(3),
            activeColor: activeItemColor,
            inactiveColor: inactiveItemColor,
            activeBgColor: activeBgColor,
          ),
        ],
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color activeColor;
  final Color inactiveColor;
  final Color activeBgColor;

  const _NavIcon({
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.activeColor,
    required this.inactiveColor,
    required this.activeBgColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? activeBgColor : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: isSelected ? activeColor : inactiveColor,
          size: 22,
        ),
      ),
    );
  }
}
