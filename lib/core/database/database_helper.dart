import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test_case_skill/core/models/user_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'user_app.db');
    return await openDatabase(
      path,
      version: 4,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE users(id TEXT PRIMARY KEY, name TEXT, email TEXT, imageUrl TEXT, token TEXT, job TEXT)'
    );
    await db.execute(
      'CREATE TABLE messages(id INTEGER PRIMARY KEY AUTOINCREMENT, sender TEXT, message TEXT, time TEXT)'
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE users ADD COLUMN token TEXT');
    }
    if (oldVersion < 3) {
      try {
        await db.execute('ALTER TABLE users ADD COLUMN token TEXT');
      } catch (e) {
        debugPrint('Failed to add token column: $e');
      }
    }

    // Ensure messages table exists
    if (oldVersion < 4) {
      final tables = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table' AND name='messages'");
      if (tables.isEmpty) {
        await db.execute(
          'CREATE TABLE messages(id INTEGER PRIMARY KEY AUTOINCREMENT, sender TEXT, message TEXT, time TEXT)'
        );
      }
    }
  }

  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete('users');
  }

  // User CRUD operations
  Future<List<UserModel>> fetchTopUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return maps.map((e) => UserModel.fromMap(e)).toList();
  }

  Future<void> insertUser(UserModel user) async {
    final db = await database;
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<UserModel>> getAllUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return maps.map((e) => UserModel.fromMap(e)).toList();
  }

  Future<void> updateUser(UserModel user) async {
    final db = await database;
    await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<void> deleteUser(String id) async { // Fixed typo: deteleUser -> deleteUser
    final db = await database;
    await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Message CRUD operations
  Future<void> insertMessage(Map<String, dynamic> message) async {
    final db = await database;
    
    // Check for duplicate messages to prevent storing the same message multiple times
    final existing = await db.query(
      'messages',
      where: 'sender = ? AND message = ? AND time = ?',
      whereArgs: [message['sender'], message['message'], message['time']],
    );

    if (existing.isEmpty) {
      await db.insert('messages', message);
    }
  }

  Future<List<Map<String, dynamic>>> getAllMessages() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('messages', orderBy: 'id ASC');
    return maps;
  }

  // Additional helper methods for better performance
  Future<void> insertMessages(List<Map<String, dynamic>> messages) async {
    final db = await database;
    final batch = db.batch();
    
    for (final message in messages) {
      batch.insert('messages', message, conflictAlgorithm: ConflictAlgorithm.ignore);
    }
    
    await batch.commit();
  }

  Future<void> clearMessages() async {
    final db = await database;
    await db.delete('messages');
  }

  Future<int> getMessagesCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM messages');
    return Sqflite.firstIntValue(result) ?? 0;
  }
}