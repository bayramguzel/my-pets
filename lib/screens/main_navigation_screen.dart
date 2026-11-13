import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_pets/l10n/app_localizations.dart';
import 'pet_list_screen.dart';
import 'explore_screen.dart';
import 'statistics_screen.dart';
import 'settings_screen.dart';
import '../widgets/banner_ad_widget.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const PetListScreen(),
    const ExploreScreen(),
    const StatisticsScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: Platform.isIOS
          ? _buildCupertinoTabBar(context, l10n)
          : _buildMaterialNavigationBar(context, l10n),
    );
  }

  /// iOS uses the native tab bar look: flat icons, a hairline separator and
  /// the system safe-area handling built into [CupertinoTabBar].
  Widget _buildCupertinoTabBar(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: BannerAdWidget(),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: scheme.outlineVariant.withValues(alpha: 0.6),
                width: 0.5,
              ),
            ),
          ),
          child: CupertinoTabBar(
            currentIndex: _selectedIndex,
            onTap: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            backgroundColor: scheme.surface,
            activeColor: scheme.primary,
            inactiveColor: scheme.onSurfaceVariant,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.pets_outlined),
                activeIcon: const Icon(Icons.pets),
                label: l10n.myPets,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.explore_outlined),
                activeIcon: const Icon(Icons.explore),
                label: l10n.explore,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.bar_chart_outlined),
                activeIcon: const Icon(Icons.bar_chart),
                label: l10n.statistics,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.settings_outlined),
                activeIcon: const Icon(Icons.settings),
                label: l10n.settings,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMaterialNavigationBar(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: BannerAdWidget(),
          ),
          NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.pets_outlined),
                selectedIcon: const Icon(Icons.pets),
                label: l10n.myPets,
              ),
              NavigationDestination(
                icon: const Icon(Icons.explore_outlined),
                selectedIcon: const Icon(Icons.explore),
                label: l10n.explore,
              ),
              NavigationDestination(
                icon: const Icon(Icons.bar_chart_outlined),
                selectedIcon: const Icon(Icons.bar_chart),
                label: l10n.statistics,
              ),
              NavigationDestination(
                icon: const Icon(Icons.settings_outlined),
                selectedIcon: const Icon(Icons.settings),
                label: l10n.settings,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
