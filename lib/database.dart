// lib/database.dart
// Select implementation per platform:
// - Web: database_web.dart
// - Desktop/Tests (FFI present): database_desktop.dart
// - Mobile (Android/iOS): database_mobile.dart

// Use conditional imports to select the right implementation
import 'database_mobile.dart'
    if (dart.library.js) 'database_web.dart'
    if (dart.library.ffi) 'database_desktop.dart';

// Re-export the getDatabaseFactory function
export 'database_mobile.dart'
    if (dart.library.js) 'database_web.dart'
    if (dart.library.ffi) 'database_desktop.dart';
