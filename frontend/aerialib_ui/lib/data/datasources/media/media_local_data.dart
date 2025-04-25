import 'package:frontend/to_sort/models/media_model.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../../services/local_database_service.dart';

class MediaLocalDataSource {
  String tableName = "media";

  Future<Database> get database async => DatabaseService.database;

  Future<void> insertMedia(MediaModel media) async {
    final db = await database;
    await db.delete(tableName, where: 'id = ?', whereArgs: [media.id]);
    await db.insert(tableName, media.toMap());
  }

  Future<void> insertMediaList(List<MediaModel> medias) async {
    final db = await database;
    final batch = db.batch();
    for (final media in medias) {
      batch.insert(
        tableName,
        media.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace, //TODO replace might be wrong here
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

  Future<List<MediaModel>> getUnsyncedMedia() async {
    final db = await database;
    final result = await db.query(
      tableName,
      where: 'isSynced = ?',
      whereArgs: [0],
    );
    if (result.isNotEmpty) {
      List<MediaModel> mediaList = [];
      for (final elem in result) {
        mediaList.add(MediaModel.fromMap(elem));
      }
      return mediaList;
    } else {
      return [];
    }
  }

  Future<void> updateSyncedStatus(String id, int newValue) async {
    final db = await database;
    await db.update(
      tableName,
      {'isSynced': newValue},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}