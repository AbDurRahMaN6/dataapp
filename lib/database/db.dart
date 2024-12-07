import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('quotation.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE items (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            item TEXT NOT NULL,
            price REAL NOT NULL,
            qty INTEGER NOT NULL,
            discount REAL NOT NULL,
            total REAL NOT NULL
          )
        ''');
      },
    );
  }

  Future<List<Map<String, dynamic>>> fetchItems() async {
    final db = await instance.database;
    return await db.query('items');
  }
}
