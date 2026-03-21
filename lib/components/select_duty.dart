import 'package:duty_selector/components/action_selection_card.dart';
import 'package:flutter/material.dart';

import 'package:duty_selector/components/title_text.dart';
import 'package:duty_selector/design.dart';

class SelectDuty extends StatelessWidget {
  const SelectDuty({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppSpacing.medium,
      children: [
        TitleText(text: 'Выбрать дежурных'),
        SizedBox.fromSize(
          size: Size.fromHeight(200),
          child: GridView.builder(
            padding: EdgeInsets.all(AppSpacing.small),
            scrollDirection: Axis.vertical,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: AppSpacing.small,
              crossAxisCount: 2,
            ),
            itemBuilder: (context, index) {
              return ActionSelectionCard();
            },
          ),
        ),
      ],
    );
  }
}
