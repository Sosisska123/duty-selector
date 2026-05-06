import 'package:duty_selector/design.dart';
import 'package:duty_selector/features/data/models/absence.dart';
import 'package:duty_selector/features/presentation/widgets/texts/accent_text.dart';
import 'package:duty_selector/features/presentation/widgets/texts/regular_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AbsenceHistoryCard extends StatelessWidget {
  final Absence absence;
  final void Function()? deleteCallback;
  final void Function()? editCallback;

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
        borderRadius: BorderRadius.circular(AppRadius.medium),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
          child: Padding(
            padding: const EdgeInsetsGeometry.all(AppSpacing.medium),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RegularText(text: absence.lessonName),
            AccentText(text: DateFormat('dd.MM.yy').format(absence.date)),
          ],
        ),
        Row(
          spacing: AppSpacing.small,
          children: [
            RegularText(text: 'Причина:'),
            RegularText(text: absence.reason),
          ],
        ),
        Row(
          spacing: AppSpacing.small,
          children: [
            AccentText(text: 'Длителность пары:'),
            AccentText(text: absence.expireDuration.toString()),
            AccentText(text: 'мин.'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: editCallback,
              child: RegularText(text: 'Изменить'),
            ),
            ElevatedButton(
              onPressed: deleteCallback,
              child: RegularText(text: 'Удалить'),
            ),
          ],
        ),
      ],
    );

    return col;
  }
}
