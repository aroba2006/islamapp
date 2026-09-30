import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../services/quran_reciter_service.dart';

/// A reusable Quran player widget with background support and notification control
class QuranPlayerWidget extends StatefulWidget {
  final QuranReciter reciter;
  final int surahNumber;
  final String surahNameAr;
  final String surahNameEn;

  const QuranPlayerWidget({
    super.key,
    required this.reciter,
    required this.surahNumber,
    required this.surahNameAr,
    required this.surahNameEn,
  });

  @override
  State<QuranPlayerWidget> createState() => _QuranPlayerWidgetState();
}

class _QuranPlayerWidgetState extends State<QuranPlayerWidget> {
  PlayerState _playerState = PlayerState.stopped;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _setupPlayerListeners();
  }

  void _setupPlayerListeners() {
    QuranReciterService.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() => _playerState = state);
      }
    });

    QuranReciterService.onDurationChanged.listen((duration) {
      if (mounted) {
        setState(() => _duration = duration);
      }
    });

    QuranReciterService.onPositionChanged.listen((position) {
      if (mounted) {
        setState(() => _position = position);
      }
    });
  }

  Future<void> _play() async {
    try {
      await QuranReciterService.playSurah(
        reciter: widget.reciter,
        surahNumber: widget.surahNumber,
        surahNameAr: widget.surahNameAr,
        reciterName: widget.reciter.nameEn,
      );
    } catch (e) {
      print('Error playing: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: Could not play audio')),
        );
      }
    }
  }

  Future<void> _pause() async {
    try {
      await QuranReciterService.pauseAudio();
    } catch (e) {
      print('Error pausing: $e');
    }
  }

  Future<void> _resume() async {
    try {
      await QuranReciterService.resumeAudio();
    } catch (e) {
      print('Error resuming: $e');
    }
  }

  Future<void> _stop() async {
    try {
      await QuranReciterService.stopAudio();
    } catch (e) {
      print('Error stopping: $e');
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  bool get _isPlaying => _playerState == PlayerState.playing;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1A1A1A) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFD4AF37).withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title and Reciter Info
          Column(
            children: [
              Text(
                widget.surahNameAr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFD4AF37),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.reciter.nameEn,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? Colors.white70 : Colors.grey.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Seek Slider
          Column(
            children: [
              SliderTheme(
                data: SliderThemeData(
                  trackHeight: 6,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                  activeTrackColor: const Color(0xFFD4AF37),
                  inactiveTrackColor: const Color(0xFFD4AF37).withValues(alpha: 0.3),
                  thumbColor: const Color(0xFFD4AF37),
                  overlayColor: const Color(0xFFD4AF37).withValues(alpha: 0.3),
                ),
                child: Slider(
                  value: _position.inSeconds.toDouble(),
                  max: _duration.inSeconds.toDouble() > 0 
                    ? _duration.inSeconds.toDouble() 
                    : 1,
                  onChanged: (value) {
                    QuranReciterService.seek(Duration(seconds: value.toInt()));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDuration(_position),
                      style: TextStyle(
                        fontSize: 12,
                        color: isDarkMode ? Colors.white70 : Colors.grey.shade700,
                      ),
                    ),
                    Text(
                      _formatDuration(_duration),
                      style: TextStyle(
                        fontSize: 12,
                        color: isDarkMode ? Colors.white70 : Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Player Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Stop Button
              IconButton(
                onPressed: _stop,
                icon: Icon(Icons.stop_circle, size: 32),
                color: isDarkMode ? Colors.white70 : Colors.grey.shade700,
                tooltip: 'Stop',
              ),
              const SizedBox(width: 8),

              // Play/Pause Button
              IconButton(
                onPressed: _isPlaying ? _pause : (_playerState == PlayerState.stopped ? _play : _resume),
                icon: Icon(
                  _isPlaying ? Icons.pause_circle : Icons.play_circle,
                  size: 48,
                ),
                color: const Color(0xFFD4AF37),
                tooltip: _isPlaying ? 'Pause' : 'Play',
              ),
              const SizedBox(width: 8),

              // Volume Control (Optional - you can expand this)
              IconButton(
                onPressed: () {
                  _showVolumeDialog();
                },
                icon: Icon(Icons.volume_up, size: 32),
                color: isDarkMode ? Colors.white70 : Colors.grey.shade700,
                tooltip: 'Volume',
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Status Text
          Text(
            _getStatusText(),
            style: TextStyle(
              fontSize: 12,
              color: isDarkMode ? Colors.white54 : Colors.grey.shade600,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusText() {
    if (_playerState == PlayerState.playing) {
      return 'Now Playing • Continues in background';
    } else if (_playerState == PlayerState.paused) {
      return 'Paused';
    } else if (_playerState == PlayerState.completed) {
      return 'Completed';
    }
    return 'Ready to play';
  }

  void _showVolumeDialog() {
    double volume = 1.0;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Volume'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Slider(
                value: volume,
                min: 0,
                max: 1,
                divisions: 10,
                label: '${(volume * 100).toInt()}%',
                onChanged: (value) {
                  setState(() => volume = value);
                  QuranReciterService.setVolume(value);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}