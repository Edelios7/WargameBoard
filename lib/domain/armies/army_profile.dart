import '../../database/models/army_details.dart';
import '../../database/models/datasheet_details.dart';
import '../../l10n/app_localizations.dart';

/// Les 5 axes utilisés pour le radar de forces/faiblesses d'une armée
/// (voir [RadarChart] dans `lib/core/widgets/radar_chart.dart`).
enum ArmyProfileAxis { tir, corpsACorps, resilience, mobilite, controle }

/// Scores 0-100 par axe pour une armée donnée — une estimation
/// pédagogique dérivée des caractéristiques déjà en base (armes,
/// modèles), pas un outil de simulation compétitive précis. Comparable
/// entre petites et grosses armées : chaque axe est une densité de
/// puissance par point dépensé (sauf [mobilite], une moyenne pondérée),
/// pas une somme brute qui grossirait avec le nombre d'unités.
class ArmyProfileScores {
  final double tir;
  final double corpsACorps;
  final double resilience;
  final double mobilite;
  final double controle;

  const ArmyProfileScores({
    required this.tir,
    required this.corpsACorps,
    required this.resilience,
    required this.mobilite,
    required this.controle,
  });

  Map<ArmyProfileAxis, double> get byAxis => {
    ArmyProfileAxis.tir: tir,
    ArmyProfileAxis.corpsACorps: corpsACorps,
    ArmyProfileAxis.resilience: resilience,
    ArmyProfileAxis.mobilite: mobilite,
    ArmyProfileAxis.controle: controle,
  };

  static const zero = ArmyProfileScores(
    tir: 0,
    corpsACorps: 0,
    resilience: 0,
    mobilite: 0,
    controle: 0,
  );
}

/// Le ou les axes dominants d'une armée — vide si tous les axes sont
/// proches (armée équilibrée), un axe si un seul se détache nettement,
/// deux si les deux premiers sont à moins de 10 points d'écart.
class ArmyProfileResult {
  final List<ArmyProfileAxis> dominantAxes;

  const ArmyProfileResult(this.dominantAxes);

  bool get isBalanced => dominantAxes.isEmpty;
}

// Plafonds empiriques par axe utilisés pour ramener chaque densité sur une
// échelle 0-100 — des constantes ajustables à la main, pas calibrées sur
// des données statistiques ; le but est un radar lisible et globalement
// cohérent, pas une mesure compétitive précise.
const _tirCeiling = 0.35;
const _corpsACorpsCeiling = 0.35;
const _resilienceCeiling = 1.2;
const _mobiliteCeilingInches = 20.0;
const _controleCeiling = 0.3;

/// Calcule le profil de forces/faiblesses d'une armée à partir de ses
/// unités et des fiches détaillées correspondantes (mêmes armes/modèles
/// que ceux affichés dans le catalogue). Les unités dont la fiche est
/// absente de [datasheetsById] (chargement en cours, catalogue
/// incomplet) sont simplement ignorées — jamais d'exception.
ArmyProfileScores computeArmyProfile(
  ArmyDetails army,
  Map<String, DatasheetDetails> datasheetsById,
) {
  if (army.units.isEmpty || army.totalPoints <= 0) {
    return ArmyProfileScores.zero;
  }

  var tirRaw = 0.0;
  var corpsACorpsRaw = 0.0;
  var resilienceRaw = 0.0;
  var controleRaw = 0.0;
  var mobiliteWeightedSum = 0.0;
  var mobiliteWeightTotal = 0;

  for (final unit in army.units) {
    final sheet = datasheetsById[unit.datasheetId];
    if (sheet == null) continue;
    // Chaque axe est une densité de puissance PAR POINT dépensé — une
    // unité à coût inconnu (points = 0 par convention arithmétique, cf.
    // ArmyUnitDetails.hasUnknownCost) ne peut pas y être représentée
    // équitablement : l'inclure gonflerait artificiellement tir/CAC/
    // résilience/contrôle (comptés via modelCount, sans rapport avec le
    // coût) sans jamais faire grossir le dénominateur totalPoints. La
    // mobilité l'excluait déjà (pondérée par unit.points) — on applique
    // la même règle aux quatre autres axes pour rester cohérent.
    if (unit.hasUnknownCost) continue;
    final modelCount = unit.modelCount > 0 ? unit.modelCount : 1;

    for (final weapon in sheet.weapons) {
      for (final profile in weapon.profiles) {
        final power = _diceAverage(profile.attacks) * _diceAverage(profile.damage);
        if (profile.isMelee) {
          corpsACorpsRaw += power * modelCount;
        } else {
          tirRaw += power * modelCount;
        }
      }
    }

    if (sheet.models.isNotEmpty) {
      var avgResilience = 0.0;
      var avgMovement = 0.0;
      var avgControle = 0.0;
      for (final model in sheet.models) {
        final survivability = ((7 - model.save) / 6).clamp(0.0, 1.0);
        avgResilience += model.wounds * model.toughness * survivability;
        avgMovement += model.movement;
        avgControle += model.objectiveControl;
      }
      final n = sheet.models.length;
      resilienceRaw += (avgResilience / n) * modelCount;
      controleRaw += (avgControle / n) * modelCount;
      mobiliteWeightedSum += (avgMovement / n) * unit.points;
      mobiliteWeightTotal += unit.points;
    }
  }

  final totalPoints = army.totalPoints;
  final mobiliteAvg = mobiliteWeightTotal > 0
      ? mobiliteWeightedSum / mobiliteWeightTotal
      : 0.0;

  return ArmyProfileScores(
    tir: _normalize(tirRaw / totalPoints, _tirCeiling),
    corpsACorps: _normalize(corpsACorpsRaw / totalPoints, _corpsACorpsCeiling),
    resilience: _normalize(resilienceRaw / totalPoints, _resilienceCeiling),
    mobilite: _normalize(mobiliteAvg, _mobiliteCeilingInches),
    controle: _normalize(controleRaw / totalPoints, _controleCeiling),
  );
}

double _normalize(double value, double ceiling) {
  if (ceiling <= 0) return 0;
  return (value / ceiling * 100).clamp(0, 100);
}

/// Moyenne d'une notation de dés simple (`"3"`, `"D6"`, `"2D6"`,
/// `"D3+1"`) — repli conservateur à 1 si le format n'est pas reconnu,
/// ne doit jamais lancer d'exception sur une donnée de catalogue.
double _diceAverage(String expr) {
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

/// Le ou les axes dominants d'un profil — voir [ArmyProfileResult].
ArmyProfileResult dominantProfile(ArmyProfileScores scores) {
  final entries = scores.byAxis.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));

  if (entries.first.value - entries.last.value < 15) {
    return const ArmyProfileResult([]);
  }
  if (entries[0].value - entries[1].value < 10) {
    return ArmyProfileResult([entries[0].key, entries[1].key]);
  }
  return ArmyProfileResult([entries[0].key]);
}

String armyProfileAxisName(AppLocalizations l10n, ArmyProfileAxis axis) {
  switch (axis) {
    case ArmyProfileAxis.tir:
      return l10n.armyProfileAxisTir;
    case ArmyProfileAxis.corpsACorps:
      return l10n.armyProfileAxisCorpsACorps;
    case ArmyProfileAxis.resilience:
      return l10n.armyProfileAxisResilience;
    case ArmyProfileAxis.mobilite:
      return l10n.armyProfileAxisMobilite;
    case ArmyProfileAxis.controle:
      return l10n.armyProfileAxisControle;
  }
}

/// Libellé du profil dominant, ex. "Tir", "Tir / Corps-à-corps", ou
/// "Équilibrée" si aucun axe ne se détache — à afficher sous un titre
/// "Profil d'armée" côté UI, pas une phrase complète en soi.
String armyProfileLabel(AppLocalizations l10n, ArmyProfileResult result) {
  if (result.isBalanced) return l10n.armyProfileLabelEquilibree;
  return result.dominantAxes
      .map((axis) => armyProfileAxisName(l10n, axis))
      .join(' / ');
}
