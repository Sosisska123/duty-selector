import 'package:duty_selector/features/data/database.dart';
import 'package:duty_selector/features/data/models/student.dart';
import 'package:duty_selector/features/data/student_attendance_type.dart';

class StudentManager {
  final Map<int, Student> students = {};
  final Map<int, StudentAttendanceType> excludedStudents = {};
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

  // TODO:
  Set<Student> getTargetStudents(int? limit) {
    return students.entries
        .where((e) => isStudentSelected(e.key))
        .where((e) => isStudentHere(e.key))
        .map((e) => e.value)
        .take(limit ?? len)
        .toSet();
  }

  Map<Student, StudentAttendanceType> getExcludedStudents() {
    return {
      for (var entry in excludedStudents.entries.where(
        (e) => e.value != StudentAttendanceType.selected,
      ))
        students[entry.key]!: entry.value,
    };
  }

  void setStudentSick(int index, bool setSick) {
    if (!isIndexValid(index)) return;
    if (setSick) {
      excludedStudents[index] = StudentAttendanceType.sick;
    } else {
      excludedStudents.removeWhere(
        (id, type) => id == index && type == StudentAttendanceType.sick,
      );
    }
  }

  void setStudentSelected(int index, bool setSelected) {
    if (!isIndexValid(index) || !isStudentHere(index)) return;
    if (setSelected) {
      excludedStudents[index] = StudentAttendanceType.selected;
    } else {
      excludedStudents.removeWhere(
        (id, type) => id == index && type == StudentAttendanceType.selected,
      );
    }
  }

  void setStudentAttendance(
    int index,
    bool attend,
    StudentAttendanceType type,
  ) {
    if (!isIndexValid(index)) return;
    if (![
      StudentAttendanceType.byApplication,
      StudentAttendanceType.goodReason,
      StudentAttendanceType.gone,
    ].contains(type)) {
      return;
    }

    if (attend) {
      switch (type) {
        case StudentAttendanceType.byApplication:
          excludedStudents.removeWhere(
            (id, t) => id == index && t == StudentAttendanceType.byApplication,
          );
          break;
        case StudentAttendanceType.goodReason:
          excludedStudents.removeWhere(
            (id, t) => id == index && t == StudentAttendanceType.goodReason,
          );
          break;
        case StudentAttendanceType.gone:
          excludedStudents.removeWhere(
            (id, t) => id == index && t == StudentAttendanceType.gone,
          );
          break;
        default:
          break;
      }
    } else {
      switch (type) {
        case StudentAttendanceType.byApplication:
          excludedStudents[index] = StudentAttendanceType.byApplication;
          break;
        case StudentAttendanceType.goodReason:
          excludedStudents[index] = StudentAttendanceType.goodReason;
          break;
        case StudentAttendanceType.gone:
          excludedStudents[index] = StudentAttendanceType.gone;
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
      (e) => e.key == index && e.value == StudentAttendanceType.gone,
    );
  }

  bool isStudentWithGoodReason(int index) {
    if (!isIndexValid(index)) return false;
    return excludedStudents.entries.any(
      (e) => e.key == index && e.value == StudentAttendanceType.goodReason,
    );
  }

  bool isStudentByApplication(int index) {
    if (!isIndexValid(index)) return false;
    return excludedStudents.entries.any(
      (e) => e.key == index && e.value == StudentAttendanceType.byApplication,
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
      (e) => e.key == index && e.value == StudentAttendanceType.sick,
    );
  }

  bool isStudentSelected(int index) {
    if (!isIndexValid(index)) return false;
    return excludedStudents.entries.any(
      (e) => e.key == index && e.value == StudentAttendanceType.selected,
    );
  }

  Future<dynamic> getStudentsFromDB() async {
    return database.getStudents();
  }

  Future<dynamic> getSickStudentsFromDB() async {
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

  int get len {
    return students.length;
  }

  bool isStudentHere(int index) =>
      !excludedStudents.containsKey(index) ||
      !excludedStudents.entries.any(
        (e) => e.key == index && e.value != StudentAttendanceType.selected,
      );

  bool isIndexValid(int index) =>
      (students.isEmpty || index > len) ? false : true;
}
