import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

import '../schemas/database_schema.dart';
import '../schemas/pose_schema.dart';

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
      version: 1, // (Increment carefully if you add new tables later)
      onCreate: (db, version) async {
        // await db.execute(createUserTable);
        await db.execute(createPoseTable);
        await db.execute(createFlowTable);
        await db.execute(createFlowPoseTable);
        // await db.execute(createMediaTable);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        await db.execute(dropFlowTable);
        await db.execute(createFlowTable);

        await db.execute(dropFlowPoseTable); // Use drop command from schema
        await db.execute(createFlowPoseTable); // Use create command from schema



      },
    );
  }
}
