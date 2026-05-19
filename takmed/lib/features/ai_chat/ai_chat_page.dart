import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/di/injection_container.dart';
import 'presentation/bloc/chat_bloc.dart';
import 'presentation/bloc/chat_event.dart';
import 'presentation/bloc/chat_state.dart';
import 'presentation/widgets/chat_bubble.dart';

class AiChatPage extends StatelessWidget {
  const AiChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChatBloc>(
      create: (_) => getIt<ChatBloc>()..add(const ChatHistoryRequested()),
      child: const _ChatView(),
    );
  }
}

class _ChatView extends StatefulWidget {
  const _ChatView();

  @override
  State<_ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<_ChatView> {
  final _inputCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  @override
  void dispose() {
    _inputCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _send(BuildContext context) {
    final text = _inputCtrl.text.trim();
    if (text.isEmpty) return;
    context.read<ChatBloc>().add(ChatMessageSent(text));
    _inputCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        title: const Text(AppStrings.aiChat),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20),
          child: BlocBuilder<ChatBloc, ChatState>(
            buildWhen: (a, b) => a.remainingToday != b.remainingToday,
            builder: (context, state) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                'Залишилось ${state.remainingToday} з 30 запитів сьогодні',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ),
      ),
      body: BlocConsumer<ChatBloc, ChatState>(
        listenWhen: (a, b) => a.messages.length != b.messages.length,
        listener: (_, __) => _scrollToBottom(),
        builder: (context, state) {
          return Column(
            children: [
              Expanded(child: _buildBody(context, state)),
              if (state.status == ChatStatus.error &&
                  state.errorMessage != null)
                _ErrorBanner(message: state.errorMessage!),
              if (state.status == ChatStatus.rateLimited &&
                  state.errorMessage != null)
                _RateLimitBanner(message: state.errorMessage!),
              _Composer(
                controller: _inputCtrl,
                onSend: () => _send(context),
                disabled: state.status == ChatStatus.sending ||
                    state.status == ChatStatus.rateLimited,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, ChatState state) {
    if (state.status == ChatStatus.loading || state.status == ChatStatus.initial) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.messages.isEmpty) {
      return _buildEmpty();
    }

    final itemCount = state.messages.length +
        (state.status == ChatStatus.sending ? 1 : 0);

    return ListView.builder(
      controller: _scrollCtrl,
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: itemCount,
      itemBuilder: (context, i) {
        if (i >= state.messages.length) {
          return const TypingIndicator();
        }
        return ChatBubble(message: state.messages[i]);
      },
    );
  }

  Widget _buildEmpty() => Padding(
        padding: const EdgeInsets.all(AppDimensions.padding3xLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.accentGreen.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.medical_services_rounded,
                color: AppColors.accentGreen,
                size: 48,
              ),
            ),
            const SizedBox(height: AppDimensions.spacerLarge),
            const Text(
              'ШІ-помічник з тактичної медицини',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppDimensions.fontSizeLarge,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Запитуй про MARCH, турнікети, чек-листи TCCC, '
              'першу домедичну допомогу. Не відповідаю на питання поза цією темою.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: AppDimensions.fontSizeMedium,
                height: 1.5,
              ),
            ),
            const SizedBox(height: AppDimensions.spacerLarge),
            const _SuggestionChip(text: 'Що таке протокол MARCH?'),
            const SizedBox(height: 8),
            const _SuggestionChip(text: 'Як правильно накласти турнікет?'),
            const SizedBox(height: 8),
            const _SuggestionChip(text: 'Які кроки при пневмотораксі?'),
          ],
        ),
      );
}

class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<ChatBloc>().add(ChatMessageSent(text)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.auto_awesome, size: 14, color: AppColors.accentGreen),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: AppDimensions.fontSizeMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.errorRed.withValues(alpha: 0.15),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(children: [
        const Icon(Icons.error_outline, size: 18, color: AppColors.errorRed),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            message,
            style: const TextStyle(color: AppColors.errorRed, fontSize: 12),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close, size: 16, color: AppColors.errorRed),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: () =>
              context.read<ChatBloc>().add(const ChatErrorDismissed()),
        ),
      ]),
    );
  }
}

class _RateLimitBanner extends StatelessWidget {
  const _RateLimitBanner({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.warningOrange.withValues(alpha: 0.15),
      padding: const EdgeInsets.all(12),
      child: Row(children: [
        const Icon(Icons.timer_outlined, color: AppColors.warningOrange),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            message,
            style: const TextStyle(color: AppColors.warningOrange, fontSize: 13),
          ),
        ),
      ]),
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer({
    required this.controller,
    required this.onSend,
    required this.disabled,
  });

  final TextEditingController controller;
  final VoidCallback onSend;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceColor,
        border: Border(top: BorderSide(color: AppColors.borderColor)),
      ),
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    enabled: !disabled,
                    maxLines: 4,
                    minLines: 1,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => onSend(),
                    decoration: InputDecoration(
                      hintText: disabled
                          ? '...'
                          : 'Запитай про тактичну медицину',
                      filled: true,
                      fillColor: AppColors.cardColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Material(
                  color: disabled
                      ? AppColors.borderColor
                      : AppColors.primaryRed,
                  shape: const CircleBorder(),
                  child: InkWell(
                    onTap: disabled ? null : onSend,
                    customBorder: const CircleBorder(),
                    child: const SizedBox(
                      width: 44,
                      height: 44,
                      child: Icon(Icons.send_rounded, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              '⚠️ Інформація для навчання, не для діагностики',
              style: TextStyle(
                fontSize: 10,
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
