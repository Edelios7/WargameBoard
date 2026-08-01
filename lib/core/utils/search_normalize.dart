const Map<String, String> _diacriticsMap = {
  'à': 'a',
  'á': 'a',
  'â': 'a',
  'ã': 'a',
  'ä': 'a',
  'å': 'a',
  'è': 'e',
  'é': 'e',
  'ê': 'e',
  'ë': 'e',
  'ì': 'i',
  'í': 'i',
  'î': 'i',
  'ï': 'i',
  'ò': 'o',
  'ó': 'o',
  'ô': 'o',
  'õ': 'o',
  'ö': 'o',
  'ù': 'u',
  'ú': 'u',
  'û': 'u',
  'ü': 'u',
  'ý': 'y',
  'ÿ': 'y',
  'ç': 'c',
  'ñ': 'n',
  'œ': 'oe',
  'æ': 'ae',
};

/// Normalise une chaîne pour la recherche : minuscules, accents retirés
/// (`é`/`è`/`ê` → `e`, etc.) — pour que taper "veterans" (ou "vétérans")
/// trouve "Escouade de Vétérans" quel que soit l'accent ou la casse tapés,
/// contrairement à une simple comparaison `toLowerCase`/`LIKE` SQLite (dont
/// le repliement de casse ne couvre que l'ASCII, pas les lettres accentuées).
String normalizeForSearch(String input) {
  final buffer = StringBuffer();
  for (final rune in input.toLowerCase().runes) {
    final char = String.fromCharCode(rune);
    buffer.write(_diacriticsMap[char] ?? char);
  }
  return buffer.toString();
}
