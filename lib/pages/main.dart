import 'package:duty_selector/database.dart';
import 'package:duty_selector/design.dart';
import 'package:duty_selector/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:duty_selector/pages/home.dart';
import 'package:duty_selector/pages/list.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PersistentTabController _controller = PersistentTabController(
    initialIndex: 0,
  );

  final DatabaseService databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      padding: const EdgeInsets.all(8),
      confineToSafeArea: true,
      backgroundColor: AppColors.secondary,
      navBarHeight: kBottomNavigationBarHeight,
      navBarStyle: NavBarStyle.style12,
    );
  }

  List<Widget> _buildScreens() {
    return [
      HomeScreen(databaseService: databaseService),
      ListScreen(databaseService: databaseService),
      SettingsScreen(databaseService: databaseService),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Ionicons.home),
        activeColorPrimary: AppColors.text,
        inactiveColorPrimary: AppColors.accent,
        title: ("Главная"),
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: "/",
          routes: {
            AppRoutes.home: (final context) =>
                HomeScreen(databaseService: databaseService),
            AppRoutes.list: (final context) =>
                ListScreen(databaseService: databaseService),
            AppRoutes.settings: (final context) =>
                SettingsScreen(databaseService: databaseService),
          },
        ),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Ionicons.list),
        title: ("Записи"),
        activeColorPrimary: AppColors.text,
        inactiveColorPrimary: AppColors.accent,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: "/",
          routes: {
            AppRoutes.list: (final context) =>
                ListScreen(databaseService: databaseService),
            AppRoutes.home: (final context) =>
                HomeScreen(databaseService: databaseService),
            AppRoutes.settings: (final context) =>
                SettingsScreen(databaseService: databaseService),
          },
        ),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Ionicons.settings),
        title: ("Настройки"),
        activeColorPrimary: AppColors.text,
        inactiveColorPrimary: AppColors.accent,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: "/",
          routes: {
            AppRoutes.settings: (final context) =>
                SettingsScreen(databaseService: databaseService),
            AppRoutes.list: (final context) =>
                ListScreen(databaseService: databaseService),
            AppRoutes.home: (final context) =>
                HomeScreen(databaseService: databaseService),
          },
        ),
      ),
    ];
  }
}
