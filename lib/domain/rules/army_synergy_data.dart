import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _assetPath = 'assets/data/army_unit_synergies.json';

/// Table de co-occurrence d'unités (`datasheetId → {autreDatasheetId:
/// nombre de listes de style où les deux apparaissent ensemble}`),
/// générée une fois par `tools/backfill_army_synergies_test.dart` à
/// partir des styles de liste par faction du guide "Exemples de listes
/// d'armée" — sert de signal de synergie pour les recommandations
/// d'unités complémentaires dans l'army builder.
typedef ArmyUnitSynergyMap = Map<String, Map<String, int>>;

/// Charge [_assetPath] une seule fois (mise en cache par Riverpod tant
/// que le provider reste observé). Retourne une map vide si l'asset est
/// absent ou malformé — jamais d'exception qui ferait planter l'army
/// builder pour une fonctionnalité secondaire.
final armySynergyDataProvider = FutureProvider<ArmyUnitSynergyMap>((
  ref,
) async {
  try {
    final raw = await rootBundle.loadString(_assetPath);
    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) return {};
    return {
      for (final entry in decoded.entries)
        if (entry.value is Map<String, dynamic>)
          entry.key: (entry.value as Map<String, dynamic>).map(
            (k, v) => MapEntry(k, v is int ? v : int.tryParse('$v') ?? 0),
          ),
    };
  } catch (_) {
    return {};
  }
});
