import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:duty_selector/pages/home.dart';
import 'package:duty_selector/pages/list.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [HomeScreen(), ListScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(label: "Главная", icon: Icon(Ionicons.home)),
          BottomNavigationBarItem(label: "Записи", icon: Icon(Ionicons.list)),
          BottomNavigationBarItem(
            label: "Настройки",
            icon: Icon(Ionicons.settings),
          ),
        ],
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
