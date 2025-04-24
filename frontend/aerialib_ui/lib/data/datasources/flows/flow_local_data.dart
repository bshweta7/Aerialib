import 'package:frontend/to_sort/models/flow_model.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:flutter/foundation.dart';
import 'dart:io';

import '../../schemas/flow_schema.dart';


class FlowLocalDataSource {
  String tableName = "flows";
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
    final path = join(dbPath, "flows.db");

    return openDatabase(
      path,
      version: 1,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < newVersion) {
          await db.execute(dropFlowTable);
          await db.execute(createFlowTable);
        }
      },
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE $tableName(
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            description TEXT,
            apparatus TEXT,

            primaryImageId TEXT NOT NULL,
            primaryImageUrl TEXT NOT NULL, 
            
            createdBy TEXT NOT NULL,
            updatedBy TEXT, 
            createdAt TEXT NOT NULL,
            updatedAt TEXT NOT NULL,

            isSynced INTEGER NOT NULL
          )'''
        );
      },
    );
  }

  Future<void> insertFlow(FlowModel flow) async {
    final db = await database;
    await db.delete(tableName, where: 'id = ?', whereArgs: [flow.id]);
    await db.insert(tableName, flow.toMap());
  }

  Future<void> insertFlows(List<FlowModel> flows) async {
    final db = await database;
    final batch = db.batch();
    for (final flow in flows) {
      batch.insert(
        tableName,
        flow.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace, //TODO replace might be wrong here
      );
    }

    await batch.commit(noResult: true);
  }

  Future<List<FlowModel>> getFlows () async {
    final db = await database;
    final result = await db.query(tableName);

    if(result.isNotEmpty) {
      List<FlowModel> flows = [];
      for (final elem in result) {
        flows.add(FlowModel.fromMap(elem));
      }
      return flows;

    } else {
      return [];
    }
  }

  Future<List<FlowModel>> getUnsyncedFlows() async {
    final db = await database;
    final result = await db.query(
      tableName,
      where: 'isSynced = ?',
      whereArgs: [0],
    );
    if (result.isNotEmpty) {
      List<FlowModel> flows = [];
      for (final elem in result) {
        flows.add(FlowModel.fromMap(elem));
      }
      return flows;
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

  Future<void> updateFlow(FlowModel flow) async {
    final db = await database;
    await db.update(
      tableName,
      flow.toMap(),
      where: 'id = ?',
      whereArgs: [flow.id],
    );
  }

}