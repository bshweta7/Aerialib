import 'package:frontend/models/pose_model.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:flutter/foundation.dart';
import 'dart:io';

class PoseLocalRepository {
  String tableName = "poses";

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
    final path = join(dbPath, "poses.db");

    return openDatabase(
      path,
      version: 4,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < newVersion) {
          await db.execute(
            'DROP TABLE $tableName',
          );
          db.execute('''
            CREATE TABLE $tableName(
              id TEXT PRIMARY KEY,
              title TEXT NOT NULL,
              description TEXT NOT NULL,
              uid TEXT NOT NULL,
              dueAt TEXT NOT NULL,
              color TEXT NOT NULL,
              createdAt TEXT NOT NULL,
              updatedAt TEXT NOT NULL,
              isSynced INTEGER NOT NULL
            )'''
          );
        }
      },
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE $tableName(
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            description TEXT NOT NULL,
            uid TEXT NOT NULL,
            dueAt TEXT NOT NULL,
            color TEXT NOT NULL,
            createdAt TEXT NOT NULL,
            updatedAt TEXT NOT NULL,
            isSynced INTEGER NOT NULL
          )'''
        );
      },
    );
  }

  Future<void> insertPose(PoseModel pose) async {
    final db = await database;
    await db.delete(tableName, where: 'id = ?', whereArgs: [pose.id]);
    await db.insert(tableName, pose.toMap());
  }

  Future<void> insertPoses(List<PoseModel> poses) async {
    final db = await database;
    final batch = db.batch();
    for (final pose in poses) {
      batch.insert(
        tableName,
        pose.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace, //TODO replace might be wrong here
      );
    }

    await batch.commit(noResult: true);
  }

  Future<List<PoseModel>> getPoses () async {
    final db = await database;
    final result = await db.query(tableName);

    if(result.isNotEmpty) {
      List<PoseModel> poses = [];
      for (final elem in result) {
        poses.add(PoseModel.fromMap(elem));
      }
      return poses;

    } else {
      return [];
    }
  }

  Future<List<PoseModel>> getUnsyncedPoses() async {
    final db = await database;
    final result = await db.query(
      tableName,
      where: 'isSynced = ?',
      whereArgs: [0],
    );
    if (result.isNotEmpty) {
      List<PoseModel> poses = [];
      for (final elem in result) {
        poses.add(PoseModel.fromMap(elem));
      }
      return poses;
    }

    return [];
  }

  // TODO rename below to updateSyncedStatus or something more descriptive
  Future<void> updateRowValue(String id, int newValue) async {
    final db = await database;
    await db.update(
      tableName,
      {'isSynced': newValue},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}