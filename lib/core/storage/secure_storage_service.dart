import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(
                encryptedSharedPreferences: true,
              ),
              iOptions: IOSOptions(
                accessibility: KeychainAccessibility.first_unlock,
              ),
            );

  static const String _keyToken = 'orange_trip_jwt_token';
  static const String _keyUser = 'orange_trip_user_data';
  static const String _keyBiometrics = 'orange_trip_biometrics_enabled';
  static const String _keyLanguage = 'orange_trip_selected_language';
  static const String _keyCustomApiUrl = 'orange_trip_custom_api_url';

  // JWT Token
  Future<void> saveToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _keyToken);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _keyToken);
  }

  // Cached User Data
  Future<void> saveUserData(Map<String, dynamic> userMap) async {
    await _storage.write(key: _keyUser, value: jsonEncode(userMap));
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final data = await _storage.read(key: _keyUser);
    if (data == null) return null;
    try {
      return jsonDecode(data) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  Future<void> deleteUserData() async {
    await _storage.delete(key: _keyUser);
  }

  // Biometrics
  Future<void> setBiometricsEnabled(bool enabled) async {
    await _storage.write(key: _keyBiometrics, value: enabled.toString());
  }

  Future<bool> isBiometricsEnabled() async {
    final value = await _storage.read(key: _keyBiometrics);
    return value == 'true';
  }

  // Language ('en' or 'ar')
  Future<void> setLanguage(String lang) async {
    await _storage.write(key: _keyLanguage, value: lang);
  }

  Future<String> getLanguage() async {
    return await _storage.read(key: _keyLanguage) ?? 'en';
  }

  // Custom Base URL (if user configures a live remote server)
  Future<void> setCustomBaseUrl(String url) async {
    await _storage.write(key: _keyCustomApiUrl, value: url);
  }

  Future<String?> getCustomBaseUrl() async {
    return await _storage.read(key: _keyCustomApiUrl);
  }

  // Clear Session
  Future<void> clearSession() async {
    await deleteToken();
    await deleteUserData();
  }
}
