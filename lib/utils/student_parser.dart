import 'package:flutter/services.dart' show rootBundle;

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
      throw FormatException("Wrong name format");
    }

    result.add(parts.join(' '));
  }

  return result;
}
