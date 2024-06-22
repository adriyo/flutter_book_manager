import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  late Future<Database> _database;

  AppDatabase() {
    _database = _init();
  }

  Future<Database> _init() async {
    return openDatabase(
      join(await getDatabasesPath(), "books.db"),
      onCreate: _onCreate,
      version: 1,
    );
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE books (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT
      )
    ''');
  }

  Future<Database> get database async => _database;
}
