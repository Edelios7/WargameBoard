import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../../l10n/app_localizations.dart';

/// État d'erreur générique pour un `AsyncValue.when(error: ...)` — un
/// message compréhensible plutôt que le texte brut de l'exception, avec
/// un bouton pour retenter (ex. `ref.invalidate(monProvider)`).
class RetryErrorState extends StatelessWidget {
  final VoidCallback onRetry;

  const RetryErrorState({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.commonLoadError,
              style: AppTextStyles.caption,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.border),
              ),
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text(l10n.commonRetry),
            ),
          ],
        ),
      ),
    );
  }
}

/// Variante compacte de [RetryErrorState] pour un emplacement en ligne
/// (ex. une section de filtre dans une liste) où le message + bouton
/// pleine hauteur serait disproportionné — une seule ligne icône +
/// message + bouton de réessai.
class InlineRetryErrorHint extends StatelessWidget {
  final VoidCallback onRetry;

  const InlineRetryErrorHint({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Icon(Icons.error_outline_rounded, size: 16, color: AppColors.error),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            l10n.commonLoadError,
            style: AppTextStyles.caption,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        IconButton(
          tooltip: l10n.commonRetry,
          icon: const Icon(Icons.refresh_rounded, size: 18),
          onPressed: onRetry,
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }
}
