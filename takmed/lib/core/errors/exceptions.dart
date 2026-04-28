/// Исключение сети
class NetworkException implements Exception {
  final String message;
  final dynamic originalError;

  NetworkException({required this.message, this.originalError});

  @override
  String toString() => 'NetworkException: $message';
}

/// Исключение сервера
class ServerException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic originalError;

  ServerException({required this.message, this.statusCode, this.originalError});

  @override
  String toString() => 'ServerException: $message (Status: $statusCode)';
}

/// Исключение парсинга
class ParseException implements Exception {
  final String message;
  final dynamic originalError;

  ParseException({required this.message, this.originalError});

  @override
  String toString() => 'ParseException: $message';
}

/// Исключение кэша
class CacheException implements Exception {
  final String message;
  final dynamic originalError;

  CacheException({required this.message, this.originalError});

  @override
  String toString() => 'CacheException: $message';
}

/// Исключение валидации
class ValidationException implements Exception {
  final String message;
  final Map<String, String>? errors;

  ValidationException({required this.message, this.errors});

  @override
  String toString() => 'ValidationException: $message';
}

/// Виняток аутентифікації
class AppAuthException implements Exception {
  final String message;
  final dynamic originalError;

  AppAuthException({required this.message, this.originalError});

  @override
  String toString() => 'AppAuthException: $message';
}
