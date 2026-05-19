import 'package:drift/drift.dart';

/// Локальний кеш повідомлень AI-чату для офлайн-перегляду історії.
@DataClassName('ChatMessageDB')
class ChatMessagesLocal extends Table {
  /// UUID з Supabase (або тимчасовий локальний для pending).
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get role => text()();
  TextColumn get content => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
