import 'package:frontend/to_sort/models/flow_pose_model.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:flutter/foundation.dart';
import 'dart:io';

import '../../../to_sort/models/flow_model.dart';
import '../../schemas/flow_poses_schema.dart';

class FlowPoseLocalDataSource {
  String tableName = flowPoseTable;
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
    final path = join(dbPath, "flow_poses.db");

    return openDatabase(
      path,
      version: 6,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < newVersion) {
          await db.execute(dropFlowPoseTable); // Use drop command from schema
          await db.execute(createFlowPoseTable); // Use create command from schema
        }
      },
      onCreate: (db, version) {
        return db.execute(createFlowPoseTable); // Use create command from schema
      },
    );
  }

  Future<void> insertFlowPose(FlowPoseModel flowPose) async {
    final db = await database;
    // TODO decide if upsert or not: await db.delete(tableName, where: 'id = ?', whereArgs: [flowPose.id]);
    await db.insert(tableName, flowPose.toMap());
  }

  Future<void> insertFlowPoses(List<FlowPoseModel> flowPoses) async {
    final db = await database;
    final batch = db.batch();
    for (final flowPose in flowPoses) {
      batch.insert(
        tableName,
        flowPose.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<List<FlowPoseModel>> getFlowPoses () async {
    final db = await database;
    final result = await db.query(tableName);

    if(result.isNotEmpty) {
      List<FlowPoseModel> flowPoses = [];
      for (final elem in result) {
        flowPoses.add(FlowPoseModel.fromMap(elem));
      }
      return flowPoses;

    } else {
      return [];
    }
  }

  Future<List<FlowPoseModel>> getUnsyncedFlowPoses() async {
    final db = await database;
    final result = await db.query(
      tableName,
      where: 'is_synced = ?',
      whereArgs: [0],
    );
    if (result.isNotEmpty) {
      List<FlowPoseModel> flowPoses = [];
      for (final elem in result) {
        flowPoses.add(FlowPoseModel.fromMap(elem));
      }
      return flowPoses;
    }

    return [];
  }

  Future<void> setSyncedStatus(String id, int newValue) async {
    final db = await database;
    await db.update(
      tableName,
      {'is_synced': newValue},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateFlowPose(FlowPoseModel flowPose) async {
    final db = await database;
    await db.update(
      tableName,
      flowPose.toMap(),
      where: 'id = ?',
      whereArgs: [flowPose.id],
    );
  }

  Future<void> deletePose(String id) async {
    final db = await database;
    await db.delete(
        tableName,
        where: 'id = ?',
        whereArgs: [id]
    );
  }

  Future<List<FlowPoseModel>> getFlowPosesInFlow(FlowModel flow) async {
    /// Returns list of FlowPoseModels containing flowPoses with the given flowId ///
    final db = await database;
    final result = await db.query(
      tableName,
      where: 'flow_id = ?',
      whereArgs: [flow.id],
    );
    if (result.isNotEmpty) {
      List<FlowPoseModel> flowPoses = [];
      for (final elem in result) {
        flowPoses.add(FlowPoseModel.fromMap(elem));
      }
      return flowPoses;
    }
    return [];
  }
}