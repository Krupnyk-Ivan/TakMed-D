import '../database/seed_data.dart';
import '../database/app_database.dart';
import '../../features/learning/domain/repositories/learning_repository.dart';

/// Сервіс синхронізації з сервером.
class SyncService {
  /// Створює sync service.
  const SyncService(this._db, this._learningRepository);

  final AppDatabase _db;
  final LearningRepository _learningRepository;

  /// Виконує синхронізацію.
  Future<void> sync() async {
    await _learningRepository.syncWithServer();
  }

  /// Ініціалізує seed data при першому запуску.
  Future<void> seedIfEmpty() async {
    await SeedData.seedIfEmpty(_db);
  }
}
