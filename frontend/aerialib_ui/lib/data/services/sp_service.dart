import 'package:shared_preferences/shared_preferences.dart';

/// Shared Preferences Service
/// Description: Handles persistent key-value storage, like user tokens,
///   theme settings, etc.
/// What goes here: Login tokens, "Has seen onboarding" flags, Offline
/// mode flags, Any user/local setting stored via SharedPreferences

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

  /// Remove the token
  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('x-auth-token'); // Important: Await the remove call
  }

}

// TODO optional extras: Future<void> setBool(String key, bool value);
// TODO optional extras: Future<bool?> getBool(String key);