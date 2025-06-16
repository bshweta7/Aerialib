import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/core/constants/constants.dart';

class HttpService {
  Future<http.Response> get({
    required String path,
    required String token,
  }) async {
    final res = await http.get(
      Uri.parse("${Constants.backendUrl}$path"),
      headers: _headers(token),
    );

    _checkForError(res);
    return res;
  }

  Future<http.Response> post({
    required String path,
    required String token,
    required dynamic body,
  }) async {
    final res = await http.post(
      Uri.parse("${Constants.backendUrl}$path"),
      headers: _headers(token),
      body: jsonEncode(body),
    );

    _checkForError(res);
    return res;
  }

  Future<http.Response> delete({
    required String path,
    required String token,
    dynamic body,
  }) async {
    final headers = _headers(token);
    final uri = Uri.parse("${Constants.backendUrl}$path");

    final res = body == null
        ? await http.delete(uri, headers: headers)
        : await http.delete(uri, headers: headers, body: jsonEncode(body));

    _checkForError(res);
    return res;
  }

  /// Allows for POST requests that don't require a token (e.g. Login and Signup)
  Future<http.Response> postInit({
    required String path,
    required dynamic body,
  }) async {
    final res = await http.post(
      Uri.parse("${Constants.backendUrl}$path"),
      headers:{'Content-Type': 'application/json'}, // base header only (no token)
      body: jsonEncode(body),
    );

    _checkForError(res);
    return res;
  }


  Future<http.Response> put({
    required String path,
    required String token,
    required dynamic body,
  }) async {
    final res = await http.put(
      Uri.parse("${Constants.backendUrl}$path"),
      headers: _headers(token),
      body: jsonEncode(body),
    );

    _checkForError(res);
    return res;
  }

  Map<String, String> _headers(String token) => {
    'Content-Type': 'application/json',
    'x-auth-token': token,
  };

  void _checkForError(http.Response res) {
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw jsonDecode(res.body)['error'] ?? 'Unknown error';
    }
  }
}
