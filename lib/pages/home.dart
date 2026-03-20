import 'package:flutter/material.dart';

import 'package:duty_selector/database.dart';
import 'package:duty_selector/design.dart';
import 'package:duty_selector/models/student.dart';
import 'package:duty_selector/utils/utils.dart';
import 'package:duty_selector/widgets/students_table.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DutyDatabaseService _databaseService = DutyDatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(future: _getStudents(), builder: generateTable),
      appBar: AppBar(
        title: Center(
          child: const Text('Выбрать дедурных', style: AppTextStyles.headline),
        ),
      ),
    );
  }

  // Generate home page table widget
  Widget generateTable(
    BuildContext context,
    AsyncSnapshot<List<Student>> snapshot,
  ) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    } else if (snapshot.connectionState == ConnectionState.done) {
      if (snapshot.hasError) return const Text("Error");
    }

    ItemScrollController itemScrollController = ItemScrollController();

    return Column(
      children: [
        SizedBox(
          height:
              MediaQuery.of(context).size.height * AppSpacing.tableHeightRatio,
          child: StudentTiles(
            students: snapshot.data!,
            itemScrollController: itemScrollController,
          ),
        ),
        ElevatedButton(
          onPressed: () =>
              _selectDuty(context, itemScrollController, _databaseService),
          child: const Text("Выбрать дежурного", style: AppTextStyles.body),
        ),
        ElevatedButton(
          onPressed: () => scrollTo(itemScrollController, 20),
          child: const Text("Настройки", style: AppTextStyles.body),
        ),
        ElevatedButton(
          onPressed: _clearDatabase,
          child: const Text("(dev) refresh data", style: AppTextStyles.body),
        ),
      ],
    );
  }

  // Get list of students from database or parse from file
  Future<List<Student>> _getStudents() async {
    List<Student> studs = await _databaseService.students();

    if (studs.isEmpty) {
      List<String> names = await parseNames();
      studs = loadNamesIntoDatabase(names, _databaseService);
    }

    return studs;
  }

  Future<void> _clearDatabase() async {
    await _databaseService.deleteAllStudents();
    await _databaseService.deleteAllDuties();
    setState(() {
      _getStudents();
    });
  }
}

void _selectDuty(
  BuildContext context,
  ItemScrollController itemScrollController,
  DutyDatabaseService databaseService,
) async {
  // TODO: get type from shared preferences
  final String dutyType = "кабинет";
  final int dutiesCount = 1;

  final List<int> ids = await databaseService.todayDuties(
    dutyType,
    count: dutiesCount,
  );

  if (ids.isEmpty) {
    if (context.mounted) {
      printSnack(context, "ERROR: $dutyType duties log is empty");
    }
    return;
  }

  final List<Student> students = await Future.wait(
    ids.map((id) => databaseService.student(id)),
  );

  scrollTo(itemScrollController, ids.first);

  if (context.mounted) {
    printSnack(
      context,
      "$dutiesCount дежурных в $dutyType. ${students.first.name} - первый",
    );
  }

  // Save duties in the log

  final date = DateTime.now().toString().split(" ")[0];
  await Future.wait(
    students.map(
      (student) => databaseService.setDuty(student, "кабинет", date),
    ),
  );
}

void printSnack(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}

void scrollTo(
  ItemScrollController itemScrollController,
  int index, {
  Duration duration = const Duration(milliseconds: 500),
  Curve curve = Curves.easeInOut,
}) {
  itemScrollController.scrollTo(index: index, duration: duration, curve: curve);
}
