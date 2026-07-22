# Photos personnelles des unités

Comme les autres dossiers de `local_assets/`, jamais commité (voir
`.gitignore`) sauf ce README.

## Contenu

Deux niveaux, tous deux nommés `<id>.<ext>` (png/jpg/jpeg/webp) :

- `local_assets/user_photos/<datasheetId>.<ext>` — photo par défaut d'un
  type d'unité, utilisée partout où une fiche est affichée hors
  Collection (Armées, Catalogue, Dashboard, Bataille).
- `local_assets/user_photos/entries/<entryId>.<ext>` — photo propre à
  une entrée précise de la Collection (une escouade en particulier),
  n'apparaît que sur sa carte dans la Collection.

Gérée entièrement depuis l'app (`lib/services/user_photo_service.dart`) :
choisir une photo depuis une carte de Collection l'enregistre aux deux
niveaux (l'entrée ET, par défaut, le type d'unité — si plusieurs entrées
de la même fiche ont chacune leur photo, la dernière choisie l'emporte
comme photo par défaut) ; retirer une photo depuis la Collection ne
retire que celle de l'entrée. Jamais de saisie manuelle attendue dans ce
dossier.

## Utilisation

`LocalCatalogImages.userPhoto(datasheetId)` résout la photo par défaut
du type d'unité ; `LocalCatalogImages.unitPhoto(datasheetId)` y retombe
sur le visuel catalogue générique (`local_assets/datasheets/`) si elle
n'existe pas — c'est ce dernier qui est utilisé partout hors Collection.
`LocalCatalogImages.entryPhoto(entryId)` résout la photo propre à une
entrée ; `LocalCatalogImages.collectionPhoto(datasheetId, entryId)`
retombe sur `unitPhoto` puis sur le visuel générique — c'est ce dernier
qui est utilisé dans la Collection, pour que la photo la plus précise
disponible s'affiche toujours, sans jamais rien montrer de vide.
