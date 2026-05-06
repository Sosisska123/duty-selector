import 'package:duty_selector/design.dart';
import 'package:duty_selector/features/data/database.dart';
import 'package:duty_selector/features/presentation/widgets/texts/regular_text.dart';
import 'package:flutter/material.dart';

class AddAbsenceModal extends StatelessWidget {
  final ScrollController scrollController;
  final DatabaseService databaseService;

  const AddAbsenceModal({
    super.key,
    required this.scrollController,
    required this.databaseService,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentGeometry.topCenter,
      padding: EdgeInsetsGeometry.all(AppSpacing.medium),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.medium),
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              controller: scrollController,
              shrinkWrap: true,
              children: [
                Center(
                  child: RegularText(text: 'Добавить запись о посещаемости'),
                ),

                SizedBox(height: AppSpacing.large),

                TextField(
                  autocorrect: true,
                  decoration: InputDecoration(
                    hintText: 'Длит. пары (в минутах)',
                    hintStyle: AppTextStyles.smallAccent,
                  ),
                  style: AppTextStyles.regular,
                  keyboardType: TextInputType.datetime,
                ),

                SizedBox(height: AppSpacing.xsmall),

                TextField(
                  autocorrect: true,
                  decoration: InputDecoration(
                    hintText: 'Дата (необязательно)',
                    hintStyle: AppTextStyles.smallAccent,
                  ),
                  style: AppTextStyles.regular,
                  keyboardType: TextInputType.datetime,
                ),
                SizedBox(height: AppSpacing.xsmall),

                Wrap(
                  spacing: AppSpacing.xsmall,
                  runSpacing: AppSpacing.xsmall,
                  children: [RegularText(text: '...')],
                ),

                SizedBox(height: AppSpacing.xsmall),

                ElevatedButton(
                  onPressed: () => {},
                  child: RegularText(text: 'Открыть таблицу'),
                ),

                SizedBox(height: AppSpacing.xsmall),

                ElevatedButton(
                  onPressed: () => {},
                  child: RegularText(text: 'Записать'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
