import 'package:flutter/foundation.dart';
import '../services/audio_service.dart';

class AudioProvider extends ChangeNotifier {
  final AudioService _audioService = AudioService();

  // Expose AudioService getters
  AudioPlayerState get playerState => _audioService.playerState;
  Duration get currentPosition => _audioService.currentPosition;
  Duration get totalDuration => _audioService.totalDuration;
  double get volume => _audioService.volume;
  String? get currentUrl => _audioService.currentUrl;
  String? get currentTitle => _audioService.currentTitle;
  String? get errorMessage => _audioService.errorMessage;
  bool get isBuffering => _audioService.isBuffering;
  bool get isPlaying => _audioService.isPlaying;
  bool get isPaused => _audioService.isPaused;
  bool get isStopped => _audioService.isStopped;
  double get progress => _audioService.progress;
  String get currentPositionString => _audioService.currentPositionString;
  String get totalDurationString => _audioService.totalDurationString;
  String get remainingTimeString => _audioService.remainingTimeString;

  AudioProvider() {
    // Listen to AudioService changes and notify widgets
    _audioService.addListener(_onAudioServiceChanged);
    _initializeAudioService();
  }

  void _onAudioServiceChanged() {
    notifyListeners();
  }

  Future<void> _initializeAudioService() async {
    await _audioService.initialize();
  }

  // Expose AudioService methods
  Future<void> playPause(String url, {String? title}) async {
    await _audioService.playPause(url, title: title);
  }

  Future<void> pause() async {
    await _audioService.pause();
  }

  Future<void> resume() async {
    await _audioService.resume();
  }

  Future<void> stop() async {
    await _audioService.stop();
  }

  Future<void> seek(Duration position) async {
    await _audioService.seek(position);
  }

  Future<void> setVolume(double volume) async {
    await _audioService.setVolume(volume);
  }

  String formatDuration(Duration duration) {
    return _audioService.formatDuration(duration);
  }

  @override
  void dispose() {
    _audioService.removeListener(_onAudioServiceChanged);
    _audioService.dispose();
    super.dispose();
  }
}
