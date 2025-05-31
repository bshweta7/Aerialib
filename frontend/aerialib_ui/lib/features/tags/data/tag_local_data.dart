import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:frontend/features/tags/data/tag_model.dart';
import 'package:frontend/core/services/local_database_service.dart';

class TagLocalDataSource {
  final String tableName = 'tags';

  Future<Database> get database async => DatabaseService.database;

  Future<void> insertTag(TagModel tag) async {
    final db = await database;
    await db.insert(tableName, tag.toMap());
  }

  Future<void> insertTags(List<TagModel> tags) async {
    final db = await database;
    final batch = db.batch();
    for (final tag in tags) {
      batch.insert(
        tableName,
        tag.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<TagModel>> getTags() async {
    final db = await database;
    final result = await db.query(tableName);

    if (result.isNotEmpty) {
      return result.map((e) => TagModel.fromMap(e)).toList();
    } else {
      return [];
    }
  }

  Future<List<TagModel>> getUnsyncedTags() async {
    final db = await database;
    final result = await db.query(
      tableName,
      where: 'is_synced = ?',
      whereArgs: [0],
    );

    return result.map((e) => TagModel.fromMap(e)).toList();
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

  Future<void> updateTag(TagModel tag) async {
    final db = await database;
    await db.update(
      tableName,
      tag.toMap(),
      where: 'id = ?',
      whereArgs: [tag.id],
    );
  }

  Future<void> deleteTag(String id) async {
    final db = await database;
    await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
