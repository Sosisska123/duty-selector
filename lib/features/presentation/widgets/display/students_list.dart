import 'package:duty_selector/features/presentation/widgets/statuses/bordered_square.dart';
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
  final bool useCheckbox;
  final bool moveSickPeopleAway;
  final bool useInitials;
  final bool useExpansionTile;

  const StudentsList({
    super.key,
    required this.databaseService,
    this.useCheckbox = true,
    this.moveSickPeopleAway = true,
    this.useInitials = true,
    this.useExpansionTile = true,
  });

  @override
  State<StudentsList> createState() => _StudentsListState();
}

class _StudentsListState extends State<StudentsList> {
  List<Student> students = <Student>[];
  Set<int> checkedStudents = <int>{};
  Set<int> sickStudents = <int>{};

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

        students = snapshot.data!;

        return ListView.builder(
          itemBuilder: (c, idx) => _buildList(context, idx),
        );
      },
    );
  }

  Future<List<Student>> _getStudents() async {
    return await widget.databaseService.getStudents();
  }

  Widget _buildList(BuildContext context, int index) {
    var studentId = students[index].id!;
    return widget.useExpansionTile
        ? ExpansionTile(
            key: ValueKey(studentId),
            title: getStudentRow(studentId),
            children: [
              Padding(
                padding: EdgeInsets.all(AppSpacing.small),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        sickStudents.contains(studentId)
                            ? _generateButton(
                                'Выздоровел',
                                () => _setStudentSick(studentId, false),
                              )
                            : _generateButton(
                                'Болеет (7дн.)',
                                () => _setStudentSick(studentId, true),
                              ),
                        _generateButton(
                          'История',
                          () => _openStudentHistory(studentId),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )
        : getStudentRow(studentId);
  }

  Row getStudentRow(int index) {
    List<Widget> children = [];
    if (widget.useCheckbox) {
      children.add(
        Checkbox(
          value: checkedStudents.contains(index),
          onChanged: (value) {
            setState(() {
              if (value == true) {
                checkedStudents.add(index);
              } else {
                checkedStudents.remove(index);
              }
            });
          },
        ),
      );
    }

    children.add(
      RegularText(
        text: widget.useInitials
            ? students[index].initialsFirstname
            : students[index].fullName,
      ),
    );
    if (sickStudents.contains(index)) {
      children.add(const BorderedSquare(text: 'Б', color: Colors.green));
    }
    if (index == 3) {
      children.add(const BorderedSquare(text: 'И', color: Colors.blue));
    }
    var preRow = Row(spacing: AppSpacing.small, children: children);

    return preRow;
  }

  void _setStudentSick(int index, bool isSick) {
    setState(() {
      if (isSick) {
        sickStudents.add(index);
      } else {
        sickStudents.remove(index);
      }

      _sortList();
    });
  }

  void _openStudentHistory(int index) {}

  void _sortList() {
    students.sort((a, b) {
      final aIsSick = sickStudents.contains(a.id);
      final bIsSick = sickStudents.contains(b.id);

      if (aIsSick && !bIsSick) return 1;
      if (!aIsSick && bIsSick) return -1;

      return a.id!.compareTo(b.id!);
    });
  }
}

ElevatedButton _generateButton(String text, Function() onPressed) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(minimumSize: const Size(150, 40)),
    child: Text(text),
  );
}
