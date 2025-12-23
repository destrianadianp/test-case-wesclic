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
      version: 3, // Incremented version to ensure migration happens
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE users(id TEXT PRIMARY KEY, name TEXT, email TEXT, imageUrl TEXT, token TEXT, job TEXT)'
        );
      },
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion < 2) {
          db.execute('ALTER TABLE users ADD COLUMN token TEXT');
        }
        if (oldVersion < 3) {
          // Ensure token column exists in case it was missed in previous migration
          // We'll attempt to add it again to be safe
          try {
            db.execute('ALTER TABLE users ADD COLUMN token TEXT');
          } catch (e) {
          }
        }
      },
    );
  }

  // Method to clear the database (for debugging/migration purposes)
  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete('users');
  }

  //CRUD operations

  Future<List<UserModel>> fetchTopUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');
      return maps.map((e)=> UserModel.fromMap(e)).toList();
    }
    
  Future<void> insertUser(UserModel user) async{
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
      return maps.map((e)=> UserModel.fromMap(e)).toList();
    }

    Future<void> updateUser(UserModel user) async{
      final db = await database;
      await db.update(
        'users',
        user.toMap(),
        where: 'id = ?',
        whereArgs: [user.id],
      );
    }
    Future<void> deteleUser(String id) async{
      final db = await database;
      await db.delete(
        'users',
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }
