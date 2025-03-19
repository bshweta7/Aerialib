import 'package:frontend/models/media_model.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:flutter/foundation.dart';
import 'dart:io';

class MediaLocalRepository {
  String tableName = "media";

  Database? _database;

  Future<Database> get database async {
    if(_database!=null) {
      return _database!;
    }

    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {

    // Initialize sqflite_common_ffi on desktop and web
    if (kIsWeb || Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "media.db");

    return openDatabase(
      path,
      version: 1,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < newVersion) {
          await db.execute(
            'DROP TABLE $tableName',
          );
          db.execute('''
            CREATE TABLE $tableName(
              id TEXT PRIMARY KEY,
              mediaURL TEXT NOT NULL,
              name TEXT,
              description TEXT,
              apparatus TEXT,
              uploadedBy TEXT NOT NULL,
              uploadedAt TEXT NOT NULL,
              isSynced INTEGER NOT NULL
            )'''
          );
        }
      },
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE $tableName(
            id TEXT PRIMARY KEY,
            mediaURL TEXT NOT NULL,
            name TEXT,
            description TEXT,
            apparatus TEXT,
            uploadedBy TEXT NOT NULL,
            uploadedAt TEXT NOT NULL,
            isSynced INTEGER NOT NULL
          )'''
        );
      },
    );
  }

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