import 'package:drift/drift.dart';

/// Une des 5 postures de bataille ("Force Disposition", pack de missions
/// GDM 2026) : chaque joueur en choisit une en secret, et le croisement
/// avec celle de l'adversaire détermine la mission primaire de chacun
/// (voir [PrimaryMissions]).
class MissionDispositions extends Table {
  TextColumn get id => text()();

  TextColumn get slug => text()();

  TextColumn get name => text()();

  @override
  Set<Column> get primaryKey => {id};
}
