import 'package:equatable/equatable.dart';

/// Доменна сутність повідомлення в AI-чаті.
class ChatMessageEntity extends Equatable {
  const ChatMessageEntity({
    required this.id,
    required this.role,
    required this.content,
    required this.createdAt,
    this.isPending = false,
  });

  /// UUID з Supabase, або тимчасовий локальний `local_<ts>` для optimistic-додавання.
  final String id;

  /// `'user'` | `'assistant'` (опційно `'system'` для майбутнього).
  final String role;

  final String content;

  final DateTime createdAt;

  /// `true` поки відповідь від сервера ще не прийшла.
  final bool isPending;

  bool get isUser => role == 'user';
  bool get isAssistant => role == 'assistant';

  ChatMessageEntity copyWith({
    String? id,
    String? content,
    bool? isPending,
  }) {
    return ChatMessageEntity(
      id: id ?? this.id,
      role: role,
      content: content ?? this.content,
      createdAt: createdAt,
      isPending: isPending ?? this.isPending,
    );
  }

  @override
  List<Object?> get props => [id, role, content, createdAt, isPending];
}
