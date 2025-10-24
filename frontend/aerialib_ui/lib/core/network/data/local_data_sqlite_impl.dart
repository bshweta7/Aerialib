import 'package:sqflite/sqflite.dart';
import 'local_data_abstract_interface.dart';

typedef ToMap<T> = Map<String, Object?> Function(T item);
typedef FromMap<T> = T Function(Map<String, Object?> map);

abstract class SqliteLocalDataSource<T> implements LocalDataSource<T> {
  @override
  final String tableName;

  final Future<Database> Function() databaseProvider;

  final ToMap<T> toMap;
  final FromMap<T> fromMap;

  SqliteLocalDataSource({
    required this.tableName,
    required this.databaseProvider,
    required this.toMap,
    required this.fromMap,
  });

  @override
  Future<void> save(T item) async {
    final db = await databaseProvider();
    await db.insert(
      tableName,
      toMap(item),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> saveAll(List<T> items) async {
    final db = await databaseProvider();
    // do single transaction for performance & consistency
    await db.transaction((txn) async {
      final batch = txn.batch();
      for (final item in items) {
        batch.insert(
          tableName,
          toMap(item),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    });
  }

  @override
  Future<List<T>> getAll() async {
    final db = await databaseProvider();
    final result = await db.query(tableName);
    return result.map((r) => fromMap(r)).toList();
  }

  @override
  Future<T?> getById(String id) async {
    final db = await databaseProvider();
    final rows = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (rows.isEmpty) return null;
    return fromMap(rows.first);
  }

  @override
  Future<void> delete(String id) async {
    final db = await databaseProvider();
    await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}
