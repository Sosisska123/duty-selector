import 'dart:async';

import 'package:duty_selector/features/data/duties_eventbus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:duty_selector/features/data/database.dart';
import 'package:duty_selector/features/data/models/student.dart';
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
  late StreamSubscription sub;

  @override
  void initState() {
    super.initState();
    sub = DutiesEventBus.stream.listen((e) {
      if (e.isNotEmpty) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return generateWidget();
  }

  Column generateWidget({
    String? lastDutyDate,
    List<Student>? lastDutyStudents,
  }) {
    return Column(
      spacing: AppSpacing.medium,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleText(text: "Предыдущие\nдежурные"),
            lastDutyDate == null
                ? getLastDutyDateText()
                : getLastDutyDateTextSync(lastDutyDate),
          ],
        ),
        SizedBox(
          height: 40,
          child: lastDutyStudents == null
              ? getLastDutyStudents()
              : getLastDutyStudentsSync(lastDutyStudents),
        ),
      ],
    );
  }

  AccentText getLastDutyDateTextSync(String lastDutyDate) {
    return lastDutyDate.isEmpty
        ? AccentText(text: 'Пусто')
        : AccentText(
            text: DateFormat('dd.MM.yy').format(DateTime.parse(lastDutyDate)),
          );
  }

  Widget getLastDutyStudentsSync(List<Student> lastDutyStudents) {
    return lastDutyStudents.isEmpty
        ? const AccentText(text: 'Пусто')
        : ListView.separated(
            separatorBuilder: (context, index) =>
                const SizedBox(width: AppSpacing.medium),
            scrollDirection: Axis.horizontal,
            itemCount: lastDutyStudents.length,
            itemBuilder: (_, idx) {
              return RoundedBackgroundText(
                text: lastDutyStudents[idx].initials,
                backgroundColor: AppColors.secondary,
              );
            },
          );
  }

  FutureBuilder<String?> getLastDutyDateText() {
    return FutureBuilder(
      future: _getLastDutyDate(),
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

        return getLastDutyDateTextSync(snapshot.data!);
      },
    );
  }

  FutureBuilder<List<Student>?> getLastDutyStudents() {
    return FutureBuilder(
      future: _getLastDutyStudents(),
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

        return getLastDutyStudentsSync(s.data!);
      },
    );
  }

  Future<List<Student>> _getLastDutyStudents() {
    return widget.databaseService.getLastDutyStudents();
  }

  Future<String> _getLastDutyDate() {
    return widget.databaseService.getLastDutyDate();
  }
}
