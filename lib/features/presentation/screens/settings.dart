import 'dart:math';

import 'package:duty_selector/features/data/absence_type.dart';
import 'package:duty_selector/features/data/models/absence.dart';
import 'package:duty_selector/features/data/models/student.dart';
import 'package:duty_selector/features/presentation/widgets/buttons_group/buttons_group.dart';
import 'package:duty_selector/features/presentation/widgets/buttons_group/group_button.dart';
import 'package:duty_selector/features/data/database.dart';
import 'package:duty_selector/features/presentation/widgets/texts/title_text.dart';
import 'package:duty_selector/utils/student_parser.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class SettingsScreen extends StatelessWidget {
  final DatabaseService databaseService;
  const SettingsScreen({super.key, required this.databaseService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const TitleText(text: 'Настройки'),
      ),
      body: Column(
        crossAxisAlignment: .start,
        children: [
          ButtonsGroup(
            children: [
              GroupButton(
                text: 'Загрузить список группы',
                tapCallback: () => _loadStudsFromFile(context, databaseService),
              ),
              GroupButton(
                text: 'Очистить список группы',
                tapCallback: () => _clearStudents(context, databaseService),
              ),
            ],
          ),
          if (kDebugMode) const TitleText(text: 'Dev'),
          if (kDebugMode)
            ButtonsGroup(
              children: [
                GroupButton(
                  text: 'Добавить 10 рандом пропусков',
                  tapCallback: () => _mockAbsences(databaseService, 10),
                ),
                GroupButton(
                  text: 'Очистить пропуски',
                  tapCallback: () => _clearAbsences(databaseService),
                ),
                GroupButton(
                  text: 'Вывести пропуски в консоль',
                  tapCallback: () => _selectAbsences(databaseService),
                ),
                GroupButton(
                  text: 'Очистить дежурства',
                  tapCallback: () => _clearDuties(databaseService),
                ),
                GroupButton(
                  text: 'Вывести дежурства',
                  tapCallback: () => _selectDuties(databaseService),
                ),
              ],
            ),
        ],
      ),
    );
  }

  void _clearDuties(final DatabaseService databaseService) async {
    final rowsCount = await databaseService.clear('duties');
    logger.d('Deleted $rowsCount from duties');
  }
}

void _selectDuties(DatabaseService databaseService) async {
  var students = await databaseService.getDuties();
  logger.i(students);
}

void _clearStudents(
  final BuildContext context,
  final DatabaseService databaseService,
) async {
  final rowsCount = await databaseService.clear('students');

  if (context.mounted) {
    snackText(context, 'Список группы очищен. ($rowsCount строк)');
  }
}

void _loadStudsFromFile(
  final BuildContext context,
  final DatabaseService databaseService,
) async {
  final isTableEmpty = (await databaseService.getStudents()).isEmpty;

  if (!isTableEmpty) {
    if (context.mounted) {
      snackText(context, 'Таблица студентов не пуста. Очистите её сначала.');
    }
    return;
  }

  List<Student> students = await parseNames();
  logger.d('Loaded students: $students');

  final lastRowId = await databaseService.addStudents(students);

  if (lastRowId != students.length) {
    if (context.mounted) {
      snackText(context, 'Ошибка загрузки студентов');
    }
    return;
  }

  if (context.mounted) {
    snackText(context, 'Успешно загружено ${students.length} студентов');
  }
}

void _mockAbsences(
  final DatabaseService databaseService,
  final int count,
) async {
  for (int i = 0; i < count; i++) {
    await databaseService.addAbsence(
      Absence(
        reason: [
          AbsenceType.sick.name,
          AbsenceType.gone.name,
          AbsenceType.goodReason.name,
          AbsenceType.byApplication.name,
        ].elementAt(Random().nextInt(4)),
        date: DateTime.now(),
        studentId: Random().nextInt(26) + 1,
        expireDuration: 80,
      ),
    );
  }
  logger.i('Mocked $count Absences');
}

void _clearAbsences(final DatabaseService databaseService) async {
  var count = await databaseService.clear('absences');
  logger.i('Cleared $count from absences');
}

void _selectAbsences(final DatabaseService databaseService) async {
  var students = await databaseService.getAbsences();
  logger.i(students);
}

void snackText(final BuildContext context, final String text) {
  final snackBar = SnackBar(content: Text(text));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
