import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/catalog_provider.dart';
import '../../../shell/navigation.dart';

class ExplorerPage extends ConsumerStatefulWidget {
  const ExplorerPage({super.key});

  @override
  ConsumerState<ExplorerPage> createState() => _ExplorerPageState();
}

class _ExplorerPageState extends ConsumerState<ExplorerPage> {
  int _tab = 0;
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.navExplorer, style: AppTextStyles.heading),
            const SizedBox(height: 16),
            Row(
              children: [
                _TabChip(
                  label: l10n.explorerTabKeywords,
                  selected: _tab == 0,
                  onTap: () => setState(() => _tab = 0),
                ),
                const SizedBox(width: 8),
                _TabChip(
                  label: l10n.explorerTabAbilities,
                  selected: _tab == 1,
                  onTap: () => setState(() => _tab = 1),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              onChanged: (value) => setState(() => _query = value),
              style: AppTextStyles.body,
              decoration: InputDecoration(
                hintText: l10n.explorerSearchHint,
                hintStyle: AppTextStyles.caption,
                filled: true,
                fillColor: AppColors.surface,
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppColors.textSecondary,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.border),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _tab == 0 ? _keywordsList(l10n) : _abilitiesList(l10n),
            ),
          ],
        ),
      ),
    );
  }

  Widget _keywordsList(AppLocalizations l10n) {
    final keywordsAsync = ref.watch(keywordsListProvider);

    return keywordsAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
      error: (error, _) =>
          Center(child: Text('$error', style: AppTextStyles.caption)),
      data: (keywords) {
        final filtered = keywords
            .where((k) =>
                k.name.toLowerCase().contains(_query.toLowerCase()))
            .toList()
          ..sort((a, b) => a.name.compareTo(b.name));

        if (filtered.isEmpty) {
          return Center(
            child: Text(l10n.explorerEmpty, style: AppTextStyles.caption),
          );
        }

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 340,
            mainAxisExtent: 130,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            final keyword = filtered[index];
            return AppCard(
              onTap: () {
                ref.read(catalogKeywordFilterProvider.notifier).state =
                    keyword.id;
                ref.read(catalogSearchQueryProvider.notifier).state = '';
                ref.read(selectedTabProvider.notifier).state =
                    AppTab.catalog;
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    keyword.name,
                    style: AppTextStyles.body,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  if (keyword.description != null)
                    Expanded(
                      child: Text(
                        keyword.description!,
                        style: AppTextStyles.caption,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  const Spacer(),
                  Text(
                    l10n.explorerViewInCatalog,
                    style:
                        AppTextStyles.caption.copyWith(color: AppColors.primary),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _abilitiesList(AppLocalizations l10n) {
    final abilitiesAsync = ref.watch(abilitiesListProvider);

    return abilitiesAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
      error: (error, _) =>
          Center(child: Text('$error', style: AppTextStyles.caption)),
      data: (abilities) {
        final filtered = abilities
            .where((a) =>
                a.name.toLowerCase().contains(_query.toLowerCase()))
            .toList()
          ..sort((a, b) => a.name.compareTo(b.name));

        if (filtered.isEmpty) {
          return Center(
            child: Text(l10n.explorerEmpty, style: AppTextStyles.caption),
          );
        }

        return ListView.builder(
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            final ability = filtered[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(ability.name, style: AppTextStyles.body),
                        ),
                        if (ability.type != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: .18),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              ability.type!,
                              style: AppTextStyles.caption
                                  .copyWith(color: AppColors.primary),
                            ),
                          ),
                      ],
                    ),
                    if (ability.description.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(ability.description, style: AppTextStyles.caption),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _TabChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary.withValues(alpha: .18) : AppColors.surface,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
            ),
          ),
          child: Text(
            label,
            style: AppTextStyles.body.copyWith(
              color: selected ? AppColors.primary : AppColors.textPrimary,
              fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
