import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
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

  Future<void> _run() async {
    final l10n = AppLocalizations.of(context)!;
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: SizedBox(
        width: 560,
        height: 480,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.settingsImportButton, style: AppTextStyles.title),
              const SizedBox(height: 16),
              Expanded(
                child: TextField(
                  controller: _controller,
                  maxLines: null,
                  expands: true,
                  autofocus: true,
                  textAlignVertical: TextAlignVertical.top,
                  style: AppTextStyles.caption
                      .copyWith(color: AppColors.textPrimary),
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
                  style: AppTextStyles.caption.copyWith(color: AppColors.error),
                ),
              ],
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed:
                        _running ? null : () => Navigator.of(context).pop(),
                    child: Text(
                      l10n.armyBuilderCancel,
                      style: AppTextStyles.body,
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    onPressed: _running ? null : _run,
                    child: _running
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(l10n.settingsImportRun),
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
