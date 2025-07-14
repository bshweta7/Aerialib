import 'dart:developer';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:flutter/foundation.dart';
import 'package:frontend/core/schema/database_schema.dart';
import 'package:synchronized/synchronized.dart';


String _getDatabaseFileName() {
  if (kIsWeb) return 'aerialib_web.db';

  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
    case TargetPlatform.iOS:
      return 'aerialib.db';
    case TargetPlatform.macOS:
      return 'aerialib_macos.db';
    case TargetPlatform.linux:
      return 'aerialib_linux.db';
    case TargetPlatform.windows:
      return 'aerialib_windows.db';
    default:
      return 'aerialib.db'; // Fallback
  }
}

class DatabaseService {
  static Database? _db;

  static final _lock = Lock();

  static Future<Database> get database async {
    return await _lock.synchronized(() async {
      if (_db != null) return _db!;
      _db = await _initDb();
      return _db!;
    });
  }

  static Future<Database> _initDb() async {
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    } else {
      switch (defaultTargetPlatform) {
        case TargetPlatform.macOS:
        case TargetPlatform.linux:
        case TargetPlatform.windows:
          sqfliteFfiInit();
          databaseFactory = databaseFactoryFfi;
          break;
        default:
          break;
      }
    }


    final path = kIsWeb ? 'aerialib_web.db' : join(await getDatabasesPath(), _getDatabaseFileName());
    log('[DatabaseService] Opening DB at path: $path');

    try {
      final db = await databaseFactory.openDatabase(
        path,
        options: OpenDatabaseOptions(
          version: 3,
            onCreate: (db, version) async {
              log('[DatabaseService] onCreate started');

              try {
                log('[DatabaseService] Creating user table...');
                await db.execute(createUserTable);

                log('[DatabaseService] Creating media table...');
                await db.execute(createMediaTable);

                log('[DatabaseService] Creating pose table...');
                await db.execute(createPoseTable);

                log('[DatabaseService] Creating transition table...');
                await db.execute(createTransitionTable);



                log('[DatabaseService] Creating flow table...');
                await db.execute(createFlowTable);

                log('[DatabaseService] Creating flow_pose table...');
                await db.execute(createFlowPoseTable);

                log('[DatabaseService] Creating music table...');
                await db.execute(createMusicTable);


                // log('[DatabaseService] Creating tag table...');
                // await db.execute(createTagsTable);
                //
                // log('[DatabaseService] Creating pose_tag table...');
                // await db.execute(createPoseTagsTable);
                //
                // log('[DatabaseService] Creating flow_tag table...');
                // await db.execute(createFlowTagsTable);

                log('[DatabaseService] All tables created successfully');
              } catch (e, st) {
                log('[DatabaseService] ERROR in onCreate: $e, $st');
                // log(st);
                rethrow;
              }
            },
            onUpgrade: (db, oldVersion, newVersion) async {
              // Users
              await db.execute(dropUserTable); // Use drop command from schema
              await db.execute(createUserTable); // Use create command from schema

              // Media
              await db.execute(dropMediaTable); // Use drop command from schema
              await db.execute(createMediaTable); // Use create command from schema

              // Poses
              log('[DatabaseService] Dropping Pose table...');
              await db.execute(dropPoseTable); // Use drop command from schema
              log('[DatabaseService] Creating Pose table...');
              await db.execute(createPoseTable); // Use create command from schema

              // Transitions
              log('[DatabaseService] Dropping Transition table...');
              await db.execute(dropTransitionTable); // Use drop command from schema
              log('[DatabaseService] Creating Transition table...');
              await db.execute(createTransitionTable); // Use create command from schema

              // Flows
              await db.execute(dropFlowTable);
              await db.execute(createFlowTable);

              // Flow Poses
              await db.execute(dropFlowPoseTable); // Use drop command from schema
              await db.execute(createFlowPoseTable); // Use create command from schema

              // Music
              await db.execute(dropMusicTable);
              await db.execute(createMusicTable);

              // // Tags
              // await db.execute(dropTagsTable);
              // await db.execute(createTagsTable);
              //
              // // Pose Tags
              // await db.execute(dropPoseTagsTable);
              // await db.execute(createPoseTagsTable);
              //
              // // Flow Tags
              // await db.execute(dropFlowTagsTable);
              // await db.execute(createFlowTagsTable);

              log('[DatabaseService] Upgrade complete.');

          },
        ),
      ).timeout(const Duration(seconds: 15));

      log('[DatabaseService] DB opened successfully');
      return db;
    } catch (e, st) {
      log('[DatabaseService] Failed to open DB: $e, $st');
      rethrow;
    }
  }

  /// Clears the entire local database by dropping all tables
  static Future<void> clearTables() async {
    final db = await database;

    // Helper to check if a table exists
    Future<bool> tableExists(String tableName) async {
      final result = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
        [tableName],
      );
      return result.isNotEmpty;
    }

    final tables = [
      'users', // TODO may not need to remove this one...
      'media',
      'poses',
      'transitions',
      'flows',
      'flow_poses',
      'music',
      // Add tags later
    ];

    for (final table in tables) {
      final exists = await tableExists(table);
      if (exists) {
        await db.delete(table);
        log('[DatabaseService] Cleared table: $table');
      } else {
        log('[DatabaseService] Skipped clearing $table (does not exist)');
      }
    }
  }
  //   final path = kIsWeb ? 'aerialib_web.db' : join(await getDatabasesPath(), _getDatabaseFileName());
  //   try {
  //     await databaseFactory.deleteDatabase(path);
  //     _db = null;
  //     log('[DatabaseService] Local database deleted successfully');
  //   } catch (e, st) {
  //     log('[DatabaseService] Failed to delete local database: $e, $st');
  //   }
  // }
}
