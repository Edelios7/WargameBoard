import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/decor_separator.dart';
import '../../../core/widgets/textured_button.dart';
import '../../../l10n/app_localizations.dart';
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
