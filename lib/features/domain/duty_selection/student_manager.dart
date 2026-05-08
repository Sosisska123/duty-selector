import 'package:duty_selector/features/data/database.dart';
import 'package:duty_selector/features/data/models/student.dart';
import 'package:duty_selector/features/data/absence_type.dart';
import 'package:duty_selector/features/data/student_row.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class StudentManager {
  final Map<int, StudentRow> studentRows = {};
  DatabaseService database;

  StudentManager(
    this.database, {
    List<Student>? students,
    List<Map<Student, AbsenceType>>? studentsAbsences,
  }) {
    if (students == null && studentsAbsences == null) return;

    initStudentsMap(students: students, studentsAbsences: studentsAbsences);
  }

  void initStudentsMap({
    List<Student>? students,
    List<Map<Student, AbsenceType>>? studentsAbsences,
  }) {
    if (students == null && studentsAbsences == null) {
      logger.e('Students and studentsAbsences are null');
      return;
    }

    // еси менять порядок сортировки то лучше исользовать взде student.id как ключик
    if (studentRows.isNotEmpty) {
      logger.i('Students already initialized');
      return;
    }

    if (studentsAbsences != null) {
      for (var i = 0; i < studentsAbsences.length; i++) {
        final student = studentsAbsences[i].keys.first;
        final absence = studentsAbsences[i].values.first;

        studentRows[i] = StudentRow(student: student, absenceType: absence);
      }
      return;
    }

    for (var i = 0; i < students!.length; i++) {
      studentRows[i] = StudentRow(student: students[i]);
    }
  }

  Set<Student> getCandidates({bool allPresent = false}) {
    final result = <Student>{};

    if (allPresent) selectAll(true);

    for (var i = 0; i < studentRows.length; i++) {
      final student = studentRows[i];

      if (student!.isSelected == true) {
        result.add(student.student);
      }
    }

    logger.i('Candidates: $result');

    return result;
  }

  List<Map<Student, AbsenceType>> getChangedAbsentStudents() {
    final result = <Map<Student, AbsenceType>>[];

    for (var i = 0; i < studentRows.length; i++) {
      final student = studentRows[i];

      if (!(student!.isStudentPresent()) && student.hasAbsenceChanged) {
        result.add({student.student: student.absenceType});
      }
    }

    logger.i('Changed absent students: $result');

    return result;
  }

  void selectAll(bool value) {
    for (var entry in studentRows.entries) {
      setStudentSelected(entry.key, value);
    }
  }

  void setStudentSick(int index, bool setSick) {
    if (!isIndexValid(index)) return;

    studentRows[index]!.setStudentSick(setSick);
  }

  void setStudentSelected(int index, bool setSelected) {
    if (!isIndexValid(index) || !isStudentPresent(index)) return;

    studentRows[index]!.setSelected(setSelected);
  }

  void setStudentAttendance(int index, AbsenceType type) {
    if (!isIndexValid(index)) return;
    if (type == AbsenceType.sick) return;

    studentRows[index]!.setStudentAbsence(type);
  }

  bool isStudentWithoutReason(int index) {
    if (!isIndexValid(index)) return false;
    return studentRows[index]!.isStudentWithoutReason();
  }

  bool isStudentWithGoodReason(int index) {
    if (!isIndexValid(index)) return false;
    return studentRows[index]!.isStudentWithGoodReason();
  }

  bool isStudentByApplication(int index) {
    if (!isIndexValid(index)) return false;
    return studentRows[index]!.isStudentByApplication();
  }

  Student? getStudent(int index) {
    if (!isIndexValid(index)) return null;
    return studentRows[index]!.student;
  }

  bool isStudentImmune(int index) {
    if (getStudent(index)!.firstName == 'Самир') return true;
    return false;
  }

  bool isStudentSick(int index) {
    if (!isIndexValid(index)) return false;
    return studentRows[index]!.isStudentSick();
  }

  bool isStudentSelected(int index) {
    if (!isIndexValid(index)) return false;
    return studentRows[index]!.isSelected;
  }

  int get studentsMapLen {
    return studentRows.length;
  }

  bool isStudentPresent(int index) => studentRows[index]!.isStudentPresent();

  bool isIndexValid(int index) =>
      (studentRows.isEmpty || index >= studentsMapLen) ? false : true;
}
