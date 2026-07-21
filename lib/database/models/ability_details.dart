class AbilityDetails {
  final String id;

  final String name;

  final String description;

  final String? type;

  final bool isCore;

  const AbilityDetails({
    required this.id,
    required this.name,
    required this.description,
    this.type,
    this.isCore = false,
  });
}
