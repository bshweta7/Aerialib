import 'dart:convert';

class UserModel {
  final String id;
  final String username;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? bio;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String token;

  const UserModel({
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

  UserModel copyWith({
    String? id,
    String? username,
    String? email,
    String? firstName,
    String? lastName,
    String? bio,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastLogin,
    String? token,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      bio: bio ?? this.bio,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      token: token ?? this.token,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'bio': bio,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'token': token,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
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

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(id: $id, username: $username, email: $email, firstName: $firstName, lastName: $lastName, bio: $bio, createdAt: $createdAt, updatedAt: $updatedAt, token: $token)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.username == username &&
        other.email == email &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.bio == bio &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.token == token;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    username.hashCode ^
    email.hashCode ^
    firstName.hashCode ^
    lastName.hashCode ^
    bio.hashCode ^
    createdAt.hashCode ^
    updatedAt.hashCode ^
    token.hashCode;
  }
}