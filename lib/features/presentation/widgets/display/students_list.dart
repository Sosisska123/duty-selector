import 'package:duty_selector/features/presentation/widgets/texts/accent_text.dart';
import 'package:duty_selector/features/presentation/widgets/texts/regular_text.dart';
import 'package:duty_selector/features/data/database.dart';
import 'package:duty_selector/design.dart';
import 'package:duty_selector/features/data/models/student.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

var logger = Logger();

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

        if (snapshot.hasError) {
          logger.e(
            'Error while building Students List',
            error: snapshot.error,
            stackTrace: snapshot.stackTrace,
          );
          return const AccentText(text: 'Ошибка');
        }

        students.addAll(snapshot.data!);

        return ListView.builder(
          itemCount: students.length,
          itemBuilder: (c, idx) => _buildList(context, idx),
        );
      },
    );
  }

  Future<List<Student>> _getStudents() async {
    return await widget.databaseService.getStudents();
  }

  Widget _buildList(BuildContext context, int index) {
    return ExpansionTile(
      title: Row(
        children: [
          Expanded(flex: 2, child: RegularText(text: students[index].fullName)),
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
