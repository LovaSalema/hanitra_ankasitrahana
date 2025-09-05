import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/song.dart';
import '../providers/songs_provider.dart';
import '../providers/audio_provider.dart';
import '../routes/app_router.dart';
import '../theme/app_theme.dart';

class SongListScreen extends StatefulWidget {
  const SongListScreen({super.key});

  @override
  State<SongListScreen> createState() => _SongListScreenState();
}

class _SongListScreenState extends State<SongListScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  late AnimationController _searchAnimationController;
  late Animation<double> _searchAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _searchController.addListener(_onSearchChanged);
  }

  void _initializeAnimations() {
    _searchAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _searchAnimation = CurvedAnimation(
      parent: _searchAnimationController,
      curve: Curves.easeInOut,
    );
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    context.read<SongsProvider>().searchSongs(query);

    if (query.isNotEmpty) {
      _searchAnimationController.forward();
    } else {
      _searchAnimationController.reverse();
    }
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<SongsProvider>().clearSearch();
    FocusScope.of(context).unfocus();
  }

  Future<void> _refreshSongs() async {
    await context.read<SongsProvider>().refreshSongs();
  }

  void _navigateToSongDetail(Song song) {
    // Select the song in provider
    context.read<SongsProvider>().selectSong(song);

    // Navigate using named route so it benefits from central route transitions
    Navigator.of(context).pushNamed(AppRoutes.songDetail, arguments: song);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Custom App Bar with Logo
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            elevation: 0,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.darkBurgundy,
                    AppColors.primaryBurgundy,
                    AppColors.burgundyAccent,
                  ],
                ),
              ),
              child: FlexibleSpaceBar(
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                      child: const Icon(
                        Icons.music_note,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Hanitra Ankasitrahana',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                centerTitle: true,
                titlePadding: const EdgeInsets.only(bottom: 16),
              ),
            ),
          ),

          // Search Bar
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF6A4C93), Colors.transparent],
                  stops: [0.0, 1.0],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: AnimatedBuilder(
                  animation: _searchAnimation,
                  builder: (context, child) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Consumer<SongsProvider>(
                        builder: (context, songsProvider, child) {
                          return TextField(
                            controller: _searchController,
                            style: const TextStyle(fontSize: 16),
                            decoration: InputDecoration(
                              hintText: 'Rechercher une chanson...',
                              hintStyle: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 16,
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.grey[600],
                                size: 24,
                              ),
                              suffixIcon: songsProvider.searchQuery.isNotEmpty
                                  ? IconButton(
                                      icon: Icon(
                                        Icons.clear,
                                        color: Colors.grey[600],
                                      ),
                                      onPressed: _clearSearch,
                                    )
                                  : null,
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // Songs List with Consumer
          SliverToBoxAdapter(
            child: Consumer<SongsProvider>(
              builder: (context, songsProvider, child) {
                return RefreshIndicator(
                  key: _refreshIndicatorKey,
                  onRefresh: _refreshSongs,
                  color: const Color(0xFF2A5298),
                  child: _buildSongsList(songsProvider),
                );
              },
            ),
          ),
        ],
      ),

      // Statistics and Actions
      floatingActionButton: Consumer<SongsProvider>(
        builder: (context, songsProvider, child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Statistics FAB
              if (songsProvider.hasData)
                FloatingActionButton.small(
                  heroTag: "stats",
                  onPressed: () => _showStatistics(context, songsProvider),
                  backgroundColor: const Color(0xFF6A4C93),
                  child: const Icon(Icons.analytics, color: Colors.white),
                ),

              const SizedBox(height: 8),

              // Add Song FAB
              FloatingActionButton(
                heroTag: "add",
                onPressed: () => _showAddSongDialog(context),
                backgroundColor: const Color(0xFF2A5298),
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSongsList(SongsProvider songsProvider) {
    // Loading state
    if (songsProvider.isLoading) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Color(0xFF2A5298),
                strokeWidth: 3,
              ),
              SizedBox(height: 16),
              Text(
                'Chargement des chansons...',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    // Error state
    if (songsProvider.hasError) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 80, color: Colors.red[400]),
              const SizedBox(height: 16),
              Text(
                'Erreur de chargement',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.red[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                songsProvider.errorMessage ?? 'Une erreur est survenue',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => songsProvider.retry(),
                icon: const Icon(Icons.refresh),
                label: const Text('Réessayer'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2A5298),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Empty state
    if (songsProvider.isEmpty) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                songsProvider.searchQuery.isNotEmpty
                    ? Icons.search_off
                    : Icons.music_off,
                size: 80,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                songsProvider.searchQuery.isNotEmpty
                    ? 'Aucune chanson trouvée'
                    : 'Aucune chanson disponible',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                songsProvider.searchQuery.isNotEmpty
                    ? 'Essayez avec d\'autres mots-clés'
                    : 'Tirez vers le bas pour actualiser',
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              ),
            ],
          ),
        ),
      );
    }

    // Songs list
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      itemCount: songsProvider.filteredSongs.length,
      itemBuilder: (context, index) {
        final song = songsProvider.filteredSongs[index];
        return _buildSongCard(song, index);
      },
    );
  }

  Widget _buildSongCard(Song song, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 50)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: Card(
                elevation: 4,
                shadowColor: Colors.black.withValues(alpha: 0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: InkWell(
                  onTap: () => _navigateToSongDetail(song),
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        // Music Icon and Number Badge
                        Stack(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF1E3C72),
                                    Color(0xFF2A5298),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(28),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF2A5298,
                                    ).withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  const Center(
                                    child: Icon(
                                      Icons.music_note,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                  ),
                                  // Audio indicator
                                  if (song.lienAudio != null &&
                                      song.lienAudio!.isNotEmpty)
                                    Positioned(
                                      bottom: 2,
                                      right: 2,
                                      child: Container(
                                        width: 16,
                                        height: 16,
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.volume_up,
                                          color: Colors.white,
                                          size: 8,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: -2,
                              right: -2,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF9B59B6),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: Text(
                                  song.numero.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(width: 16),

                        // Song Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                song.titre,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E3C72),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Par ${song.auteur}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${song.tonalite} • ${song.mesure}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Play button for songs with audio
                        if (song.lienAudio != null &&
                            song.lienAudio!.isNotEmpty)
                          Consumer<AudioProvider>(
                            builder: (context, audioProvider, child) {
                              final isCurrentTrack =
                                  audioProvider.currentUrl == song.lienAudio;
                              final isPlaying =
                                  isCurrentTrack && audioProvider.isPlaying;

                              return Container(
                                margin: const EdgeInsets.only(right: 8),
                                child: IconButton(
                                  onPressed: () => audioProvider.playPause(
                                    song.lienAudio!,
                                    title: song.titre,
                                  ),
                                  icon: Icon(
                                    isPlaying ? Icons.pause : Icons.play_arrow,
                                    color: const Color(0xFF2A5298),
                                    size: 28,
                                  ),
                                ),
                              );
                            },
                          ),

                        // Navigation Arrow
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF2A5298,
                            ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            color: Color(0xFF2A5298),
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showStatistics(BuildContext context, SongsProvider songsProvider) {
    final stats = songsProvider.getStatistics();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Statistiques'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatItem('Total des chansons', '${stats['totalSongs']}'),
            _buildStatItem('Avec audio', '${stats['songsWithAudio']}'),
            _buildStatItem('Sans audio', '${stats['songsWithoutAudio']}'),
            _buildStatItem('Auteurs uniques', '${stats['uniqueAuthors']}'),
            _buildStatItem('Tonalités uniques', '${stats['uniqueTonalities']}'),
            if (songsProvider.searchQuery.isNotEmpty)
              _buildStatItem('Résultats filtrés', '${stats['filteredSongs']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _showAddSongDialog(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fonctionnalité à venir: Ajouter une chanson'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
