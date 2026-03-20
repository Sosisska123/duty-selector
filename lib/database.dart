import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:duty_selector/models/student.dart';

class DatabaseService {
  DatabaseService._();
  static final DatabaseService _databaseService = DatabaseService._();
  factory DatabaseService() => _databaseService;

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    // Initialize the DB first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDownloadsDirectory();
    final downloadPath = databasePath?.path ?? '';

    final path = join(downloadPath, 'Duty Selector', 'students.db');

    return await openDatabase(path, onCreate: _onCreate, version: 1);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE students(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)',
    );
    await db.execute(
      'CREATE TABLE duties(id INTEGER PRIMARY KEY AUTOINCREMENT, type TEXT, date TEXT, student_id INTEGER REFERENCES students(id))',
    );
  }

  Future<void> insertStudent(Student student) async {
    // Get a reference to the database
    final db = await database;

    // Insert the Student into the correct table
    await db.insert(
      'students',
      student.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Student>> students() async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all the Breeds.
    final List<Map<String, dynamic>> maps = await db.query('students');

    // Convert the List<Map<String, dynamic> into a List<Student>.
    return List.generate(maps.length, (index) => Student.fromMap(maps[index]));
  }

  Future<Student> student(int id) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      'students',
      where: 'id = ?',
      whereArgs: [id],
    );

    return Student.fromMap(maps[0]);
  }

  Future<void> updateStudent(Student student) async {
    // Get a reference to the database.
    final db = await database;

    // Update the given student
    await db.update(
      'students',
      student.toMap(),
      // Ensure that the Student has a matching id.
      where: 'id = ?',
      // Pass the Student's id as a whereArg to prevent SQL injection.
      whereArgs: [student.id],
    );
  }

  Future<void> deleteStudent(int id) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Student from the database.
    await db.delete(
      'students',
      // Use a `where` clause to delete a specific student.
      where: 'id = ?',
      // Pass the Student's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  Future<void> deleteAllStudents() async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Student from the database.
    await db.delete('students');
  }

  Future<void> setDuty(Student student, String type, String date) async {
    final db = await database;

    await db.insert('duties', {
      'type': type,
      'date': date,
      'student_id': student.id,
    });
  }

  Future<String?> getLastDutyDate(int studentId) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      'duties',
      where: 'student_id = ?',
      whereArgs: [studentId],
      orderBy: 'date DESC',
      limit: 1,
    );

    if (maps.isEmpty) {
      return null;
    }

    return maps.first['date'] as String?;
  }

  Future<List<Map<String, dynamic>>> getHistory(int studentId) async {
    final db = await database;

    return await db.query(
      'duties',
      where: 'student_id = ?',
      whereArgs: [studentId],
    );
  }

  Future<void> deleteDuty(int id) async {
    final db = await database;

    await db.delete('duties', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteAllDuties() async {
    final db = await database;

    await db.delete('duties');
  }
}

class DutyDatabaseService extends DatabaseService {
  DutyDatabaseService() : super._();

  Future<List<int>> todayDuties(String type, {int count = 1}) async {
    /* Return list of student ids who have the least duties of the given type */
    final db = await database;

    // 🤯
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT s.id, MAX(d.date) AS last_duty_date 
      FROM students s 
      LEFT JOIN duties d ON d.student_id = s.id AND d.type = ? 
      GROUP BY s.id 
      ORDER BY last_duty_date IS NOT NULL, last_duty_date ASC 
      LIMIT ?
      ''',
      [type, count],
    );

    final ids = maps.map((map) => map['id'] as int).toList();

    return ids;
  }
}
