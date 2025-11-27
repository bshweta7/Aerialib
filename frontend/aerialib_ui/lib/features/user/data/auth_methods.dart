import 'dart:developer';

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

  /// Sign up a new user with Firebase Auth + Firestore.
  ///
  /// Returns the created UserEntity on success, throws on failure.
  Future<UserEntity> signUpUser({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      log('[AuthMethods] signUpUser called for $email');

      // 1. Create auth user in FirebaseAuth
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = cred.user!.uid;
      final now = DateTime.now();

      // 2. Build your UserEntity
      final user = UserEntity(
        uid: uid,
        username: username,
        email: email,
        firstName: null,
        lastName: null,
        bio: null,
        createdAt: now,
        updatedAt: now,
        token: '', // legacy field, not used for Firebase
      );

      // 3. Save to Firestore in 'users/{uid}'
      await _firestore
          .collection('users')
          .doc(uid)
          .set(user.toMap());

      log('[AuthMethods] signUpUser success, uid: $uid');

      return user;
    } on FirebaseAuthException catch (e, st) {
      log('[AuthMethods] FirebaseAuthException in signUpUser: ${e.code} $e',
          stackTrace: st);

      throw Exception(_mapAuthErrorToMessage(e));
    } catch (e, st) {
      log('[AuthMethods] Unknown error in signUpUser: $e', stackTrace: st);
      throw Exception('Failed to sign up: $e');
    }
  }

  String _mapAuthErrorToMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'weak-password':
        return 'The password is too weak.';
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      default:
        return e.message ?? 'Authentication error: ${e.code}';
    }
  }
}
