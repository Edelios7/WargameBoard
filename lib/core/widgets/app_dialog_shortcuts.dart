import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Comportement clavier standard pour toutes les popups de l'app :
/// Échap ferme/revient en arrière, Entrée valide l'action principale
/// (si fournie). `showDialog` ne lie pas Échap tout seul sur desktop,
/// d'où ce wrapper à poser autour du contenu de chaque dialogue.
///
/// Un champ de texte multiligne (notes...) garde son propre traitement
/// d'Entrée (retour à la ligne) : `CallbackShortcuts` ne reçoit l'événement
/// que si rien de focus en dessous ne l'a déjà consommé.
class AppDialogShortcuts extends StatelessWidget {
  final Widget child;
  final VoidCallback? onEnter;

  const AppDialogShortcuts({
    super.key,
    required this.child,
    this.onEnter,
  });

  @override
  Widget build(BuildContext context) {
    final bindings = <ShortcutActivator, VoidCallback>{
      const SingleActivator(LogicalKeyboardKey.escape): () =>
          Navigator.of(context).maybePop(),
    };
    final onEnter = this.onEnter;
    if (onEnter != null) {
      bindings[const SingleActivator(LogicalKeyboardKey.enter)] = onEnter;
      bindings[const SingleActivator(LogicalKeyboardKey.numpadEnter)] =
          onEnter;
    }
    return CallbackShortcuts(bindings: bindings, child: child);
  }
}
