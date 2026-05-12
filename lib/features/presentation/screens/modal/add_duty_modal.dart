import 'package:duty_selector/design.dart';
import 'package:duty_selector/features/data/database.dart';
import 'package:duty_selector/features/data/models/duty.dart';
import 'package:duty_selector/features/presentation/widgets/texts/regular_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class AddDutyModal extends StatefulWidget {
  final ScrollController scrollController;
  final DatabaseService databaseService;
  final int studentId;

  const AddDutyModal({
    super.key,
    required this.scrollController,
    required this.databaseService,
    required this.studentId,
  });

  @override
  State<AddDutyModal> createState() => _AddDutyModalState();
}

class _AddDutyModalState extends State<AddDutyModal> {
  late final TextEditingController dateController;

  String dutyType = _entries()[0].label;
  DateTime selectedDate = .now();

  @override
  void initState() {
    dateController = TextEditingController(
      text: DateFormat('dd.MM.yyyy').format(selectedDate),
    );

    super.initState();
  }

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: .topCenter,
      padding: .all(AppSpacing.medium),
      decoration: const BoxDecoration(
        color: AppColors.secondary,
        borderRadius: .vertical(top: .circular(AppSpacing.medium)),
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              controller: widget.scrollController,
              shrinkWrap: true,
              children: [
                const Center(child: RegularText(text: 'Добавить дежурство')),

                SizedBox(height: AppSpacing.large),

                DropdownMenu(
                  label: Text('Тип дежурства', style: AppTextStyles.regular),
                  initialSelection: 1,
                  enableFilter: true,
                  textStyle: AppTextStyles.regular,
                  width: MediaQuery.of(context).size.width,
                  dropdownMenuEntries: _entries(),
                  onSelected: (value) {
                    dutyType = _entries()[value! - 1].label;
                  },
                ),

                const SizedBox(height: AppSpacing.xsmall),

                Stack(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Дата',
                        hintStyle: AppTextStyles.smallAccent,
                      ),
                      style: AppTextStyles.regular,
                      readOnly: true,
                      controller: dateController,
                    ),
                    Align(
                      alignment: .centerEnd,
                      child: IconButton(
                        onPressed: () async {
                          final date = await _selectDate(context, selectedDate);

                          if (date == null) return;

                          setState(() {
                            selectedDate = date;
                            dateController.text = DateFormat(
                              'dd.MM.yyyy',
                            ).format(selectedDate);
                          });
                        },
                        icon: const Icon(
                          Ionicons.calendar,
                          color: AppColors.text,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.xsmall),

                ElevatedButton(
                  onPressed: () async {
                    final duty = Duty(
                      type: dutyType,
                      date: selectedDate,
                      studentId: widget.studentId,
                    );

                    logger.i(duty);

                    await widget.databaseService.addDuty(duty);

                    // TODO: make it update visually
                    if (context.mounted) {
                      PersistentNavBarNavigator.pop(context);
                    }
                  },
                  child: const RegularText(text: 'Добавить'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

List<DropdownMenuEntry<int>> _entries() {
  List<DropdownMenuEntry<int>> entries = List.empty(growable: true);

  // TODO: Get entries from the file

  entries.add(const DropdownMenuEntry(value: 0, label: "На улице"));
  entries.add(const DropdownMenuEntry(value: 1, label: "В кабинете"));

  return entries;
}

Future<DateTime?> _selectDate(
  final BuildContext context,
  final DateTime initialDate,
) async {
  DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: initialDate.subtract(const Duration(days: 365)),
    lastDate: initialDate.add(const Duration(days: 365)),
  );

  return pickedDate;
}
