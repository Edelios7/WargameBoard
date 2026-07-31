import 'dart:math';

/// Moyenne d'une notation de dés simple (`"3"`, `"D6"`, `"2D6"`, `"D3+1"`) —
/// repli conservateur à 1 si le format n'est pas reconnu, ne doit jamais
/// lancer d'exception sur une donnée de catalogue.
double diceNotationAverage(String expr) {
  final trimmed = expr.trim();
  final plain = int.tryParse(trimmed);
  if (plain != null) return plain.toDouble();

  final match = RegExp(
    r'^(\d+)?D(\d+)(?:\+(\d+))?$',
    caseSensitive: false,
  ).firstMatch(trimmed);
  if (match == null) return 1;

  final count = int.tryParse(match.group(1) ?? '1') ?? 1;
  final die = int.tryParse(match.group(2) ?? '0') ?? 0;
  final bonus = int.tryParse(match.group(3) ?? '0') ?? 0;
  return count * (die + 1) / 2 + bonus;
}

/// Jet réel d'une notation de dés simple (même formats que
/// [diceNotationAverage]) — repli conservateur à 1 si le format n'est pas
/// reconnu, ne doit jamais lancer d'exception sur une donnée de catalogue.
int rollDiceNotation(Random random, String expr) {
  final trimmed = expr.trim();
  final plain = int.tryParse(trimmed);
  if (plain != null) return plain;

  final match = RegExp(
    r'^(\d+)?D(\d+)(?:\+(\d+))?$',
    caseSensitive: false,
  ).firstMatch(trimmed);
  if (match == null) return 1;

  final count = int.tryParse(match.group(1) ?? '1') ?? 1;
  final die = int.tryParse(match.group(2) ?? '0') ?? 0;
  final bonus = int.tryParse(match.group(3) ?? '0') ?? 0;
  if (die <= 0) return bonus;

  var total = bonus;
  for (var i = 0; i < count; i++) {
    total += random.nextInt(die) + 1;
  }
  return total;
}
