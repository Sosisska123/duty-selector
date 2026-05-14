import 'package:duty_selector/design.dart';
import 'package:duty_selector/features/data/database.dart';
import 'package:duty_selector/features/data/models/absence.dart';
import 'package:duty_selector/features/data/models/student.dart';
import 'package:duty_selector/features/presentation/screens/modal/add_absence_modal.dart';
import 'package:duty_selector/features/presentation/screens/modal/edit_absence_modal.dart';
import 'package:duty_selector/features/presentation/widgets/cards/absence_history_card.dart';
import 'package:duty_selector/features/presentation/widgets/texts/accent_text.dart';
import 'package:duty_selector/features/presentation/widgets/texts/regular_text.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class AbsencesHistory extends StatefulWidget {
  final Student student;
  final DatabaseService databaseService;

  const AbsencesHistory({
    super.key,
    required this.student,
    required this.databaseService,
  });

  @override
  State<AbsencesHistory> createState() => _AbsencesHistoryState();
}

class _AbsencesHistoryState extends State<AbsencesHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: RegularText(
          text: 'Пропуски ${widget.student.initialsFirstname}',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.secondary,
        onPressed: () => showAddModal(context),
        child: const Icon(Ionicons.add, color: AppColors.text),
      ),
      body: FutureBuilder(
        future: _getStudentAbsences(),
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
            return const Center(child: AccentText(text: 'Пусто'));
          }

          return ListView.builder(
            itemCount: s.data!.length,
            itemBuilder: (c, idx) => _buildList(context, s.data!, idx),
          );
        },
      ),
    );
  }

  Future<List<Absence>> _getStudentAbsences() async =>
      await widget.databaseService.getWeekAbsencesFor(widget.student.id!);

  Widget _buildList(
    final BuildContext context,
    final List<Absence> list,
    final int index,
  ) {
    final absence = list[index];

    return AbsenceHistoryCard(
      absence,
      deleteCallback: (a) => setState(() {
        _deleteAbsence(context, widget.databaseService, a.id!);
      }),
      editCallback: (a) => showEditModal(context, a),
    );
  }

  void showAddModal(final BuildContext context) {
    final modal = DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.4,
      maxChildSize: 0.75,
      expand: false,
      snap: true,
      builder: (BuildContext context, ScrollController scrollController) {
        return AddAbsenceModal(
          scrollController: scrollController,
          studentId: widget.student.id!,
          onAbsenceAdded: (absence) async {
            await widget.databaseService.addAbsence(absence);

            setState(() {
              /* fetching db */
            });
          },
        );
      },
    );

    _showModal(context, modal: modal, databaseService: widget.databaseService);
  }

  void showEditModal(final BuildContext context, final Absence absence) {
    final modal = DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.4,
      maxChildSize: 0.75,
      expand: false,
      snap: true,
      builder: (BuildContext context, ScrollController scrollController) {
        return EditAbsenceModal(
          scrollController: scrollController,
          absence: absence,
          onAbsenceChanged: (a) async {
            if (absence.id == null) {
              snackText(context, 'что-то пошло не так');
            }

            logger.i('Old absence: $absence');

            await widget.databaseService.updateAbsence(absence.id!, a);

            setState(() {
              /* fetching db */
            });
          },
        );
      },
    );

    _showModal(context, modal: modal, databaseService: widget.databaseService);
  }

  void _showModal(
    final BuildContext context, {
    required final DatabaseService databaseService,
    required final Widget modal,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: .vertical(top: .circular(15)),
      ),
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => modal,
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
