import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:duty_selector/features/data/database.dart';
import 'package:duty_selector/features/data/models/last_duty.dart';
import 'package:duty_selector/features/presentation/widgets/texts/rounded_background_text.dart';
import 'package:duty_selector/features/presentation/widgets/texts/accent_text.dart';
import 'package:duty_selector/features/presentation/widgets/texts/title_text.dart';
import 'package:duty_selector/design.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class LastDuties extends StatefulWidget {
  final DatabaseService databaseService;
  const LastDuties({super.key, required this.databaseService});

  @override
  State<LastDuties> createState() => _LastDutiesState();
}

class _LastDutiesState extends State<LastDuties> {
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppSpacing.medium,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleText(text: "Предыдущие\nдежурные"),
            getLastDutyDateText(),
          ],
        ),
        SizedBox(height: 40, child: getLastDutyStudents()),
      ],
    );
  }

  FutureBuilder<LastDutyData> getLastDutyDateText() {
    return FutureBuilder(
      future: _getLastDutyData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const AccentText(text: 'Загрузка...');
        }

        if (snapshot.hasError) {
          logger.e(
            'Error while getting LastDutyDateText from DB',
            error: snapshot.error,
            stackTrace: snapshot.stackTrace,
          );
          return const AccentText(text: 'Ошибка');
        }

        return snapshot.data!.date.isEmpty
            ? AccentText(text: 'Пусто')
            : AccentText(
                text: DateFormat(
                  'dd.MM.yy',
                ).format(DateTime.parse(snapshot.data!.date)),
              );
      },
    );
  }

  FutureBuilder<LastDutyData> getLastDutyStudents() {
    return FutureBuilder(
      future: _getLastDutyData(),
      builder: (c, s) {
        if (!s.hasData) {
          return const AccentText(text: 'Загрузка...');
        }

        if (s.hasError) {
          logger.e(
            'Error while getting LastDutyStudents from DB',
            error: s.error,
            stackTrace: s.stackTrace,
          );
          return const AccentText(text: 'Ошибка');
        }

        return s.data!.students.isNotEmpty
            ? ListView.separated(
                separatorBuilder: (context, index) =>
                    const SizedBox(width: AppSpacing.medium),
                scrollDirection: Axis.horizontal,
                itemCount: s.data!.students.length,
                itemBuilder: (_, idx) {
                  return RoundedBackgroundText(
                    text: s.data!.students[idx].initials,
                    backgroundColor: AppColors.secondary,
                  );
                },
              )
            : const AccentText(text: 'Пусто');
      },
    );
  }

  Future<LastDutyData> _getLastDutyData() async {
    return await widget.databaseService.getLastDutyData();
  }
}
