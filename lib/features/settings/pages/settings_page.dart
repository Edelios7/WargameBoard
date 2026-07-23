import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/decor_separator.dart';
import '../../../core/widgets/textured_button.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/backup_provider.dart';
import '../../../providers/dashboard_provider.dart';
import '../../../providers/locale_provider.dart';
import '../../../providers/shared_preferences_provider.dart';
import '../widgets/import_json_dialog.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: ref.read(displayNameProvider) ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveName() {
    final name = _nameController.text.trim();
    ref.read(displayNameProvider.notifier).state = name.isEmpty ? null : name;
    final prefs = ref.read(sharedPreferencesProvider);
    if (name.isEmpty) {
      prefs.remove(displayNamePreferenceKey);
    } else {
      prefs.setString(displayNamePreferenceKey, name);
    }
  }

  Future<void> _exportBackup() async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final path = await ref.read(backupServiceProvider).exportBackup();
      if (path == null || !mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.settingsBackupExportSuccess(path))),
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.settingsBackupExportError)),
        );
      }
    }
  }

  Future<void> _restoreBackup() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          l10n.settingsBackupRestoreConfirmTitle,
          style: AppTextStyles.title,
        ),
        content: Text(
          l10n.settingsBackupRestoreConfirmBody,
          style: AppTextStyles.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.armyBuilderCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.settingsBackupRestoreConfirmAction),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    final staged = await ref.read(backupServiceProvider).stageRestore();
    if (!mounted || !staged) return;
    ref.invalidate(pendingRestoreProvider);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.settingsBackupRestoreStaged)),
    );
  }

  Future<void> _cancelPendingRestore() async {
    await ref.read(backupServiceProvider).cancelPendingRestore();
    ref.invalidate(pendingRestoreProvider);
  }

  void _setLocale(WidgetRef ref, Locale? locale) {
    ref.read(localeOverrideProvider.notifier).state = locale;

    final prefs = ref.read(sharedPreferencesProvider);
    if (locale == null) {
      prefs.remove(localePreferenceKey);
    } else {
      prefs.setString(localePreferenceKey, locale.languageCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeOverride = ref.watch(localeOverrideProvider);
    final pendingRestore = ref.watch(pendingRestoreProvider).value ?? false;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.navSettings, style: AppTextStyles.heading),
            const DecorSeparator(maxWidth: 200, padding: EdgeInsets.only(top: 8, bottom: 20)),
            SizedBox(
              width: 420,
              child: AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.settingsProfileTitle, style: AppTextStyles.body),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _nameController,
                      style: AppTextStyles.body,
                      decoration: InputDecoration(
                        labelText: l10n.settingsDisplayNameLabel,
                        labelStyle: AppTextStyles.caption,
                        filled: true,
                        fillColor: AppColors.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => _saveName(),
                      onEditingComplete: _saveName,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 420,
              child: AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.settingsLanguageTitle, style: AppTextStyles.body),
                    const SizedBox(height: 12),
                    _LanguageOption(
                      label: l10n.settingsLanguageSystem,
                      selected: localeOverride == null,
                      onTap: () => _setLocale(ref, null),
                    ),
                    _LanguageOption(
                      label: l10n.settingsLanguageFrench,
                      selected: localeOverride == const Locale('fr'),
                      onTap: () => _setLocale(ref, const Locale('fr')),
                    ),
                    _LanguageOption(
                      label: l10n.settingsLanguageEnglish,
                      selected: localeOverride == const Locale('en'),
                      onTap: () => _setLocale(ref, const Locale('en')),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 420,
              child: AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.settingsImportTitle, style: AppTextStyles.body),
                    const SizedBox(height: 8),
                    Text(
                      l10n.settingsImportDescription,
                      style: AppTextStyles.caption,
                    ),
                    const SizedBox(height: 12),
                    TexturedButton(
                      label: l10n.settingsImportButton,
                      icon: Icons.file_download_outlined,
                      onPressed: () => showDialog(
                        context: context,
                        builder: (_) => const ImportJsonDialog(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 420,
              child: AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.settingsBackupTitle, style: AppTextStyles.body),
                    const SizedBox(height: 8),
                    Text(
                      l10n.settingsBackupDescription,
                      style: AppTextStyles.caption,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        TexturedButton(
                          label: l10n.settingsBackupExportButton,
                          icon: Icons.file_upload_outlined,
                          onPressed: _exportBackup,
                        ),
                        TexturedButton(
                          label: l10n.settingsBackupRestoreButton,
                          icon: Icons.settings_backup_restore_rounded,
                          onPressed: _restoreBackup,
                        ),
                      ],
                    ),
                    if (pendingRestore) ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: .12),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.warning.withValues(alpha: .4),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.info_outline_rounded,
                                  size: 16,
                                  color: AppColors.warning,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    l10n.settingsBackupRestoreStaged,
                                    style: AppTextStyles.caption,
                                  ),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: _cancelPendingRestore,
                              child: Text(
                                l10n.settingsBackupRestoreCancel,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: selected ? AppColors.primary : AppColors.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(label, style: AppTextStyles.body),
          ],
        ),
      ),
    );
  }
}
