// lib/database_desktop.dart
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

DatabaseFactory getDatabaseFactory() {
  // Initialize FFI for desktop usage
  sqfliteFfiInit();
  return databaseFactoryFfi;
}
