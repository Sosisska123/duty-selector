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
    logger.i('4 Databases created');
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
      'SELECT s.id, s.first_name, s.surname, s.last_name FROM students s JOIN duties d ON s.id = d.student_id WHERE d.date = (SELECT MAX(date) FROM duties)',
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

  Future<List<Absence>> getWeekAbsencesFor(int? id) async {
    final db = await database;

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

  Future<List<Absence>> getAbsences() async {
    final db = await database;

    final results = await db.query('absences', orderBy: 'id');

    return results.map((row) => Absence.fromMap(row)).toList();
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
