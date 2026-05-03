import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../l10n/app_localizations.dart';
import '../../shared/theme/app_theme.dart';
import '../home/home_providers.dart';
import 'chat_providers.dart';
import 'widgets/correction_card.dart';
import 'widgets/message_bubble.dart';
import 'widgets/typing_indicator.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _textCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();

  @override
  void dispose() {
    _textCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _send() async {
    final text = _textCtrl.text.trim();
    if (text.isEmpty) return;
    _textCtrl.clear();
    await ref.read(chatProvider.notifier).sendMessage(text);
    _scrollToBottom();
  }

  String _localizedModeDisplay(AppLocalizations l10n, String? mode) {
    switch (mode) {
      case 'casual':
        return l10n.modeCasual;
      case 'business':
        return l10n.modeBusiness;
      case 'travel':
        return l10n.modeTravel;
      case 'interview':
        return l10n.modeInterview;
      default:
        return l10n.modeCasual;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(chatProvider);
    final userAsync = ref.watch(userProfileProvider);
    final modeDisplay = _localizedModeDisplay(
        l10n, userAsync.valueOrNull?.currentMode);
    ref.listen(chatProvider, (prev, next) {
      if (next.error != null && next.error != prev?.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: AppTheme.error,
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () =>
                  ref.read(chatProvider.notifier).clearError(),
            ),
          ),
        );
      }
      if (next.messages.length != prev?.messages.length) {
        _scrollToBottom();
      }
    });

    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: _ChatHeader(modeDisplay: modeDisplay),
      ),
      body: Column(
        children: [
          Expanded(
            child: state.messages.isEmpty && !state.isTyping
                ? const _EmptyState()
                : _MessageList(
                    state: state,
                    scrollController: _scrollCtrl,
                  ),
          ),
          _InputBar(
            controller: _textCtrl,
            enabled: !state.isTyping,
            onSend: _send,
          ),
        ],
      ),
    );
  }
}

// ─── Custom header ────────────────────────────────────────────────────────────

class _ChatHeader extends StatelessWidget {
  final String modeDisplay;

  const _ChatHeader({required this.modeDisplay});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final canPop = Navigator.of(context).canPop();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SafeArea(
          bottom: false,
          child: SizedBox(
            height: 56,
            child: Row(
              children: [
                if (canPop) ...[
                  const SizedBox(width: 4),
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                    onPressed: () => Navigator.of(context).pop(),
                    color: AppTheme.textPrimary,
                  ),
                ] else
                  const SizedBox(width: 16),
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: AppTheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text('🤖', style: TextStyle(fontSize: 18)),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.chatHeaderSubtitle,
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      modeDisplay,
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }
}

// ─── Lista de mensagens ───────────────────────────────────────────────────────

class _MessageList extends StatelessWidget {
  final ChatState state;
  final ScrollController scrollController;

  const _MessageList({
    required this.state,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final items = state.messages;

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: items.length + (state.isTyping ? 1 : 0),
      itemBuilder: (context, index) {
        if (state.isTyping && index == items.length) {
          return const TypingIndicator();
        }

        final msg = items[index];
        final showCard = msg.isAssistant &&
            msg.aiResponse != null &&
            ((msg.aiResponse!.correction != null) ||
                msg.aiResponse!.newWords.isNotEmpty);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MessageBubble(message: msg),
            if (showCard)
              CorrectionCard(
                correction: msg.aiResponse?.correction ?? '',
                grammarNote: msg.aiResponse?.grammarNote,
                newWords: msg.aiResponse?.newWords ?? [],
              ),
          ],
        );
      },
    );
  }
}

// ─── Campo de entrada ─────────────────────────────────────────────────────────

class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;
  final VoidCallback onSend;

  const _InputBar({
    required this.controller,
    required this.enabled,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      color: AppTheme.surface,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      enabled: enabled,
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: 4,
                      minLines: 1,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: l10n.chatInputHint,
                        hintStyle: const TextStyle(color: AppTheme.textSecondary),
                      ),
                      onSubmitted: enabled ? (_) => onSend() : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedOpacity(
                    opacity: enabled ? 1.0 : 0.4,
                    duration: const Duration(milliseconds: 200),
                    child: GestureDetector(
                      onTap: enabled ? onSend : null,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          color: AppTheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_upward_rounded,
                            color: Colors.white, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Estado vazio ─────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: AppTheme.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text('🤖', style: TextStyle(fontSize: 34)),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.chatEmptyTitle,
              style: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.chatEmptySubtitle,
              style: GoogleFonts.nunito(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
