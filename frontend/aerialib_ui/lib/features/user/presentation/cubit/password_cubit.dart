import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/repositories/user_repository.dart';

part 'password_state.dart';

class PasswordCubit extends Cubit<PasswordState> {
  final UserRepository _userRepository;

  PasswordCubit(this._userRepository) : super(PasswordInitial());

  Future<void> sendForgotPasswordEmail(String email) async {
    emit(PasswordLoading());
    final error = await _userRepository.sendForgotPasswordEmail(email);
    if (error == null) {
      emit(PasswordResetSuccess());
    } else {
      emit(PasswordError(error));
    }
  }

  Future<void> checkToken(String token) async {
    emit(PasswordLoading());
    final valid = await _userRepository.tokenIsValid(token);
    if (valid) {
      emit(PasswordTokenValid());
    } else {
      emit(const PasswordError("Invalid or expired reset link."));
    }
  }

  Future<void> resetPassword(String token, String newPassword) async {
    emit(PasswordLoading());
    final error = await _userRepository.resetPassword(token, newPassword);
    if (error == null) {
      emit(PasswordResetSuccess());
    } else {
      emit(PasswordError(error));
    }
  }
}
