import 'package:duty_selector/components/students_list.dart';
import 'package:duty_selector/components/texts/regular_text.dart';
import 'package:duty_selector/components/texts/title_text.dart';
import 'package:duty_selector/database.dart';
import 'package:duty_selector/design.dart';
import 'package:flutter/material.dart';

class StudentsPage extends StatefulWidget {
  final DatabaseService databaseService;
  const StudentsPage({super.key, required this.databaseService});

  @override
  State<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  final String _excludedStudents = "Загрузка...";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          MediaQuery.of(context).size.height * 0.1 -
              AppSpacing.tableHeightRatio,
        ),
        child: Center(child: TitleText(text: 'Выбрать из списка')),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height:
                MediaQuery.of(context).size.height *
                AppSpacing.tableHeightRatio,
            child: StudentsList(databaseService: widget.databaseService),
          ),
          RegularText(text: 'Исключить: $_excludedStudents'),
          SizedBox(height: AppSpacing.small),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              onPressed: () => {},
              child: RegularText(text: 'Выбрать'),
            ),
          ),
        ],
      ),
    );
  }
}
