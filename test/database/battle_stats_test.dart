import 'package:flutter_test/flutter_test.dart';
import 'package:wargameboard/database/models/battle_details.dart';
import 'package:wargameboard/database/models/battle_stats.dart';
import 'package:wargameboard/database/tables/battles_table.dart';

BattleDetails _battle(BattleResult? result) => BattleDetails(
      id: 'b-${result?.name ?? 'none'}-${DateTime.now().microsecondsSinceEpoch}',
      result: result,
      playedAt: DateTime(2026, 1, 1),
    );

void main() {
  test('fromBattles counts each result and computes the win rate', () {
    final stats = BattleStats.fromBattles([
      _battle(BattleResult.victory),
      _battle(BattleResult.victory),
      _battle(BattleResult.defeat),
      _battle(BattleResult.draw),
    ]);

    expect(stats.totalGames, 4);
    expect(stats.victories, 2);
    expect(stats.defeats, 1);
    expect(stats.draws, 1);
    expect(stats.winRate, 0.5);
  });

  test('battles without a result count as played but not in the win rate',
      () {
    final stats = BattleStats.fromBattles([
      _battle(BattleResult.victory),
      _battle(null),
    ]);

    expect(stats.totalGames, 2);
    expect(stats.winRate, 1.0);
  });

  test('win rate is 0 with no decided games', () {
    expect(BattleStats.fromBattles([]).winRate, 0);
    expect(BattleStats.fromBattles([_battle(null)]).winRate, 0);
  });
}
