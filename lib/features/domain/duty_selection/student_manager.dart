import 'package:duty_selector/features/data/database.dart';
import 'package:duty_selector/features/data/models/student.dart';
import 'package:duty_selector/features/data/absence_type.dart';

class StudentManager {
  final Map<int, Student> students = {};
  final Map<int, AbsenceType> excludedStudents = {};
  DatabaseService database;

  StudentManager(this.database, {List<Student>? students}) {
    if (students != null) {
      initStudentsMap(students);
    }
  }

  void initStudentsMap(List<Student> students) {
    // еси менять порядок сортировки то лучше исользовать взде student.id как ключик
    if (this.students.isEmpty) {
      for (var i = 0; i < students.length; i++) {
        this.students[i] = students[i];
      }
      return;
    }
  }

  Map<Student, AbsenceType> getCandidates() {
    final result = <Student, AbsenceType>{};
    for (var e in excludedStudents.entries) {
      result[getStudent(e.key)!] = e.value;
    }
    return result;
  }

  void setStudentSick(int index, bool setSick) {
    if (!isIndexValid(index)) return;
    if (setSick) {
      excludedStudents[index] = AbsenceType.sick;
    } else {
      excludedStudents.removeWhere(
        (id, type) => id == index && type == AbsenceType.sick,
      );
    }
  }

  void setStudentSelected(int index, bool setSelected) {
    if (!isIndexValid(index) || !isStudentHere(index)) return;
    if (setSelected) {
      excludedStudents[index] = AbsenceType.selected;
    } else {
      excludedStudents.removeWhere(
        (id, type) => id == index && type == AbsenceType.selected,
      );
    }
  }

  void setStudentAttendance(int index, bool attend, AbsenceType type) {
    if (!isIndexValid(index)) return;
    if (![
      AbsenceType.byApplication,
      AbsenceType.goodReason,
      AbsenceType.gone,
    ].contains(type)) {
      return;
    }

    if (attend) {
      switch (type) {
        case AbsenceType.byApplication:
          excludedStudents.removeWhere(
            (id, t) => id == index && t == AbsenceType.byApplication,
          );
          break;
        case AbsenceType.goodReason:
          excludedStudents.removeWhere(
            (id, t) => id == index && t == AbsenceType.goodReason,
          );
          break;
        case AbsenceType.gone:
          excludedStudents.removeWhere(
            (id, t) => id == index && t == AbsenceType.gone,
          );
          break;
        default:
          break;
      }
    } else {
      switch (type) {
        case AbsenceType.byApplication:
          excludedStudents[index] = AbsenceType.byApplication;
          break;
        case AbsenceType.goodReason:
          excludedStudents[index] = AbsenceType.goodReason;
          break;
        case AbsenceType.gone:
          excludedStudents[index] = AbsenceType.gone;
          break;
        default:
          break;
      }
    }

    logger.i('Set Att $excludedStudents');
  }

  bool isStudentWithoutReason(int index) {
    if (!isIndexValid(index)) return false;
    return excludedStudents.entries.any(
      (e) => e.key == index && e.value == AbsenceType.gone,
    );
  }

  bool isStudentWithGoodReason(int index) {
    if (!isIndexValid(index)) return false;
    return excludedStudents.entries.any(
      (e) => e.key == index && e.value == AbsenceType.goodReason,
    );
  }

  bool isStudentByApplication(int index) {
    if (!isIndexValid(index)) return false;
    return excludedStudents.entries.any(
      (e) => e.key == index && e.value == AbsenceType.byApplication,
    );
  }

  Student? getStudent(int index) {
    if (!isIndexValid(index)) return null;
    // return students.entries.firstWhere((e) => e.key == index).value;
    return students[index];
  }

  bool isStudentImmune(int index) {
    if (getStudent(index)!.firstName == 'Самир') return true;
    return false;
  }

  bool isStudentSick(int index) {
    if (!isIndexValid(index)) return false;
    return excludedStudents.entries.any(
      (e) => e.key == index && e.value == AbsenceType.sick,
    );
  }

  bool isStudentSelected(int index) {
    if (!isIndexValid(index)) return false;
    return excludedStudents.entries.any(
      (e) => e.key == index && e.value == AbsenceType.selected,
    );
  }

  Future<List<Student>> getStudentsFromDB() async {
    return database.getStudents();
  }

  Future<dynamic> addSickStudentsFromDB() async {
    // TODO: var sickStudents = database.getSickStudents();
    // addAll(sickStudents ids: StudentAttendanceType.sick)
  }

  void setAllSelected(bool value) {
    if (value) {
      for (var entry in students.entries) {
        setStudentSelected(entry.key, true);
      }
    } else {
      for (var entry in students.entries) {
        setStudentSelected(entry.key, false);
      }
    }
  }

  int get studentsMapLen {
    return students.length;
  }

  bool isStudentHere(int index) =>
      !excludedStudents.containsKey(index) ||
      !excludedStudents.entries.any(
        (e) => e.key == index && e.value != AbsenceType.selected,
      );

  bool isIndexValid(int index) =>
      (students.isEmpty || index > studentsMapLen) ? false : true;
}
