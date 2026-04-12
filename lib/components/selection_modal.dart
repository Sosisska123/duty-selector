import 'package:duty_selector/components/select_duty.dart';
import 'package:duty_selector/components/texts/title_text.dart';
import 'package:duty_selector/database.dart';
import 'package:duty_selector/design.dart';
import 'package:duty_selector/pages/students.dart';
import 'package:flutter/material.dart';

class SelectionModal extends StatelessWidget {
  final ScrollController scrollController;
  final SelectionType selectionType;
  final int peopleCount;
  final DatabaseService databaseService;

  const SelectionModal({
    super.key,
    required this.scrollController,
    required this.selectionType,
    required this.databaseService,
    this.peopleCount = 1,
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
                Center(child: TitleText(text: 'Настройка выборки')),
                SizedBox(height: AppSpacing.large),
                DropdownMenu(
                  label: Text('Тип дежурства', style: AppTextStyles.regular),
                  initialSelection: 1,
                  enableFilter: true,
                  textStyle: AppTextStyles.regular,
                  width: MediaQuery.of(context).size.width,
                  dropdownMenuEntries: _entries().toList(),
                ),
                SizedBox(height: AppSpacing.medium),
                Text('Кол-во человек', style: AppTextStyles.bigRegular),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Кол-во человек',
                    hintStyle: AppTextStyles.smallAccent,
                  ),
                  style: AppTextStyles.regular,
                ),
                SizedBox(height: AppSpacing.medium),
                Text('Заметка', style: AppTextStyles.bigRegular),
                TextField(
                  autocorrect: true,
                  decoration: InputDecoration(
                    hintText: 'Заметка',
                    hintStyle: AppTextStyles.smallAccent,
                  ),
                  style: AppTextStyles.regular,
                ),
                SizedBox(height: AppSpacing.medium),
                ElevatedButton(
                  onPressed: () => _selectStudents(context),
                  child: Text('Выбрать'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<DropdownMenuEntry<int>> _entries() {
    List<DropdownMenuEntry<int>> entries = List.empty(growable: true);

    // TODO: Get entries from the file

    entries.add(const DropdownMenuEntry(value: 0, label: "На улице"));
    entries.add(const DropdownMenuEntry(value: 1, label: "В кабинете"));

    return entries;
  }

  void _selectStudents(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentsPage(databaseService: databaseService),
      ),
    );
  }
}
