// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Duty {
  final int? id;
  final String type;
  final DateTime date;
  final int studentId;

  Duty({
    this.id,
    required this.type,
    required this.date,
    required this.studentId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'duty_type': type,
      'date': date.toString(),
      'student_id': studentId,
    };
  }

  factory Duty.fromMap(Map<String, dynamic> map) {
    return Duty(
      id: map['id'] as int,
      type: map['duty_type'] as String,
      date: DateTime.parse(map['date'] as String),
      studentId: map['student_id'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Duty.fromJson(String source) =>
      Duty.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Duty(id: $id, type: $type, date: ${date.toString()}, studentId: $studentId)';
  }
}
