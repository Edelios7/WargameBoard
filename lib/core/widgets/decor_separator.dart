import 'package:flutter/material.dart';

import '../utils/local_catalog_images.dart';

/// Style de séparateur décoratif — voir local_assets/decor/README.md pour
/// le rendu de chaque variante.
enum DecorSeparatorStyle { fine, horizontal, curved, vertical }

/// Séparateur décoratif discret entre deux sections d'une page (recadré
/// depuis les planches de référence PDF, voir local_assets/decor/README.md).
/// Retombe sur un simple espacement si l'image n'est pas présente en local
/// (contenu jamais commité).
///
/// [color] doit correspondre à une des variantes du dossier `decor/`
/// (`purple-corrupted` par défaut, seule variante alignée avec
/// `AppColors.primary`). Reprendre ce widget plutôt que d'afficher les
/// images à pleine intensité, pour rester sobre.
class DecorSeparator extends StatelessWidget {
  final DecorSeparatorStyle style;
  final String color;
  final double height;
  final double maxWidth;
  final double opacity;
  final EdgeInsetsGeometry padding;

  const DecorSeparator({
    super.key,
    this.style = DecorSeparatorStyle.fine,
    this.color = 'purple-corrupted',
    this.height = 18,
    this.maxWidth = 420,
    this.opacity = 0.7,
    this.padding = const EdgeInsets.symmetric(vertical: 20),
  });

  @override
  Widget build(BuildContext context) {
    final prefix = switch (style) {
      DecorSeparatorStyle.fine => 'separator-fine',
      DecorSeparatorStyle.horizontal => 'separator-horizontal',
      DecorSeparatorStyle.curved => 'separator-curved',
      DecorSeparatorStyle.vertical => 'separator-vertical',
    };
    final file = LocalCatalogImages.decor('$prefix-$color');
    if (file == null) return SizedBox(height: height + 10);

    return Padding(
      padding: padding,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Opacity(
            opacity: opacity,
            child: Image.file(file, height: height, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
