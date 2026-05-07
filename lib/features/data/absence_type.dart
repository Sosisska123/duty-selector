enum AbsenceType {
  present('присутствует'),
  sick('болеет'),
  goodReason('по уважительной'),
  gone('пропустил'),
  byApplication('по заявлению'),
  selected('выбран'); // TODO: <- do something

  final String name;

  const AbsenceType(this.name);

  static AbsenceType fromString(String label) {
    return AbsenceType.values.firstWhere((e) => e.name == label);
  }
}
