import 'package:frontend/data/models/user_model.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:frontend/data/schemas/user_schema.dart';


class UserLocalDataSource {
  String tableName = userTable;
  Database? _database;

  /// Returns the database instance, initializing it if it's null.
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDb();
    return _database!;
  }

  /// Initializes the local database.
  Future<Database> _initDb() async {
    // Initialize sqflite_common_ffi on desktop and web
    if (kIsWeb || Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "user.db");

    return openDatabase(
      path,
      version: 1,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < newVersion) {
          await db.execute(dropUserTable); // Use drop command from schema
          await db.execute(createUserTable); // Use create command from schema
        }
      },
      onCreate: (db, version) {
        return db.execute(createUserTable); // Use create command from schema
      },
    );
  }

  /// Inserts a new user into the local database, replacing if a user with the same ID already exists.
  Future<void> insertUser(UserModel userModel) async {
    final db = await database;
    await db.insert(
      tableName,
      userModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Retrieves the currently logged-in user from the local database (if any). Returns null if no user is found.
  Future<UserModel?> getUser() async {
    final db = await database;
    final result = await db.query(tableName, limit: 1);

    if (result.isNotEmpty) {
      return UserModel.fromMap(result.first);
    } else {
      return null;
    }
  }

  /// Clears all user data from the local database.
  // TODO instead of clearing it altogether, it could be like facebook (login as Shweta - not you? click here) OR show multiple user icons for studios that have multiple instructors
  Future<void> clearUser() async {
    final db = await database;
    await db.delete(tableName); // Delete all rows from the users table.
  }
}