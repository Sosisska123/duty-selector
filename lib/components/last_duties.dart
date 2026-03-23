import 'package:duty_selector/components/text_box.dart';
import 'package:duty_selector/design.dart';
import 'package:flutter/material.dart';

import 'package:duty_selector/components/accent_text.dart';
import 'package:duty_selector/components/title_text.dart';
import 'package:intl/intl.dart';

class LastDuties extends StatelessWidget {
  const LastDuties({super.key});

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
            AccentText(text: _getCurrentDate()),
          ],
        ),
        SizedBox(
          height: 40,
          child: ListView.separated(
            separatorBuilder: (context, index) =>
                const SizedBox(width: AppSpacing.medium),
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            itemBuilder: (_, idx) {
              return const RoundedBackgroundText(
                text: 'Фасхутдинов Р.А',
                backgroundColor: AppColors.secondary,
              );
            },
          ),
        ),
      ],
    );
  }

  String _getCurrentDate() {
    // TODO: simpliest caching in final var,
    // get last duty date instead
    DateTime now = DateTime.now();

    return DateFormat('dd.MM.yy').format(now);
  }
}
