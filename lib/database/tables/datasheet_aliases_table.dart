import 'package:drift/drift.dart';

/// Noms alternatifs d'une fiche (ex. le nom anglais officiel d'une fiche
/// dont le nom principal est en français) — utilisés uniquement pour la
/// recherche : taper "veteran squad" doit retrouver "Escouade de
/// Vétérans" et inversement, sans dupliquer/traduire le nom affiché
/// partout ailleurs dans l'app (voir DatasheetDao.search).
class DatasheetAliases extends Table {
  TextColumn get id => text()();

  TextColumn get datasheetId => text()();

  TextColumn get name => text()();

  @override
  Set<Column> get primaryKey => {id};
}
