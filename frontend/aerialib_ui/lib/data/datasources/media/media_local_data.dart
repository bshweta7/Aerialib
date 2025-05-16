import 'dart:developer';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:frontend/data/models/media_model.dart';
import 'package:frontend/data/services/local_database_service.dart';

class MediaLocalDataSource {
  String tableName = "media";

  Future<Database> get database async => DatabaseService.database;

  Future<void> insertMedia(MediaModel media) async {
    final db = await database;
    // TODO decide if upsert or not: await db.delete(tableName, where: 'id = ?', whereArgs: [media.id]);
    await db.insert(tableName, media.toMap());
  }

  Future<void> insertMediaList(List<MediaModel> medias) async {
    final db = await database;
    final batch = db.batch();
    for (final media in medias) {
      batch.insert(
        tableName,
        media.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore, //TODO replace might be wrong here - use replace if upserting
      );
    }

    await batch.commit(noResult: true);
  }

  Future<List<MediaModel>> getMediaList () async {
    final db = await database;
    final result = await db.query(tableName);

    if(result.isNotEmpty) {
      List<MediaModel> mediaList = [];
      for (final elem in result) {
        mediaList.add(MediaModel.fromMap(elem));
      }
      return mediaList;

    } else {
      return [];
    }
  }

  /// Get list of media models that are primary images for poses
  Future<List<MediaModel>> getPoseMedia() async {
    final db = await database;
    log("Entered getPoseMedia");
    final result = await db.query(
      tableName,
      where: 'primary_media = ?',
      whereArgs: ['pose'],
    );
    log("Got Result");

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
      List<MediaModel> mediaList = [];
      for (final elem in result) {
        mediaList.add(MediaModel.fromMap(elem));
      }
      return mediaList;
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

  Future<void> updateMedia(MediaModel media) async {
    final db = await database;
    await db.update(
      tableName,
      media.toMap(),
      where: 'id = ?',
      whereArgs: [media.id],
    );
  }

  Future<void> deleteMedia(String id) async {
    final db = await database;
    await db.delete(
        tableName,
        where: 'id = ?',
        whereArgs: [id]
    );
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
      return null; // Return null if not found
    }
  }

  /// Return List of MediaModels given list of IDs.
  Future<List<MediaModel>> getMediasByIds(List<String> ids) async {
    final db = await database;
    final result = await db.query(
      'media',
      where: 'id IN (${List.filled(ids.length, '?').join(', ')})',
      whereArgs: ids,
    );
    return result.map((e) => MediaModel.fromMap(e)).toList();
  }
}