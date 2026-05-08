import 'package:duty_selector/features/data/absence_type.dart';
import 'package:duty_selector/features/data/models/student.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class StudentRow {
  final Student student;
  AbsenceType absenceType;
  bool hasAbsenceChanged = false;
  bool isSelected;

  StudentRow({
    required this.student,
    this.absenceType = AbsenceType.present,
    this.isSelected = false,
  });

  void setSelected(bool value) {
    isSelected = value;
  }

  void setStudentAbsence(AbsenceType newAbsenceType) {
    if (absenceType == newAbsenceType) return;

    if (newAbsenceType != AbsenceType.present) {
      isSelected = false;
    }

    absenceType = newAbsenceType;
    setHasAbsenceChanged(true);
  }

  void setStudentSick(bool setSick) {
    if (absenceType == AbsenceType.sick && setSick) return;

    if (setSick) {
      isSelected = false;
    }

    absenceType = setSick ? AbsenceType.sick : AbsenceType.present;
    setHasAbsenceChanged(true);
  }

  void setHasAbsenceChanged(bool value) {
    hasAbsenceChanged = value;
  }

  bool isStudentWithoutReason() {
    return absenceType == AbsenceType.gone;
  }

  bool isStudentWithGoodReason() {
    return absenceType == AbsenceType.goodReason;
  }

  bool isStudentByApplication() {
    return absenceType == AbsenceType.byApplication;
  }

  bool isStudentSick() {
    return absenceType == AbsenceType.sick;
  }

  bool isStudentPresent() {
    return absenceType == AbsenceType.present ||
        absenceType == AbsenceType.selected;
  }

  @override
  String toString() {
    return 'StudentRow(student: $student, absenceType: $absenceType, hasAbsenceChanged: $hasAbsenceChanged, isSelected: $isSelected)';
  }
}
