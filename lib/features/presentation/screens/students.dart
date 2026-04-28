import 'package:duty_selector/features/data/models/student.dart';
import 'package:duty_selector/features/presentation/widgets/display/students_list.dart';
import 'package:duty_selector/features/presentation/widgets/texts/regular_text.dart';
import 'package:duty_selector/features/presentation/widgets/texts/title_text.dart';
import 'package:duty_selector/features/data/database.dart';
import 'package:duty_selector/design.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import 'package:logger/logger.dart';

var logger = Logger();

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
    var w = StudentsList(databaseService: widget.databaseService);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => {PersistentNavBarNavigator.pop(context)},
          icon: Icon(Ionicons.arrow_back),
        ),
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: TitleText(text: 'Выбрать из списка'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height:
                MediaQuery.of(context).size.height *
                AppSpacing.tableHeightRatio,
            child: w,
          ),
          SizedBox(height: AppSpacing.small),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              onPressed: () => _performSelection(
                w.getCheckedStudents(withSick: false),
                widget.selectionType,
              ),
              child: RegularText(text: 'Выбрать ${widget.selectionType}'),
            ),
          ),
        ],
      ),
    );
  }

  void _performSelection(Set<Student> selectedStudents, String selectionType) {
    // TODO: Implement selection logic
    logger.i('Selected students: $selectedStudents for $selectionType');
  }
}
