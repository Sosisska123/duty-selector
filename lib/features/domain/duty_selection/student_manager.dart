import 'package:duty_selector/features/data/database.dart';
import 'package:duty_selector/features/data/models/student.dart';
import 'package:duty_selector/features/data/student_attendance_type.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class StudentManager {
  final Map<int, Student> students = {};
  final Map<int, StudentAttendanceType> excludedStudents = {};
  DatabaseService database;

  StudentManager(this.database, {List<Student>? students}) {
    if (students != null) {
      initStudentsMap(students);
    }
  }

  Future<dynamic> getStudentsFromDB() async {
    return database.getStudents();
  }

  Future<dynamic> getSickStudentsFromDB() async {
    // TODO: var sickStudents = database.getSickStudents();
    // addAll(sickStudents ids: StudentAttendanceType.sick)
  }

  void initStudentsMap(List<Student> students) {
    if (this.students.isEmpty) {
      for (var i = 0; i < students.length; i++) {
        this.students[i] = students[i];
      }
      return;
    }
  }

  // TODO:
  Set<Student> getTargetStudents(int? limit) {
    return students.entries
        .where((e) => isStudentSelected(e.key))
        .where((e) => !excludedStudents.containsKey(e.key))
        .map((e) => e.value)
        .take(limit ?? len)
        .toSet();
  }

  Student? getStudent(int index) {
    if (!_isStudentValid(index)) return null;
    return students.entries.firstWhere((e) => e.key == index).value;
  }

  bool isStudentImmune(int index) {
    if (getStudent(index)!.firstName == 'Самир') return true;
    return false;
  }

  bool isStudentSick(int index) {
    if (!_isStudentValid(index)) return false;
    return excludedStudents.entries.any(
      (e) => e.key == index && e.value == StudentAttendanceType.sick,
    );
  }

  void setStudentSick(int index, bool setSick) {
    if (!_isStudentValid(index)) return;
    if (setSick) {
      excludedStudents[index] = StudentAttendanceType.sick;
    } else {
      excludedStudents.removeWhere(
        (id, type) => id == index && type == StudentAttendanceType.sick,
      );
    }
  }

  void setStudentSelected(int index, bool setSelected) {
    if (!_isStudentValid(index)) return;
    if (setSelected) {
      excludedStudents[index] = StudentAttendanceType.selected;
    } else {
      excludedStudents.removeWhere(
        (id, type) => id == index && type == StudentAttendanceType.selected,
      );
    }
  }

  bool isStudentSelected(int index) {
    if (!_isStudentValid(index)) return false;
    return excludedStudents.entries.any(
      (e) => e.key == index && e.value == StudentAttendanceType.selected,
    );
  }

  void setStudentPass(
    int index, {
    bool withGoodReason = false,
    bool byApplication = false,
  }) {
    if (!_isStudentValid(index)) return;
    if (withGoodReason) {
      excludedStudents[index] = StudentAttendanceType.goodReason;
    } else if (byApplication) {
      excludedStudents[index] = StudentAttendanceType.byApplication;
    } else {
      excludedStudents[index] = StudentAttendanceType.gone;
    }
  }

  int get len {
    return students.length;
  }

  bool _isStudentValid(int index) =>
      (students.isEmpty || index > len) ? false : true;

  void setAllSelected(bool value) {
    // TODO:
  }
}
