import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TranslationLanguage { portuguese, spanish }

extension TranslationLanguageExt on TranslationLanguage {
  String get label =>
      this == TranslationLanguage.portuguese ? 'Português' : 'Español';
  String get flag =>
      this == TranslationLanguage.portuguese ? '🇧🇷' : '🇪🇸';
  String get localeName =>
      this == TranslationLanguage.portuguese ? 'Brazilian Portuguese' : 'Spanish';
}

class TranslationState {
  final bool isLoading;
  final String? text;
  final TranslationLanguage? language;
  final bool hasError;

  const TranslationState({
    this.isLoading = false,
    this.text,
    this.language,
    this.hasError = false,
  });

  bool get isVisible => isLoading || text != null;
}

class TranslationNotifier extends StateNotifier<TranslationState> {
  TranslationNotifier() : super(const TranslationState());

  Future<void> translate(String originalText, TranslationLanguage lang) async {
    // Mesmo idioma e já traduzido: esconde
    if (state.language == lang && state.text != null) {
      state = const TranslationState();
      return;
    }

    state = const TranslationState(isLoading: true);

    try {
      final model = FirebaseAI.googleAI().generativeModel(
        model: 'gemini-2.5-flash',
        systemInstruction: Content.system(
          'You are a translator. Translate the given English text to ${lang.localeName}. '
          'Return ONLY the translation — no explanations, no extra text.',
        ),
        generationConfig: GenerationConfig(maxOutputTokens: 400),
      );

      final response =
          await model.generateContent([Content.text(originalText)]);
      final translated = response.text?.trim() ?? '';

      if (!mounted) return;

      if (translated.isEmpty) {
        state = const TranslationState(hasError: true);
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) state = const TranslationState();
        return;
      }

      state = TranslationState(text: translated, language: lang);
    } catch (e) {
      debugPrint('[Translation] error: $e');
      if (!mounted) return;
      state = const TranslationState(hasError: true);
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) state = const TranslationState();
    }
  }

  void hide() => state = const TranslationState();
}

// Provider por mensagem — estado independente para cada bubble
final translationProvider = StateNotifierProvider.family<TranslationNotifier,
    TranslationState, int>(
  (ref, messageId) => TranslationNotifier(),
);
