import 'package:duty_selector/design.dart';
import 'package:duty_selector/pages/list.dart';
import 'package:flutter/material.dart';
import 'pages/home.dart';

void main() {
  runApp(const DutySelectorApp());
}

class DutySelectorApp extends StatelessWidget {
  const DutySelectorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Duty Selector',
      theme: getTheme(),
      routes: {
        AppRoutes.home: (context) => const HomeScreen(),
        AppRoutes.list: (context) => const ListScreen(),
      },
    );
  }
}
