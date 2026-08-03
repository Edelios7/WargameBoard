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

  /// À partir de quelle copie de cette datasheet (1re, 2e, 3e...) dans une
  /// même liste d'armée ce palier s'applique. `null` signifie "s'applique
  /// dès la 1re copie" (comportement historique, valeur par défaut).
  ///
  /// Beaucoup d'unités du MFM coûtent plus cher à partir d'un certain
  /// nombre d'exemplaires dans la même liste (ex. "de la 1re à la 2e unité :
  /// 150 pts", "3e unité et suivantes : 165 pts") : ce champ permet de
  /// stocker ces deux paliers côte à côte pour un même `modelCount`,
  /// distingués par leur seuil de déclenchement plutôt que par leur taille.
  IntColumn get minCopyIndex => integer().nullable()();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}