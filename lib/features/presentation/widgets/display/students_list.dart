import 'package:duty_selector/features/data/absence_type.dart';
import 'package:duty_selector/features/domain/duty_selection/student_manager.dart';
import 'package:duty_selector/features/presentation/screens/student_history.dart';
import 'package:duty_selector/features/presentation/widgets/statuses/bordered_square.dart';
import 'package:duty_selector/features/presentation/widgets/texts/regular_text.dart';
import 'package:duty_selector/design.dart';
import 'package:duty_selector/features/data/models/student.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

var logger = Logger();

class StudentsList extends StatefulWidget {
  final StudentManager studentManager;
  final bool useCheckbox;
  final bool useInitials;
  final bool useExpansionTile;
  final bool onlyHistory;
  final bool onlyMissing;

  const StudentsList({
    super.key,
    required this.studentManager,
    this.useCheckbox = false,
    this.useInitials = true,
    this.useExpansionTile = true,
    this.onlyHistory = false,
    this.onlyMissing = false,
  });

  @override
  State<StudentsList> createState() => _StudentsListState();
}

class _StudentsListState extends State<StudentsList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.studentManager.studentsMapLen,
      itemBuilder: (c, idx) => _buildList(c, idx),
    );
  }

  Widget _buildList(BuildContext context, int index) {
    if (widget.onlyMissing && _isStudentHere(index)) {
      return SizedBox();
    }

    return widget.useExpansionTile
        ? _makeStudentExpansionTile(index)
        : _makeStudentRow(index);
  }

  ExpansionTile _makeStudentExpansionTile(int index) {
    return widget.onlyHistory
        ? ExpansionTile(
            title: _makeStudentRow(index),
            children: [
              Padding(
                padding: EdgeInsets.all(AppSpacing.small),
                child: Column(
                  children: [
                    _generateButton(
                      'История',
                      () => _openStudentHistory(context, index),
                    ),
                  ],
                ),
              ),
            ],
          )
        : ExpansionTile(
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
                        _isStudentWithoutReason(index)
                            ? _generateButton(
                                'Пришел',
                                () => _setStudentAttendance(
                                  index,
                                  AbsenceType.present,
                                ),
                              )
                            : _generateButton(
                                'Пропуск',
                                () => _setStudentAttendance(
                                  index,
                                  AbsenceType.gone,
                                ),
                              ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _isStudentWithGoodReason(index)
                            ? _generateButton(
                                'Без уважительной',
                                () => _setStudentAttendance(
                                  index,
                                  AbsenceType.present,
                                ),
                              )
                            : _generateButton(
                                'По уважительной',
                                () => _setStudentAttendance(
                                  index,
                                  AbsenceType.goodReason,
                                ),
                              ),
                        _isStudentByApplication(index)
                            ? _generateButton(
                                'Без заявления',
                                () => _setStudentAttendance(
                                  index,
                                  AbsenceType.present,
                                ),
                              )
                            : _generateButton(
                                'По заявлению',
                                () => _setStudentAttendance(
                                  index,
                                  AbsenceType.byApplication,
                                ),
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

    if (widget.useCheckbox && _isStudentHere(index)) {
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
    if (_isStudentWithoutReason(index)) {
      children.add(const BorderedSquare(text: 'У', color: Colors.red));
    }
    if (_isStudentWithGoodReason(index)) {
      children.add(const BorderedSquare(text: 'У', color: Colors.yellow));
    }
    if (_isStudentByApplication(index)) {
      children.add(const BorderedSquare(text: 'З', color: Colors.yellow));
    }

    return Row(spacing: AppSpacing.small, children: children);
  }

  Student? _getStudent(int index) => widget.studentManager.getStudent(index);

  void _setStudentSick(int index, bool isSick) => setState(() {
    widget.studentManager.setStudentSick(index, isSick);
  });

  bool _isStudentSick(int index) => widget.studentManager.isStudentSick(index);

  void _setStudentSelected(int index, bool value) =>
      widget.studentManager.setStudentSelected(index, value);

  bool _isStudentSelected(int index) =>
      widget.studentManager.isStudentSelected(index);

  void _setStudentAttendance(int index, AbsenceType type) => setState(() {
    widget.studentManager.setStudentAttendance(index, type);
  });

  void _openStudentHistory(BuildContext context, int index) {
    final student = _getStudent(index);
    PersistentNavBarNavigator.pushNewScreen(
      context,
      screen: StudentHistory(
        student: student!,
        databaseService: widget.studentManager.database,
      ),
    );
    // TODO: maybe add event bus to react to absencse list changes
  }

  bool _isStudentHere(int index) =>
      widget.studentManager.isStudentPresent(index);

  bool _isStudentWithoutReason(int index) =>
      widget.studentManager.isStudentWithoutReason(index);

  bool _isStudentWithGoodReason(int index) =>
      widget.studentManager.isStudentWithGoodReason(index);

  bool _isStudentByApplication(int index) =>
      widget.studentManager.isStudentByApplication(index);
}

ElevatedButton _generateButton(String text, Function() onPressed) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(minimumSize: const Size(170, 40)),
    child: Text(text),
  );
}
