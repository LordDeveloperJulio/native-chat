import 'package:flutter/material.dart';

import '../../../shared/theme/app_theme.dart';

import 'package:study_english/l10n/app_localizations.dart';

class CorrectionCard extends StatelessWidget {
  final String correction;
  final String? grammarNote;
  final List<String> newWords;

  const CorrectionCard({
    super.key,
    required this.correction,
    this.grammarNote,
    required this.newWords,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasCorrectionText = correction.isNotEmpty;
    final hasWords = newWords.isNotEmpty;

    if (!hasCorrectionText && !hasWords) return const SizedBox.shrink();

    final parts = hasCorrectionText ? correction.split('→') : <String>[];
    final wrongPart = parts.isNotEmpty ? parts[0].trim() : '';
    final correctPart = parts.length > 1 ? parts[1].trim() : correction;

    return Padding(
      padding: const EdgeInsets.fromLTRB(52, 0, 16, 6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppTheme.correctionBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.correctionBorder, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasCorrectionText) ...[
              Text(
                l10n.chatCorrectionLabel,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: AppTheme.correctionText,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  if (wrongPart.isNotEmpty) ...[
                    Flexible(
                      child: Text(
                        wrongPart,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.error,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: AppTheme.error,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: Text('→',
                          style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.textSecondary)),
                    ),
                  ],
                  Flexible(
                    child: Text(
                      correctPart,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              if (grammarNote != null && grammarNote!.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  grammarNote!,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.correctionText,
                    fontStyle: FontStyle.italic,
                    height: 1.4,
                  ),
                ),
              ],
            ],
            if (hasCorrectionText && hasWords) const SizedBox(height: 8),
            if (hasWords) ...[
              Text(
                l10n.chatNewWordsLabel,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(height: 5),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: newWords
                    .map((word) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 9, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryLight,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            word,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
