import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'session_service.dart';

class ApiClient {
  static VoidCallback? onUnauthorized;

  ApiClient._internal() {
    String raw = 'http://localhost:3000';
    try {
      raw = dotenv.env['API_BASE_URL'] ?? raw;
    } catch (_) {
      // dotenv no inicializado (p. ej. tests)
    }
    final baseUrl = raw;

    dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ));

    final sessionService = SessionService();

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          try {
            final token = await sessionService.getToken();
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          } catch (_) {
            // Error al leer token, continuar sin token
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 401) {
            // Solo disparar onUnauthorized si no es el endpoint de login
            final path = error.requestOptions.path;
            if (!path.contains('/auth/login')) {
              await sessionService.clearSession();
              onUnauthorized?.call();
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  static final ApiClient instance = ApiClient._internal();
  late final Dio dio;
}
