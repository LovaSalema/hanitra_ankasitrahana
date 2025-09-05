import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';

enum AudioPlayerState { stopped, playing, paused, buffering, error }

class AudioService extends ChangeNotifier {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();

  // State variables
  AudioPlayerState _playerState = AudioPlayerState.stopped;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  double _volume = 1.0;
  String? _currentUrl;
  String? _currentTitle;
  String? _errorMessage;
  bool _isBuffering = false;

  // Stream subscriptions
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration>? _durationSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;

  // Getters
  AudioPlayerState get playerState => _playerState;
  Duration get currentPosition => _currentPosition;
  Duration get totalDuration => _totalDuration;
  double get volume => _volume;
  String? get currentUrl => _currentUrl;
  String? get currentTitle => _currentTitle;
  String? get errorMessage => _errorMessage;
  bool get isBuffering => _isBuffering;
  bool get isPlaying => _playerState == AudioPlayerState.playing;
  bool get isPaused => _playerState == AudioPlayerState.paused;
  bool get isStopped => _playerState == AudioPlayerState.stopped;

  // Progress percentage (0.0 to 1.0)
  double get progress {
    if (_totalDuration.inMilliseconds == 0) return 0.0;
    return _currentPosition.inMilliseconds / _totalDuration.inMilliseconds;
  }

  // Initialize the audio service
  Future<void> initialize() async {
    try {
      // Set audio context for mobile platforms
      await _audioPlayer.setReleaseMode(ReleaseMode.stop);

      // Listen to position changes
      _positionSubscription = _audioPlayer.onPositionChanged.listen((position) {
        _currentPosition = position;
        notifyListeners();
      });

      // Listen to duration changes
      _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
        _totalDuration = duration;
        notifyListeners();
      });

      // Listen to player state changes
      _playerStateSubscription = _audioPlayer.onPlayerStateChanged.listen((
        state,
      ) {
        _handlePlayerStateChange(state);
      });

      debugPrint('AudioService initialized successfully');
    } catch (e) {
      debugPrint('Error initializing AudioService: $e');
      _setError('Failed to initialize audio service: $e');
    }
  }

  // Handle player state changes
  void _handlePlayerStateChange(PlayerState state) {
    switch (state) {
      case PlayerState.stopped:
        _playerState = AudioPlayerState.stopped;
        _currentPosition = Duration.zero;
        break;
      case PlayerState.playing:
        _playerState = AudioPlayerState.playing;
        _isBuffering = false;
        break;
      case PlayerState.paused:
        _playerState = AudioPlayerState.paused;
        _isBuffering = false;
        break;
      case PlayerState.completed:
        _playerState = AudioPlayerState.stopped;
        _currentPosition = Duration.zero;
        break;
      case PlayerState.disposed:
        _playerState = AudioPlayerState.stopped;
        _currentPosition = Duration.zero;
        _totalDuration = Duration.zero;
        break;
    }
    notifyListeners();
  }

  // Play or pause audio
  Future<void> playPause(String url, {String? title}) async {
    try {
      _clearError();

      if (_currentUrl != url) {
        // New URL, stop current and play new
        await stop();
        await _playUrl(url, title: title);
      } else {
        // Same URL, toggle play/pause
        if (_playerState == AudioPlayerState.playing) {
          await pause();
        } else if (_playerState == AudioPlayerState.paused) {
          await resume();
        } else {
          await _playUrl(url, title: title);
        }
      }
    } catch (e) {
      debugPrint('Error in playPause: $e');
      _setError('Failed to play audio: $e');
    }
  }

  // Play a specific URL
  Future<void> _playUrl(String url, {String? title}) async {
    try {
      _setBuffering(true);
      _currentUrl = url;
      _currentTitle = title;

      // Convert SoundCloud URL to direct audio URL if needed
      String audioUrl = await _processSoundCloudUrl(url);

      await _audioPlayer.play(UrlSource(audioUrl));
      debugPrint('Playing audio from: $audioUrl');
    } catch (e) {
      debugPrint('Error playing URL: $e');
      _setError('Failed to play audio from URL: $e');
      _setBuffering(false);
    }
  }

  // Process SoundCloud URL to get direct audio URL
  Future<String> _processSoundCloudUrl(String url) async {
    // For now, return the original URL
    // In a real implementation, you would:
    // 1. Use SoundCloud API to get track info
    // 2. Extract the direct audio stream URL
    // 3. Handle authentication if needed

    if (url.contains('soundcloud.com')) {
      // This is a placeholder - in production you'd need SoundCloud API integration
      debugPrint('Processing SoundCloud URL: $url');
      // For demo purposes, we'll use a direct audio URL
      // You would replace this with actual SoundCloud API integration
      return url;
    }

    return url;
  }

  // Pause playback
  Future<void> pause() async {
    try {
      await _audioPlayer.pause();
    } catch (e) {
      debugPrint('Error pausing: $e');
      _setError('Failed to pause audio: $e');
    }
  }

  // Resume playback
  Future<void> resume() async {
    try {
      await _audioPlayer.resume();
    } catch (e) {
      debugPrint('Error resuming: $e');
      _setError('Failed to resume audio: $e');
    }
  }

  // Stop playback
  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
      _currentUrl = null;
      _currentTitle = null;
      _currentPosition = Duration.zero;
      _totalDuration = Duration.zero;
      _clearError();
    } catch (e) {
      debugPrint('Error stopping: $e');
      _setError('Failed to stop audio: $e');
    }
  }

  // Seek to a specific position
  Future<void> seek(Duration position) async {
    try {
      await _audioPlayer.seek(position);
    } catch (e) {
      debugPrint('Error seeking: $e');
      _setError('Failed to seek to position: $e');
    }
  }

  // Set volume (0.0 to 1.0)
  Future<void> setVolume(double volume) async {
    try {
      _volume = volume.clamp(0.0, 1.0);
      await _audioPlayer.setVolume(_volume);
      notifyListeners();
    } catch (e) {
      debugPrint('Error setting volume: $e');
      _setError('Failed to set volume: $e');
    }
  }

  // Set buffering state
  void _setBuffering(bool buffering) {
    _isBuffering = buffering;
    if (buffering) {
      _playerState = AudioPlayerState.buffering;
    }
    notifyListeners();
  }

  // Set error state
  void _setError(String error) {
    _errorMessage = error;
    _playerState = AudioPlayerState.error;
    _isBuffering = false;
    notifyListeners();
  }

  // Clear error state
  void _clearError() {
    _errorMessage = null;
    if (_playerState == AudioPlayerState.error) {
      _playerState = AudioPlayerState.stopped;
    }
    notifyListeners();
  }

  // Format duration for display
  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours > 0) {
      return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
    } else {
      return '$twoDigitMinutes:$twoDigitSeconds';
    }
  }

  // Get current position as formatted string
  String get currentPositionString => formatDuration(_currentPosition);

  // Get total duration as formatted string
  String get totalDurationString => formatDuration(_totalDuration);

  // Get remaining time as formatted string
  String get remainingTimeString {
    final remaining = _totalDuration - _currentPosition;
    return '-${formatDuration(remaining)}';
  }

  // Dispose resources
  @override
  void dispose() {
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }
}
