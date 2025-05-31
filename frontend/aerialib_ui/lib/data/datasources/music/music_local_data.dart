import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:frontend/data/models/music_model.dart';
import '../../../core/services/local_database_service.dart';

class MusicLocalDataSource {
  final String tableName = 'music';

  Future<Database> get database async => DatabaseService.database;

  Future<void> insertMusic(MusicModel music) async {
    final db = await database;
    await db.insert(tableName, music.toMap());
  }

  Future<void> insertMusicList(List<MusicModel> musicList) async {
    final db = await database;
    final batch = db.batch();
    for (final music in musicList) {
      batch.insert(
        tableName,
        music.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore, // use replace for upsert
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<MusicModel>> getAllMusic() async {
    final db = await database;
    final result = await db.query(tableName);
    return result.map((e) => MusicModel.fromMap(e)).toList();
  }

  Future<List<MusicModel>> getUnsyncedMusic() async {
    final db = await database;
    final result = await db.query(
      tableName,
      where: 'is_synced = ?',
      whereArgs: [0],
    );
    return result.map((e) => MusicModel.fromMap(e)).toList();
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

  Future<void> updateMusic(MusicModel music) async {
    final db = await database;
    await db.update(
      tableName,
      music.toMap(),
      where: 'id = ?',
      whereArgs: [music.id],
    );
  }

  Future<void> deleteMusic(String id) async {
    final db = await database;
    await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<MusicModel?> getMusicById(String musicId) async {
    final db = await database;
    final result = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [musicId],
    );
    if (result.isNotEmpty) {
      return MusicModel.fromMap(result.first);
    }
    return null;
  }

  Future<List<MusicModel>> getMusicByIds(List<String> ids) async {
    final db = await database;
    final result = await db.query(
      tableName,
      where: 'id IN (${List.filled(ids.length, '?').join(', ')})',
      whereArgs: ids,
    );
    return result.map((e) => MusicModel.fromMap(e)).toList();
  }
}
