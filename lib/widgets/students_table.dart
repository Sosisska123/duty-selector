import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'package:duty_selector/database.dart';
import 'package:duty_selector/design.dart';
import 'package:duty_selector/models/student.dart';

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

  String date = "N/A";

  void setDate(String date) {
    setState(() {
      this.date = date;
    });
  }

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
              Text(date, style: AppTextStyles.caption),
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
                      _studentActionButton((s) => _assignDuty(s), 'Назначить'),
                      _studentActionButton((s) => _releaseDuty(s), 'Отпустить'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _studentActionButton((s) => _showHistory(s), 'История'),
                      _studentActionButton(
                        (s) => _markAsNotDuty(s),
                        'Не дежурил',
                      ),
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

  ElevatedButton _studentActionButton(
    ValueSetter<Student> onPressed,
    String text,
  ) {
    return ElevatedButton(
      onPressed: () => onPressed,
      style: ElevatedButton.styleFrom(minimumSize: const Size(130, 40)),
      child: Text(text),
    );
  }

  void _showHistory(Student student) {
    // TODO: Implement history display in a separate page
  }

  void _markAsNotDuty(Student student) {
    // TODO: Implement not duty mark functionality
  }

  void _assignDuty(Student student) {
    // TODO: Implement duty assignment functionality
  }

  void _releaseDuty(Student student) {
    // TODO: Implement duty release functionality
  }
}
