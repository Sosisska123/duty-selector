import 'package:duty_selector/features/data/duty_selection_type.dart';
import 'package:duty_selector/features/domain/duty_selection/student_manager.dart';
import 'package:duty_selector/features/presentation/widgets/display/students_list.dart';
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
  @override
  Widget build(BuildContext context) {
    var studentsList = _generateStudentsList(widget.selectionType);

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
              onPressed: () =>
                  _performSelection(studentsList, widget.selectionType),
              child: RegularText(
                text: 'Выбрать ${widget.selectionType.name.toLowerCase()}',
              ),
            ),
          ),
        ],
      ),
    );
  }

  StudentsList _generateStudentsList(DutySelectionType type) {
    switch (type) {
      case DutySelectionType.byHand:
        return StudentsList(
          studentManager: StudentManager(widget.databaseService),
          useCheckbox: true,
        );
      default:
        break;
    }
    return StudentsList(studentManager: StudentManager(widget.databaseService));
  }

  void _performSelection(
    StudentsList studentsList,
    DutySelectionType selectionType,
  ) {
    int? sLimit;
    if (selectionType == DutySelectionType.next2) sLimit = 2;
    if (selectionType == DutySelectionType.next4) sLimit = 4;

    var targetStudents = studentsList.getTargetStudents(limit: sLimit);
    var excludedStudents = studentsList.getExcludedStudents();

    logger.i('Selected students: $targetStudents for $selectionType');
    logger.i('Excluded students: $excludedStudents');
  }
}
