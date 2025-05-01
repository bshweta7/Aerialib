import 'dart:convert';

import 'package:frontend/data/services/sp_service.dart';
import 'package:frontend/data/models/user_model.dart';
import 'package:frontend/data/services/http_service.dart';

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
      print("Login Error Response Body: ${response.body}");
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

    if (tokenIsValidResponse.statusCode != 200 || jsonDecode(tokenIsValidResponse.body) == false) {
      return null;
    }

    final userResponse = await httpService.get(
      path: '/auth',
      token: token,
    );

    if (userResponse.statusCode != 200) {
      throw jsonDecode(userResponse.body)['error'];
    }
    return UserModel.fromJson(userResponse.body);
  }
}