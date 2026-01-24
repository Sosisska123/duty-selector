import 'package:flutter/material.dart';

import 'package:duty_selector/models/student.dart';

class StudentsTable extends StatefulWidget {
  const StudentsTable({super.key, required this.students});

  final List<Student> students;

  @override
  State<StudentsTable> createState() => _StudentsTableState();
}

class _StudentsTableState extends State<StudentsTable> {
  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: [
        DataColumn(label: Text('ID')),
        DataColumn(label: Text('ФИО')),
        DataColumn(label: Text('Статус')),
        // DataColumn(label: Text('Последнее дежурство')),
      ],
      rows: List<DataRow>.generate(
        widget.students.length,
        (index) => DataRow(
          cells: [
            DataCell(Text(widget.students[index].id.toString())),
            DataCell(Text(widget.students[index].name.toString())),
            DataCell(Text(widget.students[index].status)),
            // DataCell(Text(student.lastDutyDate)),
          ],
        ),
      ),
    );
  }
}
