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
  final DatabaseService _databaseService = DatabaseService();

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
          child: StudentsTable(
            students: snapshot.data!,
            itemScrollController: itemScrollController,
          ),
        ),
        ElevatedButton(
          onPressed: () => scrollTo(itemScrollController, 20),
          child: const Text("Выбрать дежурного", style: AppTextStyles.body),
        ),
        ElevatedButton(
          onPressed: () => _selectDuty(itemScrollController, _databaseService),
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

  void _clearDatabase() {
    _databaseService.deleteAllStudents();
    setState(() {
      _getStudents();
    });
  }
}

void _selectDuty(
  ItemScrollController itemScrollController,
  DatabaseService databaseService,
) {
  int duty = 10;

  // TODO

  scrollTo(itemScrollController, duty);
}

void scrollTo(
  ItemScrollController itemScrollController,
  int index, {
  Duration duration = const Duration(milliseconds: 500),
  Curve curve = Curves.easeInOut,
}) {
  itemScrollController.scrollTo(index: index, duration: duration, curve: curve);
}
