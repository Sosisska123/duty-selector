import 'package:duty_selector/models/student.dart';
import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

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
      'CREATE TABLE students(id INTEGER PRIMARY KEY AUTOINCREMENT, first_name TEXT, middle_name TEXT, last_name TEXT)',
    );
    await db.execute(
      'CREATE TABLE logs(id INTEGER PRIMARY KEY AUTOINCREMENT, student_id INTEGER REFERENCES students(id), duty_type TEXT NOT NULL, date TEXT NOT NULL)',
    );
  }

  Future<List<Student>> get students async {
    final db = await database;

    final results = await db.query('students', orderBy: 'first_name');
    return results.map((row) => Student.fromMap(row)).toList();
  }

  Future<bool> addStudent(Student student) async {
    final db = await database;

    await db.insert('students', student.toMap());

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

    return insertedRows;
  }

  Future<int> clear() async {
    final db = await database;

    int rowsDeleted = await db.delete('students');

    return rowsDeleted;
  }
}
