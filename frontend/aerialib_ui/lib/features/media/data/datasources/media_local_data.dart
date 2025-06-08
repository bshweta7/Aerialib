import 'dart:developer';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:frontend/features/media/data/models/media_model.dart';
import 'package:frontend/core/services/local_database_service.dart';

class MediaLocalDataSource {
  String tableName = "media";

  Future<Database> get database async => DatabaseService.database;

  Future<void> createMedia(MediaModel media) async {
    final db = await database;

    // Insert or replace (safe upsert)
    await db.insert(
      tableName,
      media.toMapLocal(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Verify insertion
    final result = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [media.id],
    );

    if (result.isNotEmpty) {
      log('[MediaLocalDataSource] Successfully added media: ${media.id}');
    } else {
      log('[MediaLocalDataSource] Failed to add media: ${media.id}');
    }
  }

  Future<void> createMedias(List<MediaModel> medias) async {
    final db = await database;
    final batch = db.batch();

    for (final media in medias) {
      batch.insert(
        tableName,
        media.toMapLocal(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
    log('[MediaLocalDataSource] Synced ${medias.length} media items.');
  }

  Future<List<MediaModel>> getAllMedia() async {
    final db = await database;
    final result = await db.query(tableName);

    if (result.isNotEmpty) {
      return result.map((elem) => MediaModel.fromMap(elem)).toList();
    } else {
      return [];
    }
  }

  Future<List<MediaModel>> getUnsyncedMedia() async {
    final db = await database;
    final result = await db.query(
      tableName,
      where: 'is_synced = ?',
      whereArgs: [0],
    );

    if (result.isNotEmpty) {
      return result.map((elem) => MediaModel.fromMap(elem)).toList();
    } else {
      return [];
    }
  }

  /// Returns MediaModel given an ID
  Future<MediaModel?> getMediaById(String mediaId) async {
    final db = await database;
    final result = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [mediaId],
    );
    if (result.isNotEmpty) {
      return MediaModel.fromMap(result.first);
    } else {
      return null;
    }
  }

  /// Returns List of MediaModels given list of IDs
  Future<List<MediaModel>> getMediasByIds(List<String> ids) async {
    final db = await database;
    final result = await db.query(
      tableName,
      where: 'id IN (${List.filled(ids.length, '?').join(', ')})',
      whereArgs: ids,
    );
    return result.map((e) => MediaModel.fromMap(e)).toList();
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

  Future<void> updateMedia(MediaModel media) async {
    final db = await database;
    await db.update(
      tableName,
      media.toMapLocal(),
      where: 'id = ?',
      whereArgs: [media.id],
    );
  }

  Future<void> deleteMedia(String id) async {
    final db = await database;
    await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}