import 'package:duty_selector/design.dart';
import 'package:duty_selector/features/data/models/duty.dart';
import 'package:duty_selector/features/presentation/widgets/texts/regular_text.dart';
import 'package:duty_selector/utils/datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class EditDutyModal extends StatefulWidget {
  final ScrollController scrollController;
  final Duty duty;
  final Function(Duty) onDutyChanged;

  const EditDutyModal({
    super.key,
    required this.scrollController,
    required this.duty,
    required this.onDutyChanged,
  });

  @override
  State<EditDutyModal> createState() => _EditDutyModalState();
}

class _EditDutyModalState extends State<EditDutyModal> {
  late final TextEditingController _dateController;
  late DateTime _selectedDate;
  late String _selectedDutyType;

  final List<DropdownMenuEntry<String>> _dutyEntries = const [
    DropdownMenuEntry(value: 'На улице', label: 'На улице'),
    DropdownMenuEntry(value: 'В кабинете', label: 'В кабинете'),
  ];

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.duty.date;
    _selectedDutyType = widget.duty.type;

    _dateController = TextEditingController(
      text: DateFormat('dd.MM.yyyy HH:mm').format(_selectedDate),
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: .topCenter,
      padding: const .all(AppSpacing.medium),
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
                const Center(child: RegularText(text: 'Изменить дежурство')),
                const SizedBox(height: AppSpacing.large),

                _buildDutyDropdown(),
                const SizedBox(height: AppSpacing.xsmall),
                _buildDateField(),
                const SizedBox(height: AppSpacing.xsmall),
                _buildSubmitButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DropdownMenu<String> _buildDutyDropdown() {
    return DropdownMenu<String>(
      label: Text('Тип дежурства', style: AppTextStyles.regular),
      initialSelection: _selectedDutyType,
      textStyle: AppTextStyles.regular,
      width: MediaQuery.of(context).size.width,
      dropdownMenuEntries: _dutyEntries,
      onSelected: (String? value) {
        setState(() {
          _selectedDutyType = value ?? _selectedDutyType;
        });
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

  Future<void> _pickDate() async {
    final date = await selectDateTime(
      context,
      initialDate: _selectedDate,
      dateMin: _selectedDate.subtract(const Duration(days: 365)),
      dateMax: _selectedDate.add(const Duration(days: 365)),
    );

    if (date != null && date != _selectedDate) {
      setState(() {
        _selectedDate = date;
        _dateController.text = DateFormat(
          'dd.MM.yyyy HH:mm',
        ).format(_selectedDate);
      });
    }
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _saveDuty,
      child: const RegularText(text: 'Добавить'),
    );
  }

  Future<void> _saveDuty() async {
    final duty = Duty(
      type: _selectedDutyType,
      date: _selectedDate,
      studentId: widget.duty.studentId,
    );

    widget.onDutyChanged.call(duty);

    if (mounted) {
      PersistentNavBarNavigator.pop(context);
    }
  }
}
