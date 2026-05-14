import 'package:flutter/material.dart';

Future<DateTime?> selectDateTime(
  final BuildContext context, {
  required final DateTime initialDate,
  required final DateTime dateMin,
  required final DateTime dateMax,
}) async {
  final DateTime? selectedDate = await selectDate(
    context,
    initialDate,
    dateMin,
    dateMax,
  );

  if (selectedDate == null) return null;

  if (!context.mounted) return null;

  final TimeOfDay? selectedTime = await selectTime(context, initialDate);

  if (selectedTime == null) return null;

  return DateTime(
    selectedDate.year,
    selectedDate.month,
    selectedDate.day,
    selectedTime.hour,
    selectedTime.minute,
  );
}

Future<DateTime?> selectDate(
  final BuildContext context,
  final DateTime initialDate,
  final DateTime dateMin,
  final DateTime dateMax,
) async {
  return await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: dateMin,
    lastDate: dateMax,
  );
}

Future<TimeOfDay?> selectTime(
  final BuildContext context,
  final DateTime selectedDate,
) async {
  return await showTimePicker(
    context: context,
    initialTime: .fromDateTime(selectedDate),
  );
}
