import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();
  @override
  List<Object?> get props => [];
}

class ChatHistoryRequested extends ChatEvent {
  const ChatHistoryRequested();
}

class ChatMessageSent extends ChatEvent {
  const ChatMessageSent(this.text);
  final String text;
  @override
  List<Object?> get props => [text];
}

class ChatErrorDismissed extends ChatEvent {
  const ChatErrorDismissed();
}
