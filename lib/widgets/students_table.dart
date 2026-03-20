import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'package:duty_selector/database.dart';
import 'package:duty_selector/design.dart';
import 'package:duty_selector/models/student.dart';

class StudentTiles extends StatefulWidget {
  const StudentTiles({
    super.key,
    required this.students,
    required this.itemScrollController,
  });

  final List<Student> students;
  final ItemScrollController itemScrollController;

  @override
  State<StudentTiles> createState() => _StudentTilesState();
}

class _StudentTilesState extends State<StudentTiles> {
  final DatabaseService _databaseService = DatabaseService();

  String date = "N/A";

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
                      ElevatedButton(
                        onPressed: () => _assignDuty(student),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(130, 40),
                        ),
                        child: const Text('Назначить'),
                      ),
                      ElevatedButton(
                        onPressed: () => _releaseDuty(student),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(130, 40),
                        ),
                        child: const Text('Отпустить'),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => _showHistory(student),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(130, 40),
                        ),
                        child: const Text('История'),
                      ),
                      ElevatedButton(
                        onPressed: () => _markAsNotDuty(student),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(130, 40),
                        ),
                        child: const Text('Не дежурил'),
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

  void _assignDuty(Student student) {
    // TODO: Implement duty assignment functionality
  }

  void _releaseDuty(Student student) {
    // TODO: Implement duty release functionality
  }

  void _showHistory(Student student) {
    // TODO: Implement history display in a separate page
  }

  void _markAsNotDuty(Student student) {
    // TODO: Implement not duty mark functionality
  }
}
