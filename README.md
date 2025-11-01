# pagination_and_theme_task

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

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
