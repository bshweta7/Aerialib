import 'dart:developer';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:frontend/features/pose/data/models/pose_model.dart';
import '../../../../../core/services/local_database_service.dart';

class PoseLocalDataSource {
  String tableName = 'poses';

  Future<Database> get database async => DatabaseService.database;

  Future<void> createPose(PoseModel pose) async {
    final db = await database;

    // Insert the pose
    await db.insert(tableName, pose.toMapLocal());

    // Verify insertion by checking if the pose exists
    final result = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [pose.id],
    );

    if (result.isNotEmpty) {
      // Only log if the pose was successfully inserted
      log('[PoseLocalDataSource] Successfully added pose: ${pose.slug}');
    } else {
      log('[PoseLocalDataSource] Failed to add pose: ${pose.slug}');
    }
  }

  Future<void> createPoses(List<PoseModel> poses) async {
    final db = await database;
    final batch = db.batch();
    for (final pose in poses) {
      batch.insert(
        tableName,
        pose.toMapLocal(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<List<PoseModel>> getAllPoses() async {
    final db = await database;
    final result = await db.query(tableName);

    if (result.isNotEmpty) {
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
      where: 'is_synced = ?',
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

  /// Returns PoseModel given an ID
  Future<PoseModel?> getPoseById(String poseId) async {
    final db = await database;
    final result = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [poseId],
    );
    if (result.isNotEmpty) {
      return PoseModel.fromMap(result.first);
    } else {
      return null; // Return null if not found
    }
  }

  /// Return List of PoseModels given list of IDs.
  Future<List<PoseModel>> getPosesByIds(List<String> ids) async {
    final db = await database;
    final result = await db.query(
      'poses',
      where: 'id IN (${List.filled(ids.length, '?').join(', ')})',
      whereArgs: ids,
    );
    return result.map((e) => PoseModel.fromMap(e)).toList();
  }

  Future<void> updateSyncStatus(String id, int newValue) async {
    final db = await database;
    await db.update(
      tableName,
      {'is_synced': newValue},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updatePose(PoseModel pose) async {
    final db = await database;
    await db.update(
      tableName,
      pose.toMapLocal(),
      where: 'id = ?',
      whereArgs: [pose.id],
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

}