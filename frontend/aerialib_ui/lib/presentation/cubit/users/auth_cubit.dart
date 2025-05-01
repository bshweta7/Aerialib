import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/domain/repositories/user_repository.dart';
import 'package:frontend/domain/entities/user_entity.dart';
import 'package:equatable/equatable.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final UserRepository _userRepository;

  AuthCubit(this._userRepository) : super(const AuthInitial());

  void getUserData() async {
    try {
      emit(const AuthLoading());
      final userEntity = await _userRepository.getUser();

      if (userEntity != null) {
        emit(AuthLoggedIn(userEntity));
      } else {
        emit(const AuthInitial());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      emit(const AuthLoading());
      final userEntity = await _userRepository.signUp(
        username: username,
        email: email,
        password: password,
      );
      emit(AuthLoggedIn(userEntity));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void login({
    required String username,
    required String password,
  }) async {
    try {
      emit(const AuthLoading());
      final userEntity = await _userRepository.login(
        username: username,
        password: password,
      );
      emit(AuthLoggedIn(userEntity));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// Logout Function
  void logout() async {
    try {
      emit(const AuthLoading());
      await _userRepository.clearUser();
      emit(const AuthLoggedOut());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void reInitialize() {
    emit(const AuthInitial());
  }
}