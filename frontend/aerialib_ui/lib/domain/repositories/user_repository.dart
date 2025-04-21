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
      email: userModel.email,
      name: userModel.name,
      token: userModel.token,
      createdAt: userModel.createdAt,
      updatedAt: userModel.updatedAt,
    );
  }

  /// Converts a UserEntity to a UserModel.
  UserModel _userEntityToModel(UserEntity userEntity) {
    return UserModel(
      id: userEntity.id,
      email: userEntity.email,
      name: userEntity.name,
      token: userEntity.token,
      createdAt: userEntity.createdAt,
      updatedAt: userEntity.updatedAt,
    );
  }

  /// Signs up a new user via the remote data source and saves the user locally upon success.
  Future<UserEntity> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final userModel = await remoteDataSource.signUp(
      name: name,
      email: email,
      password: password,
    );
    await localDataSource.insertUser(userModel);
    return _userModelToEntity(userModel);
  }

  /// Logs in an existing user via the remote data source and saves the user locally upon success.
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    final userModel = await remoteDataSource.login(
      email: email,
      password: password,
    );
    await localDataSource.insertUser(userModel);
    return _userModelToEntity(userModel);
  }

  /// Retrieves the currently logged-in user's data. Tries the local data source first, then falls back to the remote.
  Future<UserEntity?> getUser() async {
    final localUser = await localDataSource.getUser();
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