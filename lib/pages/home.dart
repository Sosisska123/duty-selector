import 'package:duty_selector/widgets/students_table.dart';
import 'package:flutter/material.dart';

import 'package:duty_selector/database.dart';
import 'package:duty_selector/models/student.dart';

import 'package:flutter/services.dart' show rootBundle;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseService _databaseService = DatabaseService();

  Future<List<Student>> _getStudents() async {
    return await _databaseService.students();
  }

  @override
  void initState() {
    super.initState();
    test(_databaseService);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(future: _getStudents(), builder: generateTable),
    );
  }

  Widget generateTable(
    BuildContext context,
    AsyncSnapshot<List<Student>> snapshot,
  ) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    } else if (snapshot.connectionState == ConnectionState.done) {
      if (snapshot.hasError) {
        return const Text("Error");
      }
    }

    print(snapshot.data);

    return Center(
      child: SingleChildScrollView(
        child: StudentsTable(students: snapshot.data!),
      ),
    );
  }
}

Future<List<String>> parseNames() async {
  final text = await rootBundle.loadString('assets/names_local.txt');

  final lines = text
      .split('\n')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty);

  final result = <String>[];

  for (final line in lines) {
    final parts = line.split(' ');

    if (parts.length < 3) {
      throw FormatException("Wrong format");
    }

    result.add(line);
  }

  return result;
}

void loadNamesIntoDatabase(List<String> names, DatabaseService db) {
  // TODO: сбросить статус тех кто дежурил вчера до "недавно", те кто больше недели "давно"
  // TODO: разделение типов дежурства (на улице, в кабинете, в другом кабинете) / колонка "где последний раз" + история
  for (var i = 0; i < names.length; i++) {
    Student student = Student(
      id: i + 1,
      name: names[i],
      status: DutyStatus.notOnDuty.text,
      lastDutyDate: "Нет",
    );

    db.insertStudent(student);
  }
}

void test(DatabaseService databaseService) async {
  final List<Student> studs = await databaseService.students();

  if (studs.isEmpty) {
    List<String> names = await parseNames();
    loadNamesIntoDatabase(names, databaseService);
  }
}
