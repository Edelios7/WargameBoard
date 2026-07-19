# Images officielles des datasheets

Ce dossier n'est **jamais commité dans git** (voir `.gitignore`). Il te
permet de garder des images officielles (scans, artworks) en local,
sans les republier sur le dépôt GitHub.

## Convention

Nomme chaque fichier avec l'`id` exact de la datasheet, suivi de son
extension (`.png`, `.jpg`, `.jpeg` ou `.webp`) :

```
local_assets/datasheets/ds-captain.png
local_assets/datasheets/ds-death-company-marines.jpg
local_assets/datasheets/ds-sanguinary-guard.webp
```

Les ids actuels des datasheets seedées se trouvent dans
`lib/database/seed/datasheet_seed.dart` (constantes `dsCaptain`,
`dsDeathCompanyMarines`, `dsSanguinaryGuard`).

L'application détecte automatiquement le fichier si présent et
l'affiche dans la fiche détaillée du catalogue ; sinon, la fiche
s'affiche normalement sans image.
