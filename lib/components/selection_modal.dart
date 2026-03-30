import 'package:duty_selector/components/title_text.dart';
import 'package:duty_selector/design.dart';
import 'package:flutter/material.dart';

class SelectionModal extends StatelessWidget {
  const SelectionModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1200,
      alignment: AlignmentGeometry.topCenter,
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.medium),
        ),
      ),
      child: Padding(
        padding: EdgeInsetsGeometry.all(AppSpacing.large),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: AppSpacing.medium,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleText(text: 'Настройка выборки'),
            Column(
              spacing: AppSpacing.large,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownMenu(
                  label: Text('Тип дежурства', style: AppTextStyles.regular),
                  initialSelection: 1,
                  enableFilter: true,
                  textStyle: AppTextStyles.regular,
                  dropdownMenuEntries: [
                    DropdownMenuEntry(value: 1, label: 'На улице'),
                    DropdownMenuEntry(value: 2, label: 'В кабинете'),
                    DropdownMenuEntry(value: 3, label: 'Генеральная'),
                  ],
                ),
                Text('Заметка (необяз.)', style: AppTextStyles.bigRegular),
                TextField(style: AppTextStyles.regular),
                ElevatedButton(onPressed: () => {}, child: Text('Выбрать')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
