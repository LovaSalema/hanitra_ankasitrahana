import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/song.dart';
import '../providers/audio_provider.dart';
import '../widgets/audio_player_widget.dart';

class SongDetailScreen extends StatefulWidget {
  final Song song;

  const SongDetailScreen({super.key, required this.song});

  @override
  State<SongDetailScreen> createState() => _SongDetailScreenState();
}

class _SongDetailScreenState extends State<SongDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _playButtonController;
  late AnimationController _pulseController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _playButtonScaleAnimation;
  late Animation<double> _playButtonRotationAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    // Fade animation for content
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    // Play button animations
    _playButtonController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _playButtonScaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _playButtonController, curve: Curves.easeInOut),
    );
    _playButtonRotationAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(parent: _playButtonController, curve: Curves.easeInOut),
    );

    // Pulse animation for playing state
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _playButtonController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;

    return Scaffold(
      body: Consumer<AudioProvider>(
        builder: (context, audioProvider, child) {
          final isCurrentTrack =
              audioProvider.currentUrl == widget.song.lienAudio;
          final isPlaying = isCurrentTrack && audioProvider.isPlaying;
          final isBuffering = isCurrentTrack && audioProvider.isBuffering;

          // Control pulse animation based on playing state
          if (isPlaying) {
            _pulseController.repeat(reverse: true);
          } else {
            _pulseController.stop();
            _pulseController.reset();
          }

          return CustomScrollView(
            slivers: [
              // Enhanced SliverAppBar with parallax background
              SliverAppBar(
                expandedHeight: isTablet ? 400 : 300,
                floating: false,
                pinned: true,
                elevation: 0,
                backgroundColor: const Color(0xFF1E3C72),
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Background Image with parallax effect
                      _buildParallaxBackground(),

                      // Gradient Overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.3),
                              Colors.black.withValues(alpha: 0.7),
                            ],
                          ),
                        ),
                      ),

                      // Content on image
                      Positioned(
                        bottom: 20,
                        left: 20,
                        right: 20,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Song number badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF9B59B6),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.3,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  'Chanson #${widget.song.numero}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Song title
                              Text(
                                widget.song.titre,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isTablet ? 32 : 28,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.7,
                                      ),
                                      offset: const Offset(0, 2),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),

                              // Author
                              Text(
                                'Par ${widget.song.auteur}',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: isTablet ? 18 : 16,
                                  fontWeight: FontWeight.w500,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.7,
                                      ),
                                      offset: const Offset(0, 1),
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Technical Information Card
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Technical info row
                        Row(
                          children: [
                            Expanded(
                              child: _buildInfoChip(
                                icon: Icons.piano,
                                label: widget.song.tonalite,
                                color: const Color(0xFF2A5298),
                                title: 'Tonalité',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildInfoChip(
                                icon: Icons.av_timer,
                                label: widget.song.mesure,
                                color: const Color(0xFF6A4C93),
                                title: 'Mesure',
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Circular Play Button
                        if (widget.song.lienAudio != null &&
                            widget.song.lienAudio!.isNotEmpty)
                          _buildCircularPlayButton(
                            audioProvider,
                            isPlaying,
                            isBuffering,
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              // Lyrics Section
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey[200]!, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF2A5298,
                                ).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.lyrics,
                                color: const Color(0xFF2A5298),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Paroles',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          widget.song.paroles,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.8,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Full Audio Player (if available)
              if (widget.song.lienAudio != null &&
                  widget.song.lienAudio!.isNotEmpty)
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      child: AudioPlayerWidget(
                        audioUrl: widget.song.lienAudio!,
                        title: widget.song.titre,
                        showFullControls: true,
                      ),
                    ),
                  ),
                ),

              // Bottom spacing
              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildParallaxBackground() {
    // Generate a gradient background based on song data
    // In a real app, you might use actual images
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _getGradientColors(),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withValues(alpha: 0.3)],
          ),
        ),
        child: const Center(
          child: Icon(Icons.music_note, size: 120, color: Colors.white24),
        ),
      ),
    );
  }

  List<Color> _getGradientColors() {
    // Generate colors based on song number for variety
    final colors = [
      [const Color(0xFF1E3C72), const Color(0xFF2A5298)],
      [const Color(0xFF6A4C93), const Color(0xFF9B59B6)],
      [const Color(0xFF2A5298), const Color(0xFF6A4C93)],
      [const Color(0xFF1E3C72), const Color(0xFF9B59B6)],
      [const Color(0xFF4A90E2), const Color(0xFF7B68EE)],
    ];
    return colors[widget.song.numero % colors.length];
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
    required String title,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCircularPlayButton(
    AudioProvider audioProvider,
    bool isPlaying,
    bool isBuffering,
  ) {
    return GestureDetector(
      onTapDown: (_) => _playButtonController.forward(),
      onTapUp: (_) => _playButtonController.reverse(),
      onTapCancel: () => _playButtonController.reverse(),
      onTap: () => _handlePlayPause(audioProvider),
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _playButtonScaleAnimation,
          _pulseAnimation,
        ]),
        builder: (context, child) {
          return Transform.scale(
            scale:
                _playButtonScaleAnimation.value *
                (isPlaying ? _pulseAnimation.value : 1.0),
            child: Transform.rotate(
              angle: _playButtonRotationAnimation.value,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2A5298).withValues(alpha: 0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                    if (isPlaying)
                      BoxShadow(
                        color: const Color(0xFF2A5298).withValues(alpha: 0.6),
                        blurRadius: 30,
                        offset: const Offset(0, 0),
                      ),
                  ],
                ),
                child: isBuffering
                    ? const Center(
                        child: SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        size: 40,
                        color: Colors.white,
                      ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _handlePlayPause(AudioProvider audioProvider) {
    if (widget.song.lienAudio != null && widget.song.lienAudio!.isNotEmpty) {
      audioProvider.playPause(widget.song.lienAudio!, title: widget.song.titre);
    }
  }
}
