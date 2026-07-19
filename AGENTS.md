# AGENTS

## Purpose
This file helps AI coding agents understand the current Flutter project layout and common workflows so they can work predictably in this repository. See also `CLAUDE.md` for standing authorizations (e.g. `git push`).

## Project type
- Flutter desktop application (Windows target primary), Drift/SQLite for local storage, Riverpod for state.
- Main entrypoint: `lib/main.dart` → `lib/app.dart` (`WargameBoardApp`, wires theme/locale/`AppShell`).
- Current Dart SDK constraint: `^3.12.2`.

## Architecture
- `lib/database/`: Drift schema (`tables/`), generated database (`app_database.dart`, schemaVersion + migrations), DAOs (`daos/`), DB-facing result models (`models/`), and seed data (`seed/`, loaded on first launch only via `onCreate`).
- `lib/repositories/`: thin wrappers around DAOs, one per domain area (catalog, army, collection, battle).
- `lib/providers/`: Riverpod providers exposing repositories and derived state to the UI.
- `lib/features/<name>/pages/` and `.../widgets/`: one folder per app section (catalog, armies, battle, collection, statistics, dashboard).
- `lib/shell/`: `AppShell` (layout) and `navigation.dart` (shared `selectedTabProvider` — use this to switch tabs from anywhere, not local widget state).
- `lib/l10n/`: ARB-based i18n (EN/FR live, more locales can be added by dropping in a new `app_<locale>.arb`). Every user-facing string should go through `AppLocalizations.of(context)!`, not be hardcoded.
- `lib/core/theme/`: `AppColors`/`AppTextStyles`/`AppTheme` — the actual applied theme is `AppTheme.darkTheme`, wired in `app.dart`.
- `local_assets/datasheets/`: git-ignored folder for user's own official reference images (see its README) — never commit real Games Workshop artwork.

## Database schema changes
Whenever a table changes shape (new column/table), bump `schemaVersion` in `app_database.dart` and add a corresponding `if (from < N)` branch in `onUpgrade` — existing local databases must keep working. After editing any `tables/*.dart` or DAO, regenerate with:
```
dart run build_runner build --delete-conflicting-outputs
```

## Build and test commands
- `flutter analyze` — must be 0 errors before committing.
- `flutter test` — DB/DAO tests live in `test/database/` (use `AppDatabase.forTesting(NativeDatabase.memory())`), widget tests live in `test/features/` (wrap in `ProviderScope` overriding `databaseProvider`).
- `flutter run -d windows` to manually verify — **always close/kill the process after checking**, don't leave `flutter run` instances running in the background across turns.
- `flutter gen-l10n` after editing any `.arb` file.

## Style and conventions
- Follow the existing feature pattern (table → DAO → repository → provider → page) rather than introducing a new architecture style.
- Respect the default `flutter_lints` rules; do not disable lint rules globally unless there is a strong, documented reason.
- Card-based, dark/anthracite UI with a single accent color (`AppColors.primary`) — see project memory / prior conversation for the full design brief if extending the UI.
