import 'dart:developer';
import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:flutter/foundation.dart';
import 'package:frontend/data/schema/database_schema.dart';


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

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
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
                log('[DatabaseService] Creating pose table...');
                await db.execute(createPoseTable);

                log('[DatabaseService] Creating flow table...');
                await db.execute(createFlowTable);

                log('[DatabaseService] Creating flow_pose table...');
                await db.execute(createFlowPoseTable);

                log('[DatabaseService] Creating media table...');
                await db.execute(createMediaTable);

                log('[DatabaseService] Creating music table...');
                await db.execute(createMusicTable);

                log('[DatabaseService] Creating user table...');
                await db.execute(createUserTable);

                log('[DatabaseService] All tables created successfully');
              } catch (e, st) {
                log('[DatabaseService] ERROR in onCreate: $e, $st');
                // log(st);
                rethrow;
              }
            },
            onUpgrade: (db, oldVersion, newVersion) async {
              // Poses
              log('[DatabaseService] Dropping Pose table...');

              await db.execute(dropPoseTable); // Use drop command from schema
              log('[DatabaseService] Creating Pose table...');
              await db.execute(createPoseTable); // Use create command from schema

              // Flows
              await db.execute(dropFlowTable);
              await db.execute(createFlowTable);

              // Flow Poses
              await db.execute(dropFlowPoseTable); // Use drop command from schema
              await db.execute(createFlowPoseTable); // Use create command from schema

              // Media
              await db.execute(dropMediaTable); // Use drop command from schema
              await db.execute(createMediaTable); // Use create command from schema

              // Users
              await db.execute(dropUserTable); // Use drop command from schema
              await db.execute(createUserTable); // Use create command from schema

              // Music
              await db.execute(dropMusicTable);
              await db.execute(createMusicTable);

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

  /// Clears the entire local database by deleting the file and resetting the instance
  static Future<void> clearLocalDatabase() async {
    final path = kIsWeb ? 'aerialib_web.db' : join(await getDatabasesPath(), _getDatabaseFileName());
    try {
      await databaseFactory.deleteDatabase(path);
      _db = null;
      log('[DatabaseService] Local database deleted successfully');
    } catch (e, st) {
      log('[DatabaseService] Failed to delete local database: $e, $st');
    }
  }
}
