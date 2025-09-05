import 'package:flutter/material.dart';
import '../models/song.dart';
import '../screens/splash_screen.dart';
import '../screens/song_list_screen.dart';
import '../screens/song_detail_screen.dart';
import '../screens/error_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String root = '/';
  static const String songs = '/songs';
  static const String songDetail = '/song-detail';
}

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final name = settings.name ?? '';

    try {
      switch (name) {
        case AppRoutes.splash:
          return _fadeRoute(
            const SplashScreen(),
            settings: settings,
            durationMs: 300,
          );

        case AppRoutes.root:
        case AppRoutes.songs:
          return _fadeRoute(
            const SongListScreen(),
            settings: settings,
            durationMs: 250,
          );

        case AppRoutes.songDetail:
          {
            final args = settings.arguments;
            // We support either a full Song or a Map {'song': Song}
            Song? song;
            if (args is Song) {
              song = args;
            } else if (args is Map && args['song'] is Song) {
              song = args['song'] as Song;
            }

            if (song == null) {
              return _errorRoute(
                title: 'Paramètres manquants',
                message: 'Aucune chanson fournie à la route /song-detail.',
                settings: settings,
              );
            }

            return _slideRoute(
              SongDetailScreen(song: song),
              settings: settings,
              durationMs: 300,
              beginOffset: const Offset(1.0, 0.0),
            );
          }

        default:
          return _errorRoute(
            title: 'Route inconnue',
            message: 'La route "$name" est inconnue.',
            settings: settings,
          );
      }
    } catch (e) {
      return _errorRoute(
        title: 'Erreur de navigation',
        message: 'Une erreur est survenue: $e',
        settings: settings,
      );
    }
  }

  // Fallback for Navigator.onUnknownRoute if desired
  static Route<dynamic> unknownRoute(RouteSettings settings) {
    return _errorRoute(
      title: 'Route inconnue',
      message: 'La route "${settings.name}" est inconnue.',
      settings: settings,
    );
  }

  // Fade transition
  static PageRoute _fadeRoute(
    Widget page, {
    required RouteSettings settings,
    int durationMs = 300,
  }) {
    return PageRouteBuilder(
      settings: settings,
      transitionDuration: Duration(milliseconds: durationMs),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          child: child,
        );
      },
    );
  }

  // Slide transition
  static PageRoute _slideRoute(
    Widget page, {
    required RouteSettings settings,
    int durationMs = 300,
    Offset beginOffset = const Offset(0.0, 1.0),
  }) {
    return PageRouteBuilder(
      settings: settings,
      transitionDuration: Duration(milliseconds: durationMs),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween(
          begin: beginOffset,
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeInOut));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  // Error page route
  static PageRoute _errorRoute({
    required String title,
    required String message,
    required RouteSettings settings,
  }) {
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => ErrorScreen(title: title, message: message),
    );
  }
}
