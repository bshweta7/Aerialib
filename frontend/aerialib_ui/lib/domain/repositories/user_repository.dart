import 'package:frontend/data/datasources/user/user_local_data.dart';
import 'package:frontend/data/datasources/user/user_remote_data.dart';
import 'package:frontend/data/models/user_model.dart';
import 'package:frontend/domain/entities/user_entity.dart';

class UserRepository {
  final UserLocalDataSource localDataSource;
  final UserRemoteDataSource remoteDataSource;

  UserRepository({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  /// Converts a UserModel to a UserEntity.
  UserEntity _userModelToEntity(UserModel userModel) {
    return UserEntity(
      id: userModel.id,
      username: userModel.username,
      email: userModel.email,
      firstName: userModel.firstName,
      lastName: userModel.lastName,
      bio: userModel.bio,
      createdAt: userModel.createdAt,
      updatedAt: userModel.updatedAt,
      lastLogin: userModel.lastLogin,
      token: userModel.token,
    );
  }

  /// Converts a UserEntity to a UserModel.
  UserModel _userEntityToModel(UserEntity userEntity) {
    return UserModel(
      id: userEntity.id,
      username: userEntity.username,
      email: userEntity.email,
      firstName: userEntity.firstName,
      lastName: userEntity.lastName,
      bio: userEntity.bio,
      createdAt: userEntity.createdAt,
      updatedAt: userEntity.updatedAt,
      lastLogin: userEntity.lastLogin,
      token: userEntity.token,
    );
  }

  /// Signs up a new user via the remote data source and saves the user locally upon success.
  Future<UserEntity> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    final userModel = await remoteDataSource.signUp(
      username: username,
      email: email,
      password: password,
    );
    await localDataSource.insertUser(userModel);
    return _userModelToEntity(userModel);
  }

  /// Logs in an existing user via the remote data source and saves the user locally upon success.
  Future<UserEntity> login({
    required String username,
    required String password,
  }) async {
    final userModel = await remoteDataSource.login(
      username: username,
      password: password,
    );
    await localDataSource.insertUser(userModel);
    return _userModelToEntity(userModel);
  }

  /// Retrieves the currently logged-in user's data. Tries the local data source first, then falls back to the remote.
  Future<UserEntity?> getUser() async {
    print("[UserRepository] Getting user from local...");
    final localUser = await localDataSource.getUser();
    // print("[UserRepository] Done, ${localUser}");

    if (localUser != null) {
      return _userModelToEntity(localUser);
    }
    final remoteUser = await remoteDataSource.getUserData();
    if (remoteUser != null) {
      await localDataSource.insertUser(remoteUser);
      return _userModelToEntity(remoteUser);
    }
    return null;
  }

  /// Clears the locally stored user data.
  Future<void> clearUser() async {
    await localDataSource.clearUser();
  }
}