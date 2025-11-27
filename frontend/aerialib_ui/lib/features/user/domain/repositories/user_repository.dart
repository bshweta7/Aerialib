import 'dart:developer';

import 'package:frontend/features/user/data/auth_methods.dart';
import 'package:frontend/features/user/domain/entities/user_entity.dart';
import 'package:frontend/features/user/data/datasources/user_local_data.dart';
import 'package:frontend/features/user/data/datasources/user_remote_data.dart';
import 'package:frontend/features/user/data/models/user_model.dart';

class UserRepository {
  final UserLocalDataSource localDataSource;
  final UserRemoteDataSource remoteDataSource;
  final AuthMethods authMethods;

  UserRepository({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.authMethods
  });

  /// Converts a UserModel to a UserEntity.
  UserEntity _userModelToEntity(UserModel userModel) {
    return UserEntity(
      uid: userModel.id,
      username: userModel.username,
      email: userModel.email,
      firstName: userModel.firstName,
      lastName: userModel.lastName,
      bio: userModel.bio,
      createdAt: userModel.createdAt,
      updatedAt: userModel.updatedAt,
      token: userModel.token,
    );
  }

  /// Converts a UserEntity to a UserModel.
  UserModel _userEntityToModel(UserEntity userEntity) {
    return UserModel(
      id: userEntity.uid,
      username: userEntity.username,
      email: userEntity.email,
      firstName: userEntity.firstName,
      lastName: userEntity.lastName,
      bio: userEntity.bio,
      createdAt: userEntity.createdAt,
      updatedAt: userEntity.updatedAt,
      token: userEntity.token,
    );
  }

  /// Sign up user with email and password in Firebase
  Future<UserEntity> signUp({
    required String username,
    required String email,
    required String password,
  }) async {

    // Create user in firebase with AuthMethods
    final userEntity = await authMethods.signUpUser(
      username: username,
      email: email,
      password: password,
    );

    // TODO Add to local db
    // await localDataSource.insertUser(userEntity);

    return userEntity;
  }


  /// Checks if the username and email are taken
  Future<Map<String, bool>> checkTaken({
    required String username,
    required String email,
  }) async {
    // TODO get existing users, check emails and usernames HERE before sending to backend
    final takenStatus = await remoteDataSource.checkTaken(
      username: username,
      email: email,
    );

    return takenStatus;
  }


  /// Logs in an existing user given email and password
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    final user = await authMethods.loginUser(
      email: email,
      password: password,
    );

    // TODO cache locally
    // await localDataSource.insertUser(user);

    return user;
  }

  /// Retrieves the currently logged-in user's data. Tries the local data source first, then falls back to the remote.
  /// If [allowRemoteFallback] is false, will not attempt a remote fetch.
  Future<UserEntity?> getUser({bool allowRemoteFallback = true}) async {
    log("[UserRepository] Getting user from local...");
    final localUser = await localDataSource.getUser();

    if (localUser != null) {
      return _userModelToEntity(localUser);
    }

    if (!allowRemoteFallback) {
      log("[UserRepository] No local user and remote fetch disabled");
      return null;
    }

    try {
      final remoteUser = await remoteDataSource.getUserData();
      if (remoteUser != null) {
        await localDataSource.insertUser(remoteUser);
        return _userModelToEntity(remoteUser);
      }
    } catch (e) {
      log("[UserRepository] Remote user fetch failed: $e");
    }

    return null;
  }

  /// Clears the locally stored user data.
  Future<void> clearUser() async {
    await localDataSource.clearUser();
  }

  Future<bool> tokenIsValid(String token) => remoteDataSource.tokenIsValid(token);

  Future<String?> resetPassword(String token, String newPassword) =>
      remoteDataSource.resetPassword(token: token, newPassword: newPassword);

  Future<String?> sendForgotPasswordEmail(String email) =>
      remoteDataSource.sendForgotPasswordEmail(email: email);

  Future<String?> sendForgotUsernameEmail(String email) =>
      remoteDataSource.sendForgotUsernameEmail(email: email);
}