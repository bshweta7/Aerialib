import 'dart:convert';
import 'dart:developer';

import 'package:frontend/features/user/data/models/user_model.dart';
import 'package:frontend/core/services/sp_service.dart';
import 'package:frontend/core/services/http_service.dart';

class UserRemoteDataSource {
  final HttpService httpService;
  final spService = SpService(); // Keep spService for token retrieval

  UserRemoteDataSource({required this.httpService});

  /// Create new user
  Future<UserModel> signUp({
    required String username,
    required String email,
    required String password
  }) async {

    final body = {
      'username': username,
      'email': email,
      'password': password,
    };

    final response = await httpService.postInit(
      path: '/auth/signup',
      body: body,
    );

    if (response.statusCode != 201) {
      throw jsonDecode(response.body)['error'];
    }

    return UserModel.fromJson(response.body);
  }

  /// Check if username and email are taken
  Future<Map<String, bool>> checkTaken({
    required String username,
    required String email,
  }) async {

    final body = {
      'username': username,
      'email': email,
    };

    final response = await httpService.postInit(
      path: '/auth/check',
      body: body,
    );

    if (response.statusCode != 201) {
      throw jsonDecode(response.body)['error'];
    }

    log(response.body);

    final decoded = jsonDecode(response.body);
    return {
      'email': decoded['email'] as bool,
      'username': decoded['username'] as bool,
    };
  }


  /// Login user
  // TODO : add last logged in time
  Future<UserModel> login({
    required String username,
    required String password,
  }) async {
    final body = {
      'username': username,
      'password': password,
    };

    final response = await httpService.postInit(
      path: '/auth/login',
      body: body,
    );

    if (response.statusCode != 200) {
      log("Login Error Response Body: ${response.body}");
      throw jsonDecode(response.body)['error'];
    }

    return UserModel.fromJson(response.body);
  }

  /// Get user's data
  Future<UserModel?> getUserData() async {
    final token = await spService.getToken();
    if (token == null) {
      return null;
    }

    final tokenIsValidResponse = await httpService.post(
      path: '/auth/tokenIsValid',
      token: token,
      body: '',
    );

    if (tokenIsValidResponse.statusCode != 200 ||
        jsonDecode(tokenIsValidResponse.body) == false) {
      return null;
    }

    final userResponse = await httpService.get(
      path: '/auth',
      token: token,
    );

    final contentType = userResponse.headers['content-type'];
    if (userResponse.statusCode != 200 ||
        contentType?.contains("application/json") != true) {
      log("[UserRemoteDataSource] Unexpected response (not JSON): ${userResponse.body}");
      return null;
    }

    try {
      return UserModel.fromJson(userResponse.body);
    } catch (e, st) {
      log("[UserRemoteDataSource] Failed to parse user: $e");
      log("[UserRemoteDataSource] Stack: $st");
      return null;
    }
  }

  Future<bool> tokenIsValid(String token) async {
    final tokenIsValidResponse = await httpService.post(
      path: '/auth/tokenIsValid',
      token: token,
      body: '',
    );

    return tokenIsValidResponse.statusCode == 200 && tokenIsValidResponse.body == 'true';
  }

  Future<String?> resetPassword({required String token, required String newPassword}) async {
    final res = await httpService.post(
      path: '/auth/reset-password',
      token: token,
      body: jsonEncode({'token': token, 'newPassword': newPassword}),
    );

    if (res.statusCode == 200) return null;
    return jsonDecode(res.body)['error'] ?? 'Something went wrong';
  }

}