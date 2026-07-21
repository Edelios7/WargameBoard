import 'package:flutter_test/flutter_test.dart';
import 'package:wargameboard/database/models/army_details.dart';
import 'package:wargameboard/services/army_validation_service.dart';

void main() {
  const service = ArmyValidationService();

  ArmyDetails army({
    int totalPoints = 0,
    int? pointsLimit,
    String? detachmentId,
    List<ArmyUnitDetails> units = const [],
  }) =>
      ArmyDetails(
        id: 'a1',
        name: 'Test',
        factionId: 'fac-1',
        factionName: 'Test Faction',
        totalPoints: totalPoints,
        pointsLimit: pointsLimit,
        detachmentId: detachmentId,
        units: units,
      );

  const oneUnit = [
    ArmyUnitDetails(
      id: 'u1',
      datasheetId: 'ds-1',
      datasheetName: 'Test Unit',
      modelCount: 1,
      minimumModels: 1,
      maximumModels: 1,
      datasheetPoints: 90,
    ),
  ];

  const oneUnitWithWarlord = [
    ArmyUnitDetails(
      id: 'u1',
      datasheetId: 'ds-1',
      datasheetName: 'Test Unit',
      modelCount: 1,
      minimumModels: 1,
      maximumModels: 1,
      datasheetPoints: 90,
      isWarlord: true,
    ),
  ];

  test('a valid, complete army has no errors or warnings', () {
    final result = service.validate(army(
      totalPoints: 90,
      pointsLimit: 2000,
      detachmentId: 'det-1',
      units: oneUnitWithWarlord,
    ));

    expect(result.isValid, isTrue);
    expect(result.errors, isEmpty);
    expect(result.warnings, isEmpty);
  });

  test('over the points limit is an error', () {
    final result = service.validate(army(
      totalPoints: 2100,
      pointsLimit: 2000,
      units: oneUnit,
    ));

    expect(result.isValid, isFalse);
    expect(result.errors, contains(ArmyValidationIssue.overPointsLimit));
  });

  test('an army with no units is a warning, not an error', () {
    final result = service.validate(army());

    expect(result.isValid, isTrue);
    expect(result.warnings, contains(ArmyValidationIssue.emptyArmy));
  });

  test('a points limit without a detachment warns but does not fail', () {
    final result = service.validate(army(
      pointsLimit: 2000,
      units: oneUnit,
    ));

    expect(result.isValid, isTrue);
    expect(result.warnings, contains(ArmyValidationIssue.noDetachmentSelected));
  });

  test('no points limit means no detachment warning', () {
    final result = service.validate(army(units: oneUnit));

    expect(
      result.warnings,
      isNot(contains(ArmyValidationIssue.noDetachmentSelected)),
    );
  });

  test('a non-empty army with no Warlord warns', () {
    final result = service.validate(army(units: oneUnit));

    expect(result.isValid, isTrue);
    expect(result.warnings, contains(ArmyValidationIssue.noWarlordSelected));
  });

  test('designating a Warlord clears the warning', () {
    final result = service.validate(army(units: oneUnitWithWarlord));

    expect(
      result.warnings,
      isNot(contains(ArmyValidationIssue.noWarlordSelected)),
    );
  });
}
