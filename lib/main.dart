import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'providers/audio_provider.dart';
import 'providers/songs_provider.dart';
import 'routes/app_router.dart';
import 'theme/app_theme.dart';
import 'database.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize database factory for Android
  try {
    final dbFactory = getDatabaseFactory();
    databaseFactory = dbFactory;
    debugPrint('Database factory initialized successfully');
  } catch (e) {
    debugPrint('Error initializing database factory: $e');
  }

  runApp(const HanitraAnkasitrahanaApp());
}

class HanitraAnkasitrahanaApp extends StatefulWidget {
  const HanitraAnkasitrahanaApp({super.key});

  @override
  State<HanitraAnkasitrahanaApp> createState() =>
      _HanitraAnkasitrahanaAppState();
}

class _HanitraAnkasitrahanaAppState extends State<HanitraAnkasitrahanaApp> {
  late SongsProvider _songsProvider;
  late AudioProvider _audioProvider;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeProviders();
  }

  Future<void> _initializeProviders() async {
    _songsProvider = SongsProvider();
    _audioProvider = AudioProvider();

    // Initialize providers
    await _songsProvider.initialize();

    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return MaterialApp(
        title: 'Hanitra Ankasitrahana',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _songsProvider),
        ChangeNotifierProvider.value(value: _audioProvider),
      ],
      child: MaterialApp(
        title: 'Hanitra Ankasitrahana',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRouter.generateRoute,
        onUnknownRoute: AppRouter.unknownRoute,
        // Add home route as fallback
        home: null,
      ),
    );
  }

  @override
  void dispose() {
    _songsProvider.dispose();
    _audioProvider.dispose();
    super.dispose();
  }
}
