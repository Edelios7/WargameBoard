import 'package:intl/intl.dart';

/// Logique de présentation pour la Collection qui ne dépend pas de
/// Flutter/BuildContext (les agrégats eux-mêmes — nombre de figurines,
/// peintes, valeur totale — sont calculés par CollectionDao.getSummary,
/// pas dupliqués ici).
class CollectionService {
  const CollectionService();

  /// Formate un montant en euros selon la locale (ex. "1 234,50 €" en
  /// français, "€1,234.50" en anglais).
  String formatValue(double value, String localeCode) {
    final formatter =
        NumberFormat.simpleCurrency(locale: localeCode, name: 'EUR');
    return formatter.format(value);
  }
}
