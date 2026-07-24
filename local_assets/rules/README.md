# PDFs officiels des règles

Ce dossier n'est **jamais commité dans git** (voir `.gitignore`). Il te
permet de garder les livres de règles officiels (PDFs Games Workshop) en
local, sans les republier sur le dépôt GitHub.

## Convention

Nomme chaque fichier avec l'`id` exact du document (voir
`lib/domain/rules/rules_data.dart`), suivi de `.pdf` :

```
local_assets/rules/warhammer-40000-core-rules.pdf
```

La page Règles de l'application référence ces fichiers par leur id ; si le
fichier local est absent, le document s'affiche normalement mais son bouton
d'ouverture reste inactif. Quand le fichier est présent, "Ouvrir le livre de
règles" l'ouvre directement dans un lecteur PDF intégré à l'appli (voir
`lib/core/utils/rule_pdf_source.dart` et
`lib/features/rules/pages/rule_pdf_viewer_page.dart`).

## Build mobile perso

Sur Windows/dev, ce dossier suffit. Pour qu'un build Android personnel
embarque aussi le PDF (comme le catalogue complet, voir
`assets/seed_data/`), copie-le en plus sous `assets/rulebook/<id>.pdf`
(également jamais commité, voir `.gitignore`) avant `flutter build apk`.
