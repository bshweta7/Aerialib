import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:frontend/features/transitions/data/models/transition_model.dart';
import 'package:frontend/core/services/local_database_service.dart';

class TransitionLocalDataSource {
  final String tableName = 'transitions';

  Future<Database> get database async => DatabaseService.database;

  Future<void> insertTransition(TransitionModel transition) async {
    final db = await database;
    await db.insert(tableName, transition.toMap());
  }

  Future<void> insertTransitions(List<TransitionModel> transitions) async {
    final db = await database;
    final batch = db.batch();
    for (final t in transitions) {
      batch.insert(
        tableName,
        t.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore, // change to replace if upserting
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<TransitionModel>> getTransitions() async {
    final db = await database;
    final result = await db.query(tableName);
    return result.map((e) => TransitionModel.fromMap(e)).toList();
  }

  Future<List<TransitionModel>> getUnsyncedTransitions() async {
    final db = await database;
    final result = await db.query(
      tableName,
      where: 'is_synced = ?',
      whereArgs: [0],
    );
    return result.map((e) => TransitionModel.fromMap(e)).toList();
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

  Future<void> updateTransition(TransitionModel model) async {
    final db = await database;
    await db.update(
      tableName,
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  Future<void> deleteTransition(String id) async {
    final db = await database;
    await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Returns TransitionModel given an ID
  Future<TransitionModel?> getTransitionById(String id) async {
    final db = await database;
    final result = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? TransitionModel.fromMap(result.first) : null;
  }

  /// Returns a list of TransitionModels by IDs
  Future<List<TransitionModel>> getTransitionsByIds(List<String> ids) async {
    if (ids.isEmpty) return [];
    final db = await database;
    final result = await db.query(
      tableName,
      where: 'id IN (${List.filled(ids.length, '?').join(', ')})',
      whereArgs: ids,
    );
    return result.map((e) => TransitionModel.fromMap(e)).toList();
  }
}
