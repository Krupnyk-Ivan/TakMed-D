import 'package:equatable/equatable.dart';

/// Базовый класс для всех ошибок в приложении
abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Сетевая ошибка
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Ошибка сервера
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Ошибка парсинга данных
class ParseFailure extends Failure {
  const ParseFailure(super.message);
}

/// Ошибка локального хранилища
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Ошибка валидации
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// Ошибка аутентификации
class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

/// Неизвестная ошибка
class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}
