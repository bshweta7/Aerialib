class UserEntity {
  final String uid;
  final String username;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? bio;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String token;

  const UserEntity({
    required this.uid,
    required this.username,
    required this.email,
    this.firstName,
    this.lastName,
    this.bio,
    required this.createdAt,
    required this.updatedAt,
    required this.token,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'username': username,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'bio': bio,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory UserEntity.fromMap(Map<String, dynamic> map) {
    return UserEntity(
      uid: map['uid'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      firstName: map['first_name'],
      lastName: map['last_name'],
      bio: map['bio'],
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : DateTime.now(),
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : DateTime.now(),
      token: map['token'] ?? '',
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is UserEntity &&
              runtimeType == other.runtimeType &&
              uid == other.uid &&
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
      uid.hashCode ^
      username.hashCode ^
      email.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      bio.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      token.hashCode;
}