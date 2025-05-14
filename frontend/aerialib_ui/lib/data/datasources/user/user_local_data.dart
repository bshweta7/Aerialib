import 'package:frontend/data/models/user_model.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../../services/local_database_service.dart';


class UserLocalDataSource {
  String tableName = 'users';

  Future<Database> get database async => DatabaseService.database;

  /// Inserts a new user into the local database, replacing if a user with the same ID already exists.
  Future<void> insertUser(UserModel userModel) async {
    final db = await database;
    await db.insert(
      tableName,
      userModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Retrieves the currently logged-in user from the local database (if any). Returns null if no user is found.
  Future<UserModel?> getUser() async {
    print('[UserLocalData] Checking for local database existence...');
    final db = await DatabaseService.database;

    try {
      final result = await db.query(tableName);
      print('[UserLocalData] User found, username: ${result.first["username"]}');

      if (result.isEmpty) {
        print('[UserLocalData] No user found in local DB');
        return null;
      }

      return UserModel.fromMap(result.first); // Replace with your real logic
    } catch (e, st) {
      print('[UserLocalData] Error getting user: $e, $st');
      return null;
    }
  }


  /// Clears all user data from the local database.
  // TODO instead of clearing it altogether, it could be like facebook (login as Shweta - not you? click here) OR show multiple user icons for studios that have multiple instructors
  Future<void> clearUser() async {
    final db = await database;
    await db.delete(tableName); // Delete all rows from the users table.
  }
}