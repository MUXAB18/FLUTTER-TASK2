# To-Do & Counter App

This Flutter app demonstrates basic state management with `setState` and local persistence using `SharedPreferences`.

Features
- Counter Screen
  - Increase and decrease a counter
  - Counter value is saved to SharedPreferences and restored on app restart
- To-Do page
  - Add tasks
  - Display tasks in a ListView
  - Remove tasks (swipe to delete)
  - Tasks are saved to SharedPreferences and restored on app restart

How to run this app

1. Ensure Flutter is installed and working (see https://flutter.dev/docs/get-started/install).
2. From the project root run:

```bash
flutter pub get
flutter run
```

Files changed/added
- `lib/main.dart` - main application with counter and to-do pages
- `pubspec.yaml` - added `shared_preferences` dependency

Notes
- This project uses a minimal approach (`setState`) to teach foundational state management and persistence.
- SharedPreferences is used to keep the app simple; for larger apps consider more robust persistence solutions (SQLite, Hive, Provider/Bloc for state management).
