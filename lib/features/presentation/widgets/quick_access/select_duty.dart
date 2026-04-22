import 'package:duty_selector/features/presentation/widgets/cards/action_card.dart';
import 'package:duty_selector/features/presentation/screens/modal/selection_modal.dart';
import 'package:duty_selector/features/presentation/widgets/texts/title_text.dart';
import 'package:duty_selector/features/data/database.dart';
import 'package:duty_selector/design.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class SelectDuty extends StatelessWidget {
  final DatabaseService databaseService;

  const SelectDuty({super.key, required this.databaseService});

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
          crossAxisSpacing: AppSpacing.small,
          mainAxisSpacing: AppRadius.medium,
          padding: const EdgeInsets.all(AppSpacing.xsmall),
          children: [
            // TODO: load from disk or smth (maybe user prefs))
            ActionCard(
              color: AppColors.secondary,
              icon: Icon(Ionicons.barbell, color: AppColors.accent, size: 30),
              text: "Вручную",
              descriptionText: "Выбрать из списка",
              tapCallback: () => _showModal(context, SelectionType.byHand),
            ),
            ActionCard(
              color: AppColors.secondary,
              icon: Icon(
                Ionicons.male_female,
                color: AppColors.accent,
                size: 30,
              ),
              text: "Next 2",
              descriptionText: "Следующие 2 по списку",
              tapCallback: () => _showModal(context, SelectionType.next2),
            ),
            ActionCard(
              color: AppColors.secondary,
              icon: Icon(
                Ionicons.transgender,
                color: AppColors.accent,
                size: 30,
              ),
              text: "Next 4",
              descriptionText: "Следующие 4 по списку",
              tapCallback: () => _showModal(context, SelectionType.next2),
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          snap: true,
          builder: (BuildContext context, ScrollController scrollController) {
            return SelectionModal(
              scrollController: scrollController,
              selectionType: type,
              databaseService: databaseService,
            );
          },
        );
      },
    );
  }
}

// FIXME: more flexible
enum SelectionType { next2, next4, byHand, random, leastDuties }
