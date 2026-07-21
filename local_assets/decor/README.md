# Éléments décoratifs génériques

Comme les autres dossiers de `local_assets/`, jamais commité (voir
`.gitignore`) sauf ce README.

## Contenu

Découpé depuis `wh40k_reference/PDFS/deco et texture/Séparateurs.png`
et `.../Element de navigation.png` — fond noir plein, se fond
naturellement dans `AppColors.background` (proche du noir).

Chaque famille existe dans les 8 mêmes variantes de couleur/thème
(sauf `separator-curved`, qui n'en a que 6) :
`gold-imperial`, `red-chaos`, `teal-mechanicus`, `silver-skull`,
`gold-aquila`, `purple-corrupted`, `green-ork`, `blue-tech`.

```
separator-horizontal-<couleur>.png   ligne fine, longue, avec fleuron central
separator-fine-<couleur>.png         variante plus fine du même style
separator-vertical-<couleur>.png     hampe verticale (staff/lance)
separator-curved-<couleur>.png       arc décoratif (6 couleurs seulement)
icon-central-<couleur>.png           icône ronde/emblème isolé
corner-<couleur>.png                 coin de cadre (angle haut-gauche)
section-bar-<couleur>.png            bandeau large (pensé pour un titre de section)
watermark-<couleur>.png              filigrane sombre, très discret
frame-<couleur>.png                  cadre carré complet (4 couleurs seulement :
                                      silver-skull, red-chaos, green-ork,
                                      purple-corrupted)
footer-banner.png                    bandeau décoratif pleine largeur (bas de page)
```

## Utilisation

Utilisé par ex. dans `lib/features/profile/pages/profile_page.dart`
(`_DecorativeDivider`) comme séparateur discret entre deux sections —
`Opacity` réduite + hauteur contrainte pour rester sobre. Reprendre ce
patron (opacité ~0.6-0.8, hauteur limitée, `BoxFit.contain`) pour toute
nouvelle utilisation plutôt que d'afficher ces images à pleine
intensité, sous peine de surcharger l'interface.
