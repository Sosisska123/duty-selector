// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Student {
  final int? id;
  final String firstName;
  final String middleName;
  final String lastName;

  const Student({
    this.id,
    required this.firstName,
    required this.middleName,
    required this.lastName,
  });

  String get fullName => "$firstName $middleName $lastName";
  String get initials => "$middleName ${firstName[0]} ${lastName[0]}";

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'first_name': firstName,
      'middle_name': middleName,
      'last_name': lastName,
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'] as int,
      firstName: map['first_name'] as String,
      middleName: map['middle_name'] as String,
      lastName: map['last_name'] as String,
    );
  }

  @override
  String toString() {
    return 'Student(id: $id, first_name: $firstName, middle_name: $middleName, last_name: $lastName)';
  }

  String toJson() => json.encode(toMap());

  factory Student.fromJson(String source) =>
      Student.fromMap(json.decode(source) as Map<String, dynamic>);
}
