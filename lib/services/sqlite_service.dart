import 'dart:async';
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_model.dart';

class SQLiteService {
  static const String _dbName = 'users.db';
  static const String _tableName = 'favorites';

  // Singleton pattern
  SQLiteService._privateConstructor();
  static final SQLiteService instance = SQLiteService._privateConstructor();

  // Database object
  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  // Initialize SQLite database
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName(
            id INTEGER PRIMARY KEY,
            firstName TEXT,
            lastName TEXT,
            email TEXT,
            avatar TEXT
          )
        ''');
      },
    );
  }

  // Insert a user into the database
  Future<void> insertUser(User user) async {
    final db = await database;
    await db.insert(
      _tableName,
      user.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Fetch all users from the database
  Future<List<User>> getUsers() async {
    final db = await database;
    final result = await db.query(_tableName);
    return result.map((json) => User.fromJson(json)).toList();
  }

  // Check if a user is in the favorites list by ID
  Future<bool> isFavorite(int userId) async {
    final db = await database;
    final result = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [userId],
    );
    return result.isNotEmpty;
  }

  // Remove a user from favorites
  Future<void> removeUser(int userId) async {
    final db = await database;
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  // Toggle the favorite status of a user
  Future<void> toggleFavorite(User user) async {
    final isFav = await isFavorite(user.id);
    if (isFav) {
      await removeUser(user.id);
    } else {
      await insertUser(user);
    }
  }

  // Clear all users from the database (optional, for testing)
  Future<void> clearAllFavorites() async {
    final db = await database;
    await db.delete(_tableName);
  }
}
