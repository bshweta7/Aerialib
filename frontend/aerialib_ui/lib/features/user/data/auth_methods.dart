import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/features/user/domain/entities/user_entity.dart';

class AuthMethods {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthMethods({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _auth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Future<UserEntity> signUpUser({
    required String username,
    required String email,
    required String password,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = cred.user!.uid;
    final now = DateTime.now();

    final user = UserEntity(
      uid: uid,
      username: username,
      email: email,
      firstName: null,
      lastName: null,
      bio: null,
      createdAt: now,
      updatedAt: now,
      token: '',
    );

    await _firestore.collection('users').doc(uid).set(user.toMap());

    return user;
  }
}
