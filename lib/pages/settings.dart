import 'package:duty_selector/components/texts/regular_text.dart';
import 'package:duty_selector/components/texts/title_text.dart';
import 'package:duty_selector/database.dart';
import 'package:duty_selector/models/student.dart';
import 'package:duty_selector/utils/student_parser.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final DatabaseService databaseService;
  const SettingsScreen({super.key, required this.databaseService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TitleText(text: 'LOad Students from file'),
          ElevatedButton(
            onPressed: _loadStudsFromFile,
            child: RegularText(text: 'Load'),
          ),
        ],
      ),
    );
  }

  void _loadStudsFromFile() async {
    List<Student> students = await parseNames();
    print(students);
    databaseService.addStudents(students);
  }
}
