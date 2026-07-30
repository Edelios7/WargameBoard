import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_dialog_shortcuts.dart';
import '../../../core/widgets/discard_guard.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/catalog_provider.dart';
import '../../../providers/import_provider.dart';
import '../../../services/catalog_import_service.dart';

class ImportJsonDialog extends ConsumerStatefulWidget {
  const ImportJsonDialog({super.key});

  @override
  ConsumerState<ImportJsonDialog> createState() => _ImportJsonDialogState();
}

class _ImportJsonDialogState extends ConsumerState<ImportJsonDialog> {
  final _controller = TextEditingController();
  String? _error;
  bool _running = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _hasUnsavedInput => _controller.text.trim().isNotEmpty;

  Future<void> _run() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          l10n.settingsImportConfirmTitle,
          style: AppTextStyles.title,
        ),
        content: Text(
          l10n.settingsImportConfirmMessage,
          style: AppTextStyles.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.armyBuilderCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.settingsImportRun),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() {
      _running = true;
      _error = null;
    });

    try {
      final result = await ref
          .read(catalogImportServiceProvider)
          .importJson(_controller.text);

      ref.invalidate(catalogSearchResultsProvider);
      ref.invalidate(keywordsListProvider);
      ref.invalidate(selectedDatasheetProvider);
      // Invalide TOUTE la famille (pas un id précis) : un import peut
      // mettre à jour n'importe quelle fiche déjà ouverte via "Voir la
      // fiche complète" ailleurs dans la session, dont le cache ne
      // s'expire sinon jamais tout seul.
      ref.invalidate(datasheetByIdProvider);

      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.settingsImportSuccess(result.total))),
      );
    } on CatalogImportException catch (e) {
      setState(() {
        _running = false;
        _error = e.message;
      });
    } catch (e) {
      // Un JSON syntaxiquement valide mais avec un type de champ inattendu
      // (ex. un nombre là où une chaîne est attendue) lève une exception
      // brute (TypeError...) plutôt qu'une CatalogImportException — sans ce
      // filet, le dialogue restait bloqué en spinner pour toujours (Annuler
      // est désactivé tant que `_running` est vrai, voir plus bas).
      if (!mounted) return;
      setState(() {
        _running = false;
        _error = l10n.settingsImportUnexpectedError;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppDialogShortcuts(
      child: DiscardGuardScope(
        hasUnsavedInput: () => _hasUnsavedInput,
        child: Dialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: SizedBox(
            width: 560,
            height: 480,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.settingsImportButton, style: AppTextStyles.title),
                  const SizedBox(height: 6),
                  Text(
                    l10n.settingsImportBehaviorHint,
                    style: AppTextStyles.caption,
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      maxLines: null,
                      expands: true,
                      autofocus: true,
                      textAlignVertical: TextAlignVertical.top,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: l10n.settingsImportPasteHint,
                        hintStyle: AppTextStyles.caption,
                        filled: true,
                        fillColor: AppColors.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      _error!,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: _running
                            ? null
                            : () => DiscardGuard.popIfConfirmed(
                                context,
                                () => _hasUnsavedInput,
                              ),
                        child: Text(
                          l10n.armyBuilderCancel,
                          style: AppTextStyles.body,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ValueListenableBuilder<TextEditingValue>(
                        valueListenable: _controller,
                        builder: (context, value, _) => FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.primary,
                          ),
                          onPressed: _running || value.text.trim().isEmpty
                              ? null
                              : _run,
                          child: _running
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(l10n.settingsImportRun),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
