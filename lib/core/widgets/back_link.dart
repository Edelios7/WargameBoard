import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'hoverable.dart';

/// Lien "retour" texte (icône + libellé), utilisé en haut des pages de
/// détail qui naviguent avec `Navigator.pop` plutôt qu'un `AppBar`. Même
/// langage de survol que le reste de la navigation (sidebar, footer
/// Commandant) : [Hoverable] + [InkWell], pour que le geste "revenir en
/// arrière" ait toujours le même retour visuel dans toute l'app.
class BackLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const BackLink({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Hoverable(
      borderRadius: BorderRadius.circular(8),
      scaleAlignment: Alignment.centerLeft,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.arrow_back_rounded,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 6),
                Text(label, style: AppTextStyles.caption),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
