import 'package:flutter_test/flutter_test.dart';
import 'package:wargameboard/domain/rules/army_list_style_parser.dart';
import 'package:wargameboard/domain/rules/rule_document.dart';

void main() {
  group('parseStyleBody', () {
    test('parses a nominal body with a multiplier line', () {
      final style = parseStyleBody(
        'Marée Verte',
        'Une horde qui submerge par le nombre.'
        '\n\n4 × Boyz — 320 pts\nGhazghkull Thraka — 235 pts'
        ' — Total : 555 pts',
      );

      expect(style, isNotNull);
      expect(style!.name, 'Marée Verte');
      expect(style.description, 'Une horde qui submerge par le nombre.');
      expect(style.totalPoints, 555);
      expect(style.units, hasLength(2));
      expect(style.units[0].quantity, 4);
      expect(style.units[0].name, 'Boyz');
      expect(style.units[0].lineTotalPoints, 320);
      expect(style.units[1].quantity, 1);
      expect(style.units[1].name, 'Ghazghkull Thraka');
    });

    test('parses a line without a multiplier as quantity 1', () {
      final style = parseStyleBody(
        'Style Test',
        'Description.\n\nEscouade Intercessor — 80 pts — Total : 80 pts',
      );

      expect(style, isNotNull);
      expect(style!.units, hasLength(1));
      expect(style.units.single.quantity, 1);
      expect(style.units.single.name, 'Escouade Intercessor');
      expect(style.units.single.lineTotalPoints, 80);
    });

    test('handles a typographic apostrophe in a unit name', () {
      final style = parseStyleBody(
        'Style Test',
        'Description.\n\nEscouade D’Exaction — 180 pts — Total : 180 pts',
      );

      expect(style, isNotNull);
      expect(style!.units.single.name, 'Escouade D’Exaction');
    });

    test('returns null when the body has no blank-line separator', () {
      final style = parseStyleBody('Style Test', 'Un seul bloc sans total.');
      expect(style, isNull);
    });

    test('returns null when the total marker is missing', () {
      final style = parseStyleBody(
        'Style Test',
        'Description.\n\nEscouade Intercessor — 80 pts',
      );
      expect(style, isNull);
    });
  });

  group('groupStyleSectionsByFaction', () {
    test('groups sections by the faction prefix of their heading', () {
      final sections = [
        const RuleSection(
          heading: 'Orks — Marée Verte',
          body: 'Desc.\n\nBoyz — 80 pts — Total : 80 pts',
        ),
        const RuleSection(
          heading: 'Orks — Waaagh! Mécanisée',
          body: 'Desc.\n\nGorkanaute — 265 pts — Total : 265 pts',
        ),
        const RuleSection(
          heading: 'Necrons — Marée Nécrontyr',
          body: 'Desc.\n\nGuerriers Nécrons — 90 pts — Total : 90 pts',
        ),
        // Ignoré : pas de séparateur "Faction — Style" reconnu.
        const RuleSection(heading: 'Une section sans faction', body: 'x'),
      ];

      final byFaction = groupStyleSectionsByFaction(sections);

      expect(byFaction.keys, containsAll(['Orks', 'Necrons']));
      expect(byFaction['Orks'], hasLength(2));
      expect(byFaction['Necrons'], hasLength(1));
      expect(byFaction['Orks']!.map((s) => s.name), [
        'Marée Verte',
        'Waaagh! Mécanisée',
      ]);
    });
  });
}
