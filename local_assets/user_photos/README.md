# Photos personnelles des unités

Comme les autres dossiers de `local_assets/`, jamais commité (voir
`.gitignore`) sauf ce README.

## Contenu

Une photo par fiche (datasheet), prise par le joueur de ses propres
figurines peintes — nommée `<datasheetId>.<ext>` (png/jpg/jpeg/webp),
exactement comme `local_assets/datasheets/`.

Gérée entièrement depuis l'app (`lib/services/user_photo_service.dart`) :
choisir une photo copie le fichier sélectionné ici sous ce nom, retirer
la photo la supprime. Jamais de saisie manuelle attendue dans ce dossier.

## Utilisation

`LocalCatalogImages.userPhoto(datasheetId)` résout uniquement la photo
perso ; `LocalCatalogImages.unitPhoto(datasheetId)` renvoie la photo
perso si elle existe, sinon retombe sur le visuel catalogue générique
(`local_assets/datasheets/`) — c'est ce dernier qui est utilisé partout
où une fiche est affichée (Collection, Armées, Catalogue, Dashboard,
Bataille), pour que la photo perso remplace automatiquement le visuel
générique dès qu'elle est définie.
