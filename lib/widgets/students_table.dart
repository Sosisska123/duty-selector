import 'package:flutter/material.dart';

import 'package:duty_selector/database.dart';
import 'package:duty_selector/design.dart';
import 'package:duty_selector/models/student.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class StudentsTable extends StatefulWidget {
  const StudentsTable({
    super.key,
    required this.students,
    required this.itemScrollController,
  });

  final List<Student> students;
  final ItemScrollController itemScrollController;

  @override
  State<StudentsTable> createState() => _StudentsTableState();
}

class _StudentsTableState extends State<StudentsTable> {
  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return ScrollablePositionedList.builder(
      itemScrollController: widget.itemScrollController,
      itemCount: widget.students.length,
      itemBuilder: (context, index) {
        final student = widget.students[index];

        return ExpansionTile(
          title: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(student.name, style: AppTextStyles.tableHeader),
              ),
              Expanded(
                flex: 1,
                child: Text(student.status, style: AppTextStyles.tableHeader),
              ),
              Text(student.lastDutyDate, style: AppTextStyles.caption),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.small),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _studentActionButton(_assignDuty, 'Назначить'),
                      _studentActionButton(_releaseDuty, 'Отпустить'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _studentActionButton(_showHistory, 'История'),
                      _studentActionButton(_markAsNotDuty, 'Не дежурил'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  ElevatedButton _studentActionButton(VoidCallback onPressed, String text) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(minimumSize: const Size(130, 40)),
      child: Text(text),
    );
  }

  void _showHistory() {
    // TODO: Implement history display in a separate page
  }

  void _markAsNotDuty() {
    // TODO: Implement not duty mark functionality
  }

  void _assignDuty() {
    // TODO: Implement duty assignment functionality
  }

  void _releaseDuty() {
    // TODO: Implement duty release functionality
  }
}
