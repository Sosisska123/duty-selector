import 'package:duty_selector/features/presentation/widgets/quick_access/last_duties.dart';
import 'package:duty_selector/features/presentation/widgets/quick_access/select_duty.dart';
import 'package:duty_selector/features/data/database.dart';
import 'package:duty_selector/design.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final DatabaseService databaseService;
  const HomeScreen({super.key, required this.databaseService});

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
          LastDuties(databaseService: widget.databaseService),
          SelectDuty(databaseService: widget.databaseService),
        ],
      ),
    );
  }
}
