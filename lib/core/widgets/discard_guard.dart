import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Empêche de perdre une saisie en cours sans prévenir : un formulaire
/// dans un dialogue (nom, notes, scores...) qui se ferme sur un simple
/// tap en dehors ou un bouton "Annuler" jette tout ce qui a déjà été
/// tapé, sans recours. [popIfConfirmed] centralise la confirmation à
/// n'utiliser que si `hasUnsavedInput()` répond vrai ; sinon ferme
/// directement, comme avant.
class DiscardGuard {
  DiscardGuard._();

  /// Ferme la route courante — après confirmation si `hasUnsavedInput()`
  /// est vrai. À appeler à la fois depuis le bouton "Annuler" et depuis
  /// `PopScope.onPopInvokedWithResult` (tap sur la zone grisée, geste
  /// retour) pour couvrir les deux façons de fermer le dialogue.
  static Future<void> popIfConfirmed(
    BuildContext context,
    bool Function() hasUnsavedInput,
  ) async {
    if (!hasUnsavedInput()) {
      Navigator.of(context).pop();
      return;
    }
    final l10n = AppLocalizations.of(context)!;
    final discard = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          l10n.battleDiscardConfirmTitle,
          style: AppTextStyles.title,
        ),
        content: Text(
          l10n.battleDiscardConfirmMessage,
          style: AppTextStyles.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.battleDiscardKeepEditing),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.battleDiscardConfirmAction),
          ),
        ],
      ),
    );
    if (discard == true && context.mounted) {
      Navigator.of(context).pop();
    }
  }
}

/// Enveloppe un dialogue pour intercepter les fermetures "système" (tap
/// hors du dialogue, geste retour) et les faire passer par
/// [DiscardGuard.popIfConfirmed] au lieu de fermer directement — le
/// bouton "Annuler" visible du dialogue doit séparément appeler
/// [DiscardGuard.popIfConfirmed] lui-même, un `Navigator.pop()` direct
/// n'est pas intercepté par [PopScope].
class DiscardGuardScope extends StatelessWidget {
  final bool Function() hasUnsavedInput;
  final Widget child;

  const DiscardGuardScope({
    super.key,
    required this.hasUnsavedInput,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        DiscardGuard.popIfConfirmed(context, hasUnsavedInput);
      },
      child: child,
    );
  }
}
