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
}
