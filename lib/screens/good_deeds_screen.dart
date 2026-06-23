import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import '../services/deeds_service.dart';
import '../l10n/app_localizations.dart';
import '../widgets/islamic_pattern_background.dart';
import 'dart:math';
import 'package:intl/intl.dart';

class GoodDeedsScreen extends StatefulWidget {
  const GoodDeedsScreen({super.key});

  @override
  State<GoodDeedsScreen> createState() => _GoodDeedsScreenState();
}

class _GoodDeedsScreenState extends State<GoodDeedsScreen> {
  List<GoodDeed> deeds = [];
  bool _isLoading = true;
  String? _selectedCategory;
  int _currentStreak = 0;
  int _totalDeeds = 0;
  int _todayDeeds = 0;

  final List<String> categories = ['prayer', 'charity', 'learning', 'family', 'other'];

  final Map<String, IconData> categoryIcons = {
    'prayer': Icons.self_improvement_rounded,
    'charity': Icons.volunteer_activism_rounded,
    'learning': Icons.school_rounded,
    'family': Icons.family_restroom_rounded,
    'other': Icons.favorite_rounded,
  };

  final Map<String, Color> categoryColors = {
    'prayer': const Color(0xFF4CAF50),
    'charity': const Color(0xFFF44336),
    'learning': const Color(0xFF2196F3),
    'family': const Color(0xFF9C27B0),
    'other': const Color(0xFFFF9800),
  };

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final loadedDeeds = await DeedsService.getAllDeeds();
      final streak = await DeedsService.getCurrentStreak();
      final total = await DeedsService.getTotalDeeds();
      final today = await DeedsService.getDeedCountToday();

      setState(() {
        deeds = loadedDeeds;
        _currentStreak = streak;
        _totalDeeds = total;
        _todayDeeds = today;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  String _getCategoryName(String cat, AppLocalizations l10n) {
    switch (cat) {
      case 'prayer': return l10n.catPrayer;
      case 'charity': return l10n.catCharity;
      case 'learning': return l10n.catLearning;
      case 'family': return l10n.catFamily;
      case 'other': return l10n.catOther;
      default: return cat;
    }
  }

  void _showAddDeedDialog(BuildContext context, AppLocalizations l10n, bool isArabic) {
    String selectedCategory = 'other';
    final titleController = TextEditingController();
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (stateContext, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: const Color(0xFFF8FAF9),
          title: Text(
            l10n.recordDeedTitle,
            style: GoogleFonts.elMessiri(
              color: const Color(0xFF1B5E3F),
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: titleController,
                  style: GoogleFonts.elMessiri(),
                  decoration: InputDecoration(
                    labelText: l10n.deedTitleLabel,
                    labelStyle: GoogleFonts.elMessiri(color: Colors.grey.shade700),
                    hintText: l10n.deedTitleHint,
                    hintStyle: GoogleFonts.elMessiri(color: Colors.grey.shade400),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF1B5E3F), width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.categoryLabel,
                  style: GoogleFonts.elMessiri(fontWeight: FontWeight.w600, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: categories.map((cat) {
                    final isSelected = selectedCategory == cat;
                    return GestureDetector(
                      onTap: () => setDialogState(() => selectedCategory = cat),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? categoryColors[cat]!.withValues(alpha: 0.15) : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? categoryColors[cat]! : Colors.grey.shade300,
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: isSelected 
                              ? [BoxShadow(color: categoryColors[cat]!.withValues(alpha: 0.2), blurRadius: 8)] 
                              : [],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(categoryIcons[cat], size: 16, color: categoryColors[cat]),
                            const SizedBox(width: 8),
                            Text(
                              _getCategoryName(cat, l10n),
                              style: GoogleFonts.elMessiri(
                                fontSize: 13,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                color: isSelected ? categoryColors[cat]! : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: notesController,
                  style: GoogleFonts.elMessiri(),
                  decoration: InputDecoration(
                    labelText: l10n.notesLabel,
                    labelStyle: GoogleFonts.elMessiri(color: Colors.grey.shade700),
                    hintText: l10n.notesHint,
                    hintStyle: GoogleFonts.elMessiri(color: Colors.grey.shade400),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF1B5E3F), width: 2),
                    ),
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(l10n.cancelBtn, style: GoogleFonts.elMessiri(color: Colors.grey.shade700, fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isNotEmpty) {
                  final deed = GoodDeed(
                    id: Random().nextInt(100000).toString(),
                    title: titleController.text,
                    category: selectedCategory,
                    timestamp: DateTime.now(),
                    notes: notesController.text.isEmpty ? null : notesController.text,
                  );
                  await DeedsService.addDeed(deed);
                  if (!dialogContext.mounted) return;
                  Navigator.pop(dialogContext);
                  if (mounted) _loadData();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B5E3F),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: Text(l10n.recordBtn, style: GoogleFonts.elMessiri(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final lang = Localizations.localeOf(context).languageCode;
    final isArabic = lang == 'ar';

    // Verify filtered state specifically to avoid blank screens
    final filteredDeeds = _selectedCategory == null
        ? deeds
        : deeds.where((d) => d.category == _selectedCategory).toList();

    return Scaffold(
      body: IslamicPatternBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context, l10n, isArabic),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator(color: Color(0xFFD4AF37)))
                    : Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 800),
                          // STRICT FLEX LAYOUT: Prevents scroll collapse
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24),
                                child: _buildStatsCards(l10n),
                              ),
                              const SizedBox(height: 24),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24),
                                child: _buildCategoryFilter(l10n),
                              ),
                              const SizedBox(height: 24),
                              
                              // Expanding the list guarantees the empty state vertically centers
                              Expanded(
                                child: filteredDeeds.isEmpty
                                    ? _buildEmptyState(l10n)
                                    : ListView.builder(
                                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
                                        itemCount: filteredDeeds.length,
                                        itemBuilder: (context, index) {
                                          final deed = filteredDeeds[index];
                                          return _DeedGlassCard(
                                            deed: deed, 
                                            l10n: l10n, 
                                            color: categoryColors[deed.category] ?? Colors.grey, 
                                            icon: categoryIcons[deed.category] ?? Icons.favorite_rounded,
                                            onDelete: () async {
                                              await DeedsService.deleteDeed(deed.id);
                                              _loadData();
                                            },
                                          );
                                        },
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
      // PROTECTED FAB: Forces the button above Android's navigation bar
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: SafeArea(
        child: FloatingActionButton(
          onPressed: () => _showAddDeedDialog(context, l10n, isArabic),
          backgroundColor: const Color(0xFFD4AF37),
          child: const Icon(Icons.add_rounded, color: Color(0xFF0B3D2E), size: 32),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n, bool isArabic) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFFD4AF37), size: 24),
          ),
          Expanded(
            child: Text(
              l10n.goodDeedsTitle,
              textAlign: TextAlign.center,
              style: isArabic 
                  ? GoogleFonts.amiri(color: const Color(0xFFD4AF37), fontSize: 32, fontWeight: FontWeight.bold)
                  : GoogleFonts.arefRuqaa(color: const Color(0xFFD4AF37), fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildStatsCards(AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(child: _buildStatCard(Icons.local_fire_department_rounded, l10n.streakLabel, _currentStreak.toString(), const Color(0xFFF44336))),
        const SizedBox(width: 16),
        Expanded(child: _buildStatCard(Icons.today_rounded, l10n.todayLabel, _todayDeeds.toString(), const Color(0xFF2196F3))),
        const SizedBox(width: 16),
        Expanded(child: _buildStatCard(Icons.trending_up_rounded, l10n.totalLabel, _totalDeeds.toString(), const Color(0xFF4CAF50))),
      ],
    );
  }

  Widget _buildStatCard(IconData icon, String label, String value, Color color) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF0B3D2E).withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.elMessiri(color: Colors.white.withValues(alpha: 0.8), fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter(AppLocalizations l10n) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF0B3D2E).withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFD4AF37).withValues(alpha: 0.2)),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterPill(l10n.allFilter, null),
                const SizedBox(width: 8),
                ...categories.map((cat) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _buildFilterPill(_getCategoryName(cat, l10n), cat, icon: categoryIcons[cat], color: categoryColors[cat]),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterPill(String label, String? cat, {IconData? icon, Color? color}) {
    final isSelected = _selectedCategory == cat;
    final accentColor = color ?? const Color(0xFFD4AF37);
    
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = cat),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? accentColor.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? accentColor : Colors.white.withValues(alpha: 0.1),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: isSelected ? accentColor : Colors.white60),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: GoogleFonts.elMessiri(
                color: isSelected ? Colors.white : Colors.white60,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.volunteer_activism_rounded, size: 80, color: const Color(0xFFD4AF37).withValues(alpha: 0.3)),
            const SizedBox(height: 16),
            Text(
              l10n.noDeedsTitle,
              style: GoogleFonts.elMessiri(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.noDeedsDesc,
              style: GoogleFonts.elMessiri(color: Colors.white70, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _DeedGlassCard extends StatefulWidget {
  final GoodDeed deed;
  final AppLocalizations l10n;
  final Color color;
  final IconData icon;
  final VoidCallback onDelete;

  const _DeedGlassCard({required this.deed, required this.l10n, required this.color, required this.icon, required this.onDelete});

  @override
  State<_DeedGlassCard> createState() => _DeedGlassCardState();
}

class _DeedGlassCardState extends State<_DeedGlassCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('dd MMM, HH:mm');

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _isHovered ? const Color(0xFF144D32).withValues(alpha: 0.7) : const Color(0xFF0B3D2E).withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _isHovered ? widget.color : widget.color.withValues(alpha: 0.3),
                  width: _isHovered ? 1.5 : 1,
                ),
                boxShadow: _isHovered ? [BoxShadow(color: widget.color.withValues(alpha: 0.15), blurRadius: 12)] : [],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: widget.color.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                      border: Border.all(color: widget.color.withValues(alpha: 0.5)),
                    ),
                    child: Icon(widget.icon, color: widget.color, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.deed.title,
                          style: GoogleFonts.elMessiri(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          timeFormat.format(widget.deed.timestamp),
                          style: GoogleFonts.elMessiri(color: Colors.white.withValues(alpha: 0.5), fontSize: 13),
                        ),
                        if (widget.deed.notes != null && widget.deed.notes!.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            widget.deed.notes!,
                            style: GoogleFonts.elMessiri(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ]
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: widget.onDelete,
                    icon: Icon(Icons.close_rounded, color: Colors.white.withValues(alpha: 0.6), size: 24),
                    hoverColor: Colors.redAccent.withValues(alpha: 0.2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}