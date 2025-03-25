import 'package:shared_preferences/shared_preferences.dart';

// TODO understand this portion more
/// Shared Preferences Service
class SpService {
  /// Set the token
  Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('x-auth-token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('x-auth-token');
  }

}