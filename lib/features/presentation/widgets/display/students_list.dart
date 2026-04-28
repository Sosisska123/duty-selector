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
  final Map<int, Student> students = {};
  final Set<int> sickStudents = <int>{};
  final Set<int> checkedStudents = <int>{};
  final DatabaseService databaseService;
  final bool useCheckbox;
  final bool moveSickPeopleAway;
  final bool useInitials;
  final bool useExpansionTile;

  StudentsList({
    super.key,
    required this.databaseService,
    this.useCheckbox = true,
    this.moveSickPeopleAway = true,
    this.useInitials = true,
    this.useExpansionTile = true,
  });

  @override
  State<StudentsList> createState() => _StudentsListState();

  Set<Student> getCheckedStudents({int? limit, bool withSick = false}) {
    Set<Student> result = {};

    for (var student in students.values) {
      if (checkedStudents.contains(student.id! - 1)) {
        result.add(student);
      }
    }

    return result
        .where((e) => withSick ? true : !_isStudentSick(e.id! - 1))
        .take(limit ?? result.length)
        .toSet();
  }

  bool _isStudentSick(int index) {
    return sickStudents.contains(index);
  }

  bool _isStudentImmune(int index) {
    return index == 3;
  }
}

class _StudentsListState extends State<StudentsList> {
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

        if (widget.students.isEmpty) {
          for (var i = 0; i < snapshot.data!.length; i++) {
            widget.students[i] = snapshot.data![i];
          }
        }

        return ListView.builder(
          itemCount: widget.students.length,
          itemBuilder: (c, idx) => _buildList(c, idx),
        );
      },
    );
  }

  Future<List<Student>> _getStudents() async {
    return await widget.databaseService.getStudents();
  }

  Widget _buildList(BuildContext context, int index) {
    return widget.useExpansionTile
        ? _makeStudentExpansionTile(index)
        : _makeStudentRow(index);
  }

  ExpansionTile _makeStudentExpansionTile(int index) {
    return ExpansionTile(
      title: _makeStudentRow(index),
      children: [
        Padding(
          padding: EdgeInsets.all(AppSpacing.small),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  widget._isStudentSick(index)
                      ? _generateButton(
                          'Выздоровел',
                          () => _setStudentSick(index, false),
                        )
                      : _generateButton(
                          'Болеет (7дн.)',
                          () => _setStudentSick(index, true),
                        ),
                  _generateButton('История', () => _openStudentHistory(index)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Row _makeStudentRow(int index) {
    List<Widget> children = [];
    if (widget.useCheckbox) {
      children.add(
        Checkbox(
          value: widget.checkedStudents.contains(index),
          onChanged: (value) {
            setState(() {
              if (value == true) {
                widget.checkedStudents.add(index);
              } else {
                widget.checkedStudents.remove(index);
              }
            });
          },
        ),
      );
    }

    children.add(
      RegularText(
        text: widget.useInitials
            ? widget.students[index]!.initialsFirstname
            : widget.students[index]!.fullName,
      ),
    );
    if (widget._isStudentSick(index)) {
      children.add(const BorderedSquare(text: 'Б', color: Colors.green));
    }
    if (widget._isStudentImmune(index)) {
      children.add(const BorderedSquare(text: 'И', color: Colors.blue));
    }

    return Row(spacing: AppSpacing.small, children: children);
  }

  void _setStudentSick(int index, bool isSick) {
    setState(() {
      if (isSick) {
        widget.sickStudents.add(index);
      } else {
        widget.sickStudents.remove(index);
      }
    });
  }

  void _openStudentHistory(int index) {}
}

ElevatedButton _generateButton(String text, Function() onPressed) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(minimumSize: const Size(150, 40)),
    child: Text(text),
  );
}
