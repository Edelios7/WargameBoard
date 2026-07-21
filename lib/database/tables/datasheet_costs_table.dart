import 'package:drift/drift.dart';

class DatasheetCosts extends Table {
  TextColumn get id => text()();

  TextColumn get datasheetId => text()();

  TextColumn get editionId => text()();

  IntColumn get points => integer()();

  /// Nombre de figurines auquel ce coût s'applique. `null` signifie que
  /// la fiche n'a qu'un seul palier de coût (unité à taille fixe, ou
  /// donnée historique important qui n'a pas encore de palier détaillé) :
  /// dans ce cas ce coût s'applique quel que soit l'effectif choisi.
  ///
  /// Une même fiche peut avoir plusieurs lignes ici (une par palier
  /// officiel, ex. 5 modèles / 10 modèles), chacune avec un coût propre —
  /// contrairement aux datasheets qui montent en coût de façon linéaire,
  /// beaucoup d'unités Warhammer 40k ont un coût par palier qui n'est pas
  /// un simple multiple du coût de base.
  IntColumn get modelCount => integer().nullable()();

  IntColumn get powerLevel =>
      integer().nullable()();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}