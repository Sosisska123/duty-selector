import 'package:duty_selector/features/data/database.dart';
import 'package:duty_selector/design.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({super.key, required this.databaseService});

  final DatabaseService databaseService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('data'),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.secondary,
        onPressed: onPressed,
        child: Icon(Ionicons.add, color: AppColors.text),
      ),
    );
  }

  void onPressed() {
    print("AA");
  }
}
