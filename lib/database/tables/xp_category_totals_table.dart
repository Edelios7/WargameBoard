import 'package:drift/drift.dart';

/// Totaux d'XP cumulés par catégorie de hobby (peinture, montage, parties,
/// collection, consultation des règles). Une ligne par valeur de
/// `XpCategory` (voir lib/domain/xp/xp_category.dart), créées au seed.
class XpCategoryTotals extends Table {
  TextColumn get category => text()();

  IntColumn get xp => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {category};
}
