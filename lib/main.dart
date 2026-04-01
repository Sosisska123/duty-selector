import 'package:duty_selector/design.dart';
import 'package:duty_selector/pages/list.dart';
import 'package:duty_selector/pages/main.dart';
import 'package:duty_selector/pages/settings.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const DutySelectorApp());
}

class DutySelectorApp extends StatelessWidget {
  const DutySelectorApp({super.key});

  @override
  Widget build(BuildContext context) {
    // FIXME: safe area produces blank spaces
    return SafeArea(
      minimum: EdgeInsets.symmetric(horizontal: AppSpacing.medium),
      child: MaterialApp(
        title: 'Duty Selector',
        theme: getTheme(),
        routes: {
          AppRoutes.home: (context) => const MainScreen(),
          AppRoutes.list: (context) => const ListScreen(),
          AppRoutes.settings: (context) => const SettingsScreen(),
        },
      ),
    );
  }
}
