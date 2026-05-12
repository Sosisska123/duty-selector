import 'package:duty_selector/design.dart';
import 'package:duty_selector/features/data/database.dart';
import 'package:duty_selector/features/domain/duty_selection/student_manager.dart';
import 'package:duty_selector/features/presentation/screens/modal/add_absence_modal.dart';
import 'package:duty_selector/features/presentation/widgets/display/students_list.dart';
import 'package:duty_selector/features/presentation/widgets/texts/accent_text.dart';

import 'package:duty_selector/features/presentation/widgets/texts/title_text.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class AttendanceList extends StatelessWidget {
  final DatabaseService databaseService;
  const AttendanceList({super.key, required this.databaseService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: TitleText(text: 'Отсутствуют сейчас'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.secondary,
        onPressed: () => _editAbsence(context),
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

    return StudentsList(studentManager: manager, onlyMissing: true);
  }

  void _editAbsence(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          snap: true,
          builder: (BuildContext context, ScrollController scrollController) {
            return AddAbsenceModal(
              scrollController: scrollController,
              databaseService: databaseService,
              studentId: 1, // TODO:
            );
          },
        );
      },
    );
  }
}
