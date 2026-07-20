import '../../database/models/army_details.dart';

/// Formate une armée en texte lisible, prêt à être copié/partagé.
class ArmyListFormatter {
  ArmyListFormatter._();

  static String format(ArmyDetails army) {
    final buffer = StringBuffer();

    buffer.writeln('${army.name} — ${army.factionName}');
    if (army.detachmentName != null) {
      buffer.writeln('Détachement : ${army.detachmentName}');
    }
    buffer.writeln(
      army.pointsLimit != null
          ? '${army.totalPoints} / ${army.pointsLimit} pts'
          : '${army.totalPoints} pts',
    );
    buffer.writeln();

    for (final unit in army.units) {
      buffer.write('- ${unit.datasheetName} x${unit.modelCount}');
      buffer.write(' (${unit.points} pts)');
      if (unit.enhancementName != null) {
        buffer.write(' [${unit.enhancementName} +${unit.enhancementPoints} pts]');
      }
      buffer.writeln();
    }

    if (army.notes != null && army.notes!.trim().isNotEmpty) {
      buffer.writeln();
      buffer.writeln('Notes : ${army.notes}');
    }

    return buffer.toString().trimRight();
  }
}
