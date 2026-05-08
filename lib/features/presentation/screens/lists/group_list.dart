import 'package:duty_selector/design.dart';
import 'package:duty_selector/features/data/database.dart';
import 'package:duty_selector/features/domain/duty_selection/student_manager.dart';
import 'package:duty_selector/features/presentation/widgets/display/students_list.dart';
import 'package:duty_selector/features/presentation/widgets/texts/accent_text.dart';
import 'package:duty_selector/features/presentation/widgets/texts/title_text.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class GroupList extends StatelessWidget {
  final DatabaseService databaseService;
  const GroupList({super.key, required this.databaseService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: TitleText(text: 'Список группы'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.secondary,
        onPressed: onPressed,
        child: Icon(Ionicons.pencil, color: AppColors.text),
      ),
      body: FutureBuilder(
        future: _getStudentsList(),
        builder: (c, s) {
          if (!s.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (s.hasError) {
            logger.e(
              'Error while building Students List',
              error: s.error,
              stackTrace: s.stackTrace,
            );
            return const AccentText(text: 'Ошибка');
          }

          return s.data!;
        },
      ),
    );
  }

  Future<StudentsList> _getStudentsList() async {
    final students = await databaseService.getAbsenceNowStudents(
      includeAll: true,
    );
    final manager = StudentManager(databaseService, studentsAbsences: students);

    return StudentsList(studentManager: manager, onlyHistory: true);
  }

  void onPressed() {
    logger.i('Pressed');
  }
}
