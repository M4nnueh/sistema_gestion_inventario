import 'package:dio/dio.dart';
import '../models/user.dart';
import 'api_client.dart';

class AuthService {
  final Dio _dio = ApiClient.instance.dio;

  /// Inicia sesión y retorna el mapa con token y user
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _dio.post('/api/auth/login', data: {
      'email': email,
      'password': password,
    });
    return response.data as Map<String, dynamic>;
  }

  /// Verifica si el token actual es válido
  Future<bool> verifyToken() async {
    try {
      await _dio.post('/api/auth/verify');
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Obtiene el perfil del usuario autenticado
  Future<User> getProfile() async {
    final response = await _dio.get('/api/auth/profile');
    return User.fromJson(response.data as Map<String, dynamic>);
  }
}
