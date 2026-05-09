import 'package:duty_selector/features/data/models/student.dart';
import 'package:duty_selector/features/presentation/widgets/buttons_group/buttons_group.dart';
import 'package:duty_selector/features/presentation/widgets/buttons_group/group_button.dart';
import 'package:duty_selector/features/data/database.dart';
import 'package:duty_selector/features/presentation/widgets/texts/title_text.dart';
import 'package:duty_selector/utils/student_parser.dart';
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
      body: ButtonsGroup(
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
    );
  }
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

void snackText(final BuildContext context, final String text) {
  final snackBar = SnackBar(content: Text(text));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
