// lib/database_web.dart
import 'package:sqflite/sqflite.dart';

// Minimal web fallback to avoid analyzer/build issues without extra web deps.
// Note: This app does not support SQLite on web. This returns the default
// databaseFactory which will throw if used on web. Android APK build is unaffected.
DatabaseFactory getDatabaseFactory() {
  return databaseFactory;
}
