import 'package:duty_selector/features/data/duty_selection_type.dart';
import 'package:duty_selector/features/presentation/widgets/texts/title_text.dart';
import 'package:duty_selector/features/data/database.dart';
import 'package:duty_selector/design.dart';
import 'package:duty_selector/features/presentation/screens/students.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class SelectionModal extends StatelessWidget {
  final ScrollController scrollController;
  final DutySelectionType selectionType;
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
                Text('Примечание', style: AppTextStyles.bigRegular),
                TextField(
                  autocorrect: true,
                  decoration: InputDecoration(
                    hintText: 'Примечание',
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
    PersistentNavBarNavigator.pop(context);
    PersistentNavBarNavigator.pushNewScreen(
      context,
      screen: StudentsPage(
        databaseService: databaseService,
        selectionType: selectionType,
      ),
      withNavBar: false,
    );
  }
}
