import '../tables/battles_table.dart';
import 'battle_details.dart';

/// Statistiques agrégées sur les parties enregistrées.
class BattleStats {
  final int totalGames;
  final int victories;
  final int defeats;
  final int draws;

  const BattleStats({
    required this.totalGames,
    required this.victories,
    required this.defeats,
    required this.draws,
  });

  /// Ratio de victoires sur les parties ayant un résultat renseigné.
  double get winRate {
    final decided = victories + defeats + draws;
    return decided == 0 ? 0 : victories / decided;
  }

  static BattleStats fromBattles(List<BattleDetails> battles) {
    var victories = 0;
    var defeats = 0;
    var draws = 0;
    for (final battle in battles) {
      switch (battle.result) {
        case BattleResult.victory:
          victories++;
        case BattleResult.defeat:
          defeats++;
        case BattleResult.draw:
          draws++;
        case null:
          break;
      }
    }
    return BattleStats(
      totalGames: battles.length,
      victories: victories,
      defeats: defeats,
      draws: draws,
    );
  }
}
