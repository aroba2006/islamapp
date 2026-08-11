import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import '../services/deeds_service.dart';
import '../l10n/app_localizations.dart';
import '../widgets/islamic_pattern_background.dart';
import 'package:intl/intl.dart';
import '../services/theme_service.dart';

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

  final Map<String, IconData> categoryIcons = const {
    'prayer': Icons.self_improvement_rounded,
    'charity': Icons.volunteer_activism_rounded,
    'learning': Icons.school_rounded,
    'family': Icons.family_restroom_rounded,
    'other': Icons.favorite_rounded,
  };

  final Map<String, Color> categoryColors = const {
    'prayer': Color(0xFF4CAF50),
    'charity': Color(0xFFF44336),
    'learning': Color(0xFF2196F3),
    'family': Color(0xFF9C27B0),
    'other': Color(0xFFFF9800),
  };

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final loadedDeeds = await DeedsService.getAllDeeds();
      final streak = await DeedsService.getCurrentStreak();
      final total = await DeedsService.getTotalDeeds();
      final today = await DeedsService.getDeedCountToday();

      if (!mounted) return;
      setState(() {
        deeds = loadedDeeds;
        _currentStreak = streak;
        _totalDeeds = total;
        _todayDeeds = today;
        _isLoading = false;
      });
    } catch (e, stackTrace) {
      debugPrint('Error loading good deeds: $e\n$stackTrace');
      if (mounted) {
        setState(() => _isLoading = false);
      }
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

  void _showAddDeedDialog(BuildContext context, AppLocalizations l10n, ThemeService themeService) {
    showDialog(
      context: context,
      builder: (dialogContext) => _AddDeedDialog(
        l10n: l10n,
        categories: categories,
        categoryIcons: categoryIcons,
        categoryColors: categoryColors,
        getCategoryName: (cat) => _getCategoryName(cat, l10n),
        onDeedAdded: _loadData,
        themeService: themeService,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final lang = Localizations.localeOf(context).languageCode;
    final isArabic = lang == 'ar';
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final filteredDeeds = _selectedCategory == null
        ? deeds
        : deeds.where((d) => d.category == _selectedCategory).toList();

    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        return Scaffold(
          body: IslamicPatternBackground(
            child: SafeArea(
              child: Column(
                children: [
                  _buildHeader(context, l10n, isArabic, themeService),
                  Expanded(
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator(color: Color(0xFFD4AF37)))
                        : Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 800),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 24),
                                    child: _buildStatsCards(l10n, isDarkMode, themeService),
                                  ),
                                  const SizedBox(height: 24),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 24),
                                    child: _buildCategoryFilter(l10n, isDarkMode, themeService),
                                  ),
                                  const SizedBox(height: 24),
                                  Expanded(
                                    child: filteredDeeds.isEmpty
                                        ? _buildEmptyState(l10n, isDarkMode, themeService)
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
                                                themeService: themeService,
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
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: SafeArea(
            child: FloatingActionButton(
              onPressed: () => _showAddDeedDialog(context, l10n, themeService),
              backgroundColor: const Color(0xFFD4AF37),
              child: const Icon(Icons.add_rounded, color: Color(0xFF0B3D2E), size: 32),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n, bool isArabic, ThemeService themeService) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.maybePop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFFD4AF37), size: 24),
          ),
          Expanded(
            child: Text(
              l10n.goodDeedsTitle,
              textAlign: TextAlign.center,
              style: themeService.getTextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFD4AF37),
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildStatsCards(AppLocalizations l10n, bool isDarkMode, ThemeService themeService) {
    return Row(
      children: [
        Expanded(child: _buildStatCard(Icons.local_fire_department_rounded, l10n.streakLabel, _currentStreak.toString(), const Color(0xFFF44336), isDarkMode, themeService)),
        const SizedBox(width: 16),
        Expanded(child: _buildStatCard(Icons.today_rounded, l10n.todayLabel, _todayDeeds.toString(), const Color(0xFF2196F3), isDarkMode, themeService)),
        const SizedBox(width: 16),
        Expanded(child: _buildStatCard(Icons.trending_up_rounded, l10n.totalLabel, _totalDeeds.toString(), const Color(0xFF4CAF50), isDarkMode, themeService)),
      ],
    );
  }

  Widget _buildStatCard(IconData icon, String label, String value, Color color, bool isDarkMode, ThemeService themeService) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF0B3D2E).withValues(alpha: 0.6) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
        boxShadow: isDarkMode ? [] : [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
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
            style: themeService.getTextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white.withValues(alpha: 0.8) : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter(AppLocalizations l10n, bool isDarkMode, ThemeService themeService) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF0B3D2E).withValues(alpha: 0.4) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD4AF37).withValues(alpha: 0.3)),
        boxShadow: isDarkMode ? [] : [
          BoxShadow(
            color: const Color(0xFFD4AF37).withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterPill(l10n.allFilter, null, isDarkMode, themeService),
            const SizedBox(width: 8),
            ...categories.map((cat) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _buildFilterPill(_getCategoryName(cat, l10n), cat, isDarkMode, themeService, icon: categoryIcons[cat], color: categoryColors[cat]),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterPill(String label, String? cat, bool isDarkMode, ThemeService themeService, {IconData? icon, Color? color}) {
    final isSelected = _selectedCategory == cat;
    final accentColor = color ?? const Color(0xFFD4AF37);
    
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = cat),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? accentColor.withValues(alpha: 0.2)
              : (isDarkMode ? Colors.black.withValues(alpha: 0.2) : Colors.grey.withValues(alpha: 0.1)),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? accentColor
                : (isDarkMode ? Colors.white.withValues(alpha: 0.1) : Colors.grey.shade300),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: isSelected ? accentColor : (isDarkMode ? Colors.white60 : Colors.black54)),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: themeService.getTextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? (isDarkMode ? Colors.white : accentColor) : (isDarkMode ? Colors.white60 : Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n, bool isDarkMode, ThemeService themeService) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.volunteer_activism_rounded, size: 80, color: const Color(0xFFD4AF37).withValues(alpha: 0.3)),
            const SizedBox(height: 16),
            Text(
              l10n.noDeedsTitle,
              style: themeService.getTextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.noDeedsDesc,
              style: themeService.getTextStyle(
                fontSize: 16,
                color: isDarkMode ? Colors.white70 : Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _AddDeedDialog extends StatefulWidget {
  final AppLocalizations l10n;
  final List<String> categories;
  final Map<String, IconData> categoryIcons;
  final Map<String, Color> categoryColors;
  final String Function(String) getCategoryName;
  final VoidCallback onDeedAdded;
  final ThemeService themeService;

  const _AddDeedDialog({
    required this.l10n,
    required this.categories,
    required this.categoryIcons,
    required this.categoryColors,
    required this.getCategoryName,
    required this.onDeedAdded,
    required this.themeService,
  });

  @override
  State<_AddDeedDialog> createState() => _AddDeedDialogState();
}

class _AddDeedDialogState extends State<_AddDeedDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _notesController;
  String _selectedCategory = 'other';
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submitDeed() async {
    if (_titleController.text.trim().isEmpty || _isSubmitting) return;

    setState(() => _isSubmitting = true);

    final deed = GoodDeed(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      category: _selectedCategory,
      timestamp: DateTime.now(),
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
    );

    await DeedsService.addDeed(deed);

    if (mounted) {
      Navigator.of(context).pop();
      widget.onDeedAdded();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: const Color(0xFFF8FAF9),
      title: Text(
        widget.l10n.recordDeedTitle,
        style: widget.themeService.getTextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF1B5E3F),
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              style: widget.themeService.getTextStyle(fontSize: 16, color: Colors.black),
              decoration: InputDecoration(
                labelText: widget.l10n.deedTitleLabel,
                labelStyle: widget.themeService.getTextStyle(fontSize: 14, color: Colors.grey.shade700),
                hintText: widget.l10n.deedTitleHint,
                hintStyle: widget.themeService.getTextStyle(fontSize: 14, color: Colors.grey.shade400),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF1B5E3F), width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.l10n.categoryLabel,
              style: widget.themeService.getTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.categories.map((cat) {
                final isSelected = _selectedCategory == cat;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = cat),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? widget.categoryColors[cat]!.withValues(alpha: 0.15) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? widget.categoryColors[cat]! : Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: isSelected 
                          ? [BoxShadow(color: widget.categoryColors[cat]!.withValues(alpha: 0.2), blurRadius: 8)] 
                          : [],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(widget.categoryIcons[cat], size: 16, color: widget.categoryColors[cat]),
                        const SizedBox(width: 8),
                        Text(
                          widget.getCategoryName(cat),
                          style: widget.themeService.getTextStyle(
                            fontSize: 13,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                            color: isSelected ? widget.categoryColors[cat]! : Colors.black87,
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
              controller: _notesController,
              style: widget.themeService.getTextStyle(fontSize: 16, color: Colors.black),
              decoration: InputDecoration(
                labelText: widget.l10n.notesLabel,
                labelStyle: widget.themeService.getTextStyle(fontSize: 14, color: Colors.grey.shade700),
                hintText: widget.l10n.notesHint,
                hintStyle: widget.themeService.getTextStyle(fontSize: 14, color: Colors.grey.shade400),
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
          onPressed: () => Navigator.pop(context),
          child: Text(
            widget.l10n.cancelBtn,
            style: widget.themeService.getTextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _submitDeed,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1B5E3F),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: _isSubmitting
              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : Text(widget.l10n.recordBtn, style: widget.themeService.getTextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}

class _DeedGlassCard extends StatefulWidget {
  final GoodDeed deed;
  final AppLocalizations l10n;
  final Color color;
  final IconData icon;
  final VoidCallback onDelete;
  final ThemeService themeService;

  const _DeedGlassCard({
    required this.deed, 
    required this.l10n, 
    required this.color, 
    required this.icon, 
    required this.onDelete,
    required this.themeService,
  });

  @override
  State<_DeedGlassCard> createState() => _DeedGlassCardState();
}

class _DeedGlassCardState extends State<_DeedGlassCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final timeFormat = DateFormat('dd MMM, HH:mm');

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: isDarkMode
              ? BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: _buildDarkCard(timeFormat),
                )
              : _buildLightCard(timeFormat),
        ),
      ),
    );
  }

  Widget _buildDarkCard(DateFormat timeFormat) {
    return Container(
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
      child: _buildCardContent(timeFormat, true),
    );
  }

  Widget _buildLightCard(DateFormat timeFormat) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isHovered ? widget.color : widget.color.withValues(alpha: 0.3),
          width: _isHovered ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: widget.color.withValues(alpha: _isHovered ? 0.15 : 0.08),
            blurRadius: _isHovered ? 12 : 6,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: _buildCardContent(timeFormat, false),
    );
  }

  Widget _buildCardContent(DateFormat timeFormat, bool isDarkMode) {
    return Row(
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
                style: widget.themeService.getTextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                timeFormat.format(widget.deed.timestamp),
                style: widget.themeService.getTextStyle(
                  fontSize: 13,
                  color: isDarkMode ? Colors.white.withValues(alpha: 0.5) : Colors.black54,
                ),
              ),
              if (widget.deed.notes != null && widget.deed.notes!.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  widget.deed.notes!,
                  style: widget.themeService.getTextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: isDarkMode ? Colors.white.withValues(alpha: 0.8) : Colors.black87,
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
          icon: Icon(Icons.close_rounded, color: isDarkMode ? Colors.white.withValues(alpha: 0.6) : Colors.black38, size: 24),
          hoverColor: Colors.redAccent.withValues(alpha: 0.2),
        ),
      ],
    );
  }
}