import 'package:drift/drift.dart';

/// Une mission secondaire (18 au total). Les cartes attaquant/défenseur
/// ont un texte identique à quelques exceptions cosmétiques près, donc
/// une seule ligne par mission suffit (pas de distinction de rôle ici).
class SecondaryMissions extends Table {
  TextColumn get id => text()();

  TextColumn get slug => text()();

  TextColumn get name => text()();

  BoolColumn get isFixed => boolean().withDefault(const Constant(false))();

  TextColumn get effect => text()();

  @override
  Set<Column> get primaryKey => {id};
}
