import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/models/message.dart';
import '../../../core/services/translation_service.dart';
import '../../../shared/theme/app_theme.dart';

class MessageBubble extends ConsumerWidget {
  final ChatMessage message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isUser = message.isUser;
    final canTranslate = !isUser && message.id != null;
    final translationState =
        canTranslate ? ref.watch(translationProvider(message.id!)) : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isUser) ...[
                _aiAvatar(),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isUser ? AppTheme.userBubble : AppTheme.aiBubble,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isUser ? 16 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 16),
                    ),
                    border: isUser
                        ? null
                        : Border.all(
                            color: AppTheme.borderColor, width: 0.5),
                  ),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.82,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isUser
                            ? message.content
                            : (message.aiResponse?.reply ?? message.content),
                        style: TextStyle(
                          color:
                              isUser ? Colors.white : AppTheme.textPrimary,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                      if (translationState != null &&
                          translationState.isVisible) ...[
                        const SizedBox(height: 8),
                        Divider(
                            height: 1,
                            thickness: 0.5,
                            color: AppTheme.borderColor),
                        const SizedBox(height: 8),
                        _TranslationContent(state: translationState),
                      ],
                    ],
                  ),
                ),
              ),
              if (isUser) const SizedBox(width: 8),
            ],
          ),
          const SizedBox(height: 3),
          Padding(
            padding: EdgeInsets.only(left: isUser ? 0 : 42),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  DateFormat('HH:mm').format(message.createdAt),
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppTheme.textSecondary,
                  ),
                ),
                if (canTranslate) ...[
                  const SizedBox(width: 6),
                  _TranslateButton(message: message),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _aiAvatar() {
    return Container(
      width: 28,
      height: 28,
      decoration: const BoxDecoration(
        color: AppTheme.primary,
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Text('🤖', style: TextStyle(fontSize: 14)),
      ),
    );
  }
}

class _TranslationContent extends StatelessWidget {
  final TranslationState state;

  const _TranslationContent({required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return const SizedBox(
        height: 16,
        width: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppTheme.primary,
        ),
      );
    }

    if (state.hasError) {
      return const Text(
        'Erro ao traduzir',
        style: TextStyle(
          color: Colors.redAccent,
          fontSize: 12,
          fontStyle: FontStyle.italic,
        ),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(state.language!.flag,
            style: const TextStyle(fontSize: 13)),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            state.text!,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 13,
              height: 1.4,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }
}

class _TranslateButton extends ConsumerStatefulWidget {
  final ChatMessage message;

  const _TranslateButton({required this.message});

  @override
  ConsumerState<_TranslateButton> createState() => _TranslateButtonState();
}

class _TranslateButtonState extends ConsumerState<_TranslateButton> {
  final _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(translationProvider(widget.message.id!));

    return GestureDetector(
      key: _key,
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (state.isLoading) return;
        if (state.text != null) {
          ref.read(translationProvider(widget.message.id!).notifier).hide();
        } else {
          _showLanguagePicker(context);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Icon(
          Icons.translate_rounded,
          size: 20,
          color: state.text != null
              ? AppTheme.primary
              : AppTheme.textSecondary,
        ),
      ),
    );
  }

  void _showLanguagePicker(BuildContext context) {
    final box = _key.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;
    final overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final position = RelativeRect.fromRect(
      box.localToGlobal(Offset.zero, ancestor: overlay) & box.size,
      Offset.zero & overlay.size,
    );

    final text =
        widget.message.aiResponse?.reply ?? widget.message.content;

    showMenu<TranslationLanguage>(
      context: context,
      position: position,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      items: TranslationLanguage.values
          .map(
            (lang) => PopupMenuItem(
              value: lang,
              child: Text('${lang.flag}  ${lang.label}'),
            ),
          )
          .toList(),
    ).then((lang) {
      if (lang != null && mounted) {
        ref
            .read(translationProvider(widget.message.id!).notifier)
            .translate(text, lang);
      }
    });
  }
}
