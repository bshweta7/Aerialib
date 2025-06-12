import 'dart:developer';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:frontend/core/services/local_database_service.dart';
import 'package:frontend/features/flow/data/models/flow_pose_model.dart';

class FlowPoseLocalDataSource {
  final String tableName = 'flow_poses';

  Future<Database> get database async => DatabaseService.database;

  /// Insert a single flow pose
  Future<void> createFlowPose(FlowPoseModel flowPose) async {
    final db = await database;
    await db.insert(
      tableName,
      flowPose.toMapLocal(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    log('[FlowPoseLocalDataSource] Added flow pose: ${flowPose.id}');
  }

  /// Insert multiple flow poses
  Future<void> createFlowPoses(List<FlowPoseModel> flowPoses) async {
    final db = await database;
    final batch = db.batch();

    for (final pose in flowPoses) {
      batch.insert(
        tableName,
        pose.toMapLocal(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
    log('[FlowPoseLocalDataSource] Inserted ${flowPoses.length} flow poses');
  }

  /// Get all flow poses
  Future<List<FlowPoseModel>> getAllFlowPoses() async {
    final db = await database;
    final result = await db.query(tableName);

    return result.map((e) => FlowPoseModel.fromMap(e)).toList();
  }

  /// Get flow poses by flowId
  Future<List<FlowPoseModel>> getFlowPosesByFlowId(String flowId) async {
    final db = await database;
    final result = await db.query(
      tableName,
      where: 'flow_id = ?',
      whereArgs: [flowId],
      orderBy: 'pose_order ASC',
    );

    return result.map((e) => FlowPoseModel.fromMap(e)).toList();
  }

  /// Get unsynced flow poses
  Future<List<FlowPoseModel>> getUnsyncedFlowPoses() async {
    final db = await database;
    final result = await db.query(
      tableName,
      where: 'is_synced = ?',
      whereArgs: [0],
    );

    return result.map((e) => FlowPoseModel.fromMap(e)).toList();
  }

  /// Set is_synced status
  Future<void> updateSyncStatus(String id, int newValue) async {
    final db = await database;
    await db.update(
      tableName,
      {'is_synced': newValue},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Delete a flow pose by ID
  Future<void> deleteFlowPoseById(String id) async {
    final db = await database;
    await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    log('[FlowPoseLocalDataSource] Deleted flow pose: $id');
  }

  /// Delete all flow poses in a given flow
  Future<void> deleteFlowPosesByFlowId(String flowId) async {
    final db = await database;
    await db.delete(
      tableName,
      where: 'flow_id = ?',
      whereArgs: [flowId],
    );
    log('[FlowPoseLocalDataSource] Deleted all poses in flow: $flowId');
  }
}
