import 'package:duty_selector/design.dart';
import 'package:duty_selector/features/data/models/absence.dart';
import 'package:duty_selector/features/presentation/widgets/texts/accent_text.dart';
import 'package:duty_selector/features/presentation/widgets/texts/regular_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AbsenceHistoryCard extends StatelessWidget {
  final Absence absence;
  final void Function(Absence)? deleteCallback;
  final void Function(Absence)? editCallback;

  const AbsenceHistoryCard(
    this.absence, {
    super.key,
    required this.deleteCallback,
    required this.editCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: .circular(AppRadius.medium),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: .circular(AppRadius.medium),
          ),
          child: Padding(
            padding: const .all(AppSpacing.medium),
            child: _generateCard(),
          ),
        ),
      ),
    );
  }

  Widget _generateCard() {
    final col = Column(
      children: [
        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Column(
              mainAxisAlignment: .start,
              crossAxisAlignment: .start,
              children: [
                RegularText(text: absence.lessonName ?? 'Не указано'),
                Row(
                  spacing: AppSpacing.small,
                  children: [
                    RegularText(text: 'Причина:'),
                    RegularText(text: absence.reason),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: .end,
              children: [
                AccentText(text: DateFormat('dd.MM.yy').format(absence.date)),
                AccentText(text: DateFormat('HH:mm').format(absence.date)),
              ],
            ),
          ],
        ),

        Row(
          spacing: AppSpacing.small,
          children: [
            AccentText(text: 'Длителность:'),
            AccentText(text: absence.expireDuration.toString()),
            AccentText(text: 'мин.'),
          ],
        ),

        SizedBox(height: AppSpacing.xsmall),

        Row(
          spacing: AppSpacing.small,
          mainAxisAlignment: .end,
          children: [
            ElevatedButton(
              style: ButtonStyle(side: WidgetStatePropertyAll(.none)),
              onPressed: () => editCallback?.call(absence),
              child: RegularText(text: 'Изменить'),
            ),
            ElevatedButton(
              style: ButtonStyle(side: WidgetStatePropertyAll(.none)),
              onPressed: () => deleteCallback?.call(absence),
              child: RegularText(text: 'Удалить'),
            ),
          ],
        ),
      ],
    );

    return col;
  }
}
