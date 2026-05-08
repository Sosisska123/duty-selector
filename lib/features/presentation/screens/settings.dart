import 'package:duty_selector/features/data/absence_type.dart';
import 'package:duty_selector/features/data/models/absence.dart';
import 'package:duty_selector/features/data/models/duty.dart';
import 'package:duty_selector/features/presentation/widgets/texts/accent_text.dart';
import 'package:duty_selector/features/presentation/widgets/texts/regular_text.dart';
import 'package:duty_selector/features/presentation/widgets/texts/title_text.dart';
import 'package:duty_selector/features/data/database.dart';
import 'package:duty_selector/features/data/models/student.dart';
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
      body: Center(child: AccentText(text: 'В разработке')),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: Column(
  //       children: [
  //         TitleText(text: 'Settings'),
  //         ElevatedButton(
  //           onPressed: _loadStudsFromFile,
  //           child: RegularText(text: 'Load Students from file'),
  //         ),
  //         ElevatedButton(
  //           onPressed: _selectStuds,
  //           child: RegularText(text: 'Select students'),
  //         ),
  //         ElevatedButton(
  //           onPressed: _clearStudents,
  //           child: RegularText(text: 'Clear students'),
  //         ),
  //         ElevatedButton(
  //           onPressed: _dropStudsTable,
  //           child: RegularText(text: 'Drop students Table'),
  //         ),
  //         ElevatedButton(
  //           onPressed: _dropDutiesTable,
  //           child: RegularText(text: 'Drop Duties Table'),
  //         ),
  //         ElevatedButton(
  //           onPressed: _selectDuties,
  //           child: RegularText(text: 'Select duties'),
  //         ),
  //         ElevatedButton(
  //           onPressed: _clearDuties,
  //           child: RegularText(text: 'Clear duites'),
  //         ),
  //         ElevatedButton(
  //           onPressed: () => _mockDuties(10),
  //           child: RegularText(text: 'Mock duties'),
  //         ),
  //         ElevatedButton(
  //           onPressed: () => _mockAbsences(10),
  //           child: RegularText(text: 'Mock absences'),
  //         ),
  //         ElevatedButton(
  //           onPressed: () => _clearAbsences(),
  //           child: RegularText(text: 'Clear absences'),
  //         ),
  //         ElevatedButton(
  //           onPressed: () => _selectAbsences(),
  //           child: RegularText(text: 'Select absences'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // void _loadStudsFromFile() async {
  //   List<Student> students = await parseNames();
  //   printAll(students);
  //   await databaseService.addStudents(students);
  // }

  // void _dropStudsTable() async {
  //   await databaseService.dropTable('students');
  //   logger.i('Drop Students');
  // }

  // void _dropDutiesTable() async {
  //   await databaseService.dropTable('duties');
  //   logger.i('Drop Duties');
  // }

  // void _selectStuds() async {
  //   var duties = await databaseService.getStudents();
  //   printAll(duties);
  // }

  // void _selectDuties() async {
  //   var students = await databaseService.getDuties();
  //   students.map((e) => logger.i(e.toString()));
  //   printAll(students);
  // }

  // void _clearStudents() async {
  //   var count = await databaseService.clear('students');
  //   logger.i('Cleared $count');
  // }

  // void _clearDuties() async {
  //   var count = await databaseService.clear('duties');
  //   logger.i('Cleared $count');
  // }

  // void _mockDuties(int count) async {
  //   for (int i = 0; i < count; i++) {
  //     await databaseService.addDuty(
  //       Duty(
  //         type: "кабинет Шакирова",
  //         date: DateTime.now(),
  //         studentId: Random().nextInt(26) + 1,
  //       ),
  //     );
  //   }
  //   logger.i('Mocked $count duties');
  // }

  // void _mockAbsences(int count) async {
  //   for (int i = 0; i < count; i++) {
  //     await databaseService.addAbsence(
  //       Absence(
  //         reason: AbsenceType.sick.name,
  //         date: DateTime.now(),
  //         studentId: Random().nextInt(26) + 1,
  //         expireDuration: 80,
  //       ),
  //     );
  //   }
  //   logger.i('Mocked $count Absences');
  // }

  // void _clearAbsences() async {
  //   var count = await databaseService.clear('absences');
  //   logger.i('Cleared $count from absences');
  // }

  // void _selectAbsences() async {
  //   var students = await databaseService.getAbsences();
  //   students.map((e) => logger.i(e.toString()));
  //   printAll(students);
  // }
}

void printAll(List list) {
  for (var e in list) {
    logger.i(e.toString());
  }
}
