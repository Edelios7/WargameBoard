import 'package:flutter_test/flutter_test.dart';
import 'package:wargameboard/domain/xp/xp_awards.dart';

void main() {
  const standard = DatasheetXpClass(factionId: 'f1');
  const character = DatasheetXpClass(factionId: 'f1', isCharacterTier: true);
  const vehicle = DatasheetXpClass(factionId: 'f1', isVehicleTier: true);

  test('painting XP is tiered standard < character, standard < vehicle', () {
    expect(paintingXpPerModel(standard), paintingXpStandard);
    expect(paintingXpPerModel(character), paintingXpCharacter);
    expect(paintingXpPerModel(vehicle), paintingXpVehicle);
    expect(paintingXpCharacter, greaterThan(paintingXpStandard));
    expect(paintingXpVehicle, greaterThan(paintingXpStandard));
  });

  test('character tier takes priority over vehicle tier for painting', () {
    const characterVehicle = DatasheetXpClass(
      factionId: 'f1',
      isCharacterTier: true,
      isVehicleTier: true,
    );
    expect(paintingXpPerModel(characterVehicle), paintingXpCharacter);
  });

  test('assembly XP is tiered standard < vehicle', () {
    expect(assemblyXpPerModel(standard), assemblyXpStandard);
    expect(assemblyXpPerModel(vehicle), assemblyXpVehicle);
    expect(assemblyXpVehicle, greaterThan(assemblyXpStandard));
  });
}
