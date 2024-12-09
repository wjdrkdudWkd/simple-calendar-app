import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/category_model.dart';

class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'calendar_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE category(
        id TEXT PRIMARY KEY,
        name TEXT,
        description TEXT,
        iconName TEXT,
        isEnabled INTEGER
      )
    ''');
  }

  Future<void> insertCategory(Category category) async {
    final db = await database;
    await db.insert(
      'category',
      category.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Category>> getCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('category');
    return List.generate(maps.length, (i) => Category.fromMap(maps[i]));
  }

  Future<void> updateCategory(Category category) async {
    final db = await database;
    await db.update(
      'category',
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  Future<void> deleteCategory(String id) async {
    final db = await database;
    await db.delete(
      'category',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
