import 'package:duty_selector/components/students_list.dart';
import 'package:duty_selector/database.dart';
import 'package:duty_selector/design.dart';
import 'package:flutter/material.dart';

class StudentsPage extends StatelessWidget {
  final DatabaseService databaseService;
  const StudentsPage({super.key, required this.databaseService});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentGeometry.topCenter,
      padding: EdgeInsetsGeometry.all(AppSpacing.medium),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.medium),
        ),
      ),
      child: StudentsList(databaseService: databaseService),
    );
  }
}
