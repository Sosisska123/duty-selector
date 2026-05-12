import 'package:duty_selector/design.dart';
import 'package:duty_selector/features/data/absence_type.dart';
import 'package:duty_selector/features/data/database.dart';
import 'package:duty_selector/features/data/models/absence.dart';
import 'package:duty_selector/features/presentation/widgets/texts/regular_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class AddAbsenceModal extends StatefulWidget {
  final ScrollController scrollController;
  final DatabaseService databaseService;
  final int studentId;

  const AddAbsenceModal({
    super.key,
    required this.scrollController,
    required this.databaseService,
    required this.studentId,
  });

  @override
  State<AddAbsenceModal> createState() => _AddAbsenceModalState();
}

class _AddAbsenceModalState extends State<AddAbsenceModal> {
  late final TextEditingController durationController;
  late final TextEditingController lessonController;
  late final TextEditingController dateController;

  String? absenceType;
  DateTime selectedDate = .now();

  @override
  void initState() {
    durationController = TextEditingController(text: "120");
    lessonController = TextEditingController();
    dateController = TextEditingController(
      text: DateFormat('dd.MM.yyyy').format(selectedDate),
    );

    super.initState();
  }

  @override
  void dispose() {
    durationController.dispose();
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
                const Center(
                  child: RegularText(text: 'Добавить запись о посещаемости'),
                ),

                const SizedBox(height: AppSpacing.large),

                DropdownMenu(
                  label: const Text(
                    'Тип пропуска',
                    style: AppTextStyles.regular,
                  ),
                  initialSelection: 1,
                  enableFilter: true,
                  textStyle: AppTextStyles.regular,
                  width: MediaQuery.of(context).size.width,
                  dropdownMenuEntries: _entries(),
                  onSelected: (value) {
                    absenceType = _entries()[value! - 1].label;
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

                TextField(
                  autocorrect: true,
                  decoration: InputDecoration(
                    hintText: 'Длителность (в минутах)',
                    hintStyle: AppTextStyles.smallAccent,
                  ),
                  style: AppTextStyles.regular,
                  keyboardType: .number,
                  controller: durationController,
                ),

                const SizedBox(height: AppSpacing.xsmall),

                TextField(
                  autocorrect: true,
                  decoration: InputDecoration(
                    hintText: 'Пара (необязательно)',
                    hintStyle: AppTextStyles.smallAccent,
                  ),
                  style: AppTextStyles.regular,
                  controller: lessonController,
                ),

                const SizedBox(height: AppSpacing.xsmall),

                ElevatedButton(
                  onPressed: () async {
                    final absence = Absence(
                      reason: absenceType ?? _entries()[0].label,
                      date: selectedDate,
                      studentId: widget.studentId,
                      expireDuration:
                          int.tryParse(durationController.text) ?? 120,
                      lessonName: lessonController.text.isEmpty
                          ? null
                          : lessonController.text,
                    );

                    logger.i(absence);

                    await widget.databaseService.addAbsence(absence);

                    // TODO: make it update visually
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

  List<DropdownMenuEntry<int>> _entries() {
    List<DropdownMenuEntry<int>> entries = List.empty(growable: true);

    for (var i = 0; i < AbsenceType.values.length; i++) {
      var name = AbsenceType.values[i];

      if (name == AbsenceType.selected || name == AbsenceType.present) continue;

      entries.add(
        DropdownMenuEntry(value: i, label: AbsenceType.values[i].name),
      );
    }

    return entries;
  }
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
