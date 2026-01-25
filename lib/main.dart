import 'package:duty_selector/design.dart';
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
      home: const HomePage(),
    );
  }
}
