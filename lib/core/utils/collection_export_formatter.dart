import 'dart:convert';

import '../../database/models/collection_item_details.dart';

/// Formate la collection en CSV ou JSON, prêt à copier/partager.
///
/// Volontairement basique (pas de dépendance à un package CSV) : les
/// noms d'unités/factions ne contiennent pas de virgules ni de retours
/// à la ligne dans les données actuelles, donc un échappement minimal
/// suffit.
class CollectionExportFormatter {
  CollectionExportFormatter._();

  static const _csvHeader =
      'Unité,Faction,Possédées,Montées,Apprêtées,Peintes';

  static String toCsv(List<CollectionItemDetails> entries) {
    final buffer = StringBuffer(_csvHeader);
    buffer.writeln();
    for (final entry in entries) {
      buffer.writeln([
        _escapeCsv(entry.datasheetName),
        _escapeCsv(entry.factionName),
        entry.quantity,
        entry.assembled,
        entry.primed,
        entry.painted,
      ].join(','));
    }
    return buffer.toString().trimRight();
  }

  static String _escapeCsv(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }

  static String toJson(List<CollectionItemDetails> entries) {
    final list = entries
        .map((e) => {
              'datasheetName': e.datasheetName,
              'factionName': e.factionName,
              'quantity': e.quantity,
              'assembled': e.assembled,
              'primed': e.primed,
              'painted': e.painted,
            })
        .toList();
    return const JsonEncoder.withIndent(' ').convert(list);
  }
}
