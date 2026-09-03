class ModelDetails {
  final String id;

  final String name;

  final int movement;

  final int toughness;

  final int save;

  final int wounds;

  final int leadership;

  final int objectiveControl;

  /// Valeur "X" d'une sauvegarde invulnérable "X+", ou `null` si ce profil
  /// n'en a pas.
  final int? invulnerableSave;

  const ModelDetails({
    required this.id,
    required this.name,
    required this.movement,
    required this.toughness,
    required this.save,
    required this.wounds,
    required this.leadership,
    required this.objectiveControl,
    this.invulnerableSave,
  });
}