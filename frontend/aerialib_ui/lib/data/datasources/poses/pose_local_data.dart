import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:frontend/data/models/pose_model.dart';
import '../../services/local_database_service.dart';

class PoseLocalDataSource {
  String tableName = 'poses';

  Future<Database> get database async => DatabaseService.database;

  Future<void> insertPose(PoseModel pose) async {
    final db = await database;
    // TODO decide if upsert or not: await db.delete(tableName, where: 'id = ?', whereArgs: [pose.id]);
    await db.insert(tableName, pose.toMap());
  }

  Future<void> insertPoses(List<PoseModel> poses) async {
    final db = await database;
    final batch = db.batch();
    for (final pose in poses) {
      batch.insert(
        tableName,
        pose.toMap(),
        conflictAlgorithm: ConflictAlgorithm
            .ignore, //TODO replace might be wrong here - use replace if upserting
      );
    }

    await batch.commit(noResult: true);
  }

  Future<List<PoseModel>> getPoses() async {
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

  Future<void> setSyncedStatus(String id, int newValue) async {
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
      pose.toMap(),
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

}