import 'package:flutter/material.dart';

import 'package:duty_selector/components/action_card.dart';
import 'package:duty_selector/components/selection_modal.dart';
import 'package:duty_selector/components/title_text.dart';

import 'package:duty_selector/design.dart';

import 'package:ionicons/ionicons.dart';

enum SelectionType { byList, byHand, random }

class SelectDuty extends StatelessWidget {
  const SelectDuty({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.medium,
      children: [
        const TitleText(text: 'Выбрать дежурных'),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: AppSpacing.small,
          mainAxisSpacing: AppRadius.medium,
          padding: const EdgeInsets.all(AppSpacing.xsmall),
          children: [
            ActionCard(
              color: AppColors.secondary,
              icon: Icon(Ionicons.barbell, color: AppColors.accent, size: 30),
              text: "Вручную",
              tapCallback: () => _showModal(context, SelectionType.byHand),
            ),
            ActionCard(
              color: AppColors.secondary,
              icon: Icon(Ionicons.briefcase, color: AppColors.accent, size: 30),
              text: "По списку",
              tapCallback: () => _showModal(context, SelectionType.byList),
            ),
            ActionCard(
              color: AppColors.secondary,
              icon: Icon(Ionicons.dice, color: AppColors.accent, size: 30),
              text: "Рандом",
              tapCallback: () => _showModal(context, SelectionType.random),
            ),
          ],
        ),
      ],
    );
  }

  void _showModal(BuildContext context, SelectionType type) {
    switch (type) {
      case SelectionType.byHand:
        break;
      case SelectionType.byList:
        break;
      case SelectionType.random:
        break;
    }

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SelectionModal();
      },
    );
  }
}
