import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/audio_provider.dart';
import '../services/audio_service.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String audioUrl;
  final String? title;
  final bool showFullControls;

  const AudioPlayerWidget({
    Key? key,
    required this.audioUrl,
    this.title,
    this.showFullControls = true,
  }) : super(key: key);

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget>
    with TickerProviderStateMixin {
  late AnimationController _playButtonController;
  late Animation<double> _playButtonAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _playButtonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _playButtonAnimation = CurvedAnimation(
      parent: _playButtonController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _playButtonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioProvider>(
      builder: (context, audioProvider, child) {
        final isCurrentTrack = audioProvider.currentUrl == widget.audioUrl;
        final isPlaying = isCurrentTrack && audioProvider.isPlaying;
        final isPaused = isCurrentTrack && audioProvider.isPaused;
        final isBuffering = isCurrentTrack && audioProvider.isBuffering;

        // Update play button animation
        if (isPlaying) {
          _playButtonController.forward();
        } else {
          _playButtonController.reverse();
        }

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2A5298).withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              // Title
              if (widget.title != null) ...[
                Text(
                  widget.title!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 20),
              ],

              // Main Play Button
              GestureDetector(
                onTap: () => _handlePlayPause(audioProvider),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
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
                              color: Color(0xFF2A5298),
                            ),
                          ),
                        )
                      : AnimatedBuilder(
                          animation: _playButtonAnimation,
                          builder: (context, child) {
                            return Icon(
                              isPlaying ? Icons.pause : Icons.play_arrow,
                              size: 40,
                              color: const Color(0xFF2A5298),
                            );
                          },
                        ),
                ),
              ),

              if (widget.showFullControls && isCurrentTrack) ...[
                const SizedBox(height: 20),

                // Progress Bar
                _buildProgressBar(audioProvider),

                const SizedBox(height: 16),

                // Time Display
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      audioProvider.currentPositionString,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      audioProvider.totalDurationString,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Control Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Previous (placeholder)
                    IconButton(
                      onPressed: null,
                      icon: const Icon(
                        Icons.skip_previous,
                        color: Colors.white54,
                        size: 28,
                      ),
                    ),

                    // Stop
                    IconButton(
                      onPressed: () => audioProvider.stop(),
                      icon: const Icon(
                        Icons.stop,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),

                    // Next (placeholder)
                    IconButton(
                      onPressed: null,
                      icon: const Icon(
                        Icons.skip_next,
                        color: Colors.white54,
                        size: 28,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Volume Control
                _buildVolumeControl(audioProvider),
              ],

              // Error Display
              if (audioProvider.errorMessage != null && isCurrentTrack) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.red.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          audioProvider.errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildProgressBar(AudioProvider audioProvider) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: Colors.white,
        inactiveTrackColor: Colors.white30,
        thumbColor: Colors.white,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
        trackHeight: 3,
      ),
      child: Slider(
        value: audioProvider.progress.clamp(0.0, 1.0),
        onChanged: (value) {
          final position = Duration(
            milliseconds: (value * audioProvider.totalDuration.inMilliseconds)
                .round(),
          );
          audioProvider.seek(position);
        },
      ),
    );
  }

  Widget _buildVolumeControl(AudioProvider audioProvider) {
    return Row(
      children: [
        const Icon(Icons.volume_down, color: Colors.white70, size: 20),
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.white70,
              inactiveTrackColor: Colors.white30,
              thumbColor: Colors.white70,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 4),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 8),
              trackHeight: 2,
            ),
            child: Slider(
              value: audioProvider.volume,
              onChanged: (value) => audioProvider.setVolume(value),
            ),
          ),
        ),
        const Icon(Icons.volume_up, color: Colors.white70, size: 20),
      ],
    );
  }

  void _handlePlayPause(AudioProvider audioProvider) {
    audioProvider.playPause(widget.audioUrl, title: widget.title);
  }
}
