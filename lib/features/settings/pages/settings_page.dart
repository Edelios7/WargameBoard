import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/locale_provider.dart';
import '../../../providers/shared_preferences_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

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
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final localeOverride = ref.watch(localeOverrideProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.navSettings, style: AppTextStyles.heading),
            const SizedBox(height: 24),
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
