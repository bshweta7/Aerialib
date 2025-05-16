import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:frontend/domain/repositories/user_repository.dart';
import 'package:frontend/domain/entities/user_entity.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final UserRepository _userRepository;

  AuthCubit(this._userRepository) : super(const AuthInitial()) {
    getUserData();
  }

  void getUserData() async {
    try {
      emit(AuthLoading());
      final user = await _userRepository.getUser();

      if (user == null) {
        log('[AuthCubit] No user found, logging out');
        emit(AuthLoggedOut());
      } else {
        log('[AuthCubit] User found, logging in');
        emit(AuthLoggedIn(user));
      }
    } catch (e, st) {
      log('[AuthCubit] getUserFromLocal error: $e, $st');
      emit(AuthLoggedOut());
    }
  }

  Future<Map<String, bool>> checkIfTaken({
    required String username,
    required String email,
  }) async {
    try {
      final result = await _userRepository.checkTaken(
        username: username,
        email: email,
      );

      return result;
    } catch (e) {
      throw Exception("Unable to check availability");
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