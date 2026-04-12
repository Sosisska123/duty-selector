import 'package:duty_selector/database.dart';
import 'package:duty_selector/design.dart';
import 'package:duty_selector/models/student.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class StudentsList extends StatefulWidget {
  final DatabaseService databaseService;

  const StudentsList({super.key, required this.databaseService});

  @override
  State<StudentsList> createState() => _StudentsListState();
}

class _StudentsListState extends State<StudentsList> {
  List<Student> students = List.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getStudents(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        students.addAll([
          Student(id: 1, name: 'name'),
          Student(id: 1, name: 'name1'),
          Student(id: 1, name: 'name2'),
          Student(id: 1, name: 'name3'),
        ]);

        return ScrollablePositionedList.builder(
          itemCount: _getStudentsCount(students),
          itemBuilder: (context, index) => _buildList(context, index),
        );
      },
    );
  }

  Future<List<Student>> _getStudents() async {
    return await widget.databaseService.students;
  }

  int _getStudentsCount(List<Student> students) {
    return students.length;
  }

  Widget _buildList(BuildContext context, int index) {
    return ExpansionTile(
      title: Row(
        children: [
          Expanded(flex: 2, child: Text(students[index].name)),
          Text("年"),
        ],
      ),
      children: [
        Padding(
          padding: EdgeInsets.all(AppSpacing.small),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => {},
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(130, 40),
                    ),
                    child: const Text('Назначить'),
                  ),
                  ElevatedButton(
                    onPressed: () => {},
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
                    onPressed: () => {},
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(130, 40),
                    ),
                    child: const Text('История'),
                  ),
                  ElevatedButton(
                    onPressed: () => {},
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
  }
}
