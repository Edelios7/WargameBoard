# Icônes de faction

Comme `local_assets/datasheets/`, ce dossier n'est **jamais commité**
(voir `.gitignore`).

## Convention

Nomme chaque fichier avec l'`id` exact de la faction :

```
local_assets/factions/fac-blood-angels.png
local_assets/factions/fac-orks.png
```

Les ids se trouvent dans `lib/database/seed/faction_seed.dart`
(`seedFactionId`, `seedOrksFactionId`).

Affichée automatiquement en petite icône ronde à côté du nom de la
faction dans la fiche détaillée du catalogue, si le fichier existe.
