# AGENTS

## Purpose
This file helps AI coding agents understand the current Flutter project layout and common workflows so they can work predictably in this repository.

## Project type
- Flutter application with standard platform folders: `android/`, `ios/`, `linux/`, `macos/`, `web/`, `windows/`.
- Main entrypoint: `lib/main.dart`.
- Current Dart SDK constraint: `^3.12.2`.

## Key files and folders
- `lib/main.dart`: application startup and default sample UI.
- `lib/app.dart`: present but currently empty; do not assume it contains app wiring.
- `lib/features/`: intended for feature modules.
- `lib/shared/`: intended for shared widgets/utilities.
- `lib/core/constants/`: intended for constants.
- `analysis_options.yaml`: uses `package:flutter_lints/flutter.yaml`.

## Build and test commands
Use standard Flutter commands for this repo:
- `flutter pub get`
- `flutter analyze`
- `flutter test`
- `flutter run -d <device-id>`

## Style and conventions
- Keep code organization compact and feature-focused.
- Prefer grouping related Dart files under `lib/features/` and `lib/shared/` rather than creating many shallow directories.
- Avoid creating folders unless multiple files share the same responsibility.
- Respect the default `flutter_lints` rules; do not disable lint rules globally unless there is a strong, documented reason.

## Notes for AI agents
- There are no existing AI customization files in this repository yet.
- Use this file as the primary local guidance for how to navigate the project.
- For general Flutter guidance, refer to the default Flutter docs linked from `README.md`.
