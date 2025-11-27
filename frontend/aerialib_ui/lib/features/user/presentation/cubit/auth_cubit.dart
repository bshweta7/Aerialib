import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:frontend/features/user/domain/repositories/user_repository.dart';
import 'package:frontend/features/user/domain/entities/user_entity.dart';

import '../../../../core/services/local_database_service.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final UserRepository _userRepository;

  AuthCubit(this._userRepository) : super(const AuthInitial()) {
    getUserData();
  }

  void getUserData() async {
    try {
      emit(const AuthLoading());
      log('[AuthCubit] Getting user data... ');
      final user = await _userRepository.getUser(allowRemoteFallback: true);

      if (user == null) {
        log('[AuthCubit] No user found, logging out');
        emit(const AuthLoggedOut());
      } else {
        log('[AuthCubit] User found, logging in');
        emit(AuthLoggedIn(user));
      }
    } catch (e, st) {
      if (e is FormatException) {
        log('[AuthCubit] FormatException (likely HTML response instead of JSON): $e');
      } else {
        log('[AuthCubit] getUserFromLocal error: $e');
      }
      emit(const AuthLoggedOut());
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
    required String email,
    required String password,
  }) async {
    try {
      emit(const AuthLoading());
      final userEntity = await _userRepository.login(
        email: email,
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
      await DatabaseService.clearTables(); // Clears everything
      // TODO verify if there are any unsynced flows/poses before logging out, store separately or something idk....
      emit(const AuthLoggedOut());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void reInitialize() {
    emit(const AuthInitial());
  }


}