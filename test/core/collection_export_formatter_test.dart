import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:wargameboard/core/utils/collection_export_formatter.dart';
import 'package:wargameboard/database/models/collection_item_details.dart';

void main() {
  final entries = [
    CollectionItemDetails(
      id: 'c1',
      datasheetId: 'ds-1',
      datasheetName: 'Sanguinary Guard',
      factionName: 'Blood Angels',
      quantity: 3,
      assembled: 3,
      primed: 2,
      painted: 1,
      createdAt: DateTime(2026, 1, 1),
    ),
    CollectionItemDetails(
      id: 'c2',
      datasheetId: 'ds-2',
      datasheetName: 'Unit, with comma',
      factionName: 'Blood Angels',
      quantity: 1,
      assembled: 0,
      primed: 0,
      painted: 0,
      createdAt: DateTime(2026, 1, 1),
    ),
  ];

  test('toCsv produces a header row plus one row per entry', () {
    final csv = CollectionExportFormatter.toCsv(entries);
    final lines = csv.split('\n');

    expect(lines[0], 'Unité,Faction,Possédées,Montées,Apprêtées,Peintes');
    expect(lines[1], 'Sanguinary Guard,Blood Angels,3,3,2,1');
    expect(lines.length, 3);
  });

  test('toCsv quotes values containing a comma', () {
    final csv = CollectionExportFormatter.toCsv(entries);
    expect(csv, contains('"Unit, with comma"'));
  });

  test('toJson round-trips the entries as a list of maps', () {
    final json = CollectionExportFormatter.toJson(entries);
    final decoded = jsonDecode(json) as List;

    expect(decoded, hasLength(2));
    expect(decoded.first['datasheetName'], 'Sanguinary Guard');
    expect(decoded.first['painted'], 1);
  });

  test('handles an empty collection', () {
    expect(
      CollectionExportFormatter.toCsv(const []),
      'Unité,Faction,Possédées,Montées,Apprêtées,Peintes',
    );
    expect(jsonDecode(CollectionExportFormatter.toJson(const [])), isEmpty);
  });
}
