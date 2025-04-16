import 'package:frontend/to_sort/models/transition_model.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:flutter/foundation.dart';
import 'dart:io';

class TransitionLocalRepository {
  String tableName = "transitions";

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
    final path = join(dbPath, "transitions.db");

    return openDatabase(
      path,
      version: 1,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < newVersion) {
          await db.execute(
            'DROP TABLE $tableName',
          );
          db.execute('''
            CREATE TABLE $tableName(
              id TEXT PRIMARY KEY,
              fromPoseId TEXT NOT NULL,
              toPoseId TEXT NOT NULL,
              name TEXT,
              description TEXT,
              cues TEXT,
              difficulty INT,
              duration DOUBLE,
              primaryVideoId TEXT,
              isSynced INTEGER NOT NULL
            )'''
          );
        }
      },
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE $tableName(
            id TEXT PRIMARY KEY,
            fromPoseId TEXT NOT NULL,
            toPoseId TEXT NOT NULL,
            name TEXT,
            description TEXT,
            cues TEXT,
            difficulty INT,
            duration DOUBLE,
            primaryVideoId TEXT,
            isSynced INTEGER NOT NULL
          )'''
        );
      },
    );
  }

  Future<void> insertTransition(TransitionModel transition) async {
    final db = await database;
    await db.delete(tableName, where: 'id = ?', whereArgs: [transition.id]);
    await db.insert(tableName, transition.toMap());
  }

  Future<void> insertTransitionList(List<TransitionModel> transitions) async {
    final db = await database;
    final batch = db.batch();
    for (final transition in transitions) {
      batch.insert(
        tableName,
        transition.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace, //TODO replace might be wrong here
      );
    }

    await batch.commit(noResult: true);
  }

  Future<List<TransitionModel>> getTransitionList () async {
    final db = await database;
    final result = await db.query(tableName);

    if(result.isNotEmpty) {
      List<TransitionModel> transitionList = [];
      for (final elem in result) {
        transitionList.add(TransitionModel.fromMap(elem));
      }
      return transitionList;

    } else {
      return [];
    }
  }

  Future<List<TransitionModel>> getUnsyncedTransition() async {
    final db = await database;
    final result = await db.query(
      tableName,
      where: 'isSynced = ?',
      whereArgs: [0],
    );
    if (result.isNotEmpty) {
      List<TransitionModel> transitionList = [];
      for (final elem in result) {
        transitionList.add(TransitionModel.fromMap(elem));
      }
      return transitionList;
    } else {
      return [];
    }
  }

  Future<void> updateSyncedStatus(String id, int newValue) async {
    final db = await database;
    await db.update(
      tableName,
      {'isSynced': newValue},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}