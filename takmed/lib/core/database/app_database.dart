import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'tables/courses_table.dart';
import 'tables/lessons_table.dart';
import 'tables/user_progress_table.dart';
import 'daos/course_dao.dart';
import 'daos/lesson_dao.dart';
import 'daos/progress_dao.dart';
import 'seed_data.dart';

part 'app_database.g.dart';

/// Головна база даних TacMed (Drift / SQLite).
@DriftDatabase(
  tables: [Courses, Lessons, UserProgress],
  daos: [CourseDao, LessonDao, ProgressDao],
)
class AppDatabase extends _$AppDatabase {
  /// Створює production database.
  AppDatabase() : super(_openConnection());

  /// Створює database з довільним executor (для тестів).
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await _migrateToV2(m);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'takmed',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('/sqlite3.wasm'),
        driftWorker: Uri.parse('/drift_worker.dart.js'),
      ),
    );
  }

  /// Заповнює seed data якщо DB порожня.
  Future<void> seedIfEmpty() async {
    await SeedData.seedIfEmpty(this);
  }

  Future<void> _migrateToV2(Migrator m) async {
    await m.addColumn(lessons, lessons.updatedAt);

    await m.addColumn(userProgress, userProgress.userId);
    await m.addColumn(userProgress, userProgress.updatedAt);
    await m.addColumn(userProgress, userProgress.isDirty);
    await m.addColumn(userProgress, userProgress.syncedAt);

    await customStatement('''
      UPDATE user_progress
      SET updated_at = completed_at
      WHERE updated_at IS NULL
    ''');

    await customStatement('''
      UPDATE user_progress
      SET is_dirty = 1
      WHERE is_dirty IS NULL
    ''');

    await customStatement('''
      DELETE FROM user_progress
      WHERE id NOT IN (
        SELECT MAX(id)
        FROM user_progress
        GROUP BY user_id, lesson_remote_id
      )
    ''');

    await customStatement(
      'CREATE UNIQUE INDEX IF NOT EXISTS idx_courses_remote_id ON courses(remote_id)',
    );
    await customStatement(
      'CREATE UNIQUE INDEX IF NOT EXISTS idx_lessons_remote_id ON lessons(remote_id)',
    );
    await customStatement('''
      CREATE UNIQUE INDEX IF NOT EXISTS idx_user_progress_user_lesson
      ON user_progress(user_id, lesson_remote_id)
    ''');
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_user_progress_user_dirty
      ON user_progress(user_id, is_dirty)
    ''');
  }
}
