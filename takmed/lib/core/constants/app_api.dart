/// API-константы приложения TacMed.
class AppApi {
  /// Базовый URL API.
  static const String baseUrl = 'https://api.tacmed.app';

  /// Таймаут соединения в секундах.
  static const int connectTimeoutSeconds = 30;

  /// Таймаут получения ответа в секундах.
  static const int receiveTimeoutSeconds = 30;

  /// Заголовок типа контента.
  static const String contentTypeHeader = 'application/json';
}
