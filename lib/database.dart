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
      'CREATE TABLE students(id INTEGER PRIMARY KEY, name TEXT, status TEXT, last_duty_date TEXT)',
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

  // A method that retrieves all the students from the students table.
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

  // A method that updates a student data from the students table.
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

  // A method that deletes a student data from the students table.
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

  // A method that deletes all student data from the students table.
  Future<void> deleteAllStudents() async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Student from the database.
    await db.delete('students');
  }
}
