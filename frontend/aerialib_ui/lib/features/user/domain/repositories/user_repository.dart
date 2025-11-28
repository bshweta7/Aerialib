import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/features/user/data/auth_methods.dart';
import 'package:frontend/features/user/domain/entities/user_entity.dart';
// import 'package:frontend/features/user/data/datasources/user_local_data.dart';
import 'package:frontend/features/user/data/datasources/user_remote_data.dart';

class UserRepository {
  // final UserLocalDataSource localDataSource;
  final UserRemoteDataSource remoteDataSource;
  final AuthMethods authMethods;
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  UserRepository({
    // required this.localDataSource,
    required this.remoteDataSource,
    required this.authMethods,
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _auth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance; // TODO see if this should be moved to main.dart


  /// Sign up user with email and password in Firebase
  Future<UserEntity> signUp({
    required String username,
    required String email,
    required String password,
  }) async {

    // Create user in firebase with AuthMethods
    final userEntity = await authMethods.signUpUser(
      username: username,
      email: email,
      password: password,
    );

    // TODO Add to local db
    // await localDataSource.insertUser(userEntity);

    return userEntity;
  }

  /// Logs in an existing user given email and password
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    final user = await authMethods.loginUser(
      email: email,
      password: password,
    );

    // TODO cache locally
    // await localDataSource.insertUser(user);

    return user;
  }

  /// Retrieves the currently logged-in user's data. Tries the local data source first, then falls back to the remote.
  /// If [allowRemoteFallback] is false, will not attempt a remote fetch.
  Future<UserEntity?> getUser({bool allowRemoteFallback = true}) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        log('[UserRepository] getUser: no Firebase currentUser');
        return null;
      }

      final uid = currentUser.uid;

      // TODO try local cache first later
      // if (localDataSource != null) {
      //   final localUser = await localDataSource.getUser(uid);
      //   if (localUser != null) {
      //     log('[UserRepository] getUser: returning local cached user');
      //     return localUser;
      //   }
      // }

      if (!allowRemoteFallback) {
        return null;
      }

      final doc =
      await _firestore.collection('users').doc(uid).get();

      if (!doc.exists) {
        log('[UserRepository] getUser: Firestore user doc not found for $uid');
        return null;
      }

      final data = doc.data() as Map<String, dynamic>;

      final user = UserEntity.fromMap({
        ...data,
        'uid': uid,
        'token': '', // legacy field; not stored in Firestore
      });

      // TODO refresh cache later
      // await localDataSource.insertUser(user);

      return user;
    } catch (e, st) {
      log('[UserRepository] getUser error: $e', stackTrace: st);
      return null;
    }
  }

  // TODO below this line ------------------------------------------------------

  /// Checks if the username and email are taken
  Future<Map<String, bool>> checkTaken({
    required String username,
    required String email,
  }) async {
    // TODO get existing users, check emails and usernames HERE before sending to backend
    return {
      'email': false, // TODO change validation from here and use firebase built in instead
      'username': false,
    };
  }

  bool tokenIsValid(String token) => true;
}