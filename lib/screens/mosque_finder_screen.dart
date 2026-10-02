import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import '../widgets/islamic_pattern_background.dart';
import '../app_theme.dart';
import '../services/theme_service.dart';
import '../services/overpass_service.dart';
import 'mosque_map_screen.dart';

class _MosqueFinderConstants {
  static const Color primaryGold = Color(0xFFD4AF37);
  static const Color deepGold = Color(0xFFB8860B);
  static const Color softGold = Color(0xFFF0D774);

  static const double cardBorderRadius = 20;
  static const double cardPadding = 16;
  static const double iconSize = 24;
  static const double hoverScale = 0.985;

  static const Duration hoverDuration = Duration(milliseconds: 150);
  static const Duration containerDuration = Duration(milliseconds: 200);
  static const Duration entranceDuration = Duration(milliseconds: 480);
  static const Duration routeDuration = Duration(milliseconds: 360);
}

enum _SortMode { distance, name }

class MosqueFinderScreen extends StatefulWidget {
  const MosqueFinderScreen({super.key});

  @override
  State<MosqueFinderScreen> createState() => _MosqueFinderScreenState();
}

class _MosqueFinderScreenState extends State<MosqueFinderScreen> {
  bool _isLoading = true;
  List<Mosque> _nearbyMosques = const [];
  String? _errorMessage;
  double? _currentLatitude;
  double? _currentLongitude;

  _SortMode _sortMode = _SortMode.distance;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _initializeMosqueFinder();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ───────────────────────── Data loading ─────────────────────────

  Future<void> _initializeMosqueFinder() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        throw Exception('Location services are disabled');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception('Location permission denied');
      }

      final position = await Geolocator.getCurrentPosition();

      final mosques = await OverpassService.getNearbyMosques(
        position.latitude,
        position.longitude,
      );

      final result = mosques.map((m) {
        final distanceKm = Geolocator.distanceBetween(
              position.latitude,
              position.longitude,
              m.latitude,
              m.longitude,
            ) /
            1000;

        final bearing = _bearing(
          position.latitude,
          position.longitude,
          m.latitude,
          m.longitude,
        );

        return Mosque(
          name: m.name,
          latitude: m.latitude,
          longitude: m.longitude,
          distance: distanceKm,
          direction: _compassLabel(bearing),
          prayerTime: '--:--',
        );
      }).toList()
        ..sort((a, b) => a.distance.compareTo(b.distance));

      if (!mounted) return;
      setState(() {
        _currentLatitude = position.latitude;
        _currentLongitude = position.longitude;
        _nearbyMosques = result;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  static double _bearing(double lat1, double lon1, double lat2, double lon2) {
    final phi1 = lat1 * math.pi / 180;
    final phi2 = lat2 * math.pi / 180;
    final dLambda = (lon2 - lon1) * math.pi / 180;
    final y = math.sin(dLambda) * math.cos(phi2);
    final x = math.cos(phi1) * math.sin(phi2) -
        math.sin(phi1) * math.cos(phi2) * math.cos(dLambda);
    return (math.atan2(y, x) * 180 / math.pi + 360) % 360;
  }

  static String _compassLabel(double bearing) {
    const labels = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    final idx = (((bearing + 22.5) % 360) ~/ 45) % 8;
    return labels[idx];
  }

  List<Mosque> get _filteredMosques {
    var list = [..._nearbyMosques];
    final q = _searchQuery.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list.where((m) => m.name.toLowerCase().contains(q)).toList();
    }
    switch (_sortMode) {
      case _SortMode.distance:
        list.sort((a, b) => a.distance.compareTo(b.distance));
        break;
      case _SortMode.name:
        list.sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );
        break;
    }
    return list;
  }

  // ───────────────────────── Build ─────────────────────────

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        return Scaffold(
          body: IslamicPatternBackground(
            child: SafeArea(
              child: Column(
                children: [
                  _buildHeader(context, isArabic, themeService),
                  if (!_isLoading && _errorMessage == null && _nearbyMosques.isNotEmpty)
                    _buildSearchAndSort(context, isArabic, themeService),
                  Expanded(
                    child: _buildContent(context, isArabic, themeService),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(
    BuildContext context,
    bool isArabic,
    ThemeService themeService,
  ) {
    final secondary = Theme.of(context).colorScheme.secondary;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: secondary),
            tooltip: isArabic ? 'العودة' : 'Back',
          ),
          Expanded(
            child: Column(
              children: [
                // Large gold "logo" emblem
                Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [
                        _MosqueFinderConstants.softGold,
                        _MosqueFinderConstants.primaryGold,
                        _MosqueFinderConstants.deepGold,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _MosqueFinderConstants.primaryGold
                            .withValues(alpha: 0.45),
                        blurRadius: 18,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(3),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    child: Icon(
                      Icons.mosque_rounded,
                      color: _MosqueFinderConstants.primaryGold,
                      size: 32,
                      semanticLabel: isArabic ? 'مسجد' : 'Mosque',
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  isArabic ? 'أقرب مسجد' : 'Nearest Mosque',
                  textAlign: TextAlign.center,
                  style: themeService.getTextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: secondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _isLoading
                      ? (isArabic ? 'جارٍ البحث…' : 'Searching nearby…')
                      : (isArabic
                          ? '${_nearbyMosques.length} مسجد بالقرب منك'
                          : '${_nearbyMosques.length} mosques near you'),
                  textAlign: TextAlign.center,
                  style: themeService.getTextStyle(
                    fontSize: 12,
                    color: AppTheme.getOnBackgroundColor(context)
                        .withValues(alpha: 0.65),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildSearchAndSort(
    BuildContext context,
    bool isArabic,
    ThemeService themeService,
  ) {
    final onBg = AppTheme.getOnBackgroundColor(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: TextField(
                  controller: _searchController,
                  onChanged: (v) => setState(() => _searchQuery = v),
                  style: themeService.getTextStyle(fontSize: 14, color: onBg),
                  decoration: InputDecoration(
                    hintText: isArabic ? 'ابحث عن مسجد…' : 'Search mosques…',
                    hintStyle: themeService.getTextStyle(
                      fontSize: 13,
                      color: onBg.withValues(alpha: 0.5),
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: _MosqueFinderConstants.primaryGold
                          .withValues(alpha: 0.85),
                    ),
                    suffixIcon: _searchQuery.isEmpty
                        ? null
                        : IconButton(
                            icon: Icon(Icons.close_rounded,
                                color: onBg.withValues(alpha: 0.6), size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          ),
                    filled: true,
                    fillColor: Theme.of(context)
                        .scaffoldBackgroundColor
                        .withValues(alpha: 0.55),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: _MosqueFinderConstants.primaryGold
                            .withValues(alpha: 0.25),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: _MosqueFinderConstants.primaryGold
                            .withValues(alpha: 0.25),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: _MosqueFinderConstants.primaryGold,
                        width: 1.4,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          _SortButton(
            isArabic: isArabic,
            mode: _sortMode,
            onChanged: (m) => setState(() => _sortMode = m),
            themeService: themeService,
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    bool isArabic,
    ThemeService themeService,
  ) {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 44,
              height: 44,
              child: CircularProgressIndicator(
                color: _MosqueFinderConstants.primaryGold,
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              isArabic
                  ? 'نحدد موقعك ونبحث عن المساجد…'
                  : 'Locating you & searching…',
              style: themeService.getTextStyle(
                fontSize: 14,
                color: AppTheme.getOnBackgroundColor(context)
                    .withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _MosqueFinderConstants.primaryGold
                      .withValues(alpha: 0.15),
                ),
                child: const Icon(
                  Icons.error_outline_rounded,
                  color: _MosqueFinderConstants.primaryGold,
                  size: 44,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                isArabic
                    ? 'تعذر تحديد الموقع'
                    : 'Could not locate you',
                style: themeService.getTextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                _errorMessage!,
                style: themeService.getTextStyle(
                  fontSize: 13,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _initializeMosqueFinder,
                icon: const Icon(Icons.refresh_rounded),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _MosqueFinderConstants.primaryGold,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                label: Text(
                  isArabic ? 'حاول مجددًا' : 'Retry',
                  style: themeService.getTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final mosques = _filteredMosques;

    if (_nearbyMosques.isEmpty) {
      return _EmptyState(
        icon: Icons.location_off_rounded,
        title: isArabic
            ? 'لا توجد مساجد قريبة'
            : 'No nearby mosques found',
        subtitle: isArabic
            ? 'جرب توسيع نطاق البحث أو حاول لاحقًا'
            : 'Try widening your search or retry later',
        actionLabel: isArabic ? 'تحديث' : 'Refresh',
        onAction: _initializeMosqueFinder,
        themeService: themeService,
      );
    }

    if (mosques.isEmpty) {
      return _EmptyState(
        icon: Icons.search_off_rounded,
        title: isArabic ? 'لا توجد نتائج' : 'No matches',
        subtitle: isArabic
            ? 'لم نجد مساجد بهذا الاسم'
            : 'No mosques match your search',
        actionLabel: isArabic ? 'مسح البحث' : 'Clear search',
        onAction: () {
          _searchController.clear();
          setState(() => _searchQuery = '');
        },
        themeService: themeService,
      );
    }

    return RefreshIndicator(
      color: _MosqueFinderConstants.primaryGold,
      onRefresh: _initializeMosqueFinder,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: mosques.length,
        itemBuilder: (context, index) {
          final mosque = mosques[index];
          return _MosqueCard(
            key: ValueKey('${mosque.latitude}_${mosque.longitude}'),
            index: index,
            mosque: mosque,
            isArabic: isArabic,
            userLat: _currentLatitude!,
            userLng: _currentLongitude!,
            themeService: themeService,
          );
        },
      ),
    );
  }
}

// ───────────────────────── Sort button ─────────────────────────

class _SortButton extends StatelessWidget {
  final bool isArabic;
  final _SortMode mode;
  final ValueChanged<_SortMode> onChanged;
  final ThemeService themeService;

  const _SortButton({
    required this.isArabic,
    required this.mode,
    required this.onChanged,
    required this.themeService,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_SortMode>(
      tooltip: isArabic ? 'ترتيب' : 'Sort',
      color: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: _MosqueFinderConstants.primaryGold.withValues(alpha: 0.3),
        ),
      ),
      onSelected: onChanged,
      itemBuilder: (_) => [
        PopupMenuItem(
          value: _SortMode.distance,
          child: Row(
            children: [
              Icon(
                Icons.near_me_rounded,
                size: 18,
                color: mode == _SortMode.distance
                    ? _MosqueFinderConstants.primaryGold
                    : Colors.white70,
              ),
              const SizedBox(width: 10),
              Text(
                isArabic ? 'الأقرب' : 'Nearest',
                style: themeService.getTextStyle(fontSize: 13),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: _SortMode.name,
          child: Row(
            children: [
              Icon(
                Icons.sort_by_alpha_rounded,
                size: 18,
                color: mode == _SortMode.name
                    ? _MosqueFinderConstants.primaryGold
                    : Colors.white70,
              ),
              const SizedBox(width: 10),
              Text(
                isArabic ? 'الاسم' : 'Name',
                style: themeService.getTextStyle(fontSize: 13),
              ),
            ],
          ),
        ),
      ],
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Theme.of(context)
              .scaffoldBackgroundColor
              .withValues(alpha: 0.55),
          border: Border.all(
            color: _MosqueFinderConstants.primaryGold.withValues(alpha: 0.25),
          ),
        ),
        child: const Icon(
          Icons.tune_rounded,
          color: _MosqueFinderConstants.primaryGold,
          size: 20,
        ),
      ),
    );
  }
}

// ───────────────────────── Empty state ─────────────────────────

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String actionLabel;
  final VoidCallback onAction;
  final ThemeService themeService;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.onAction,
    required this.themeService,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _MosqueFinderConstants.primaryGold.withValues(alpha: 0.12),
              ),
              child: Icon(
                icon,
                color: _MosqueFinderConstants.primaryGold,
                size: 44,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: themeService.getTextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: themeService.getTextStyle(
                fontSize: 13,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 18),
            OutlinedButton(
              onPressed: onAction,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  color: _MosqueFinderConstants.primaryGold,
                  width: 1.2,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                actionLabel,
                style: themeService.getTextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _MosqueFinderConstants.primaryGold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ───────────────────────── Mosque card ─────────────────────────

class _MosqueCard extends StatefulWidget {
  final Mosque mosque;
  final bool isArabic;
  final double userLat;
  final double userLng;
  final ThemeService themeService;
  final int index;

  const _MosqueCard({
    super.key,
    required this.mosque,
    required this.isArabic,
    required this.userLat,
    required this.userLng,
    required this.themeService,
    this.index = 0,
  });

  @override
  State<_MosqueCard> createState() => _MosqueCardState();
}

class _MosqueCardState extends State<_MosqueCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entryController;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: _MosqueFinderConstants.entranceDuration,
    );
    _fade = CurvedAnimation(parent: _entryController, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.10),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeOutCubic),
    );

    final delay = Duration(milliseconds: 60 * widget.index.clamp(0, 8));
    Future.delayed(delay, () {
      if (mounted) _entryController.forward();
    });
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  String _walkTimeText(double km) {
    // Assume a leisurely walk of ~5 km/h.
    final minutes = (km / 5.0 * 60).round();
    if (minutes < 60) {
      return widget.isArabic ? '$minutes دقيقة' : '$minutes min';
    }
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return widget.isArabic ? '$h س $m د' : '${h}h ${m}m';
  }

  void _openMap() {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: _MosqueFinderConstants.routeDuration,
        pageBuilder: (_, __, ___) => MosqueMapScreen(
          userLat: widget.userLat,
          userLng: widget.userLng,
          mosqueLat: widget.mosque.latitude,
          mosqueLng: widget.mosque.longitude,
          mosqueName: widget.mosque.name,
          distanceKm: widget.mosque.distance,
        ),
        transitionsBuilder: (_, animation, __, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.05),
                end: Offset.zero,
              ).animate(curved),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mosque = widget.mosque;
    final onBg = AppTheme.getOnBackgroundColor(context);
    final gold = _MosqueFinderConstants.primaryGold;

    final distanceText = widget.isArabic
        ? '${mosque.distance.toStringAsFixed(2)} كم'
        : '${mosque.distance.toStringAsFixed(2)} km';

    final walkText = _walkTimeText(mosque.distance);

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: MouseRegion(
            onEnter: (_) => setState(() => _isHovered = true),
            onExit: (_) => setState(() => _isHovered = false),
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: _openMap,
              child: AnimatedScale(
                scale: _isHovered ? _MosqueFinderConstants.hoverScale : 1.0,
                duration: _MosqueFinderConstants.hoverDuration,
                curve: Curves.easeOut,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    _MosqueFinderConstants.cardBorderRadius,
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: AnimatedContainer(
                      duration: _MosqueFinderConstants.containerDuration,
                      decoration: BoxDecoration(
                        color: _isHovered
                            ? Theme.of(context)
                                .colorScheme
                                .surface
                                .withValues(alpha: 0.85)
                            : Theme.of(context)
                                .scaffoldBackgroundColor
                                .withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(
                          _MosqueFinderConstants.cardBorderRadius,
                        ),
                        border: Border.all(
                          color: gold.withValues(alpha: _isHovered ? 0.85 : 0.22),
                          width: _isHovered ? 2 : 1,
                        ),
                        boxShadow: _isHovered
                            ? [
                                BoxShadow(
                                  color: gold.withValues(alpha: 0.25),
                                  blurRadius: 22,
                                  spreadRadius: 1,
                                  offset: const Offset(0, 6),
                                ),
                              ]
                            : null,
                      ),
                      padding: const EdgeInsets.all(
                        _MosqueFinderConstants.cardPadding,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ── Large logo / avatar ──
                              _MosqueEmblem(isHovered: _isHovered),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      mosque.name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: widget.themeService.getTextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: _isHovered ? onBg : gold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Wrap(
                                      spacing: 6,
                                      runSpacing: 6,
                                      children: [
                                        _InfoChip(
                                          icon: Icons.straighten_rounded,
                                          label: distanceText,
                                          isArabic: widget.isArabic,
                                          themeService: widget.themeService,
                                        ),
                                        _InfoChip(
                                          icon: Icons.explore_rounded,
                                          label: mosque.direction,
                                          isArabic: widget.isArabic,
                                          themeService: widget.themeService,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    mosque.prayerTime,
                                    style: widget.themeService.getTextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: gold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    widget.isArabic
                                        ? 'وقت الصلاة'
                                        : 'Prayer',
                                    style: widget.themeService.getTextStyle(
                                      fontSize: 10,
                                      color: onBg.withValues(alpha: 0.55),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Divider(
                            height: 1,
                            color: gold.withValues(alpha: 0.18),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(
                                Icons.directions_walk_rounded,
                                size: 16,
                                color: onBg.withValues(alpha: 0.6),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                widget.isArabic
                                    ? 'سيرًا: $walkText'
                                    : 'Walk: $walkText',
                                style: widget.themeService.getTextStyle(
                                  fontSize: 12,
                                  color: onBg.withValues(alpha: 0.7),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                widget.isArabic
                                    ? 'عرض على الخريطة'
                                    : 'View on map',
                                style: widget.themeService.getTextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: gold,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 12,
                                color: gold,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MosqueEmblem extends StatelessWidget {
  final bool isHovered;
  const _MosqueEmblem({required this.isHovered});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: _MosqueFinderConstants.containerDuration,
      width: 68,
      height: 68,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: isHovered
              ? const [
                  _MosqueFinderConstants.softGold,
                  _MosqueFinderConstants.primaryGold,
                  _MosqueFinderConstants.deepGold,
                ]
              : [
                  _MosqueFinderConstants.primaryGold.withValues(alpha: 0.85),
                  _MosqueFinderConstants.deepGold.withValues(alpha: 0.85),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: _MosqueFinderConstants.primaryGold
                .withValues(alpha: isHovered ? 0.45 : 0.2),
            blurRadius: isHovered ? 18 : 10,
            spreadRadius: 0,
          ),
        ],
      ),
      padding: const EdgeInsets.all(3),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Icon(
          Icons.mosque_rounded,
          color: isHovered
              ? _MosqueFinderConstants.primaryGold
              : Colors.white,
          size: 30,
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isArabic;
  final ThemeService themeService;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.isArabic,
    required this.themeService,
  });

  @override
  Widget build(BuildContext context) {
    final gold = _MosqueFinderConstants.primaryGold;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: gold.withValues(alpha: 0.12),
        border: Border.all(color: gold.withValues(alpha: 0.28)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: gold),
          const SizedBox(width: 4),
          Text(
            label,
            style: themeService.getTextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: gold,
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────── Model ─────────────────────────

class Mosque {
  final String name;
  final double latitude;
  final double longitude;
  final double distance;
  final String direction;
  final String prayerTime;

  Mosque({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.distance,
    required this.direction,
    required this.prayerTime,
  });
}