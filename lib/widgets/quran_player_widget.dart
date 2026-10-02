import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import '../services/quran_reciter_service.dart';

/// A reusable Quran player widget with background support and notification control.
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

  /// While the user is dragging the slider, ignore incoming position updates
  /// so the thumb doesn't jump back under their finger.
  bool _isScrubbing = false;
  double _scrubValue = 0;

  bool _isLoadingAudio = false;

  @override
  void initState() {
    super.initState();
    _setupPlayerListeners();
  }

  void _setupPlayerListeners() {
    QuranReciterService.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        _playerState = state;
        // Any state transition that isn't "playing" clears the loading flag.
        if (state == PlayerState.playing || state == PlayerState.paused) {
          _isLoadingAudio = false;
        }
      });
    });

    QuranReciterService.onDurationChanged.listen((duration) {
      if (mounted) setState(() => _duration = duration);
    });

    QuranReciterService.onPositionChanged.listen((position) {
      if (!mounted || _isScrubbing) return;
      setState(() => _position = position);
    });
  }

  Future<void> _play() async {
    setState(() => _isLoadingAudio = true);
    try {
      await QuranReciterService.playSurah(
        reciter: widget.reciter,
        surahNumber: widget.surahNumber,
        surahNameAr: widget.surahNameAr,
        reciterName: widget.reciter.nameEn,
      );
    } catch (e) {
      debugPrint('Error playing: $e');
      if (!mounted) return;
      setState(() => _isLoadingAudio = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Could not play audio')),
      );
    }
  }

  Future<void> _pause() async {
    try {
      await QuranReciterService.pauseAudio();
    } catch (e) {
      debugPrint('Error pausing: $e');
    }
  }

  Future<void> _resume() async {
    try {
      await QuranReciterService.resumeAudio();
    } catch (e) {
      debugPrint('Error resuming: $e');
    }
  }

  Future<void> _stop() async {
    try {
      await QuranReciterService.stopAudio();
      if (mounted) {
        setState(() {
          _position = Duration.zero;
          _isLoadingAudio = false;
        });
      }
    } catch (e) {
      debugPrint('Error stopping: $e');
    }
  }

  Future<void> _skip(Duration delta) async {
    final target = _position + delta;
    final clamped = target < Duration.zero
        ? Duration.zero
        : (target > _duration ? _duration : target);
    try {
      await QuranReciterService.seek(clamped);
      if (mounted) setState(() => _position = clamped);
    } catch (e) {
      debugPrint('Error seeking: $e');
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  bool get _isPlaying => _playerState == PlayerState.playing;
  bool get _isPaused => _playerState == PlayerState.paused;
  bool get _isStopped =>
      _playerState == PlayerState.stopped ||
      _playerState == PlayerState.completed;

  @override
  Widget build(BuildContext context) {
    final palette = _PlayerPalette.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: palette.gold.withValues(alpha: 0.35),
          width: 1.4,
        ),
        boxShadow: [
          BoxShadow(
            color: palette.gold.withValues(alpha: 0.10),
            blurRadius: 24,
            spreadRadius: -6,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ---------- HEADER: reciter + surah ----------
          _Header(
            surahNameAr: widget.surahNameAr,
            surahNameEn: widget.surahNameEn,
            reciterName: widget.reciter.nameEn,
            palette: palette,
          ),
          const SizedBox(height: 18),

          // ---------- SEEK BAR ----------
          _SeekBar(
            position: _isScrubbing
                ? Duration(seconds: _scrubValue.round())
                : _position,
            duration: _duration,
            isScrubbing: _isScrubbing,
            palette: palette,
            onScrubStart: (v) => setState(() {
              _isScrubbing = true;
              _scrubValue = v;
            }),
            onScrubUpdate: (v) => setState(() => _scrubValue = v),
            onScrubEnd: (v) async {
              setState(() {
                _isScrubbing = false;
                _position = Duration(seconds: v.round());
              });
              await QuranReciterService.seek(
                Duration(seconds: v.round()),
              );
            },
            formatDuration: _formatDuration,
          ),
          const SizedBox(height: 16),

          // ---------- CONTROLS ----------
          _Controls(
            isPlaying: _isPlaying,
            isStopped: _isStopped,
            isLoading: _isLoadingAudio,
            palette: palette,
            onStop: _stop,
            onSkipBack: () => _skip(const Duration(seconds: -10)),
            onSkipForward: () => _skip(const Duration(seconds: 10)),
            onPlayPause: () {
              if (_isPlaying) {
                _pause();
              } else if (_isPaused) {
                _resume();
              } else {
                _play();
              }
            },
            onVolume: () => _showVolumeDialog(palette),
          ),
          const SizedBox(height: 14),

          // ---------- STATUS ----------
          _StatusLine(
            state: _playerState,
            isLoading: _isLoadingAudio,
            palette: palette,
          ),
        ],
      ),
    );
  }

  void _showVolumeDialog(_PlayerPalette palette) {
    double volume = 1.0;

    showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setLocal) => AlertDialog(
          backgroundColor: palette.card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: palette.gold.withValues(alpha: 0.4),
              width: 1.2,
            ),
          ),
          title: Row(
            children: [
              Icon(Icons.volume_up_rounded, color: palette.gold, size: 22),
              const SizedBox(width: 10),
              Text(
                'Volume',
                style: TextStyle(
                  color: palette.text,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SliderTheme(
                data: SliderThemeData(
                  trackHeight: 5,
                  activeTrackColor: palette.gold,
                  inactiveTrackColor: palette.gold.withValues(alpha: 0.25),
                  thumbColor: palette.gold,
                  overlayColor: palette.gold.withValues(alpha: 0.25),
                ),
                child: Slider(
                  value: volume,
                  min: 0,
                  max: 1,
                  divisions: 10,
                  label: '${(volume * 100).toInt()}%',
                  onChanged: (value) {
                    setLocal(() => volume = value);
                    QuranReciterService.setVolume(value);
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Close',
                style: TextStyle(color: palette.gold),
              ),
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

// ============================================================================
//  HEADER
// ============================================================================

class _Header extends StatelessWidget {
  final String surahNameAr;
  final String surahNameEn;
  final String reciterName;
  final _PlayerPalette palette;

  const _Header({
    required this.surahNameAr,
    required this.surahNameEn,
    required this.reciterName,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Gold disc with a book/mosque glyph for identity
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                palette.goldSoft,
                palette.gold,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: palette.gold.withValues(alpha: 0.45),
                blurRadius: 18,
                spreadRadius: -2,
              ),
            ],
          ),
          child: Icon(
            Icons.menu_book_rounded,
            color: palette.card,
            size: 26,
          ),
        ),
        const SizedBox(height: 12),

        // Arabic surah name (RTL)
        Text(
          surahNameAr,
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: palette.gold,
            fontFamily: 'Amiri',
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),

        // English surah name + reciter
        Text(
          surahNameEn,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: palette.text.withValues(alpha: 0.85),
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          reciterName,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: palette.text.withValues(alpha: 0.55),
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
//  SEEK BAR
// ============================================================================

class _SeekBar extends StatelessWidget {
  final Duration position;
  final Duration duration;
  final bool isScrubbing;
  final _PlayerPalette palette;
  final ValueChanged<double> onScrubStart;
  final ValueChanged<double> onScrubUpdate;
  final ValueChanged<double> onScrubEnd;
  final String Function(Duration) formatDuration;

  const _SeekBar({
    required this.position,
    required this.duration,
    required this.isScrubbing,
    required this.palette,
    required this.onScrubStart,
    required this.onScrubUpdate,
    required this.onScrubEnd,
    required this.formatDuration,
  });

  @override
  Widget build(BuildContext context) {
    final maxSeconds = duration.inSeconds > 0
        ? duration.inSeconds.toDouble()
        : 1.0;
    final value =
        position.inSeconds.toDouble().clamp(0.0, maxSeconds);

    return Column(
      children: [
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 5,
            activeTrackColor: palette.gold,
            inactiveTrackColor: palette.gold.withValues(alpha: 0.22),
            thumbColor: palette.gold,
            overlayColor: palette.gold.withValues(alpha: 0.22),
            thumbShape: RoundSliderThumbShape(
              enabledThumbRadius: isScrubbing ? 11 : 8,
              elevation: isScrubbing ? 6 : 3,
            ),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
          ),
          child: Slider(
            value: value,
            max: maxSeconds,
            onChangeStart: onScrubStart,
            onChanged: onScrubUpdate,
            onChangeEnd: onScrubEnd,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formatDuration(position),
                style: TextStyle(
                  fontSize: 12,
                  color: palette.text.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w500,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              Text(
                formatDuration(duration),
                style: TextStyle(
                  fontSize: 12,
                  color: palette.text.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w500,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ============================================================================
//  CONTROLS
// ============================================================================

class _Controls extends StatelessWidget {
  final bool isPlaying;
  final bool isStopped;
  final bool isLoading;
  final _PlayerPalette palette;
  final VoidCallback onStop;
  final VoidCallback onSkipBack;
  final VoidCallback onSkipForward;
  final VoidCallback onPlayPause;
  final VoidCallback onVolume;

  const _Controls({
    required this.isPlaying,
    required this.isStopped,
    required this.isLoading,
    required this.palette,
    required this.onStop,
    required this.onSkipBack,
    required this.onSkipForward,
    required this.onPlayPause,
    required this.onVolume,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _CircleButton(
          icon: Icons.stop_rounded,
          size: 44,
          iconSize: 22,
          onTap: onStop,
          palette: palette,
          tooltip: 'Stop',
        ),
        _CircleButton(
          icon: Icons.replay_10_rounded,
          size: 52,
          iconSize: 26,
          onTap: onSkipBack,
          palette: palette,
          tooltip: 'Back 10s',
        ),

        // Primary play/pause button
        _PlayButton(
          isPlaying: isPlaying,
          isLoading: isLoading,
          palette: palette,
          onTap: onPlayPause,
        ),

        _CircleButton(
          icon: Icons.forward_10_rounded,
          size: 52,
          iconSize: 26,
          onTap: onSkipForward,
          palette: palette,
          tooltip: 'Forward 10s',
        ),
        _CircleButton(
          icon: Icons.volume_up_rounded,
          size: 44,
          iconSize: 22,
          onTap: onVolume,
          palette: palette,
          tooltip: 'Volume',
        ),
      ],
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final double size;
  final double iconSize;
  final VoidCallback onTap;
  final _PlayerPalette palette;
  final String tooltip;

  const _CircleButton({
    required this.icon,
    required this.size,
    required this.iconSize,
    required this.onTap,
    required this.palette,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: palette.gold.withValues(alpha: 0.10),
              border: Border.all(
                color: palette.gold.withValues(alpha: 0.45),
                width: 1.2,
              ),
            ),
            child: Icon(icon, color: palette.gold, size: iconSize),
          ),
        ),
      ),
    );
  }
}

class _PlayButton extends StatelessWidget {
  final bool isPlaying;
  final bool isLoading;
  final _PlayerPalette palette;
  final VoidCallback onTap;

  const _PlayButton({
    required this.isPlaying,
    required this.isLoading,
    required this.palette,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 76,
      height: 76,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [palette.goldSoft, palette.gold],
        ),
        boxShadow: [
          BoxShadow(
            color: palette.gold.withValues(alpha: 0.55),
            blurRadius: 26,
            spreadRadius: -2,
          ),
          BoxShadow(
            color: palette.gold.withValues(alpha: 0.25),
            blurRadius: 44,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: isLoading ? null : onTap,
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        palette.card,
                      ),
                    ),
                  )
                : Icon(
                    isPlaying
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    color: palette.card,
                    size: 40,
                  ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
//  STATUS LINE
// ============================================================================

class _StatusLine extends StatelessWidget {
  final PlayerState state;
  final bool isLoading;
  final _PlayerPalette palette;

  const _StatusLine({
    required this.state,
    required this.isLoading,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    String label;
    IconData icon;
    Color color;

    if (isLoading) {
      label = 'Loading…';
      icon = Icons.downloading_rounded;
      color = palette.gold;
    } else if (state == PlayerState.playing) {
      label = 'Now Playing · Continues in background';
      icon = Icons.graphic_eq_rounded;
      color = palette.gold;
    } else if (state == PlayerState.paused) {
      label = 'Paused';
      icon = Icons.pause_circle_outline_rounded;
      color = palette.text.withValues(alpha: 0.6);
    } else if (state == PlayerState.completed) {
      label = 'Completed';
      icon = Icons.check_circle_outline_rounded;
      color = palette.text.withValues(alpha: 0.6);
    } else {
      label = 'Ready to play';
      icon = Icons.play_circle_outline_rounded;
      color = palette.text.withValues(alpha: 0.55);
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 260),
      child: Row(
        key: ValueKey('$label-$isLoading'),
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontStyle: FontStyle.italic,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
//  THEME PALETTE
// ============================================================================

class _PlayerPalette {
  final Color card;
  final Color gold;
  final Color goldSoft;
  final Color text;

  const _PlayerPalette({
    required this.card,
    required this.gold,
    required this.goldSoft,
    required this.text,
  });

  static _PlayerPalette of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) {
      return const _PlayerPalette(
        card: Color(0xFF13251E),
        gold: Color(0xFFD4AF37),
        goldSoft: Color(0xFFFFF3B0),
        text: Colors.white,
      );
    }
    return const _PlayerPalette(
      card: Color(0xFFFFFBF0),
      gold: Color(0xFFB8860B),
      goldSoft: Color(0xFFD4AF37),
      text: Color(0xFF1A1A1A),
    );
  }
}