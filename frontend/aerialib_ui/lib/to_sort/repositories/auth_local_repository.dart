import 'package:frontend/data/models/user_model.dart';
import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

class AuthLocalRepository {
  String tableName = "users";

  Database? _database;

  Future<Database> get database async {
    if(_database!=null) {
      return _database!;
    }

    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {

    // Initialize sqflite_common_ffi on desktop and web
    if (kIsWeb || Platform.isLinux || Platform.isWindows || Platform.isMacOS) {

      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;

    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "auth.db");

    return openDatabase(
        path,
        version: 1,
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < newVersion) {
            // await db.execute(
            //   'DROP TABLE $tableName',
            // );
            db.execute('''
          CREATE TABLE $tableName(
            id TEXT PRIMARY KEY,
            email TEXT NOT NULL,
            token TEXT NOT NULL,
            name TEXT NOT NULL,
            createdAt TEXT NOT NULL,
            updatedAt TEXT NOT NULL
          )'''
          );
          }
        },
        onCreate: (db, version) {
          return db.execute('''
          CREATE TABLE $tableName(
            id TEXT PRIMARY KEY,
            email TEXT NOT NULL,
            token TEXT NOT NULL,
            name TEXT NOT NULL,
            createdAt TEXT NOT NULL,
            updatedAt TEXT NOT NULL
          )'''
          );
        }
    );
  }

  Future<void> insertUser(UserModel userModel) async {
    final db = await database;
    await db.insert(
      tableName,
      userModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<UserModel?> getUser() async {
    final db = await database;
    final result = await db.query(tableName, limit: 1);

    if(result.isNotEmpty) {
      return UserModel.fromMap(result.first);
    } else {
      return null;
    }
  }

  // Function to clear user data
  // TODO instead of clearing it altogether, it could be like facebook (login as Shweta - not you? click here)
  Future<void> clearUser() async {
    final db = await database;
    await db.delete(tableName); // Delete all rows from the users table.
  }

}