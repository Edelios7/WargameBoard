import 'package:drift/drift.dart';

import 'datasheets_table.dart';

/// Fiches épinglées par le joueur pour un accès rapide depuis le Catalogue
/// (bouton étoile) — la présence d'une ligne vaut "favori", pas de colonne
/// booléenne nécessaire.
class FavoriteDatasheets extends Table {
  TextColumn get datasheetId => text().references(Datasheets, #id)();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {datasheetId};
}
