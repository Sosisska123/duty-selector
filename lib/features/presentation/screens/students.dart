import 'package:duty_selector/features/presentation/widgets/display/students_list.dart';
import 'package:duty_selector/features/presentation/widgets/texts/regular_text.dart';
import 'package:duty_selector/features/presentation/widgets/texts/title_text.dart';
import 'package:duty_selector/features/data/database.dart';
import 'package:duty_selector/design.dart';
import 'package:flutter/material.dart';

class StudentsPage extends StatefulWidget {
  final DatabaseService databaseService;
  final String selectionType;

  const StudentsPage({
    super.key,
    required this.databaseService,
    required this.selectionType,
  });

  @override
  State<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
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
          SizedBox(height: AppSpacing.small),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              onPressed: () => {},
              child: RegularText(text: 'Выбрать ${widget.selectionType}'),
            ),
          ),
        ],
      ),
    );
  }
}
