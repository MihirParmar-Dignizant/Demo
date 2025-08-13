import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:user_data/database/user_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  static const String tableUser = 'user';

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('userdata.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final String finalDBPath = join(dbPath, fileName);
    debugPrint('Final DB path : $finalDBPath');
    return await openDatabase(finalDBPath, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableUser (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fName TEXT NOT NULL,
        lName TEXT NOT NULL,
        phone TEXT,
        email TEXT NOT NULL,
        password TEXT NOT NULL,
        gender INTEGER NOT NULL,
        occupation TEXT,
        city TEXT,
        state TEXT,
        country TEXT,
        userPic TEXT
      )
    ''');
  }

  Future<int> insertUser(UserModelData user) async {
    try {
      final db = await instance.database;
      return await db.insert(tableUser, user.toMap());
    } catch (e) {
      debugPrint('Insert Error: $e');
      rethrow;
    }
  }

  Future<UserModelData?> getUserByEmail(String email) async {
    final db = await instance.database;
    final result = await db.query(
      tableUser,
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );
    if (result.isNotEmpty) {
      return UserModelData.fromMap(result.first);
    }
    return null;
  }

  Future<UserModelData?> getUserByEmailAndPassword(
      String email, String password) async {
    final db = await instance.database;
    final result = await db.query(
      tableUser,
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
      limit: 1,
    );
    if (result.isNotEmpty) {
      return UserModelData.fromMap(result.first);
    }
    return null;
  }

  Future<int> updateUser(UserModelData user) async {
    final db = await instance.database;
    return await db.update(
      tableUser,
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> deleteUser(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableUser,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    await db.close();
  }
}
