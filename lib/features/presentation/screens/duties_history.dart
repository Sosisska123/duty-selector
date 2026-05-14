import 'package:duty_selector/design.dart';
import 'package:duty_selector/features/data/database.dart';
import 'package:duty_selector/features/data/models/duty.dart';
import 'package:duty_selector/features/data/models/student.dart';
import 'package:duty_selector/features/presentation/screens/modal/add_duty_modal.dart';
import 'package:duty_selector/features/presentation/widgets/cards/duty_history_card.dart';
import 'package:duty_selector/features/presentation/widgets/texts/accent_text.dart';
import 'package:duty_selector/features/presentation/widgets/texts/regular_text.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class DutiesHistory extends StatefulWidget {
  final Student student;
  final DatabaseService databaseService;

  const DutiesHistory({
    super.key,
    required this.student,
    required this.databaseService,
  });

  @override
  State<DutiesHistory> createState() => _DutiesHistoryState();
}

class _DutiesHistoryState extends State<DutiesHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: RegularText(
          text: 'Дежурства ${widget.student.initialsFirstname}',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.secondary,
        onPressed: () => _addDuty(context, widget.databaseService),
        child: const Icon(Ionicons.add, color: AppColors.text),
      ),
      body: FutureBuilder(
        future: _getStudentDuties(),
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

  void _addDuty(
    final BuildContext context,
    final DatabaseService databaseService,
  ) {
    _showModal(context, databaseService, widget.student.id!);
  }

  Future<List<Duty>> _getStudentDuties() async =>
      await widget.databaseService.getLastDutiesFor(widget.student.id!);

  Widget _buildList(
    final BuildContext context,
    final List<Duty> list,
    final int index,
  ) {
    final duty = list[index];

    return DutyHistoryCard(
      duty,
      deleteCallback: () => setState(() {
        _deleteDuty(context, widget.databaseService, duty.id!);
      }),
      editCallback: () => snackText(context, 'Пока не работает'),
    );
  }
}

void _deleteDuty(
  final BuildContext context,
  final DatabaseService databaseService,
  final int dutyId,
) async {
  await databaseService.deleteDuty(dutyId);

  if (context.mounted) {
    snackText(context, 'Запись удалена');
  }
}

void snackText(final BuildContext context, final String text) {
  final snackBar = SnackBar(content: Text(text));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void _showModal(
  final BuildContext context,
  final DatabaseService databaseService,
  final int studentId,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: .vertical(top: .circular(15)),
    ),
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.4,
        minChildSize: 0.3,
        maxChildSize: 0.5,
        expand: false,
        snap: true,
        builder: (BuildContext context, ScrollController scrollController) {
          return AddDutyModal(
            databaseService: databaseService,
            scrollController: scrollController,
            studentId: studentId,
          );
        },
      );
    },
  );
}
