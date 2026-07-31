import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_wallpapers.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/decor_separator.dart';
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final accent = ref.watch(accentColorProvider);

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
                Text(l10n.customizationTitle, style: AppTextStyles.heading),
                const DecorSeparator(
                  maxWidth: 200,
                  padding: EdgeInsets.only(top: 8, bottom: 20),
                ),
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
