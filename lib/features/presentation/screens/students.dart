// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:logger/logger.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import 'package:duty_selector/design.dart';
import 'package:duty_selector/features/data/absence_type.dart';
import 'package:duty_selector/features/data/database.dart';
import 'package:duty_selector/features/data/duties_eventbus.dart';
import 'package:duty_selector/features/data/duty_selection_type.dart';
import 'package:duty_selector/features/data/models/absence.dart';
import 'package:duty_selector/features/data/models/duty.dart';
import 'package:duty_selector/features/data/models/student.dart';
import 'package:duty_selector/features/domain/duty_selection/student_manager.dart';
import 'package:duty_selector/features/presentation/widgets/display/students_list.dart';
import 'package:duty_selector/features/presentation/widgets/texts/accent_text.dart';
import 'package:duty_selector/features/presentation/widgets/texts/regular_text.dart';
import 'package:duty_selector/features/presentation/widgets/texts/title_text.dart';

var logger = Logger();

class StudentsPage extends StatefulWidget {
  final DatabaseService databaseService;
  final DutySelectionType selectionType;
  final String dutyType;

  const StudentsPage({
    super.key,
    required this.databaseService,
    required this.selectionType,
    required this.dutyType,
  });

  @override
  State<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  @override
  Widget build(BuildContext context) {
    var manager = StudentManager(widget.databaseService);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => {PersistentNavBarNavigator.pop(context)},
          icon: const Icon(Ionicons.arrow_back),
        ),
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: const TitleText(text: 'Выбрать из списка'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.medium),
          SizedBox(
            height:
                MediaQuery.of(context).size.height *
                AppSpacing.tableHeightRatio,
            child: getList(manager),
          ),
          const SizedBox(height: AppSpacing.small),
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

  FutureBuilder<StudentsList> getList(StudentManager manager) {
    return FutureBuilder(
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

        return s.data!;
      },
    );
  }

  Future<StudentsList> _generateStudentsList(
    StudentManager manager,
    DutySelectionType type,
  ) async {
    final r = await widget.databaseService.getStudents();
    manager.initStudentsMap(r);
    await manager.initAbsentStudentsFromDB();

    if (type == DutySelectionType.byHand || type == DutySelectionType.random) {
      return StudentsList(studentManager: manager, useCheckbox: true);
    }

    return StudentsList(studentManager: manager);
  }

  void _performSelection(
    StudentManager manager,
    DutySelectionType selectionType,
  ) async {
    Map<Student, AbsenceType> candidates;

    // those with checkbosex
    if (selectionType == DutySelectionType.byHand ||
        selectionType == DutySelectionType.random) {
      candidates = manager.getCandidates();
    } else {
      candidates = manager.getPresentStudents();
    }

    int sLimit = candidates.length;

    logger.i('Selected candidates: $candidates for $selectionType');

    if (selectionType == DutySelectionType.next2) {
      sLimit = 2;
    } else if (selectionType == DutySelectionType.next4) {
      sLimit = 4;
    }

    final missing = candidates.entries.where(
      (e) => e.value != AbsenceType.selected,
    );

    logger.i('Missing: $missing');

    Future.wait(
      missing.map(
        (e) => widget.databaseService.addAbsence(
          Absence(
            studentId: e.key.id!,
            reason: e.value.name,
            date: DateTime.now(),
            expireDuration: 80,
          ),
        ),
      ),
    );

    final selected = candidates.entries
        .where((e) => e.value == AbsenceType.selected)
        .map((e) => e.key)
        .toSet();

    logger.i('Selected: $selected');

    final duties = await widget.databaseService.getNewDutiesWithin(
      selected,
      limit: sLimit,
    );

    Future.wait(
      duties.map(
        (e) => widget.databaseService.addDuty(
          Duty(
            type: widget.dutyType,
            date: DateTime.parse(
              DateFormat('yyyy-MM-dd HH:mm:ss').format(.now()),
            ),
            studentId: e.id!,
          ),
        ),
      ),
    );

    DutiesEventBus.send(duties);

    if (context.mounted) {
      PersistentNavBarNavigator.pop(context);
    }
  }
}
