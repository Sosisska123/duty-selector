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
      padding: EdgeInsetsGeometry.all(AppSpacing.medium),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.medium),
        ),
      ),
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.medium,
          children: [
            Center(child: TitleText(text: 'Настройка выборки')),
            Column(
              spacing: AppSpacing.large,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownMenu(
                  label: Text('Тип дежурства', style: AppTextStyles.regular),
                  initialSelection: 1,
                  enableFilter: true,
                  textStyle: AppTextStyles.regular,
                  width: MediaQuery.of(context).size.width,
                  dropdownMenuEntries: _entries().toList(),
                ),
                Text('Заметка', style: AppTextStyles.bigRegular),
                TextField(style: AppTextStyles.regular),
                ElevatedButton(onPressed: () => {}, child: Text('Выбрать')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<DropdownMenuEntry<int>> _entries() {
    List<DropdownMenuEntry<int>> entries = List.empty(growable: true);

    // TODO: Get entries from the file

    entries.add(DropdownMenuEntry(value: 0, label: "На улице"));
    entries.add(DropdownMenuEntry(value: 1, label: "В кабинете"));

    return entries;
  }
}
