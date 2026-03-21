import 'package:duty_selector/components/last_duties.dart';
import 'package:duty_selector/components/select_duty.dart';
import 'package:duty_selector/design.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
    );
  }
}
