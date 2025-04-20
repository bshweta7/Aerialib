import 'dart:convert';

import 'package:frontend/data/services/sp_service.dart';
import 'package:frontend/data/datasources/user/user_local_data.dart';
import 'package:frontend/data/models/user_model.dart';
import 'package:http/http.dart' as http;

import 'package:frontend/core/constants/constants.dart';

class AuthRemoteRepository {
  final spService = SpService();
  final authLocalRepository = UserLocalDataSource();

  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password
  }) async {
    try{
      final res = await http.post(
        Uri.parse(
          '${Constants.backendUri}/user/signup',
        ),
        headers: {
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      if(res.statusCode != 201) {
        throw jsonDecode(res.body)['error'];
      }

      return UserModel.fromJson(res.body);

    } catch(e) {
      throw e.toString();
    };

  }

  Future<UserModel> login({
    required String email,
    required String password
  }) async {
    try{
      final res = await http.post(
        Uri.parse(
          '${Constants.backendUri}/user/login',
        ),
        headers: {
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if(res.statusCode != 200) {
        throw jsonDecode(res.body)['error'];
      }

      return UserModel.fromJson(res.body);

    } catch(e) {
      throw e.toString();
    }
  }

  Future<UserModel?> getUserData() async {
    try{
      final token = await spService.getToken();
      if (token == null) {
        return null;
      }

      final res = await http.post(
        Uri.parse(
          '${Constants.backendUri}/user/tokenIsValid',
        ),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
      );

      if(res.statusCode != 200 || jsonDecode(res.body)==false) {
        return null;
      }

      final userResponse = await http.get(
        Uri.parse(
          '${Constants.backendUri}/user',
        ),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
      );

      if(userResponse.statusCode != 200) {
        throw jsonDecode(userResponse.body)['error'];
      }
      return UserModel.fromJson(userResponse.body);
    } catch(e) {
      final user = await authLocalRepository.getUser();
      return user;
    }
  }

}