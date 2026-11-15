import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/session_service.dart';
import '../services/api_client.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final SessionService _sessionService = SessionService();

  User? _user;
  bool _isLoading = false;
  bool _isAuthenticated = false;
  String? _error;
  bool _hasToken = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String? get error => _error;
  bool get hasToken => _hasToken;

  AuthProvider() {
    // Vincular cierre de sesión automático ante 401 en endpoints protegidos
    ApiClient.onUnauthorized = () {
      logout();
    };
  }

  /// Intenta restaurar la sesión desde el almacenamiento local
  Future<void> tryRestoreSession() async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await _sessionService.getToken();
      final hasStoredToken = token != null && token.isNotEmpty;

      if (hasStoredToken) {
        // Verificar token con el backend
        final isValid = await _authService.verifyToken();
        if (isValid) {
          final userInfo = await _sessionService.getUserInfo();
          if (userInfo != null) {
            _user = User.fromJson(userInfo);
            _isAuthenticated = true;
            _hasToken = true;
          } else {
            // Intentar cargar perfil desde backend
            final profile = await _authService.getProfile();
            _user = profile;
            _isAuthenticated = true;
            _hasToken = true;
            await _sessionService.saveUserInfo(
              id: profile.id,
              nombre: profile.nombre,
              email: profile.email,
            );
          }
        } else {
          // Token inválido o expirado
          await _sessionService.clearSession();
          _user = null;
          _isAuthenticated = false;
          _hasToken = false;
        }
      } else {
        _isAuthenticated = false;
        _hasToken = false;
      }
    } catch (_) {
      await _sessionService.clearSession();
      _user = null;
      _isAuthenticated = false;
      _hasToken = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Inicia sesión con email y contraseña
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _authService.login(email, password);
      final token = data['token'] as String;
      final userData = data['user'] as Map<String, dynamic>;

      // Guardar token en secure storage
      await _sessionService.saveToken(token);

      // Guardar usuario en SharedPreferences
      final user = User.fromJson(userData);
      await _sessionService.saveUserInfo(
        id: user.id,
        nombre: user.nombre,
        email: user.email,
      );

      _user = user;
      _isAuthenticated = true;
      _hasToken = true;
      _error = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } on DioException catch (e) {
      final resData = e.response?.data;
      if (resData is Map && resData['message'] != null) {
        _error = resData['message'].toString();
      } else if (e.type == DioExceptionType.connectionError) {
        _error = 'No se pudo conectar con el servidor backend.';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        _error = 'Tiempo de espera agotado al conectar.';
      } else {
        _error = 'Credenciales invalidas o error de autenticacion.';
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'Error inesperado: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Cierra la sesión y limpia el almacenamiento
  Future<void> logout() async {
    await _sessionService.clearSession();
    _user = null;
    _isAuthenticated = false;
    _hasToken = false;
    _error = null;
    notifyListeners();
  }
}
