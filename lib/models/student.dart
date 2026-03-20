// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Student {
  final int id;
  final String name;

  const Student({required this.id, required this.name});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'name': name};
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(id: map['id'] as int, name: map['name'] as String);
  }

  @override
  String toString() {
    return 'Student(id: $id, name: $name)';
  }

  String toJson() => json.encode(toMap());

  factory Student.fromJson(String source) =>
      Student.fromMap(json.decode(source) as Map<String, dynamic>);
}
