import 'package:duty_selector/features/data/models/student.dart';
import 'package:flutter/services.dart' show rootBundle;

Future<List<Student>> parseNames() async {
  final text = await rootBundle.loadString('assets/names_local.txt');

  final lines = text
      .split('\n')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty);

  final result = <Student>[];

  for (final line in lines) {
    final parts = line.split(' ');

    if (parts.length < 3) {
      throw FormatException("Wrong name format");
    }

    result.add(
      Student(middleName: parts[2], firstName: parts[0], lastName: parts[1]),
    );
  }

  return result;
}
