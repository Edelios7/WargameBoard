class DispositionOption {
  final String id;
  final String slug;
  final String name;

  const DispositionOption({
    required this.id,
    required this.slug,
    required this.name,
  });
}

class PrimaryMissionDetails {
  final String id;
  final String name;
  final String scoring;
  final String? action;

  const PrimaryMissionDetails({
    required this.id,
    required this.name,
    required this.scoring,
    this.action,
  });
}

class SecondaryMissionOption {
  final String id;
  final String name;
  final bool isFixed;
  final String effect;

  const SecondaryMissionOption({
    required this.id,
    required this.name,
    required this.isFixed,
    required this.effect,
  });
}
