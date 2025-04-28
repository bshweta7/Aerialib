import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:frontend/data/models/flow_pose_model.dart';
import '../../services/local_database_service.dart';

class FlowPoseLocalDataSource {
  String tableName = 'flow_poses';

  Future<Database> get database async => DatabaseService.database;

  /// Insert a flow pose into the database
  Future<void> insertFlowPose(FlowPoseModel flowPose) async {
    final db = await database;
    // TODO decide if upsert or not: await db.delete(tableName, where: 'id = ?', whereArgs: [flowPose.id]);
    await db.insert(tableName, flowPose.toMap());
  }

  /// Insert a list of flow poses into the database (bulk insert)
  Future<void> insertFlowPoses(List<FlowPoseModel> flowPoses) async {
    final db = await database;
    final batch = db.batch();
    for (var flowPose in flowPoses) {
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

  // Future<void> updateFlowPose(FlowPoseModel flowPose) async {
  //   final db = await database;
  //   await db.update(
  //     tableName,
  //     flowPose.toMap(),
  //     where: 'id = ?',
  //     whereArgs: [flowPose.id],
  //   );
  // }


  Future<void> deleteFlowPose(String id) async {
    final db = await database;
    await db.delete(
        tableName,
        where: 'id = ?',
        whereArgs: [id]
    );
  }

  /// Delete all the flow poses for a given flow
  Future<void> deleteFlowPoseInFlow(String flowId) async {
    final db = await database;
    await db.delete(
      tableName,
      where: 'flow_id = ?',
      whereArgs: [flowId],
    );
  }

  /// Returns list of FlowPoseModels containing flowPoses with the given flowId
  Future<List<FlowPoseModel>> getFlowPosesInFlow(String flowId) async {
    final db = await database;
    final result = await db.query(
      tableName,
      where: 'flow_id = ?',
      whereArgs: [flowId],
      orderBy: 'order ASC',
    );
    return result.map((e) => FlowPoseModel.fromMap(e)).toList();
  }
}