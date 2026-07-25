import 'package:flutter_test/flutter_test.dart';
import 'package:wargameboard/core/utils/army_list_formatter.dart';
import 'package:wargameboard/database/models/army_details.dart';

void main() {
  test('formats an army with detachment, enhancement and points limit', () {
    const army = ArmyDetails(
      id: 'a1',
      name: 'Ma première liste',
      factionId: 'fac-blood-angels',
      factionName: 'Blood Angels',
      detachmentName: 'Angelic Host',
      pointsLimit: 2000,
      totalPoints: 115,
      units: [
        ArmyUnitDetails(
          id: 'u1',
          datasheetId: 'ds-captain',
          datasheetName: 'Captain',
          modelCount: 1,
          minimumModels: 1,
          maximumModels: 1,
          datasheetPoints: 90,
          enhancementName: 'Death Visions of Sanguinius',
          enhancementPoints: 25,
        ),
      ],
    );

    final text = ArmyListFormatter.format(army);

    expect(text, contains('Ma première liste — Blood Angels'));
    expect(text, contains('Détachement : Angelic Host'));
    expect(text, contains('115 / 2000 pts'));
    expect(
      text,
      contains(
        '- Captain x1 (115 pts) [Death Visions of Sanguinius +25 pts]',
      ),
    );
  });

  test('omits detachment and enhancement lines when absent', () {
    const army = ArmyDetails(
      id: 'a1',
      name: 'Liste simple',
      factionId: 'fac-blood-angels',
      factionName: 'Blood Angels',
      totalPoints: 90,
      units: [
        ArmyUnitDetails(
          id: 'u1',
          datasheetId: 'ds-captain',
          datasheetName: 'Captain',
          modelCount: 1,
          minimumModels: 1,
          maximumModels: 1,
          datasheetPoints: 90,
        ),
      ],
    );

    final text = ArmyListFormatter.format(army);

    expect(text, isNot(contains('Détachement')));
    expect(text, isNot(contains('[')));
    expect(text, contains('90 pts'));
  });

  test(
    'flags a unit with no known cost instead of printing a misleading '
    '"0 pts", and warns that the total is an underestimate',
    () {
      const army = ArmyDetails(
        id: 'a1',
        name: 'Liste incomplète',
        factionId: 'fac-blood-angels',
        factionName: 'Blood Angels',
        totalPoints: 90,
        units: [
          ArmyUnitDetails(
            id: 'u1',
            datasheetId: 'ds-captain',
            datasheetName: 'Captain',
            modelCount: 1,
            minimumModels: 1,
            maximumModels: 1,
            datasheetPoints: 90,
          ),
          ArmyUnitDetails(
            id: 'u2',
            datasheetId: 'ds-no-cost',
            datasheetName: 'Fiche sans données de coût',
            modelCount: 1,
            minimumModels: 1,
            maximumModels: 1,
            datasheetPoints: null,
          ),
        ],
      );

      final text = ArmyListFormatter.format(army);

      expect(
        text,
        contains('- Fiche sans données de coût x1 (coût inconnu)'),
      );
      expect(text, isNot(contains('Fiche sans données de coût x1 (0 pts)')));
      expect(text, contains('total sous-estimé'));
    },
  );
}
