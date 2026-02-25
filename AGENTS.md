# AGENTS.md

## Cursor Cloud specific instructions

### Project overview

Agreg Master is a Flutter web/mobile app for preparing the French *agrégation de mathématiques* exam. It provides revision cards (fiches), exercises, mock exams, spaced repetition, and planning tools.

### Development commands

| Task | Command |
|------|---------|
| Install deps | `flutter pub get` |
| Lint / analyze | `flutter analyze` |
| Build web | `flutter build web` |
| Run web (dev) | `flutter run -d chrome` or serve `build/web/` on a local HTTP server |
| Run tests | `flutter test` (no test files exist yet) |

### Key notes

- **Flutter SDK** must be on `PATH` at `/opt/flutter/bin`. The project requires SDK `>=3.0.0 <4.0.0` (Flutter stable channel).
- **Web is the primary dev target** in this cloud environment (no Android emulator / iOS simulator available). Use `flutter build web` then serve `build/web/` with `python3 -m http.server 8080` for quick testing, or use `flutter run -d web-server --web-port=8080` for hot-reload dev mode.
- **Firebase** is configured for web directly in `lib/main.dart` (hardcoded `FirebaseOptions`). All Firebase calls are wrapped in `try/catch` so the app runs gracefully even if Firebase is unreachable.
- **No test directory** exists — `flutter test` has nothing to run.
- `flutter analyze` produces only info-level `avoid_print` lints in tooling files (`tool/`, `tools/`, `update_files.dart`). The main app code (`lib/`) is clean.
- Content (93 markdown fiches + JSON data) is bundled as Flutter assets — no external content server needed.
- **RevenueCat / Sentry** init errors are caught and non-blocking; the app works in free mode without them.
