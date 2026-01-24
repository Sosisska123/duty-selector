// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Student {
  final int id;
  final String name;
  final String status;
  final String lastDutyDate;

  const Student({
    required this.id,
    required this.name,
    required this.status,
    required this.lastDutyDate,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'status': status,
      'last_duty_date': lastDutyDate,
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'] as int,
      name: map['name'] as String,
      status: map['status'] as String,
      lastDutyDate: map['last_duty_date'] as String,
    );
  }

  @override
  String toString() {
    return 'Student(id: $id, name: $name, status: $status, lastDutyDate: $lastDutyDate)';
  }

  String toJson() => json.encode(toMap());

  factory Student.fromJson(String source) =>
      Student.fromMap(json.decode(source) as Map<String, dynamic>);
}

enum DutyStatus {
  notOnDuty('Не дедурил'), // обычное / ушел сам
  notOnDutyLong('Давно не дежурил'), // если больше недели
  onDuty('Дежурит'), // Дежурит щяс.  сбрасывается каждые 24ч
  willBeOnDuty('Будет дежурить'), // TODO: планирование
  released('Отпущен'); // ушел по уважительной

  final String text;

  const DutyStatus(this.text);
}
