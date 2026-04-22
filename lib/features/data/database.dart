import 'package:duty_selector/features/data/models/duty.dart';
import 'package:duty_selector/features/data/models/last_duty.dart';
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

    return await openDatabase(path, onCreate: _onCreate, version: 1);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE IF NOT EXISTS students(id INTEGER PRIMARY KEY AUTOINCREMENT, first_name TEXT NOT NULL, middle_name TEXT, last_name TEXT NOT NULL)',
    );
    await db.execute(
      'CREATE TABLE IF NOT EXISTS duties(id INTEGER PRIMARY KEY AUTOINCREMENT, student_id INTEGER REFERENCES students(id), duty_type TEXT NOT NULL, date TEXT NOT NULL)',
    );
    logger.i('Database created');
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

  Future<LastDutyData> getLastDutyData() async {
    final db = await database;

    // get last duty date
    var rawDate = await db.rawQuery(
      'SELECT max(date) AS last_duty_date FROM duties',
    );

    logger.i('${rawDate.toString()} Raw Date');

    // get students from the last duty
    var rawStudents = await db.rawQuery(
      'SELECT * from students s JOIN duties d on s.id = d.student_id WHERE d.date = (SELECT MAX(date) FROM duties);',
    );

    logger.i('${rawStudents.toString()} Raw Students');

    String date = '2026-01-01';
    List<Student> students = List.filled(
      5,
      Student(
        firstName: 'firstName',
        middleName: 'middleName',
        lastName: 'lastName',
      ),
    );

    return LastDutyData(date: date, students: students);
  }

  Future<bool> addStudent(Student student) async {
    final db = await database;

    await db.insert('students', student.toMap());

    logger.i('New Student Inserted ${student.fullName}');
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

  Future<int> addStudentsV2(List<Student> students) async {
    final db = await database;
    int insertedRows = 0;

    insertedRows = await db.rawInsert(
      join(
        'INSERT INTO students (first_name, middle_name, last_name) VALUES ',
        students
            .map(
              (s) => '("${s.firstName}", "${s.middleName}", "${s.lastName}")',
            )
            .join(', '),
      ),
    );

    logger.i('Students inserted');

    return insertedRows;
  }

  Future<int> clear(String tableName) async {
    final db = await database;

    int rowsDeleted = await db.delete(tableName);

    logger.i('Table $tableName cleared');

    return rowsDeleted;
  }

  Future<void> dropTable(String tableName) async {
    final db = await database;

    await db.execute('DROP TABLE $tableName');

    logger.i('Table $tableName dropped');
  }
}
