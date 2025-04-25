import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:frontend/data/models/flow_model.dart';
import '../../services/local_database_service.dart';


class FlowLocalDataSource {
  String tableName = 'flows';

  Future<Database> get database async => DatabaseService.database;

  Future<void> insertFlow(FlowModel flow) async {
    final db = await database;
    // TODO decide if upsert or not: await db.delete(tableName, where: 'id = ?', whereArgs: [flow.id]);
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
      where: 'is_synced = ?',
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
  Future<void> setSyncedStatus(String id, int newValue) async {
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
      flow.toMap(),
      where: 'id = ?',
      whereArgs: [flow.id],
    );
  }

  Future<void> deleteFlow(String id) async {
    final db = await database;
    await db.delete(
        tableName,
        where: 'id = ?',
        whereArgs: [id]
    );
  }

}