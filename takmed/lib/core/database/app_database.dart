import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'tables/courses_table.dart';
import 'tables/lessons_table.dart';
import 'tables/user_progress_table.dart';
import 'tables/quiz_attempts_table.dart';
import 'tables/chat_messages_table.dart';
import 'tables/march_history_table.dart';
import 'daos/course_dao.dart';
import 'daos/lesson_dao.dart';
import 'daos/progress_dao.dart';
import 'daos/quiz_attempt_dao.dart';
import 'daos/chat_dao.dart';
import 'daos/march_history_dao.dart';
import 'seed_data.dart';

part 'app_database.g.dart';

/// Головна база даних TacMed (Drift / SQLite).
@DriftDatabase(
  tables: [
    Courses,
    Lessons,
    UserProgress,
    QuizAttempts,
    ChatMessagesLocal,
    MarchHistory,
  ],
  daos: [
    CourseDao,
    LessonDao,
    ProgressDao,
    QuizAttemptDao,
    ChatDao,
    MarchHistoryDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  /// Створює production database.
  AppDatabase() : super(_openConnection());

  /// Створює database з довільним executor (для тестів).
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 7;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await _migrateToV2(m);
      }
      if (from < 3) {
        // Видаляємо seed-курси — дані тепер беруться виключно з Supabase.
        await customStatement(
          "DELETE FROM lessons WHERE remote_id LIKE 'mil-%' OR remote_id LIKE 'civ-%' OR remote_id LIKE 'exam-%' OR remote_id LIKE 'march-%'",
        );
        await customStatement(
          "DELETE FROM courses WHERE remote_id LIKE 'mil-%' OR remote_id LIKE 'civ-%' OR remote_id LIKE 'exam-%'",
        );
      }
      if (from < 4) {
        await m.createTable(quizAttempts);
      }
      if (from < 5) {
        await m.createTable(chatMessagesLocal);
      }
      if (from < 6) {
        await m.createTable(marchHistory);
      }
      if (from < 7) {
        await m.addColumn(quizAttempts, quizAttempts.isDirty);
        await m.addColumn(quizAttempts, quizAttempts.syncedAt);
        await m.addColumn(quizAttempts, quizAttempts.updatedAt);
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
    // SQLite не дозволяє нелітеральний DEFAULT в ALTER TABLE ADD COLUMN,
    // тому використовуємо 0 (epoch) — sync перезапише реальними датами.
    await customStatement(
      'ALTER TABLE "lessons" ADD COLUMN "updated_at" INTEGER NOT NULL DEFAULT 0',
    );

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
