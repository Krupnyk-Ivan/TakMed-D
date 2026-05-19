# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

**TacMed** — a Flutter mobile app for learning tactical medicine (Ukrainian-language UI, comments, and commit messages). Two audiences: military medics and civilians learning first aid. Backend is Supabase; local persistence is Drift (SQLite). Most app code lives under `takmed/`; the `web/` directory at repo root holds Drift's WASM worker assets for Flutter Web.

## Common commands

All commands run from `takmed/`:

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # regen after editing @freezed/@JsonSerializable/@DriftDatabase/@RestApi/Drift schema
dart run build_runner watch --delete-conflicting-outputs   # continuous regen during dev
flutter analyze
flutter test
flutter test test/path/to/file_test.dart                    # single test file
flutter test --plain-name "name fragment"                    # single test by name
flutter run -d chrome                                       # or -d android / -d ios
```

### Supabase credentials

`lib/core/config/supabase_config.dart` reads `SUPABASE_URL` / `SUPABASE_ANON_KEY` via `String.fromEnvironment` (with hardcoded defaults pointing at the project's dev instance). To override, run with:

```bash
flutter run --dart-define-from-file=.env.json
```

DB migrations live in `takmed/supabase/migrations/` (`supabase db push` to apply).

## Architecture

Clean Architecture, feature-sliced. Every feature under `lib/features/<name>/` follows:

```
data/         # remote/local data sources, models, repository impls
domain/       # entities, repository interfaces, use cases
presentation/ # pages, BLoCs, feature-local widgets
```

**Data flow:** UI → BLoC → UseCase → Repository → DataSource (Remote = Supabase/Dio, Local = Drift / SharedPreferences / FlutterSecureStorage).

### Cross-cutting pieces in `lib/core/`

- `config/` — `SupabaseConfig` (env-driven).
- `database/` — Drift `AppDatabase` + DAOs (e.g. `ProgressDao`, `QuizAttemptDao`). After schema edits, **rerun `build_runner`** to regenerate `*.g.dart` and bump the Drift schema version.
- `di/injection_container.dart` — **manual GetIt registration** in `setupServiceLocator()`. Despite `injectable` being in pubspec, DI is wired by hand here: when you add a new use case / repo / bloc, register it explicitly in this file.
- `network/` — Dio + Retrofit `ApiClient`, `NetworkInfo` (connectivity_plus).
- `sync/` — bridges local Drift state with Supabase (offline-first).
- `errors/` — `Failure` types used with `Either<Failure, T>` (dartz) returned from repositories/use cases.

### Navigation

`go_router` configured in `lib/shared/navigation/app_router.dart`. Redirect-guards depend on `AuthBloc` state (auth) and onboarding completion. Route constants live in `lib/core/constants/app_routes.dart` — add new routes there, not as string literals.

### State management

`flutter_bloc`. One BLoC per feature in `presentation/bloc/`. BLoCs are registered as factories in `injection_container.dart` and provided at the app root in `main.dart` via `MultiBlocProvider` so guards and shared widgets can read them.

### Models & codegen

- `@freezed` + `@JsonSerializable` for entities/DTOs (e.g. `quiz_question.dart` → `.freezed.dart`, `.g.dart`).
- `@DriftDatabase` for the database; tables under `lib/core/database/tables/`, DAOs under `lib/core/database/daos/`.
- `@RestApi` (Retrofit) for HTTP clients in `core/network/`.

Never hand-edit `*.freezed.dart` / `*.g.dart` — always regenerate.

### Gamification

`features/gamification/` provides `GamificationService` (points/streaks/achievements) and `StreakReminderService` (workmanager + flutter_local_notifications for daily reminders). Other features call into `GamificationBloc` events on completion (e.g. lesson done → award points).

## Conventions

- Code, comments, and UI strings are in **Ukrainian**. Match existing tone when adding new strings.
- Theme is dark-only Material 3, accent `#D32F2F`. Reuse colors from `lib/shared/theme/app_theme.dart` rather than hardcoding hex values.
- Repository methods return `Future<Either<Failure, T>>`; do not throw across layer boundaries — map exceptions to `Failure` subtypes in data layer.
