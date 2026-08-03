import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_wallpapers.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_dialog_shortcuts.dart';
import '../../../core/widgets/decor_separator.dart';
import '../../../domain/customization/theme_preset.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/customization_provider.dart';
import '../widgets/hsv_color_picker.dart';

class CustomizationPage extends ConsumerWidget {
  const CustomizationPage({super.key});

  Future<void> _applyColor(WidgetRef ref, Color color) async {
    await ref.read(customizationServiceProvider).setAccentColor(color);
    ref.read(themeVersionProvider.notifier).state++;
  }

  Future<void> _resetColor(WidgetRef ref) async {
    await ref.read(customizationServiceProvider).resetAccentColor();
    ref.read(themeVersionProvider.notifier).state++;
  }

  Future<void> _pickWallpaper(
    BuildContext context,
    WidgetRef ref,
    WallpaperSlot slot,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final ok = await ref
        .read(customizationServiceProvider)
        .pickAndSetWallpaper(slot);
    if (ok) {
      ref.read(themeVersionProvider.notifier).state++;
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.customizationUnsupportedFormat)),
      );
    }
  }

  Future<void> _clearWallpaper(WidgetRef ref, WallpaperSlot slot) async {
    await ref.read(customizationServiceProvider).clearWallpaper(slot);
    ref.read(themeVersionProvider.notifier).state++;
  }

  Future<void> _setDimming(WidgetRef ref, double value) async {
    await ref.read(customizationServiceProvider).setWallpaperDimming(value);
    ref.read(themeVersionProvider.notifier).state++;
  }

  Future<void> _savePreset(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AppDialogShortcuts(
        onEnter: () => Navigator.of(dialogContext).pop(controller.text.trim()),
        child: AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text(
            l10n.customizationSavePresetDialogTitle,
            style: AppTextStyles.title,
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            style: AppTextStyles.body,
            decoration: InputDecoration(
              hintText: l10n.customizationSavePresetDialogHint,
              hintStyle: AppTextStyles.caption,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l10n.armyBuilderCancel),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
              onPressed: () =>
                  Navigator.of(dialogContext).pop(controller.text.trim()),
              child: Text(l10n.armyBuilderSave),
            ),
          ],
        ),
      ),
    );
    controller.dispose();
    if (name == null || name.isEmpty) return;
    await ref.read(customizationServiceProvider).savePreset(name);
    ref.read(themeVersionProvider.notifier).state++;
  }

  Future<void> _applyPreset(WidgetRef ref, ThemePreset preset) async {
    await ref.read(customizationServiceProvider).applyPreset(preset);
    ref.read(themeVersionProvider.notifier).state++;
  }

  Future<void> _deletePreset(
    BuildContext context,
    WidgetRef ref,
    String name,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    // Contrairement à "Tout réinitialiser" (qui demande déjà confirmation),
    // supprimer un thème enregistré individuellement s'exécutait
    // directement sans recours — une combinaison composée à la main
    // (couleur, fonds d'écran, voile) perdue sur un clic mal calibré.
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AppDialogShortcuts(
        child: AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text(
            l10n.customizationDeletePresetConfirmTitle,
            style: AppTextStyles.title,
          ),
          content: Text(
            l10n.customizationDeletePresetConfirmMessage(name),
            style: AppTextStyles.body,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.armyBuilderCancel),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppColors.error),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(l10n.customizationPresetDelete),
            ),
          ],
        ),
      ),
    );
    if (confirmed != true) return;
    await ref.read(customizationServiceProvider).deletePreset(name);
    ref.read(themeVersionProvider.notifier).state++;
  }

  Future<void> _resetAll(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AppDialogShortcuts(
        onEnter: () => Navigator.of(dialogContext).pop(true),
        child: AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text(
            l10n.customizationResetAllConfirmTitle,
            style: AppTextStyles.title,
          ),
          content: Text(
            l10n.customizationResetAllConfirmMessage,
            style: AppTextStyles.body,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.armyBuilderCancel),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppColors.error),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(l10n.customizationResetAll),
            ),
          ],
        ),
      ),
    );
    if (confirmed != true) return;
    await ref.read(customizationServiceProvider).resetAll();
    ref.read(themeVersionProvider.notifier).state++;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final accent = ref.watch(accentColorProvider);
    final dimming = ref.watch(wallpaperDimmingProvider);
    final presets = ref.watch(themePresetsProvider);

    return Scaffold(
      backgroundColor: AppWallpapers.app == null
          ? AppColors.background
          : Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = constraints.maxWidth < 560
                ? constraints.maxWidth
                : 560.0;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.customizationTitle,
                        style: AppTextStyles.heading,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => _resetAll(context, ref),
                      icon: const Icon(
                        Icons.settings_backup_restore_rounded,
                        size: 18,
                      ),
                      label: Text(l10n.customizationResetAll),
                    ),
                  ],
                ),
                const DecorSeparator(
                  maxWidth: 200,
                  padding: EdgeInsets.only(top: 8, bottom: 20),
                ),
                SizedBox(
                  width: cardWidth,
                  child: _LivePreviewStrip(accent: accent),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: cardWidth,
                  child: AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                l10n.customizationAccentSection,
                                style: AppTextStyles.title,
                              ),
                            ),
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: accent,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: .2),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          l10n.customizationAccentHint,
                          style: AppTextStyles.caption,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.customizationRecommendedColors,
                          style: AppTextStyles.eyebrow,
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            for (final color in AppColors.recommendedAccents)
                              _ColorSwatch(
                                color: color,
                                selected: color.toARGB32() == accent.toARGB32(),
                                onTap: () => _applyColor(ref, color),
                              ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          l10n.customizationCustomColor,
                          style: AppTextStyles.eyebrow,
                        ),
                        const SizedBox(height: 10),
                        HsvColorPicker(
                          initialColor: accent,
                          onChanged: (color) => _applyColor(ref, color),
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: () => _resetColor(ref),
                            icon: const Icon(
                              Icons.restart_alt_rounded,
                              size: 18,
                            ),
                            label: Text(l10n.customizationResetColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: cardWidth,
                  child: AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.customizationWallpapersSection,
                          style: AppTextStyles.title,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          l10n.customizationWallpapersHint,
                          style: AppTextStyles.caption,
                        ),
                        const SizedBox(height: 16),
                        _WallpaperRow(
                          label: l10n.customizationWallpaperApp,
                          slot: WallpaperSlot.app,
                          onPick: () =>
                              _pickWallpaper(context, ref, WallpaperSlot.app),
                          onClear: () =>
                              _clearWallpaper(ref, WallpaperSlot.app),
                        ),
                        const SizedBox(height: 14),
                        _WallpaperRow(
                          label: l10n.customizationWallpaperSidebar,
                          slot: WallpaperSlot.sidebar,
                          onPick: () => _pickWallpaper(
                            context,
                            ref,
                            WallpaperSlot.sidebar,
                          ),
                          onClear: () =>
                              _clearWallpaper(ref, WallpaperSlot.sidebar),
                        ),
                        const SizedBox(height: 14),
                        _WallpaperRow(
                          label: l10n.customizationWallpaperCards,
                          slot: WallpaperSlot.cards,
                          onPick: () =>
                              _pickWallpaper(context, ref, WallpaperSlot.cards),
                          onClear: () =>
                              _clearWallpaper(ref, WallpaperSlot.cards),
                        ),
                        const SizedBox(height: 14),
                        _WallpaperRow(
                          label: l10n.customizationWallpaperBanner,
                          slot: WallpaperSlot.banner,
                          onPick: () => _pickWallpaper(
                            context,
                            ref,
                            WallpaperSlot.banner,
                          ),
                          onClear: () =>
                              _clearWallpaper(ref, WallpaperSlot.banner),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          l10n.customizationDimmingLabel,
                          style: AppTextStyles.eyebrow,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.customizationDimmingHint,
                          style: AppTextStyles.caption,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.image_rounded,
                              size: 16,
                              color: AppColors.textSecondary,
                            ),
                            Expanded(
                              child: Slider(
                                value: dimming,
                                min: 0.3,
                                max: 0.95,
                                activeColor: AppColors.primary,
                                onChanged: (value) => _setDimming(ref, value),
                              ),
                            ),
                            const Icon(
                              Icons.text_fields_rounded,
                              size: 16,
                              color: AppColors.textSecondary,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: cardWidth,
                  child: AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                l10n.customizationPresetsSection,
                                style: AppTextStyles.title,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () => _savePreset(context, ref),
                              icon: const Icon(
                                Icons.bookmark_add_rounded,
                                size: 18,
                              ),
                              label: Text(l10n.customizationSavePreset),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          l10n.customizationPresetsHint,
                          style: AppTextStyles.caption,
                        ),
                        const SizedBox(height: 16),
                        if (presets.isEmpty)
                          Text(
                            l10n.customizationNoPresets,
                            style: AppTextStyles.caption,
                          )
                        else
                          Column(
                            children: [
                              for (final preset in presets)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: _PresetRow(
                                    preset: preset,
                                    onApply: () => _applyPreset(ref, preset),
                                    onDelete: () => _deletePreset(
                                      context,
                                      ref,
                                      preset.name,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _LivePreviewStrip extends StatelessWidget {
  final Color accent;

  const _LivePreviewStrip({required this.accent});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.customizationPreviewLabel, style: AppTextStyles.eyebrow),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [accent, accent.withValues(alpha: .55)],
                  ),
                ),
                child: const Icon(
                  Icons.shield_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_rounded, color: accent, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.customizationPreviewSelected,
                          style: AppTextStyles.caption,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 14),
              FilledButton(
                onPressed: null,
                style: FilledButton.styleFrom(
                  disabledBackgroundColor: accent,
                  disabledForegroundColor: Colors.white,
                ),
                child: Text(l10n.customizationPreviewButton),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PresetRow extends StatelessWidget {
  final ThemePreset preset;
  final VoidCallback onApply;
  final VoidCallback onDelete;

  const _PresetRow({
    required this.preset,
    required this.onApply,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: Color(preset.accentColor),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withValues(alpha: .2)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            preset.name,
            style: AppTextStyles.body,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        TextButton(
          onPressed: onApply,
          child: Text(l10n.customizationPresetApply),
        ),
        IconButton(
          tooltip: l10n.customizationPresetDelete,
          icon: const Icon(Icons.close_rounded, size: 18),
          color: AppColors.textSecondary,
          onPressed: onDelete,
        ),
      ],
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _ColorSwatch({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: selected
                ? Colors.white
                : Colors.white.withValues(alpha: .15),
            width: selected ? 2.4 : 1,
          ),
          boxShadow: selected
              ? [BoxShadow(color: color.withValues(alpha: .6), blurRadius: 10)]
              : null,
        ),
        child: selected
            ? const Icon(Icons.check_rounded, color: Colors.white, size: 18)
            : null,
      ),
    );
  }
}

class _WallpaperRow extends ConsumerWidget {
  final String label;
  final WallpaperSlot slot;
  final VoidCallback onPick;
  final VoidCallback onClear;

  const _WallpaperRow({
    required this.label,
    required this.slot,
    required this.onPick,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final File? file = ref.watch(wallpaperProvider(slot));

    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 56,
            height: 40,
            color: AppColors.surface,
            child: file != null
                ? Image.file(file, fit: BoxFit.cover)
                : const Icon(
                    Icons.image_not_supported_outlined,
                    color: AppColors.textSecondary,
                    size: 18,
                  ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.body),
              Text(
                file != null
                    ? l10n.customizationChangeImage
                    : l10n.customizationNoImage,
                style: AppTextStyles.caption,
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: onPick,
          child: Text(
            file != null
                ? l10n.customizationChangeImage
                : l10n.customizationChooseImage,
          ),
        ),
        if (file != null)
          IconButton(
            tooltip: l10n.customizationRemoveImage,
            icon: const Icon(Icons.close_rounded, size: 18),
            color: AppColors.textSecondary,
            onPressed: onClear,
          ),
      ],
    );
  }
}
