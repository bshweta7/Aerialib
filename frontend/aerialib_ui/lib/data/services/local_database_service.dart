import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

import 'package:frontend/data/schema/database_schema.dart';

class DatabaseService {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;

    // Initialize if not yet opened
    _db = await _initDb();
    return _db!;
  }

  static Future<Database> _initDb() async {
    if (kIsWeb || Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'aerialib.db'); // New shared database file

    return await openDatabase(
      path,
      version: 2, // (Increment carefully if you add new tables later)
      onCreate: (db, version) async {
        await db.execute(createPoseTable);
        await db.execute(createFlowTable);
        await db.execute(createFlowPoseTable);
        await db.execute(createMediaTable);
        await db.execute(createUserTable);

      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // Poses
        await db.execute(dropPoseTable); // Use drop command from schema
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

      },
    );
  }
}


// Future<Database> _initDb() async {
//   DatabaseFactory? factory;
//
//   final dbPath = await getDatabasesPath();
//   String path = join(dbPath, "poses.db");
//
//   if (kIsWeb || Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
//     // Initialize sqflite_common_ffi on desktop and web
//     sqfliteFfiInit();
//     factory = databaseFactoryFfi;
//   } else {
//     factory = databaseFactory; // Use the default factory for mobile
//   }
//
//   return openDatabase(
//     path,
//     version: 6,
//     onUpgrade: (db, oldVersion, newVersion) async {
//       if (oldVersion < newVersion) {
//         await db.execute(dropPoseTable); // Use drop command from schema
//         await db.execute(createPoseTable); // Use create command from schema
//       }
//     },
//     onCreate: (db, version) async {
//       return db.execute(createPoseTable); // Use create command from schema
//     },
//   );
// }