import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiClient {
  ApiClient._internal() {
    String raw = 'http://localhost:3000';
    try {
      raw = dotenv.env['API_BASE_URL'] ?? raw;
    } catch (_) {
      // dotenv no inicializado (p. ej. tests)
    }
    String baseUrl = raw;
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      baseUrl = baseUrl.replaceFirst('localhost', '10.0.2.2');
    }
    dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ));
  }

  static final ApiClient instance = ApiClient._internal();
  late final Dio dio;
}