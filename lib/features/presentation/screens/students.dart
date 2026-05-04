import 'package:duty_selector/features/data/duty_selection_type.dart';
import 'package:duty_selector/features/domain/duty_selection/student_manager.dart';
import 'package:duty_selector/features/presentation/widgets/display/students_list.dart';
import 'package:duty_selector/features/presentation/widgets/texts/accent_text.dart';
import 'package:duty_selector/features/presentation/widgets/texts/regular_text.dart';
import 'package:duty_selector/features/presentation/widgets/texts/title_text.dart';
import 'package:duty_selector/features/data/database.dart';
import 'package:duty_selector/design.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import 'package:logger/logger.dart';

var logger = Logger();

class StudentsPage extends StatefulWidget {
  final DatabaseService databaseService;
  final DutySelectionType selectionType;

  const StudentsPage({
    super.key,
    required this.databaseService,
    required this.selectionType,
  });

  @override
  State<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  StudentManager initManager() {
    return StudentManager(widget.databaseService);
  }

  @override
  Widget build(BuildContext context) {
    var manager = initManager();

    var studentsList = FutureBuilder(
      future: _generateStudentsList(manager, widget.selectionType),
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

        return s.data ??
            StudentsList(
              studentManager: StudentManager(widget.databaseService),
            );
      },
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => {PersistentNavBarNavigator.pop(context)},
          icon: Icon(Ionicons.arrow_back),
        ),
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: TitleText(text: 'Выбрать из списка'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AppSpacing.medium),
          SizedBox(
            height:
                MediaQuery.of(context).size.height *
                AppSpacing.tableHeightRatio,
            child: studentsList,
          ),
          SizedBox(height: AppSpacing.small),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              onPressed: () => _performSelection(manager, widget.selectionType),
              child: RegularText(
                text: 'Выбрать ${widget.selectionType.name.toLowerCase()}',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<StudentsList> _generateStudentsList(
    StudentManager manager,
    DutySelectionType type,
  ) async {
    final r = await manager.getStudentsFromDB();
    manager.initStudentsMap(r);
    manager.addSickStudentsFromDB();

    if (type == DutySelectionType.byHand || type == DutySelectionType.random) {
      return StudentsList(studentManager: manager, useCheckbox: true);
    }

    return StudentsList(studentManager: manager);
  }

  void _performSelection(
    StudentManager manager,
    DutySelectionType selectionType,
  ) {
    int? sLimit;
    if (selectionType == DutySelectionType.next2) sLimit = 2;
    if (selectionType == DutySelectionType.next4) sLimit = 4;

    var targetStudents = manager.getTargetStudents(sLimit);
    var excludedStudents = manager.getExcludedStudents();

    logger.i('Selected students: $targetStudents for $selectionType');
    logger.i('Excluded students: $excludedStudents');

    final snackBar = SnackBar(
      content: Text(
        'Выбрано ${targetStudents.map((e) => e.initials).join(', ')}',
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    PersistentNavBarNavigator.pop(context);
  }
}
