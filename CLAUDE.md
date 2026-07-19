# Instructions pour Claude

## Autorisations permanentes

- Claude est autorisé à faire `git push` vers `origin/main` sans demander
  confirmation à chaque fois, dès qu'un commit est prêt et que les
  vérifications (`flutter analyze`, `flutter test`) passent.
- Cette autorisation ne couvre **pas** les opérations destructrices ou
  irréversibles (force-push, `git reset --hard`, suppression de branche,
  réécriture d'historique, etc.) — celles-ci restent toujours soumises à
  confirmation explicite dans la conversation.

## Avant de commiter/pousser

- Toujours faire passer `flutter analyze` (0 erreur) et `flutter test`
  (tout au vert) avant de commiter.
- Ne jamais commiter d'images ou contenu officiel Games Workshop — voir
  `local_assets/datasheets/README.md` pour la convention d'images locales
  (jamais suivies par git).
