import 'dart:developer';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:frontend/features/transitions/data/transition_model.dart';
import 'package:frontend/core/services/local_database_service.dart';

class TransitionLocalDataSource {
  String tableName = 'transitions';

  Future<Database> get database async => DatabaseService.database;

  Future<void> createTransition(TransitionModel transition) async {
    final db = await database;

    // Insert the transition
    await db.insert(tableName, transition.toMapLocal());

    // Verify insertion by checking if the transition exists
    final result = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [transition.id],
    );

    if (result.isNotEmpty) {
      // Only log if the transition was successfully inserted
      log('[TransitionLocalDataSource] Successfully added transition: ${transition.id}');
    } else {
      log('[TransitionLocalDataSource] Failed to add transition: ${transition.id}');
    }
  }

  Future<void> createTransitions(List<TransitionModel> transitions) async {
    final db = await database;
    final batch = db.batch();
    for (final transition in transitions) {
      batch.insert(
        tableName,
        transition.toMapLocal(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<List<TransitionModel>> getAllTransitions() async {
    final db = await database;
    final result = await db.query(tableName);

    if (result.isNotEmpty) {
      List<TransitionModel> transitions = [];
      for (final elem in result) {
        transitions.add(TransitionModel.fromMap(elem));
      }
      return transitions;
    } else {
      return [];
    }
  }

  Future<List<TransitionModel>> getUnsyncedTransitions() async {
    final db = await database;
    final result = await db.query(
      tableName,
      where: 'is_synced = ?',
      whereArgs: [0],
    );
    if (result.isNotEmpty) {
      List<TransitionModel> transitions = [];
      for (final elem in result) {
        transitions.add(TransitionModel.fromMap(elem));
      }
      return transitions;
    }

    return [];
  }

  /// Returns TransitionModel given an ID
  Future<TransitionModel?> getTransitionById(String transitionId) async {
    final db = await database;
    final result = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [transitionId],
    );
    if (result.isNotEmpty) {
      return TransitionModel.fromMap(result.first);
    } else {
      return null; // Return null if not found
    }
  }

  /// Return List of TransitionModels given list of IDs.
  Future<List<TransitionModel>> getTransitionsByIds(List<String> ids) async {
    final db = await database;
    final result = await db.query(
      'transitions',
      where: 'id IN (${List.filled(ids.length, '?').join(', ')})',
      whereArgs: ids,
    );
    return result.map((e) => TransitionModel.fromMap(e)).toList();
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

  Future<void> updateTransition(TransitionModel transition) async {
    final db = await database;
    await db.update(
      tableName,
      transition.toMapLocal(),
      where: 'id = ?',
      whereArgs: [transition.id],
    );
  }

  Future<void> deleteTransition(String id) async {
    final db = await database;
    await db.delete(
        tableName,
        where: 'id = ?',
        whereArgs: [id]
    );
  }
}