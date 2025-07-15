class UserEntity {
  final String id;
  final String username;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? bio;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String token;

  const UserEntity({
    required this.id,
    required this.username,
    required this.email,
    this.firstName,
    this.lastName,
    this.bio,
    required this.createdAt,
    required this.updatedAt,
    required this.token,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is UserEntity &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              username == other.username &&
              email == other.email &&
              firstName == other.firstName &&
              lastName == other.lastName &&
              bio == other.bio &&
              createdAt == other.createdAt &&
              updatedAt == other.updatedAt &&
              token == other.token;

  @override
  int get hashCode =>
      id.hashCode ^
      username.hashCode ^
      email.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      bio.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      token.hashCode;
}