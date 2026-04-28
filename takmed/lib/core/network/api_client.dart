import 'package:dio/dio.dart';
import '../constants/app_api.dart';

/// Централизованный HTTP-клиент приложения.
class ApiClient {
  /// Создает API-клиент с базовой конфигурацией Dio.
  ApiClient()
    : dio = Dio(
        BaseOptions(
          baseUrl: AppApi.baseUrl,
          connectTimeout: const Duration(seconds: AppApi.connectTimeoutSeconds),
          receiveTimeout: const Duration(seconds: AppApi.receiveTimeoutSeconds),
          contentType: AppApi.contentTypeHeader,
        ),
      ) {
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }

  /// Экземпляр Dio для HTTP-запросов.
  final Dio dio;
}
