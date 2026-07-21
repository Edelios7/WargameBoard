import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../database/models/weapon_summary.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/catalog_provider.dart';

enum _WeaponTypeFilter { all, ranged, melee }

class WeaponsInventoryPage extends ConsumerStatefulWidget {
  const WeaponsInventoryPage({super.key});

  @override
  ConsumerState<WeaponsInventoryPage> createState() =>
      _WeaponsInventoryPageState();
}

class _WeaponsInventoryPageState extends ConsumerState<WeaponsInventoryPage> {
  final _searchController = TextEditingController();
  String _query = '';
  _WeaponTypeFilter _typeFilter = _WeaponTypeFilter.all;
  bool _missingProfileOnly = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final weaponsAsync = ref.watch(weaponsInventoryProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.arrow_back_rounded,
                      size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 6),
                  Text(
                    l10n.catalogBackToCatalog,
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(l10n.catalogWeaponsTitle, style: AppTextStyles.heading),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth > 700;
                final search = SizedBox(
                  width: wide ? 320 : double.infinity,
                  child: TextField(
                    controller: _searchController,
                    style: AppTextStyles.body,
                    onChanged: (value) => setState(() => _query = value),
                    decoration: InputDecoration(
                      hintText: l10n.catalogWeaponsSearchHint,
                      hintStyle: AppTextStyles.caption,
                      filled: true,
                      fillColor: AppColors.surface,
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        size: 18,
                        color: AppColors.textSecondary,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppColors.border),
                      ),
                    ),
                  ),
                );
                final filters = Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _TypeChip(
                      label: l10n.catalogWeaponsFilterAll,
                      selected: _typeFilter == _WeaponTypeFilter.all,
                      onTap: () =>
                          setState(() => _typeFilter = _WeaponTypeFilter.all),
                    ),
                    _TypeChip(
                      label: l10n.catalogWeaponsFilterRanged,
                      selected: _typeFilter == _WeaponTypeFilter.ranged,
                      onTap: () => setState(
                          () => _typeFilter = _WeaponTypeFilter.ranged),
                    ),
                    _TypeChip(
                      label: l10n.catalogWeaponsFilterMelee,
                      selected: _typeFilter == _WeaponTypeFilter.melee,
                      onTap: () => setState(
                          () => _typeFilter = _WeaponTypeFilter.melee),
                    ),
                    const SizedBox(width: 4),
                    _TypeChip(
                      label: l10n.catalogWeaponsFilterMissingProfile,
                      selected: _missingProfileOnly,
                      accentColor: AppColors.warning,
                      onTap: () => setState(
                          () => _missingProfileOnly = !_missingProfileOnly),
                    ),
                  ],
                );

                if (!wide) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      search,
                      const SizedBox(height: 12),
                      filters,
                    ],
                  );
                }
                return Row(
                  children: [
                    search,
                    const SizedBox(width: 16),
                    Expanded(child: filters),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: weaponsAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
                error: (error, _) => Center(
                  child: Text('$error', style: AppTextStyles.caption),
                ),
                data: (weapons) {
                  final filtered = weapons.where((weapon) {
                    if (_query.isNotEmpty &&
                        !weapon.name
                            .toLowerCase()
                            .contains(_query.toLowerCase())) {
                      return false;
                    }
                    switch (_typeFilter) {
                      case _WeaponTypeFilter.ranged:
                        if (!weapon.isRanged) return false;
                        break;
                      case _WeaponTypeFilter.melee:
                        if (!weapon.isMelee) return false;
                        break;
                      case _WeaponTypeFilter.all:
                        break;
                    }
                    if (_missingProfileOnly && weapon.hasProfile) {
                      return false;
                    }
                    return true;
                  }).toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.catalogWeaponsCount(filtered.length),
                        style: AppTextStyles.eyebrow,
                      ),
                      const SizedBox(height: 8),
                      if (filtered.isEmpty)
                        Expanded(
                          child: Center(
                            child: Text(
                              l10n.catalogWeaponsEmpty,
                              style: AppTextStyles.caption,
                            ),
                          ),
                        )
                      else
                        Expanded(
                          child: ListView.separated(
                            itemCount: filtered.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 8),
                            itemBuilder: (context, index) =>
                                _WeaponRow(weapon: filtered[index]),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color accentColor;

  const _TypeChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.accentColor = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? accentColor.withValues(alpha: .16)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? accentColor : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: selected ? accentColor : AppColors.textSecondary,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class _WeaponRow extends StatelessWidget {
  final WeaponSummary weapon;

  const _WeaponRow({required this.weapon});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: weapon.hasProfile ? AppColors.border : AppColors.warning,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                weapon.isMelee
                    ? Icons.sports_martial_arts_rounded
                    : Icons.gps_fixed_rounded,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  weapon.name,
                  style: AppTextStyles.body,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                l10n.catalogWeaponsUsedBy(weapon.usedByCount),
                style: AppTextStyles.caption,
              ),
            ],
          ),
          if (weapon.hasProfile) ...[
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: const {
                  0: FixedColumnWidth(120),
                  1: FixedColumnWidth(60),
                  2: FixedColumnWidth(60),
                  3: FixedColumnWidth(50),
                  4: FixedColumnWidth(50),
                  5: FixedColumnWidth(50),
                },
                children: [
                  TableRow(
                    children: [
                      _headerCell(l10n.weaponColName),
                      _headerCell(l10n.weaponColRange),
                      _headerCell(l10n.weaponColAttacks),
                      _headerCell(l10n.weaponColStrength),
                      _headerCell(l10n.weaponColAp),
                      _headerCell(l10n.weaponColDamage),
                    ],
                  ),
                  for (final profile in weapon.profiles)
                    TableRow(
                      children: [
                        _cell(profile.name),
                        _cell(profile.isMelee
                            ? l10n.weaponMelee
                            : '${profile.range}"'),
                        _cell(profile.attacks),
                        _cell('${profile.strength}'),
                        _cell('${profile.armorPenetration}'),
                        _cell(profile.damage),
                      ],
                    ),
                ],
              ),
            ),
          ] else ...[
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.warning_amber_rounded,
                    size: 14, color: AppColors.warning),
                const SizedBox(width: 4),
                Text(
                  l10n.catalogWeaponsNoProfile,
                  style:
                      AppTextStyles.caption.copyWith(color: AppColors.warning),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _headerCell(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(label, style: AppTextStyles.eyebrow),
    );
  }

  Widget _cell(String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        value,
        style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
