import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/services/sp_service.dart';
import 'package:frontend/data/datasources/user/user_remote_data.dart';
import 'package:frontend/data/datasources/user/user_local_data.dart';
import 'package:frontend/data/models/user_model.dart';

import '../../../data/services/http_service.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  final userRemoteDataSource = UserRemoteDataSource(httpService: HttpService());
  final userLocalRepository = UserLocalDataSource();
  final spService = SpService();

  void getUserData() async {
    try {
      emit(AuthLoading());
      final userModel = await userRemoteDataSource.getUserData();

      if (userModel != null) {
        await userLocalRepository.insertUser(userModel);
        emit(AuthLoggedIn(userModel));
      } else {
        emit(AuthInitial());
      }

    } catch (e) {
      emit(AuthInitial());
    }
  }

  void signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      emit(AuthLoading());
      await userRemoteDataSource.signUp(
          name: name,
          email: email,
          password: password
      );

      emit(AuthSignUp());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void login({
    required String email,
    required String password,
  }) async {
    try {
      emit(AuthLoading());
      final userModel = await userRemoteDataSource.login(
          email: email,
          password: password
      );

      if(userModel.token.isNotEmpty) {
        await spService.setToken(userModel.token);
      }

      await userLocalRepository.insertUser(userModel);

      emit(AuthLoggedIn(userModel));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  // Logout Function
  void logout() async {
    try {
      emit(AuthLoading());
      // Clear local data (token, user data)
      await spService.removeToken();
      await userLocalRepository.clearUser();

      // emit(AuthLoggedOut());
      emit(AuthInitial());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void reInitialize() {
    emit(AuthInitial());
  }
}
