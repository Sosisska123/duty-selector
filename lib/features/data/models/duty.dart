// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Duty {
  final int id;
  final String type;
  final String date;
  final String student;

  Duty({
    required this.id,
    required this.type,
    required this.date,
    required this.student,
  });

  Duty copyWith({int? id, String? type, String? date, String? student}) {
    return Duty(
      id: id ?? this.id,
      type: type ?? this.type,
      date: date ?? this.date,
      student: student ?? this.student,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'type': type,
      'date': date,
      'student': student,
    };
  }

  factory Duty.fromMap(Map<String, dynamic> map) {
    return Duty(
      id: map['id'] as int,
      type: map['type'] as String,
      date: map['date'] as String,
      student: map['student'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Duty.fromJson(String source) =>
      Duty.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Duty(id: $id, type: $type, date: $date, student: $student)';
  }
}
