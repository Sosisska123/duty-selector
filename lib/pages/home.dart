import 'package:duty_selector/components/last_duties.dart';
import 'package:duty_selector/components/select_duty.dart';
import 'package:duty_selector/design.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: AppSpacing.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.xlarge,
          children: [
            SizedBox(height: AppSpacing.medium),
            LastDuties(),
            SelectDuty(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(label: "Главная", icon: Icon(Ionicons.home)),
          BottomNavigationBarItem(label: "Записи", icon: Icon(Ionicons.list)),
          BottomNavigationBarItem(
            label: "Настройки",
            icon: Icon(Ionicons.settings),
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              break;
            case 1:
              Navigator.pushNamed(context, AppRoutes.list);
              break;
            default:
              break;
          }
        },
      ),
    );
  }
}
