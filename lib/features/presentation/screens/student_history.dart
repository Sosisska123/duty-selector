import 'package:duty_selector/design.dart';
import 'package:duty_selector/features/data/database.dart';
import 'package:duty_selector/features/data/models/absence.dart';
import 'package:duty_selector/features/data/models/student.dart';
import 'package:duty_selector/features/presentation/widgets/cards/absence_history_card.dart';
import 'package:duty_selector/features/presentation/widgets/texts/accent_text.dart';
import 'package:duty_selector/features/presentation/widgets/texts/regular_text.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class StudentHistory extends StatefulWidget {
  final Student student;
  final DatabaseService databaseService;

  const StudentHistory({
    super.key,
    required this.student,
    required this.databaseService,
  });

  @override
  State<StudentHistory> createState() => _StudentHistoryState();
}

class _StudentHistoryState extends State<StudentHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: RegularText(text: 'История ${widget.student.initialsFirstname}'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.secondary,
        onPressed: () => _addAbsence(context),
        child: Icon(Ionicons.add, color: AppColors.text),
      ),
      body: FutureBuilder(
        future: _getStudentsAbsences(),
        builder: (c, s) {
          if (!s.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (s.hasError) {
            logger.e(
              'Error while building Students List',
              error: s.error,
              stackTrace: s.stackTrace,
            );
            return const AccentText(text: 'Ошибка');
          }

          if (s.data!.isEmpty) {
            return Center(child: AccentText(text: 'Пусто'));
          }

          return ListView.builder(
            itemCount: s.data!.length,
            itemBuilder: (c, idx) => _buildList(context, s.data!, idx),
          );
        },
      ),
    );
  }

  void _addAbsence(BuildContext context) {}

  Future<List<Absence>> _getStudentsAbsences() async =>
      await widget.databaseService.getWeekAbsencesFor(widget.student.id);

  Widget _buildList(
    final BuildContext context,
    final List<Absence> list,
    final int index,
  ) {
    final absence = list[index];

    return AbsenceHistoryCard(
      absence,
      deleteCallback: () => setState(() {
        _deleteAbsence(context, widget.databaseService, absence.id!);
      }),
      editCallback: () => {},
    );
  }
}

void _deleteAbsence(
  final BuildContext context,
  final DatabaseService databaseService,
  final int absenceId,
) async {
  await databaseService.deleteAbsence(absenceId);
  if (context.mounted) {
    snackText(context, 'Запись удалена');
  }
}

void snackText(final BuildContext context, final String text) {
  final snackBar = SnackBar(content: Text(text));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
