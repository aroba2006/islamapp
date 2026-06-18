import 'dart:async';
import 'package:flutter/material.dart';
import '../models/country_data.dart';
import '../models/prayer_times.dart';
import '../services/prayer_times_service.dart';
import '../widgets/islamic_pattern_background.dart';

class PrayerTimesScreen extends StatefulWidget {
  final CountryData country;
  final String region;

  const PrayerTimesScreen({
    super.key,
    required this.country,
    required this.region,
  });

  @override
  State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  PrayerTimes? _times;
  String? _error;
  bool _loading = true;
  Timer? _clockTimer;
  Duration? _timeUntilNext;
  String? _nextPrayerName;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await PrayerTimesService.fetchByCity(
        city: widget.region,
        country: widget.country.name,
      );
      setState(() {
        _times = result;
        _loading = false;
      });
      _startCountdown();
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void _startCountdown() {
    _clockTimer?.cancel();
    _updateCountdown();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) => _updateCountdown());
  }

  void _updateCountdown() {
    if (_times == null) return;
    final now = DateTime.now();
    final entries = _times!.asOrderedList();

    DateTime? parseToday(String hhmm) {
      final parts = hhmm.split(':');
      if (parts.length != 2) return null;
      final h = int.tryParse(parts[0]);
      final m = int.tryParse(parts[1]);
      if (h == null || m == null) return null;
      return DateTime(now.year, now.month, now.day, h, m);
    }

    DateTime? nextTime;
    String? nextName;
    for (final entry in entries) {
      final dt = parseToday(entry.value);
      if (dt == null) continue;
      if (dt.isAfter(now)) {
        nextTime = dt;
        nextName = entry.key;
        break;
      }
    }
    // If all of today's prayers have passed, next is tomorrow's Fajr.
    if (nextTime == null) {
      final fajrDt = parseToday(entries.first.value);
      if (fajrDt != null) {
        nextTime = fajrDt.add(const Duration(days: 1));
        nextName = entries.first.key;
      }
    }

    if (nextTime != null && mounted) {
      setState(() {
        _timeUntilNext = nextTime!.difference(now);
        _nextPrayerName = nextName;
      });
    }
  }

  String _formatDuration(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return "$h:$m:$s";
  }

  IconData _iconFor(String prayer) {
    switch (prayer) {
      case 'Fajr':
        return Icons.brightness_4;
      case 'Dhuhr':
        return Icons.wb_sunny;
      case 'Asr':
        return Icons.wb_twilight;
      case 'Maghrib':
        return Icons.brightness_5;
      case 'Isha':
        return Icons.nightlight_round;
      default:
        return Icons.access_time;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IslamicPatternBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  child: _loading
                      ? _buildLoading()
                      : _error != null
                          ? _buildError()
                          : _buildContent(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 20, 12),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(widget.country.flagEmoji, style: const TextStyle(fontSize: 18)),
                    const SizedBox(width: 6),
                    Text(
                      widget.region,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                Text(
                  widget.country.name,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 13),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _load,
            icon: const Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      key: ValueKey('loading'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Color(0xFFD4AF37)),
          SizedBox(height: 16),
          Text("Fetching prayer times...", style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      key: const ValueKey('error'),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off, color: Colors.white70, size: 56),
            const SizedBox(height: 16),
            Text(
              _error ?? "Something went wrong.",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 15),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _load,
              icon: const Icon(Icons.refresh),
              label: const Text("Try again"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4AF37),
                foregroundColor: const Color(0xFF0B3D2E),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    final times = _times!;
    return Container(
      key: const ValueKey('content'),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        children: [
          if (_timeUntilNext != null) _buildCountdownCard(),
          const SizedBox(height: 20),
          Text(
            times.dateReadable,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
          ),
          const SizedBox(height: 16),
          ...times.asOrderedList().asMap().entries.map((e) {
            final index = e.key;
            final entry = e.value;
            final isNext = entry.key == _nextPrayerName;
            return TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 300 + (index * 80)),
              tween: Tween(begin: 0, end: 1),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, (1 - value) * 20),
                    child: child,
                  ),
                );
              },
              child: _PrayerRow(
                name: entry.key,
                time: entry.value,
                icon: _iconFor(entry.key),
                isNext: isNext,
              ),
            );
          }),
          const SizedBox(height: 12),
          _buildSunriseNote(times.sunrise),
        ],
      ),
    );
  }

  Widget _buildCountdownCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1B5E3F), Color(0xFF0B3D2E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1B5E3F).withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "Time until ${_nextPrayerName ?? '--'}",
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            _timeUntilNext != null ? _formatDuration(_timeUntilNext!) : "--:--:--",
            style: const TextStyle(
              color: Color(0xFFD4AF37),
              fontSize: 36,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSunriseNote(String sunrise) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD4AF37).withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.wb_twilight, color: Color(0xFFD4AF37)),
          const SizedBox(width: 12),
          Text(
            "Sunrise: $sunrise",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B5A1E),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrayerRow extends StatelessWidget {
  final String name;
  final String time;
  final IconData icon;
  final bool isNext;

  const _PrayerRow({
    required this.name,
    required this.time,
    required this.icon,
    required this.isNext,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: isNext ? const Color(0xFF1B5E3F) : const Color(0xFFF8FAF9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isNext ? const Color(0xFFD4AF37) : const Color(0xFFE3E9E6),
          width: isNext ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isNext ? Colors.white.withValues(alpha: 0.15) : Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isNext ? const Color(0xFFD4AF37) : const Color(0xFF1B5E3F),
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: isNext ? Colors.white : const Color(0xFF1A2E25),
              ),
            ),
          ),
          if (isNext)
            Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFD4AF37),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                "NEXT",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0B3D2E),
                ),
              ),
            ),
          Text(
            time,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isNext ? const Color(0xFFD4AF37) : const Color(0xFF1B5E3F),
            ),
          ),
        ],
      ),
    );
  }
}
