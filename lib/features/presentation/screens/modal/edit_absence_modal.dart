import 'dart:math';

import 'package:duty_selector/design.dart';
import 'package:duty_selector/features/data/absence_type.dart';
import 'package:duty_selector/features/data/models/absence.dart';
import 'package:duty_selector/features/presentation/widgets/texts/regular_text.dart';
import 'package:duty_selector/utils/datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:logger/logger.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

var logger = Logger();

class EditAbsenceModal extends StatefulWidget {
  final ScrollController scrollController;
  final Function(Absence) onAbsenceChanged;
  final Absence absence;
  final int defaultDuration = 120;

  const EditAbsenceModal({
    super.key,
    required this.scrollController,
    required this.absence,
    required this.onAbsenceChanged,
  });

  @override
  State<EditAbsenceModal> createState() => _EditAbsenceModalState();
}

class _EditAbsenceModalState extends State<EditAbsenceModal> {
  late final TextEditingController _durationController;
  late final TextEditingController _lessonController;
  late final TextEditingController _dateController;

  late String _absenceType;
  late DateTime _selectedDate;

  late List<DropdownMenuEntry<String>> _entries = List.empty(growable: true);

  @override
  void initState() {
    _entries = _entries.isEmpty ? _generateEntries() : _entries;
    _absenceType = widget.absence.reason;
    _selectedDate = widget.absence.date;

    _durationController = TextEditingController(
      text: widget.absence.expireDuration.toString(),
    );
    _lessonController = TextEditingController();
    _dateController = TextEditingController(
      text: DateFormat('dd.MM.yyyy HH:mm').format(_selectedDate),
    );

    super.initState();
  }

  @override
  void dispose() {
    _durationController.dispose();
    _lessonController.dispose();
    _dateController.dispose();
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
                  child: RegularText(text: 'Изменить запись о посещаемости'),
                ),

                const SizedBox(height: AppSpacing.large),

                _buildDropdown(context),

                const SizedBox(height: AppSpacing.xsmall),

                _buildDateField(),

                const SizedBox(height: AppSpacing.xsmall),

                _buildDurationTextField(),

                const SizedBox(height: AppSpacing.xsmall),

                _buildLessonTextField(),

                const SizedBox(height: AppSpacing.xsmall),

                _buildSubmitButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DropdownMenu<String> _buildDropdown(BuildContext context) {
    return DropdownMenu<String>(
      label: const Text('Тип пропуска', style: AppTextStyles.regular),
      initialSelection: _absenceType,
      enableFilter: true,
      textStyle: AppTextStyles.regular,
      width: MediaQuery.of(context).size.width,
      dropdownMenuEntries: _entries,
      onSelected: (value) {
        _absenceType = value ?? _absenceType;
      },
    );
  }

  TextField _buildDateField() {
    return TextField(
      controller: _dateController,
      style: AppTextStyles.regular,
      readOnly: true,
      decoration: InputDecoration(
        hintText: 'Дата',
        hintStyle: AppTextStyles.smallAccent,
        suffixIcon: IconButton(
          onPressed: _pickDate,
          icon: const Icon(Ionicons.calendar, color: AppColors.text),
        ),
      ),
      onTap: _pickDate,
    );
  }

  TextField _buildDurationTextField() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Длителность (в минутах)',
        hintStyle: AppTextStyles.smallAccent,
      ),
      style: AppTextStyles.regular,
      keyboardType: .number,
      onSubmitted: (value) {
        if (_validateDuration(value)) _durationController.text = value;
      },
      controller: _durationController,
    );
  }

  TextField _buildLessonTextField() {
    return TextField(
      autocorrect: true,
      decoration: InputDecoration(
        hintText: 'Пара (необязательно)',
        hintStyle: AppTextStyles.smallAccent,
      ),
      style: AppTextStyles.regular,
      controller: _lessonController,
    );
  }

  ElevatedButton _buildSubmitButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => addAbsence(context),
      child: const RegularText(text: 'Изменить'),
    );
  }

  Future<void> addAbsence(BuildContext context) async {
    final absence = Absence(
      reason: _absenceType,
      date: _selectedDate,
      studentId: widget.absence.studentId,
      expireDuration: _validateDuration(_durationController.text)
          ? int.parse(_durationController.text)
          : widget.defaultDuration,
      lessonName: _lessonController.text.isEmpty
          ? null
          : _lessonController.text,
    );

    widget.onAbsenceChanged.call(absence);

    if (context.mounted) {
      PersistentNavBarNavigator.pop(context);
    }
  }

  List<DropdownMenuEntry<String>> _generateEntries() {
    List<DropdownMenuEntry<String>> entries = List.empty(growable: true);

    for (var aType in AbsenceType.values) {
      if (aType == AbsenceType.selected || aType == AbsenceType.present) {
        continue;
      }

      entries.add(DropdownMenuEntry(value: aType.name, label: aType.name));
    }

    return entries;
  }

  Future<void> _pickDate() async {
    final date = await selectDateTime(
      context,
      initialDate: _selectedDate,
      dateMin: _selectedDate.subtract(const Duration(days: 365)),
      dateMax: _selectedDate.add(const Duration(days: 365)),
    );

    if (date == null) return;

    setState(() {
      _selectedDate = date;
      _dateController.text = DateFormat(
        'dd.MM.yyyy HH:mm',
      ).format(_selectedDate);
    });
  }

  bool _validateDuration(String value) => max(int.tryParse(value) ?? 0, 0) > 0;
}
