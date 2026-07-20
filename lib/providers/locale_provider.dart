import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Clé utilisée pour persister la langue choisie dans SharedPreferences.
const String localePreferenceKey = 'locale';

/// Langue choisie manuellement par l'utilisateur.
///
/// `null` = suit la langue du système (comportement par défaut). La valeur
/// initiale réelle est injectée au démarrage via un override dans
/// main.dart, à partir de SharedPreferences.
final localeOverrideProvider = StateProvider<Locale?>((ref) => null);
