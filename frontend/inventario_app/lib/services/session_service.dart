import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const _tokenKey = 'access_token';
  static const _userNameKey = 'user_nombre';
  static const _userEmailKey = 'user_email';
  static const _userIdKey = 'user_id';

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  /// Guarda el access_token de forma segura usando flutter_secure_storage
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
  }

  /// Lee el access_token almacenado de forma segura
  Future<String?> getToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }

  /// Elimina el access_token almacenado
  Future<void> deleteToken() async {
    await _secureStorage.delete(key: _tokenKey);
  }

  /// Verifica si existe un token almacenado (para indicadores en UI)
  Future<bool> hasToken() async {
    final token = await _secureStorage.read(key: _tokenKey);
    return token != null && token.isNotEmpty;
  }

  /// Guarda la información no sensible del usuario en SharedPreferences
  Future<void> saveUserInfo({
    required int id,
    required String nombre,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_userIdKey, id);
    await prefs.setString(_userNameKey, nombre);
    await prefs.setString(_userEmailKey, email);
  }

  /// Obtiene los datos del usuario guardados en SharedPreferences
  Future<Map<String, dynamic>?> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt(_userIdKey);
    final nombre = prefs.getString(_userNameKey);
    final email = prefs.getString(_userEmailKey);
    if (id == null || nombre == null || email == null) return null;
    return {
      'id': id,
      'nombre': nombre,
      'email': email,
    };
  }

  /// Limpia tanto el almacenamiento seguro como las SharedPreferences
  Future<void> clearSession() async {
    await _secureStorage.delete(key: _tokenKey);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
    await prefs.remove(_userNameKey);
    await prefs.remove(_userEmailKey);
  }
}
