import 'package:connectivity_plus/connectivity_plus.dart';

/// Контракт проверки доступности сети.
abstract class NetworkInfo {
  /// Возвращает `true`, если устройство имеет сетевое подключение.
  Future<bool> get isConnected;
}

/// Реализация проверки сети через connectivity_plus.
class NetworkInfoImpl implements NetworkInfo {
  /// Создает реализацию проверки сети.
  const NetworkInfoImpl(this._connectivity);

  final Connectivity _connectivity;

  @override
  Future<bool> get isConnected async {
    final ConnectivityResult result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }
}
