import 'package:drift/drift.dart';

/// Marque des évènements XP "une seule fois, tous historiques confondus"
/// (ex. "première armée créée") — un simple compteur de lignes existantes
/// (`COUNT(*)`) ne suffit pas puisqu'une suppression puis recréation ferait
/// retomber ce compteur à une valeur qui semble "la toute première fois".
class XpMilestones extends Table {
  TextColumn get key => text()();

  DateTimeColumn get achievedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {key};
}
