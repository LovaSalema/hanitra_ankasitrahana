import 'package:flutter/foundation.dart';
import '../models/song.dart';
import '../database/database_helper.dart';

enum SongsLoadingState { initial, loading, loaded, error, refreshing }

class SongsProvider extends ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // State variables
  List<Song> _allSongs = [];
  List<Song> _filteredSongs = [];
  SongsLoadingState _loadingState = SongsLoadingState.initial;
  String _searchQuery = '';
  String? _errorMessage;
  Song? _selectedSong;

  // Getters
  List<Song> get allSongs => List.unmodifiable(_allSongs);
  List<Song> get filteredSongs => List.unmodifiable(_filteredSongs);
  SongsLoadingState get loadingState => _loadingState;
  String get searchQuery => _searchQuery;
  String? get errorMessage => _errorMessage;
  Song? get selectedSong => _selectedSong;

  bool get isLoading => _loadingState == SongsLoadingState.loading;
  bool get isRefreshing => _loadingState == SongsLoadingState.refreshing;
  bool get hasError => _loadingState == SongsLoadingState.error;
  bool get isEmpty =>
      _filteredSongs.isEmpty && _loadingState == SongsLoadingState.loaded;
  bool get hasData => _filteredSongs.isNotEmpty;
  int get songCount => _filteredSongs.length;
  int get totalSongCount => _allSongs.length;

  // Initialize and load songs
  Future<void> initialize() async {
    debugPrint('SongsProvider: Starting initialization...');
    await loadSongs();
  }

  // Load all songs from database
  Future<void> loadSongs() async {
    try {
      debugPrint('SongsProvider: Setting loading state...');
      _setLoadingState(SongsLoadingState.loading);
      _clearError();

      debugPrint('SongsProvider: Fetching songs from database...');
      final songs = await _databaseHelper.getAllSongs();

      debugPrint('SongsProvider: Received ${songs.length} songs from database');
      _allSongs = songs;
      _applySearchFilter();
      _setLoadingState(SongsLoadingState.loaded);

      debugPrint('SongsProvider: Successfully loaded ${songs.length} songs');
      debugPrint(
        'SongsProvider: Filtered songs count: ${_filteredSongs.length}',
      );
    } catch (e) {
      debugPrint('SongsProvider: Error loading songs: $e');
      _setError('Failed to load songs: $e');
    }
  }

  // Refresh songs (for pull-to-refresh)
  Future<void> refreshSongs() async {
    try {
      _setLoadingState(SongsLoadingState.refreshing);
      _clearError();

      final songs = await _databaseHelper.getAllSongs();

      _allSongs = songs;
      _applySearchFilter();
      _setLoadingState(SongsLoadingState.loaded);

      debugPrint('Refreshed ${songs.length} songs from database');
    } catch (e) {
      debugPrint('Error refreshing songs: $e');
      _setError('Failed to refresh songs: $e');
    }
  }

  // Search functionality
  void searchSongs(String query) {
    _searchQuery = query.trim();
    _applySearchFilter();
    notifyListeners();
  }

  // Clear search
  void clearSearch() {
    _searchQuery = '';
    _applySearchFilter();
    notifyListeners();
  }

  // Apply search filter to songs
  void _applySearchFilter() {
    if (_searchQuery.isEmpty) {
      _filteredSongs = List.from(_allSongs);
    } else {
      _filteredSongs = _allSongs.where((song) {
        final query = _searchQuery.toLowerCase();
        return song.titre.toLowerCase().contains(query) ||
            song.auteur.toLowerCase().contains(query) ||
            song.numero.toString().contains(query) ||
            song.tonalite.toLowerCase().contains(query) ||
            song.paroles.toLowerCase().contains(query);
      }).toList();
    }
  }

  // Get song by ID
  Future<Song?> getSongById(int id) async {
    try {
      return await _databaseHelper.getSongById(id);
    } catch (e) {
      debugPrint('Error getting song by ID: $e');
      return null;
    }
  }

  // Get song by number
  Future<Song?> getSongByNumber(int numero) async {
    try {
      return await _databaseHelper.getSongByNumber(numero);
    } catch (e) {
      debugPrint('Error getting song by number: $e');
      return null;
    }
  }

  // Add new song
  Future<bool> addSong(Song song) async {
    try {
      _clearError();
      final id = await _databaseHelper.insertSong(song);

      if (id > 0) {
        final newSong = song.copyWith(id: id);
        _allSongs.add(newSong);
        _applySearchFilter();
        notifyListeners();

        debugPrint('Added new song: ${song.titre}');
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error adding song: $e');
      _setError('Failed to add song: $e');
      return false;
    }
  }

  // Update existing song
  Future<bool> updateSong(Song song) async {
    try {
      _clearError();
      final result = await _databaseHelper.updateSong(song);

      if (result > 0) {
        final index = _allSongs.indexWhere((s) => s.id == song.id);
        if (index != -1) {
          _allSongs[index] = song;
          _applySearchFilter();
          notifyListeners();

          debugPrint('Updated song: ${song.titre}');
          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint('Error updating song: $e');
      _setError('Failed to update song: $e');
      return false;
    }
  }

  // Delete song
  Future<bool> deleteSong(int id) async {
    try {
      _clearError();
      final result = await _databaseHelper.deleteSong(id);

      if (result > 0) {
        _allSongs.removeWhere((song) => song.id == id);
        _applySearchFilter();

        // Clear selected song if it was deleted
        if (_selectedSong?.id == id) {
          _selectedSong = null;
        }

        notifyListeners();
        debugPrint('Deleted song with ID: $id');
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error deleting song: $e');
      _setError('Failed to delete song: $e');
      return false;
    }
  }

  // Filter songs by author
  List<Song> getSongsByAuthor(String author) {
    return _allSongs
        .where((song) => song.auteur.toLowerCase() == author.toLowerCase())
        .toList();
  }

  // Filter songs by tonality
  List<Song> getSongsByTonality(String tonality) {
    return _allSongs
        .where((song) => song.tonalite.toLowerCase() == tonality.toLowerCase())
        .toList();
  }

  // Get all unique authors
  List<String> getAllAuthors() {
    final authors = _allSongs.map((song) => song.auteur).toSet().toList();
    authors.sort();
    return authors;
  }

  // Get all unique tonalities
  List<String> getAllTonalities() {
    final tonalities = _allSongs.map((song) => song.tonalite).toSet().toList();
    tonalities.sort();
    return tonalities;
  }

  // Select a song (for detail view)
  void selectSong(Song song) {
    _selectedSong = song;
    notifyListeners();
  }

  // Clear selected song
  void clearSelectedSong() {
    _selectedSong = null;
    notifyListeners();
  }

  // Get random song
  Song? getRandomSong() {
    if (_allSongs.isEmpty) return null;
    final random = DateTime.now().millisecondsSinceEpoch % _allSongs.length;
    return _allSongs[random];
  }

  // Get songs with audio
  List<Song> getSongsWithAudio() {
    return _allSongs
        .where((song) => song.lienAudio != null && song.lienAudio!.isNotEmpty)
        .toList();
  }

  // Get songs without audio
  List<Song> getSongsWithoutAudio() {
    return _allSongs
        .where((song) => song.lienAudio == null || song.lienAudio!.isEmpty)
        .toList();
  }

  // Search songs in database (for advanced search)
  Future<List<Song>> searchSongsInDatabase(String query) async {
    try {
      return await _databaseHelper.searchSongs(query);
    } catch (e) {
      debugPrint('Error searching songs in database: $e');
      return [];
    }
  }

  // Get song statistics
  Map<String, dynamic> getStatistics() {
    final songsWithAudio = getSongsWithAudio().length;
    final songsWithoutAudio = getSongsWithoutAudio().length;
    final authors = getAllAuthors().length;
    final tonalities = getAllTonalities().length;

    return {
      'totalSongs': _allSongs.length,
      'songsWithAudio': songsWithAudio,
      'songsWithoutAudio': songsWithoutAudio,
      'uniqueAuthors': authors,
      'uniqueTonalities': tonalities,
      'filteredSongs': _filteredSongs.length,
    };
  }

  // Private helper methods
  void _setLoadingState(SongsLoadingState state) {
    debugPrint('SongsProvider: State changed from $_loadingState to $state');
    _loadingState = state;
    notifyListeners();
  }

  void _setError(String error) {
    debugPrint('SongsProvider: Error occurred: $error');
    _errorMessage = error;
    _loadingState = SongsLoadingState.error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  // Retry loading after error
  Future<void> retry() async {
    await loadSongs();
  }

  @override
  void dispose() {
    _allSongs.clear();
    _filteredSongs.clear();
    super.dispose();
  }
}
