import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Langue choisie manuellement par l'utilisateur.
///
/// `null` = suit la langue du système (comportement par défaut).
final localeOverrideProvider = StateProvider<Locale?>((ref) => null);
