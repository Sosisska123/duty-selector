import 'package:duty_selector/components/last_duties.dart';
import 'package:duty_selector/components/select_duty.dart';
import 'package:duty_selector/design.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.xlarge,
        children: [
          SizedBox(height: AppSpacing.medium),
          LastDuties(),
          SelectDuty(),
        ],
      ),
    );
  }
}
