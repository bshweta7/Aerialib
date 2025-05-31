part of "auth_cubit.dart";

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

// final class AuthSignUp extends AuthState {
//   const AuthSignUp();
// }

final class AuthLoggedIn extends AuthState {
  final UserEntity user;
  const AuthLoggedIn(this.user);

  String get token => user.token;

  @override
  List<Object?> get props => [user]; // Include user in props for equality
}

final class AuthError extends AuthState {
  final String error;
  const AuthError(this.error);

  @override
  List<Object?> get props => [error]; // Include error in props for equality
}

final class AuthErrorShow extends AuthState {
  const AuthErrorShow();
}

final class AuthLoggedOut extends AuthState {
  const AuthLoggedOut();
}
