import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/services/sp_service.dart';
import 'package:frontend/to_sort/repositories/auth_remote_repository.dart';
import 'package:frontend/to_sort/repositories/auth_local_repository.dart';
import 'package:frontend/data/models/user_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  final authRemoteRepository = AuthRemoteRepository();
  final authLocalRepository = AuthLocalRepository();
  final spService = SpService();

  void getUserData() async {
    try {
      emit(AuthLoading());
      final userModel = await authRemoteRepository.getUserData();

      if (userModel != null) {
        await authLocalRepository.insertUser(userModel);
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
      await authRemoteRepository.signUp(
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
      final userModel = await authRemoteRepository.login(
          email: email,
          password: password
      );

      if(userModel.token.isNotEmpty) {
        await spService.setToken(userModel.token);
      }

      await authLocalRepository.insertUser(userModel);

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
      await authLocalRepository.clearUser();

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
