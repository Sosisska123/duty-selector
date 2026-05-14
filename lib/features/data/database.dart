import 'dart:core';

import 'package:duty_selector/features/data/absence_type.dart';
import 'package:duty_selector/features/data/models/absence.dart';
import 'package:duty_selector/features/data/models/duty.dart';
import 'package:duty_selector/features/data/models/student.dart';
import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

var logger = Logger();

class DatabaseService {
  DatabaseService._();
  static final DatabaseService _databaseService = DatabaseService._();
  factory DatabaseService() => _databaseService;

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    // Initialize the DB first time it is accessed
    _database = await _init();
    return _database!;
  }

  Future<Database> _init() async {
    final databasePath = await getDownloadsDirectory();
    final downloadPath = databasePath?.path ?? '';

    final path = join(downloadPath, 'Duty Selector', 'students.db');

    return await openDatabase(
      path,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      version: 1,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE IF NOT EXISTS students(id INTEGER PRIMARY KEY AUTOINCREMENT, first_name TEXT NOT NULL, surname TEXT, last_name TEXT NOT NULL)',
    );
    await db.execute(
      'CREATE TABLE IF NOT EXISTS duties(id INTEGER PRIMARY KEY AUTOINCREMENT, student_id INTEGER REFERENCES students(id), duty_type TEXT NOT NULL, date TEXT NOT NULL)',
    );
    await db.execute(
      'CREATE TABLE IF NOT EXISTS absences(id INTEGER PRIMARY KEY AUTOINCREMENT, student_id INTEGER REFERENCES students(id), date TEXT NOT NULL, expire_time INTEGER NOT NULL, reason TEXT NOT NULL, lesson_name TEXT)',
    );
    // TODO: Add views, idexes
    logger.i('3 Databases created');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    logger.i('Migrating from $oldVersion to $newVersion');
  }

  Future<List<Student>> getStudents() async {
    final db = await database;

    final results = await db.query('students', orderBy: 'id');

    logger.i('Get all students');

    return results.map((row) => Student.fromMap(row)).toList();
  }

  Future<List<Duty>> getDuties() async {
    final db = await database;

    final results = await db.query('duties', orderBy: 'id');

    logger.i('Get all duties');

    return results.map((row) => Duty.fromMap(row)).toList();
  }

  Future<String> getLastDutyDate() async {
    final db = await database;

    var result = await db.query(
      'duties',
      columns: ['MAX(date) AS last_duty_date'],
      orderBy: 'date DESC',
      limit: 1,
    );

    var text = result.first['last_duty_date'];

    if (text == null) {
      logger.i('Last duty date is Null');
      return '';
    }

    logger.i('Last duty date $text');
    return text as String;
  }

  Future<List<Student>> getLastDutyStudents() async {
    final db = await database;

    var result = await db.rawQuery(
      'SELECT s.id, s.first_name, s.surname, s.last_name FROM students s JOIN duties d ON s.id = d.student_id AND date(d.date) = (SELECT MAX(date(date)) FROM duties)',
    );

    if (result.isEmpty) {
      logger.i('Last duty students is Null');
      return [];
    }

    List<Student> students = result.map((e) => Student.fromMap(e)).toList();

    logger.i('Last duty students ${students.toString()}');

    return students;
  }

  Future<bool> addStudent(Student student) async {
    final db = await database;

    await db.insert('students', student.toMap());

    logger.i('New Student Inserted ${student.fullName}');
    return true;
  }

  Future<bool> addDuty(Duty duty) async {
    final db = await database;

    await db.insert('duties', duty.toMap());

    logger.i('New Duty Inserted ${duty.toString()}');
    return true;
  }

  Future<int> addStudents(List<Student> students) async {
    final db = await database;
    int lastRowsId = 0;

    for (var student in students) {
      lastRowsId = await db.insert(
        'students',
        student.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    return lastRowsId;
  }

  Future<Set<Student>> getNewDutiesWithin(
    Set<Student> students, {
    int limit = 100,
  }) async {
    final db = await database;

    final result = await db.rawQuery(
      'SELECT '
      's.id, '
      's.first_name, '
      's.surname, '
      's.last_name '
      'FROM students s '
      'LEFT JOIN duties d '
      'ON s.id = d.student_id '
      'AND d.date = ('
      'SELECT MAX(date) '
      'FROM duties d2 '
      'WHERE s.id = d2.student_id'
      ') '
      'WHERE s.id IN '
      '(${students.map((e) => '?').join(', ')}) '
      'AND NOT EXISTS ('
      'SELECT 1 '
      'FROM absences a '
      'WHERE a.student_id = s.id '
      "AND datetime(a.date, '' || a.expire_time || ' minutes') > datetime('now', 'localtime')"
      ') '
      'ORDER by d.date asc, s.id asc '
      'LIMIT ?',
      [...students.map((e) => e.id), limit],
    );

    logger.i('getNewDutiesWithin: $result students');

    return result.map((e) => Student.fromMap(e)).toSet();
  }

  Future<List<Duty>> getLastDutiesFor(int id) async {
    final db = await database;

    final result = await db.query(
      'duties',
      where: 'student_id = ?',
      whereArgs: [id],
      orderBy: 'date DESC',
    );

    return result.map((e) => Duty.fromMap(e)).toList();
  }

  Future<int> deleteDuty(int dutyId) async {
    final db = await database;

    final rowsCount = await db.delete(
      'duties',
      where: 'id = ?',
      whereArgs: [dutyId],
    );

    logger.i('Delete duty $dutyId');

    return rowsCount;
  }

  Future<int> updateDuty(int oldDutyId, Duty newDuty) async {
    final db = await database;

    final rowsCount = await db.update(
      'duties',
      newDuty.toMap(),
      where: 'id = ?',
      whereArgs: [oldDutyId],
    );

    logger.i('New absence: $newDuty');

    return rowsCount;
  }

  // absences

  Future<bool> addAbsence(Absence absence) async {
    final db = await database;

    await db.insert(
      'absences',
      absence.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    logger.i('Inserted ${absence.toString()}');

    return true;
  }

  Future<List<Absence>> getWeekAbsencesFor(int id) async {
    final db = await database;
    //TODO: remove limit

    final result = await db.query(
      'absences',
      where: 'student_id = ?',
      whereArgs: [id],
      orderBy: 'date DESC',
      limit: 7,
    );

    logger.i('Get week absences for $id');
    return result.map((e) => Absence.fromMap(e)).toList();
  }

  Future<List<Map<Student, AbsenceType>>> getAbsenceNowStudents({
    bool includeAll = false,
  }) async {
    final db = await database;

    final queryRes = await db.rawQuery(
      'SELECT '
      's.id AS sid, '
      's.first_name, '
      's.surname, '
      's.last_name, '
      'a.reason '
      'FROM students s '
      '${includeAll ? "LEFT JOIN" : "INNER JOIN"} absences a '
      'ON a.id = ('
      '  SELECT id FROM absences a2 '
      '  WHERE a2.student_id = s.id '
      "  AND datetime(a2.date, '' || a2.expire_time || ' minutes') > datetime('now', 'localtime') "
      '  ORDER BY a2.id DESC, a2.id DESC '
      '  LIMIT 1 '
      ')',
    );

    List<Map<Student, AbsenceType>> result = [];

    for (var e in queryRes) {
      final stud = Student(
        id: e['sid'] as int,
        firstName: e['first_name'] as String,
        surname: e['surname'] as String,
        lastName: e['last_name'] as String,
      );

      final absenceType = AbsenceType.fromString(
        e['reason'] as String? ?? 'присутствует',
      );

      result.add({stud: absenceType});
    }

    logger.i('Absence now:');
    logger.i(result);

    return result;
  }

  Future<List<Absence>> getAbsences() async {
    final db = await database;

    final results = await db.query('absences', orderBy: 'id');

    logger.i('Get all absences');

    return results.map((row) => Absence.fromMap(row)).toList();
  }

  Future<void> removeLastAbsence(int studentId) async {
    final db = await database;

    await db.delete(
      'absences',
      where:
          'id = (SELECT id FROM absences WHERE student_id = ? ORDER BY id DESC LIMIT 1)',
      whereArgs: [studentId],
    );

    logger.i('Remove last absence from: $studentId');
  }

  Future<int> deleteAbsence(int absenceId) async {
    final db = await database;

    final rowsCount = await db.delete(
      'absences',
      where: 'id = ?',
      whereArgs: [absenceId],
    );

    logger.i('Delete absence $absenceId');

    return rowsCount;
  }

  Future<int> updateAbsence(int oldAbsenceId, Absence newAbsence) async {
    final db = await database;

    final rowsCount = await db.update(
      'absences',
      newAbsence.toMap(),
      where: 'id = ?',
      whereArgs: [oldAbsenceId],
    );

    logger.i('New absence: $newAbsence');

    return rowsCount;
  }

  // endregion

  Future<int> clear(String tableName) async {
    final db = await database;

    int rowsDeleted = await db.delete(tableName);
    await db.delete(
      'sqlite_sequence',
      where: 'name = ?',
      whereArgs: [tableName],
    );

    logger.i('Table $tableName cleared');

    return rowsDeleted;
  }

  Future<void> dropTable(String tableName) async {
    final db = await database;

    await db.execute('DROP TABLE $tableName');
    await db.delete(
      'sqlite_sequence',
      where: 'name = ?',
      whereArgs: [tableName],
    );

    logger.i('Table $tableName dropped');
  }
}
