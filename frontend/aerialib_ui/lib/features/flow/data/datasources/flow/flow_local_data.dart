import 'dart:developer';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:frontend/core/services/local_database_service.dart';

import '../../models/flow_model.dart';

class FlowLocalDataSource {
  final String tableName = 'flows';

  Future<Database> get database async => DatabaseService.database;

  Future<void> createFlow(FlowModel flow) async {
    final db = await database;

    await db.insert(tableName, flow.toMapLocal());

    final result = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [flow.id],
    );

    if (result.isNotEmpty) {
      log('[FlowLocalDataSource] Successfully added flow: ${flow.id}');
    } else {
      log('[FlowLocalDataSource] Failed to add flow: ${flow.id}');
    }
  }

  Future<void> createFlows(List<FlowModel> flows) async {
    final db = await database;
    final batch = db.batch();

    for (final flow in flows) {
      batch.insert(
        tableName,
        flow.toMapLocal(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<List<FlowModel>> getAllFlows() async {
    final db = await database;
    final result = await db.query(tableName);

    if (result.isNotEmpty) {
      return result.map((e) => FlowModel.fromMap(e)).toList();
    } else {
      return [];
    }
  }

  Future<List<FlowModel>> getUnsyncedFlows() async {
    final db = await database;
    final result = await db.query(
      tableName,
      where: 'is_synced = ?',
      whereArgs: [0],
    );

    return result.map((e) => FlowModel.fromMap(e)).toList();
  }

  Future<FlowModel?> getFlowById(String flowId) async {
    final db = await database;
    final result = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [flowId],
    );

    if (result.isNotEmpty) {
      return FlowModel.fromMap(result.first);
    } else {
      return null;
    }
  }

  Future<List<FlowModel>> getFlowsByIds(List<String> ids) async {
    final db = await database;
    final result = await db.query(
      tableName,
      where: 'id IN (${List.filled(ids.length, '?').join(', ')})',
      whereArgs: ids,
    );

    return result.map((e) => FlowModel.fromMap(e)).toList();
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

  Future<void> updateFlow(FlowModel flow) async {
    final db = await database;
    await db.update(
      tableName,
      flow.toMapLocal(),
      where: 'id = ?',
      whereArgs: [flow.id],
    );
  }

  Future<void> deleteFlow(String id) async {
    final db = await database;
    await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
