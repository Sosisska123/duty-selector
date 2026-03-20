import 'package:flutter/services.dart' show rootBundle;

import 'package:duty_selector/database.dart';
import 'package:duty_selector/models/student.dart';

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

    result.add("${parts[0]} ${parts[1]}");
  }

  return result;
}

List<Student> loadNamesIntoDatabase(List<String> names, DatabaseService db) {
  // TODO: сбросить статус тех кто дежурил вчера до "недавно", те кто больше недели "давно"
  // TODO: разделение типов дежурства (на улице, в кабинете, в другом кабинете) / колонка "где последний раз" + история
  final students = <Student>[];

  for (var i = 0; i < names.length; i++) {
    Student student = Student(id: i + 1, name: names[i]);

    students.add(student);
    db.insertStudent(student);
  }

  return students;
}
