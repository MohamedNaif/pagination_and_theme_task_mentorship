# Pagination & Theme Task (Flutter)

Professional, well-documented sample project demonstrating:

- Light and dark theming with persistence
- Infinite scrolling pagination (products list)
- Simple caching using SharedPreferences
- Error logging and request retry via Dio interceptors
- Clean-ish architecture (presentation + data layers — no domain layer as requested)

This repository is a mentorship / learning project that showcases common mobile app patterns and how to wire them together in a real Flutter codebase.

---

## Table of contents

- Project overview
- Features
- Architecture
- Getting started
- How to run and test the products page
- Theming and toggling
- Caching and debugging
- File / folder overview
- Next steps and ideas
- Contributing

---

## Project overview

The app demonstrates a paginated products list backed by DummyJSON (https://dummyjson.com/). It is wired with Dio for networking, GetIt for dependency injection, BLoC/Cubit for presentation state management, and SharedPreferences for small persistent state (theme choice and some caching).

Key design goals

- Minimal, readable code that fits inside an existing Flutter project
- Keep the architecture simple: presentation (Cubit) + data (remote datasource + repository)
- Demonstrate runtime theme toggling, pagination, caching and simple error logging

## Features

- Light & Dark theming (persisted): toggle from the Products screen AppBar
- Pagination: infinite scroll using the existing `ListViewPagination` widget
- Caching: last fetched product ids saved in SharedPreferences under key `cached_products`
- Error logging: errors saved to `last_error` SharedPreferences key and lifecycle logs via `MyBlocObserver`
- Navigation: implemented with `go_router`; tapping a product opens details (product passed via `state.extra`)

## Architecture

- Presentation: Cubit for products (`lib/features/products/presentation/cubit`) - controls pagination states and emits Loading/Loaded/Error states.
- Data: Remote datasource uses a generic `ApiConsumer` (Dio wrapper) to call `EndPoints.products` with `limit` and `skip` query parameters.
- DI: GetIt (`lib/core/di/dependency_injection.dart`) registers Dio, ApiConsumer, datasource, repository and `ProductsCubit` factory, and a `ThemeController` (ValueNotifier) for runtime theme changes.
- Routing: `go_router` with routes in `lib/config/routing/app_router.dart` and route paths in `lib/config/routing/routes.dart`.

## Getting started

Prerequisites

- Flutter SDK (stable channel) installed and on PATH
- An editor (VS Code, Android Studio, etc.)

Install and run

1. From project root, get packages:

```powershell
flutter pub get
```

2. Run the app in an emulator or device:

```powershell
flutter run
```

Notes for Windows PowerShell: use the commands above directly in your PowerShell terminal.

## How to run and test the products page

- The products page is registered at route `/products`. For convenience, the project currently uses `/products` as the initial route.
- Once the app is running, open the products page (it loads automatically) and scroll to the bottom to trigger additional pages (limit = 10 per request).
- Tap any product to open the details page. The product object is passed directly through the router `extra` payload.

## Theming and toggling

- Toggle theme via the switch in the Products screen AppBar.
- The app uses a `ThemeController` (a `ValueNotifier<ThemeMode>`) registered in GetIt. When the switch changes, the controller updates and `MaterialApp` rebuilds with the new `themeMode`.
- The selection is persisted in `SharedPreferences` under key `theme_mode` (values: `light` or `dark`). On cold start the choice is restored by the DI registration code.

## Caching and debugging

- The cubit caches the last fetched product ids in `SharedPreferences` under key `cached_products` (comma-separated ids) as a low-risk demonstration. You can extend this to store full JSON payloads or use Hive/sqflite for robust offline support.
- The cubit also saves the last error message under `last_error` for quick debugging.
- Dio logs are enabled in debug mode via `PrettyDioLogger` and `AppInterceptors` handles token refresh and retries for 401 responses.

## File / folder overview

- `lib/main.dart` — app entry: localization + app router + theme controller wiring
- `lib/config/theme/` — theme, colors, styles
- `lib/config/routing/` — `app_router.dart` and route definitions
- `lib/core/di/` — GetIt dependency registration
- `lib/core/api/` — Dio consumer, interceptors, endpoints
- `lib/core/storage/` — `AppSharedPreferences` (SharedPreferences wrapper)
- `lib/features/products/` — product model, datasource, repository, cubit, pages

## Next steps and ideas

- Improve caching: store full JSON objects or add Hive for offline access
- Add unit tests for the cubit (happy path and error path)
- Add product search and filtering
- Replace SharedPreferences caching with local DB for large payloads
- Add Hero animation for product thumbnail between list and details

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes and include tests where applicable
4. Open a pull request describing your changes

If you want help implementing any next step above, open an issue or request and I'll implement it.

## License

This project is a mentorship sample. Use and modify it freely for learning and non-commercial experiments.

---

## Quick test instructions

- The products feature uses DummyJSON (https://dummyjson.com/) as the API.
- Endpoint base is defined in `lib/core/api/end_points.dart` and `products` path is `products`.
- Dependency injection registers `ProductsCubit` via GetIt. The products page route is `/products`.

## How to try the products page

1. Run the app (e.g., `flutter run`).
2. Navigate to `/products` (use router navigation or set initial route temporarily).
3. The page will load items in pages (limit 10) and request more as you scroll.

## Caching and error logging

- Last fetched product ids are cached in SharedPreferences under key `cached_products` (as comma-separated ids).
- Last error message is stored under `last_error` key.
- Bloc and Dio logs are printed to the console; `MyBlocObserver` logs lifecycle events.

## Notes

- This change added a minimal feature to demonstrate pagination, caching, theming integration and error logging; it uses the existing app structure and keeps changes small.
