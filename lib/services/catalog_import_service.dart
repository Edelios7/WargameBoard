import 'dart:convert';

import 'package:drift/drift.dart';

import '../database/app_database.dart';

/// Résultat d'un import de catalogue.
class CatalogImportResult {
  final int datasheets;
  final int weapons;
  final int keywords;
  final int abilities;

  const CatalogImportResult({
    this.datasheets = 0,
    this.weapons = 0,
    this.keywords = 0,
    this.abilities = 0,
  });

  int get total => datasheets + weapons + keywords + abilities;
}

/// Levée quand le JSON fourni ne respecte pas le format attendu.
class CatalogImportException implements Exception {
  final String message;

  const CatalogImportException(this.message);

  @override
  String toString() => message;
}

/// Importe des données de catalogue depuis un document JSON.
///
/// Format attendu (toutes les sections sont optionnelles) :
/// ```json
/// {
///   "factions":  [{"id": "...", "gameSystemId": "...", "name": "..."}],
///   "keywords":  [{"id": "...", "name": "..."}],
///   "abilities": [{"id": "...", "name": "...", "description": "..."}],
///   "weapons": [{
///     "id": "...", "name": "...", "isMelee": false,
///     "profiles": [{"range": 12, "attacks": "1", "ballisticSkill": 3,
///                   "strength": 4, "armorPenetration": -1, "damage": "1"}]
///   }],
///   "datasheets": [{
///     "id": "...", "name": "...", "factionId": "...",
///     "battlefieldRole": "...", "unitType": "...",
///     "points": 90, "editionId": "...",
///     "minimumModels": 1, "maximumModels": 1, "defaultModels": 1,
///     "keywordIds": ["..."], "abilityIds": ["..."],
///     "weaponIds": ["..."],
///     "models": [{"name": "...", "movement": 6, "toughness": 4,
///                 "save": 3, "wounds": 5, "leadership": 6,
///                 "objectiveControl": 1}]
///   }]
/// }
/// ```
///
/// L'import est un upsert : réimporter le même id met à jour la ligne
/// (c'est le mécanisme prévu pour les mises à jour de points/erratas).
/// Tout se joue dans une transaction : un document invalide ne laisse
/// aucune écriture partielle.
class CatalogImportService {
  final AppDatabase database;

  CatalogImportService(this.database);

  Future<CatalogImportResult> importJson(String jsonText) async {
    final dynamic decoded;
    try {
      decoded = jsonDecode(jsonText);
    } on FormatException catch (e) {
      throw CatalogImportException('JSON invalide : ${e.message}');
    }
    if (decoded is! Map<String, dynamic>) {
      throw const CatalogImportException(
        'Le document doit être un objet JSON ({...}).',
      );
    }

    return database.transaction(() async {
      await _importFactions(decoded);
      final keywords = await _importKeywords(decoded);
      final abilities = await _importAbilities(decoded);
      final weapons = await _importWeapons(decoded);
      final datasheets = await _importDatasheets(decoded);
      return CatalogImportResult(
        keywords: keywords,
        abilities: abilities,
        weapons: weapons,
        datasheets: datasheets,
      );
    });
  }

  Future<void> _importFactions(Map<String, dynamic> root) async {
    final items = _section(root, 'factions');
    for (final item in items) {
      final gameSystemId =
          _require<String>(item, 'gameSystemId', 'factions');
      final systemExists = await (database.select(database.gameSystems)
            ..where((t) => t.id.equals(gameSystemId)))
          .getSingleOrNull();
      if (systemExists == null) {
        throw CatalogImportException(
          'Système de jeu inconnu "$gameSystemId" dans "factions".',
        );
      }
      await database.into(database.factions).insertOnConflictUpdate(
            FactionsCompanion.insert(
              id: _require<String>(item, 'id', 'factions'),
              gameSystemId: gameSystemId,
              name: _require<String>(item, 'name', 'factions'),
            ),
          );
    }
  }

  List<Map<String, dynamic>> _section(Map<String, dynamic> root, String key) {
    final value = root[key];
    if (value == null) return const [];
    if (value is! List) {
      throw CatalogImportException('"$key" doit être une liste.');
    }
    return value.map((item) {
      if (item is! Map<String, dynamic>) {
        throw CatalogImportException(
          'Chaque entrée de "$key" doit être un objet.',
        );
      }
      return item;
    }).toList();
  }

  T _require<T>(Map<String, dynamic> item, String field, String section) {
    final value = item[field];
    if (value is! T) {
      throw CatalogImportException(
        'Champ "$field" manquant ou invalide dans "$section" '
        '(entrée ${item['id'] ?? '?'}).',
      );
    }
    return value;
  }

  Future<int> _importKeywords(Map<String, dynamic> root) async {
    final items = _section(root, 'keywords');
    for (final item in items) {
      await database.into(database.keywords).insertOnConflictUpdate(
            KeywordsCompanion.insert(
              id: _require<String>(item, 'id', 'keywords'),
              name: _require<String>(item, 'name', 'keywords'),
            ),
          );
    }
    return items.length;
  }

  Future<int> _importAbilities(Map<String, dynamic> root) async {
    final items = _section(root, 'abilities');
    for (final item in items) {
      await database.into(database.abilities).insertOnConflictUpdate(
            AbilitiesCompanion.insert(
              id: _require<String>(item, 'id', 'abilities'),
              name: _require<String>(item, 'name', 'abilities'),
              description:
                  _require<String>(item, 'description', 'abilities'),
              type: Value(item['type'] as String?),
            ),
          );
    }
    return items.length;
  }

  Future<int> _importWeapons(Map<String, dynamic> root) async {
    final items = _section(root, 'weapons');
    for (final item in items) {
      final weaponId = _require<String>(item, 'id', 'weapons');
      final isMelee = item['isMelee'] as bool? ?? false;
      await database.into(database.weapons).insertOnConflictUpdate(
            WeaponsCompanion.insert(
              id: weaponId,
              name: _require<String>(item, 'name', 'weapons'),
              isMelee: Value(isMelee),
              isRanged: Value(!isMelee),
            ),
          );

      final profiles = item['profiles'];
      if (profiles is List) {
        // Remplace les profils existants : le document importé fait foi.
        await (database.delete(database.weaponProfiles)
              ..where((t) => t.weaponId.equals(weaponId)))
            .go();
        for (var i = 0; i < profiles.length; i++) {
          final profile = profiles[i];
          if (profile is! Map<String, dynamic>) {
            throw CatalogImportException(
              'Profil invalide pour l\'arme $weaponId.',
            );
          }
          await database.into(database.weaponProfiles).insert(
                WeaponProfilesCompanion.insert(
                  id: 'wpp-$weaponId-$i',
                  weaponId: weaponId,
                  name: profile['name'] as String? ?? 'Standard',
                  range: _require<int>(profile, 'range', 'profiles'),
                  attacks: _require<String>(profile, 'attacks', 'profiles'),
                  ballisticSkill: Value(profile['ballisticSkill'] as int?),
                  weaponSkill: Value(profile['weaponSkill'] as int?),
                  strength: _require<int>(profile, 'strength', 'profiles'),
                  armorPenetration:
                      _require<int>(profile, 'armorPenetration', 'profiles'),
                  damage: _require<String>(profile, 'damage', 'profiles'),
                ),
              );
        }
      }
    }
    return items.length;
  }

  Future<int> _importDatasheets(Map<String, dynamic> root) async {
    final items = _section(root, 'datasheets');
    for (final item in items) {
      final datasheetId = _require<String>(item, 'id', 'datasheets');
      final factionId = _require<String>(item, 'factionId', 'datasheets');

      final factionExists = await (database.select(database.factions)
            ..where((t) => t.id.equals(factionId)))
          .getSingleOrNull();
      if (factionExists == null) {
        throw CatalogImportException(
          'Faction inconnue "$factionId" pour la datasheet $datasheetId.',
        );
      }

      await database.into(database.datasheets).insertOnConflictUpdate(
            DatasheetsCompanion.insert(
              id: datasheetId,
              factionId: factionId,
              name: _require<String>(item, 'name', 'datasheets'),
              battlefieldRole:
                  _require<String>(item, 'battlefieldRole', 'datasheets'),
              unitType: _require<String>(item, 'unitType', 'datasheets'),
            ),
          );

      final points = item['points'] as int?;
      final editionId = item['editionId'] as String?;
      if (points != null && editionId != null) {
        await database.into(database.datasheetCosts).insertOnConflictUpdate(
              DatasheetCostsCompanion.insert(
                id: 'cost-$datasheetId',
                datasheetId: datasheetId,
                editionId: editionId,
                points: points,
              ),
            );
      }

      final minModels = item['minimumModels'] as int?;
      final maxModels = item['maximumModels'] as int?;
      if (minModels != null && maxModels != null) {
        await database.into(database.unitSizes).insertOnConflictUpdate(
              UnitSizesCompanion.insert(
                id: 'size-$datasheetId',
                datasheetId: datasheetId,
                minimumModels: minModels,
                maximumModels: maxModels,
                defaultModels: item['defaultModels'] as int? ?? minModels,
              ),
            );
      }

      final models = item['models'];
      if (models is List) {
        // Le document importé fait foi : remplace les modèles existants.
        final oldModels = await (database.select(database.datasheetModels)
              ..where((t) => t.datasheetId.equals(datasheetId)))
            .get();
        for (final oldModel in oldModels) {
          await (database.delete(database.modelProfiles)
                ..where((t) => t.datasheetModelId.equals(oldModel.id)))
              .go();
        }
        await (database.delete(database.datasheetModels)
              ..where((t) => t.datasheetId.equals(datasheetId)))
            .go();

        for (var i = 0; i < models.length; i++) {
          final model = models[i];
          if (model is! Map<String, dynamic>) {
            throw CatalogImportException(
              'Modèle invalide pour la datasheet $datasheetId.',
            );
          }
          final modelId = 'dm-$datasheetId-$i';
          final modelName = _require<String>(model, 'name', 'models');
          await database.into(database.datasheetModels).insert(
                DatasheetModelsCompanion.insert(
                  id: modelId,
                  datasheetId: datasheetId,
                  name: modelName,
                  displayOrder: Value(i),
                ),
              );
          await database.into(database.modelProfiles).insert(
                ModelProfilesCompanion.insert(
                  id: 'mp-$datasheetId-$i',
                  datasheetModelId: modelId,
                  name: modelName,
                  movement: _require<int>(model, 'movement', 'models'),
                  toughness: _require<int>(model, 'toughness', 'models'),
                  save: _require<int>(model, 'save', 'models'),
                  wounds: _require<int>(model, 'wounds', 'models'),
                  leadership: _require<int>(model, 'leadership', 'models'),
                  objectiveControl:
                      _require<int>(model, 'objectiveControl', 'models'),
                ),
              );
        }
      }

      final weaponIds = item['weaponIds'];
      if (weaponIds is List && models is List && models.isNotEmpty) {
        // Rattache les armes au premier modèle de la datasheet. On
        // supprime d'abord les liens existants : le document importé fait
        // foi, y compris pour retirer une arme qui ne devrait plus y
        // figurer.
        const modelIndex = 0;
        await (database.delete(database.datasheetWeapons)
              ..where((t) =>
                  t.datasheetModelId.equals('dm-$datasheetId-$modelIndex')))
            .go();
        for (final weaponId in weaponIds.cast<String>()) {
          await database
              .into(database.datasheetWeapons)
              .insertOnConflictUpdate(
                DatasheetWeaponsCompanion.insert(
                  id: 'dw-$datasheetId-$weaponId',
                  datasheetModelId: 'dm-$datasheetId-$modelIndex',
                  weaponId: weaponId,
                  isDefault: const Value(true),
                ),
              );
        }
      }

      final keywordIds = item['keywordIds'];
      if (keywordIds is List) {
        // Le document importé fait foi : on retire d'abord les liens
        // existants pour que les mots-clés qui en ont disparu le soient
        // aussi côté base (sinon ils restent affichés indéfiniment).
        await (database.delete(database.datasheetKeywordLinks)
              ..where((t) => t.datasheetId.equals(datasheetId)))
            .go();
        for (final keywordId in keywordIds.cast<String>()) {
          await database
              .into(database.datasheetKeywordLinks)
              .insertOnConflictUpdate(
                DatasheetKeywordLinksCompanion.insert(
                  id: 'dkl-$datasheetId-$keywordId',
                  datasheetId: datasheetId,
                  keywordId: keywordId,
                ),
              );
        }
      }

      final abilityIds = item['abilityIds'];
      if (abilityIds is List) {
        // Même logique que pour les mots-clés ci-dessus : purge avant
        // réinsertion pour refléter les suppressions du document importé.
        await (database.delete(database.datasheetAbilityLinks)
              ..where((t) => t.datasheetId.equals(datasheetId)))
            .go();
        for (final abilityId in abilityIds.cast<String>()) {
          await database
              .into(database.datasheetAbilityLinks)
              .insertOnConflictUpdate(
                DatasheetAbilityLinksCompanion.insert(
                  id: 'dal-$datasheetId-$abilityId',
                  datasheetId: datasheetId,
                  abilityId: abilityId,
                ),
              );
        }
      }
    }
    return items.length;
  }
}
