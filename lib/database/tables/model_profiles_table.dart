import 'package:drift/drift.dart';

import 'datasheet_models_table.dart';

class ModelProfiles extends Table {
  TextColumn get id => text()();

  TextColumn get datasheetModelId => text().references(DatasheetModels, #id)();

  TextColumn get name => text()();

  IntColumn get movement => integer()();

  IntColumn get toughness => integer()();

  IntColumn get save => integer()();

  IntColumn get wounds => integer()();

  IntColumn get leadership => integer()();

  IntColumn get objectiveControl => integer()();

  /// Valeur "X" d'une sauvegarde invulnérable "X+", ou `null` si le profil
  /// n'en a pas. Volontairement à part de [save] (qui reste la sauvegarde
  /// normale, jamais nulle) plutôt que de réutiliser un -1/0 comme valeur
  /// sentinelle — un vrai `null` distingue sans ambiguïté "pas de sauvegarde
  /// invulnérable" de "sauvegarde invulnérable de 0+".
  IntColumn get invulnerableSave => integer().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
