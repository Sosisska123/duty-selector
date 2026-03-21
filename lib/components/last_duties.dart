import 'package:duty_selector/components/text_box.dart';
import 'package:duty_selector/design.dart';
import 'package:flutter/material.dart';

import 'package:duty_selector/components/accent_text.dart';
import 'package:duty_selector/components/title_text.dart';

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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RoundedBackgroundText(
              text: 'Фасхутдинов Р.А',
              backgroundColor: AppColors.secondary,
            ),
            RoundedBackgroundText(
              text: 'Фасхутдинов Р.А',
              backgroundColor: AppColors.secondary,
            ),
          ],
        ),
      ],
    );
  }

  String _getCurrentDate() {
    return "21.03.26";
  }
}
