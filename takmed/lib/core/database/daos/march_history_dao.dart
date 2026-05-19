import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/march_history_table.dart';

part 'march_history_dao.g.dart';

@DriftAccessor(tables: [MarchHistory])
class MarchHistoryDao extends DatabaseAccessor<AppDatabase>
    with _$MarchHistoryDaoMixin {
  MarchHistoryDao(super.db);

  Future<int> insertSession(MarchHistoryCompanion entry) =>
      into(marchHistory).insert(entry);

  Future<List<MarchHistoryDB>> getByUser(String userId) =>
      (select(marchHistory)
            ..where((m) => m.userId.equals(userId))
            ..orderBy([(m) => OrderingTerm.desc(m.startedAt)]))
          .get();

  Future<List<MarchHistoryDB>> getDirty(String userId) =>
      (select(marchHistory)
            ..where((m) => m.userId.equals(userId) & m.isDirty.equals(true)))
          .get();

  Future<int> markSynced(int id, {DateTime? at}) {
    return (update(marchHistory)..where((m) => m.id.equals(id))).write(
      MarchHistoryCompanion(
        isDirty: const Value(false),
        syncedAt: Value(at ?? DateTime.now()),
      ),
    );
  }

  Future<int> clearByUser(String userId) =>
      (delete(marchHistory)..where((m) => m.userId.equals(userId))).go();
}
