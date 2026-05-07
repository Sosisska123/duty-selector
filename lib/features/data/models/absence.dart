class Absence {
  final int? id;
  final String reason;
  final DateTime date;
  final String? lessonName;
  final int studentId;
  final int expireDuration;

  const Absence({
    this.id,
    this.lessonName,
    required this.reason,
    required this.date,
    required this.studentId,
    required this.expireDuration,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'expire_time': expireDuration,
      'reason': reason,
      'date': date.toIso8601String(),
      'lesson_name': lessonName,
      'student_id': studentId,
    };
  }

  factory Absence.fromMap(Map<String, dynamic> map) {
    return Absence(
      id: map['id'] != null ? map['id'] as int : null,
      expireDuration: map['expire_time'] as int,
      reason: map['reason'] as String,
      date: DateTime.parse(map['date'] as String),
      lessonName: map['lesson_name'] != null
          ? map['lesson_name'] as String
          : null,
      studentId: map['student_id'] as int,
    );
  }

  @override
  String toString() {
    return 'Absence(id: $id, expireDuration: $expireDuration, reason: $reason, date: $date, lessonName: $lessonName, studentId: $studentId)';
  }
}
