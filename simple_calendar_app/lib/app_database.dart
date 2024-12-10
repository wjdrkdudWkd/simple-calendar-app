import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/category_model.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;

  AppDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('events.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE events (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        time TEXT NOT NULL,
        title TEXT NOT NULL,
        location TEXT NOT NULL,
        duration TEXT NOT NULL
      )
    ''');
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

  Future<List<Map<String, dynamic>>> getEventsByDate(
      String date, int limit, int offset) async {
    final db = await instance.database;
    return await db.query(
      'events',
      where: 'date = ?',
      whereArgs: [date],
      limit: limit,
      offset: offset,
    );
  }

  Future<void> insertEvent(Map<String, dynamic> event) async {
    final db = await instance.database;
    await db.insert('events', event);
  }

  Future<void> insertCategory(Categories category) async {
    final db = await database;
    await db.insert(
      'category',
      category.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Categories>> getCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('category');
    return List.generate(maps.length, (i) => Categories.fromMap(maps[i]));
  }

  Future<void> updateCategory(Categories category) async {
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
