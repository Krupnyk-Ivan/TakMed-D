import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';

/// Spell для головних 5 вкладок з `BottomNavigationBar`.
///
/// Використовується з `StatefulShellRoute.indexedStack` у `AppRouter`.
class AppShellLayout extends StatelessWidget {
  const AppShellLayout({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const _destinations = <_TabDestination>[
    _TabDestination(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Головна',
    ),
    _TabDestination(
      icon: Icons.menu_book_outlined,
      activeIcon: Icons.menu_book,
      label: 'Навчання',
    ),
    _TabDestination(
      icon: Icons.medical_services_outlined,
      activeIcon: Icons.medical_services,
      label: 'MARCH',
    ),
    _TabDestination(
      icon: Icons.emoji_events_outlined,
      activeIcon: Icons.emoji_events,
      label: 'Досягнення',
    ),
    _TabDestination(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'Профіль',
    ),
  ];

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      // Повторний тап по активній вкладці — повернення до кореня вкладки.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        backgroundColor: AppColors.surfaceColor,
        indicatorColor: AppColors.primaryRed.withValues(alpha: 0.2),
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onTap,
        height: 64,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: _destinations
            .map(
              (d) => NavigationDestination(
                icon: Icon(d.icon, color: AppColors.textSecondary),
                selectedIcon: Icon(d.activeIcon, color: AppColors.primaryRed),
                label: d.label,
              ),
            )
            .toList(),
      ),
    );
  }
}

class _TabDestination {
  const _TabDestination({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
  final IconData icon;
  final IconData activeIcon;
  final String label;
}
