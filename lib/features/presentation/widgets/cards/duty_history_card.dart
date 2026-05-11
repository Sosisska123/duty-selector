import 'package:duty_selector/design.dart';
import 'package:duty_selector/features/data/models/duty.dart';
import 'package:duty_selector/features/presentation/widgets/texts/accent_text.dart';
import 'package:duty_selector/features/presentation/widgets/texts/regular_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DutyHistoryCard extends StatelessWidget {
  final Duty duty;
  final void Function()? deleteCallback;
  final void Function()? editCallback;

  const DutyHistoryCard(
    this.duty, {
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
    return Column(
      children: [
        Column(
          mainAxisAlignment: .spaceBetween,
          children: [
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                RegularText(text: duty.type),
                AccentText(text: DateFormat('dd.MM.yy').format(duty.date)),
              ],
            ),
            Row(
              mainAxisAlignment: .end,
              children: [
                AccentText(text: DateFormat('HH:mm').format(duty.date)),
              ],
            ),
          ],
        ),

        SizedBox(height: AppSpacing.xsmall),

        Row(
          spacing: AppSpacing.small,
          mainAxisAlignment: .end,
          children: [
            ElevatedButton(
              style: ButtonStyle(side: WidgetStatePropertyAll(.none)),
              onPressed: editCallback,
              child: const RegularText(text: 'Изменить'),
            ),
            ElevatedButton(
              style: const ButtonStyle(side: WidgetStatePropertyAll(.none)),
              onPressed: deleteCallback,
              child: const RegularText(text: 'Удалить'),
            ),
          ],
        ),
      ],
    );
  }
}
