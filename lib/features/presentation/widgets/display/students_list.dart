import 'package:duty_selector/features/domain/duty_selection/student_manager.dart';
import 'package:duty_selector/features/presentation/widgets/statuses/bordered_square.dart';
import 'package:duty_selector/features/presentation/widgets/texts/accent_text.dart';
import 'package:duty_selector/features/presentation/widgets/texts/regular_text.dart';
import 'package:duty_selector/design.dart';
import 'package:duty_selector/features/data/models/student.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class StudentsList extends StatefulWidget {
  final StudentManager studentManager;
  final bool useCheckbox;
  final bool useInitials;
  final bool useExpansionTile;

  const StudentsList({
    super.key,
    required this.studentManager,
    this.useCheckbox = false,
    this.useInitials = true,
    this.useExpansionTile = true,
  });

  @override
  State<StudentsList> createState() => _StudentsListState();

  Set<Student> getTargetStudents({int? limit}) =>
      studentManager.getTargetStudents(limit);
}

class _StudentsListState extends State<StudentsList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.studentManager.getStudentsFromDB(),
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

        // Important! Create an ordered Students map to work with
        widget.studentManager.initStudentsMap(snapshot.data!);

        return ListView.builder(
          itemCount: widget.studentManager.len,
          itemBuilder: (c, idx) => _buildList(c, idx),
        );
      },
    );
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
                  _isStudentSick(index)
                      ? _generateButton(
                          'Выздоровел',
                          () => _setStudentSick(index, false),
                        )
                      : _generateButton(
                          'Болеет (7дн.)',
                          () => _setStudentSick(index, true),
                        ),
                  _generateButton('Пропуск', () => _setStudentSkip(index)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _generateButton(
                    'По уважительной',
                    () => _setStudentSkip(index, withGoodReason: true),
                  ),
                  _generateButton(
                    'По заявлению',
                    () => _setStudentSkip(index, byApplication: true),
                  ),
                ],
              ),
              _generateButton(
                'История',
                () => _openStudentHistory(context, index),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Row _makeStudentRow(int index) {
    List<Widget> children = [];

    if (widget.useCheckbox && _canBeDuty(index)) {
      children.add(
        Checkbox(
          value: _isStudentSelected(index),
          onChanged: (value) {
            setState(() {
              _setStudentSelected(index, value ?? false);
            });
          },
        ),
      );
    }

    children.add(
      RegularText(
        text: widget.useInitials
            ? _getStudent(index)!.initialsFirstname
            : _getStudent(index)!.fullName,
      ),
    );
    if (_isStudentSick(index)) {
      children.add(const BorderedSquare(text: 'Б', color: Colors.green));
    }
    if (_isStudentImmune(index)) {
      children.add(const BorderedSquare(text: 'И', color: Colors.blue));
    }

    return Row(spacing: AppSpacing.small, children: children);
  }

  Student? _getStudent(int index) => widget.studentManager.getStudent(index);

  bool _isStudentImmune(int index) =>
      widget.studentManager.isStudentImmune(index);

  void _setStudentSick(int index, bool isSick) => setState(() {
    widget.studentManager.setStudentSick(index, isSick);
  });

  bool _isStudentSick(int index) => widget.studentManager.isStudentSick(index);

  void _setStudentSelected(int index, bool value) =>
      widget.studentManager.setStudentSelected(index, value);

  bool _isStudentSelected(int index) =>
      widget.studentManager.isStudentSelected(index);

  void _setStudentSkip(
    int index, {
    bool withGoodReason = false,
    bool byApplication = false,
  }) => widget.studentManager.setStudentPass(
    index,
    withGoodReason: withGoodReason,
    byApplication: byApplication,
  );

  void _openStudentHistory(BuildContext context, int index) {}

  bool _canBeDuty(int index) =>
      !_isStudentSick(index) && !_isStudentImmune(index);

  void _selectAll(bool value) {
    setState(() {
      widget.studentManager.setAllSelected(value);
      // TODO:
    });
  }
}

ElevatedButton _generateButton(String text, Function() onPressed) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(minimumSize: const Size(170, 40)),
    child: Text(text),
  );
}
