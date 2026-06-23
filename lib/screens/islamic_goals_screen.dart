import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import '../services/goals_service.dart';
import '../l10n/app_localizations.dart';
import '../widgets/islamic_pattern_background.dart';
import 'dart:math';

class IslamicGoalsScreen extends StatefulWidget {
  const IslamicGoalsScreen({super.key});

  @override
  State<IslamicGoalsScreen> createState() => _IslamicGoalsScreenState();
}

class _IslamicGoalsScreenState extends State<IslamicGoalsScreen> {
  List<IslamicGoal> goals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGoals();
  }

  Future<void> _loadGoals() async {
    setState(() => _isLoading = true);
    try {
      final loadedGoals = await GoalsService.getAllGoals();
      setState(() {
        goals = loadedGoals;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _showAddGoalDialog(BuildContext context, AppLocalizations l10n) {
    String selectedType = 'quran';
    final titleController = TextEditingController();
    final targetController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (stateContext, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: const Color(0xFFF8FAF9),
          title: Text(
            l10n.addGoalTitle,
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
                Text(
                  l10n.goalTypeLabel,
                  style: GoogleFonts.elMessiri(fontWeight: FontWeight.w600, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedType,
                      isExpanded: true,
                      dropdownColor: Colors.white,
                      style: GoogleFonts.elMessiri(color: Colors.black87, fontSize: 16),
                      onChanged: (value) {
                        if (value != null) setDialogState(() => selectedType = value);
                      },
                      items: [
                        DropdownMenuItem(value: 'quran', child: Text(l10n.goalTypeQuran)),
                        DropdownMenuItem(value: 'surah', child: Text(l10n.goalTypeSurah)),
                        DropdownMenuItem(value: 'prayer_streak', child: Text(l10n.goalTypePrayer)),
                      ].cast<DropdownMenuItem<String>>(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: titleController,
                  style: GoogleFonts.elMessiri(),
                  decoration: InputDecoration(
                    labelText: l10n.goalTitleLabel,
                    labelStyle: GoogleFonts.elMessiri(color: Colors.grey.shade700),
                    hintText: l10n.goalTitleHint,
                    hintStyle: GoogleFonts.elMessiri(color: Colors.grey.shade400),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF1B5E3F), width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: targetController,
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.elMessiri(),
                  decoration: InputDecoration(
                    labelText: selectedType == 'surah' ? l10n.surahNumberLabel : l10n.numberOfDaysLabel,
                    labelStyle: GoogleFonts.elMessiri(color: Colors.grey.shade700),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF1B5E3F), width: 2),
                    ),
                  ),
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
                if (titleController.text.isNotEmpty && targetController.text.isNotEmpty) {
                  final goal = IslamicGoal(
                    id: Random().nextInt(100000).toString(),
                    type: selectedType,
                    title: titleController.text,
                    description: _getGoalDescription(selectedType, l10n),
                    targetValue: int.parse(targetController.text),
                    currentProgress: 0,
                    createdAt: DateTime.now(),
                  );
                  await GoalsService.saveGoal(goal);
                  if (!dialogContext.mounted) return;
                  Navigator.pop(dialogContext);
                  if (mounted) _loadGoals();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B5E3F),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(l10n.createGoalBtn, style: GoogleFonts.elMessiri(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  String _getGoalDescription(String type, AppLocalizations l10n) {
    switch (type) {
      case 'quran': return l10n.goalTypeQuran;
      case 'surah': return l10n.goalTypeSurah;
      case 'prayer_streak': return l10n.goalTypePrayer;
      default: return l10n.islamicGoalsTitle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

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
                          child: goals.isEmpty
                              ? _buildEmptyState(context, l10n)
                              : _buildGoalsList(context, l10n),
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
          onPressed: () => _showAddGoalDialog(context, l10n),
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
              l10n.islamicGoalsTitle,
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

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.flag_circle_rounded, size: 80, color: const Color(0xFFD4AF37).withValues(alpha: 0.3)),
            const SizedBox(height: 16),
            Text(
              l10n.noGoalsTitle,
              style: GoogleFonts.elMessiri(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.noGoalsDesc,
              style: GoogleFonts.elMessiri(color: Colors.white.withValues(alpha: 0.7), fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalsList(BuildContext context, AppLocalizations l10n) {
    final activeGoals = goals.where((g) => !g.isCompleted).toList();
    final completedGoals = goals.where((g) => g.isCompleted).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
      children: [
        if (activeGoals.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 16),
            child: Text(
              '${l10n.activeGoals} (${activeGoals.length})',
              style: GoogleFonts.elMessiri(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          ...activeGoals.map((goal) => _GoalGlassCard(
            goal: goal, 
            l10n: l10n,
            onUpdate: () => _showProgressDialog(context, goal, l10n),
            onDelete: () => _showDeleteConfirmation(context, goal, l10n),
          )),
        ],
        if (completedGoals.isNotEmpty) ...[
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 16),
            child: Text(
              '${l10n.completedGoals} (${completedGoals.length})',
              style: GoogleFonts.elMessiri(color: Colors.white.withValues(alpha: 0.7), fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          ...completedGoals.map((goal) => _GoalGlassCard(
            goal: goal, 
            l10n: l10n,
            onUpdate: () => _showProgressDialog(context, goal, l10n),
            onDelete: () => _showDeleteConfirmation(context, goal, l10n),
          )),
        ],
      ],
    );
  }

  void _showProgressDialog(BuildContext context, IslamicGoal goal, AppLocalizations l10n) {
    final progressController = TextEditingController(text: goal.currentProgress.toString());

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color(0xFFF8FAF9),
        title: Text(l10n.updateDialogTitle, style: GoogleFonts.elMessiri(color: const Color(0xFF1B5E3F), fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: progressController,
              keyboardType: TextInputType.number,
              style: GoogleFonts.elMessiri(),
              decoration: InputDecoration(
                labelText: '${l10n.progressLabel} (${goal.targetValue} max)',
                labelStyle: GoogleFonts.elMessiri(color: Colors.grey.shade700),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF1B5E3F), width: 2),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancelBtn, style: GoogleFonts.elMessiri(color: Colors.grey.shade700, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            onPressed: () async {
              final newProgress = int.tryParse(progressController.text) ?? goal.currentProgress;
              final clamped = newProgress.clamp(0, goal.targetValue);
              await GoalsService.updateProgress(goal.id, clamped);
              if (!dialogContext.mounted) return;
              Navigator.pop(dialogContext);
              if (mounted) _loadGoals();
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B5E3F), foregroundColor: Colors.white),
            child: Text(l10n.updateBtn, style: GoogleFonts.elMessiri(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, IslamicGoal goal, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color(0xFFF8FAF9),
        title: Text(l10n.deleteGoalTitle, style: GoogleFonts.elMessiri(color: Colors.redAccent, fontWeight: FontWeight.bold)),
        content: Text('${l10n.deleteGoalDesc}\n"${goal.title}"', style: GoogleFonts.elMessiri(fontSize: 16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancelBtn, style: GoogleFonts.elMessiri(color: Colors.grey.shade700, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            onPressed: () async {
              await GoalsService.deleteGoal(goal.id);
              if (!dialogContext.mounted) return;
              Navigator.pop(dialogContext);
              if (mounted) _loadGoals();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
            child: Text(l10n.deleteBtn, style: GoogleFonts.elMessiri(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _GoalGlassCard extends StatefulWidget {
  final IslamicGoal goal;
  final AppLocalizations l10n;
  final VoidCallback onUpdate;
  final VoidCallback onDelete;

  const _GoalGlassCard({required this.goal, required this.l10n, required this.onUpdate, required this.onDelete});

  @override
  State<_GoalGlassCard> createState() => _GoalGlassCardState();
}

class _GoalGlassCardState extends State<_GoalGlassCard> {
  bool _isHovered = false;

  IconData _getGoalIcon(String type) {
    switch (type) {
      case 'quran': return Icons.menu_book_rounded;
      case 'surah': return Icons.auto_stories_rounded;
      case 'prayer_streak': return Icons.repeat_rounded;
      default: return Icons.track_changes;
    }
  }

  @override
  Widget build(BuildContext context) {
    final goal = widget.goal;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: goal.isCompleted
                    ? const Color(0xFF0B3D2E).withValues(alpha: 0.4)
                    : (_isHovered ? const Color(0xFF144D32).withValues(alpha: 0.8) : const Color(0xFF0B3D2E).withValues(alpha: 0.65)),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: goal.isCompleted
                      ? const Color(0xFFD4AF37).withValues(alpha: 0.15)
                      : (_isHovered ? const Color(0xFFD4AF37) : const Color(0xFFD4AF37).withValues(alpha: 0.3)),
                  width: _isHovered ? 2 : 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD4AF37).withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFD4AF37).withValues(alpha: 0.4)),
                        ),
                        child: Icon(_getGoalIcon(goal.type), color: const Color(0xFFD4AF37), size: 24),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              goal.title,
                              style: GoogleFonts.elMessiri(
                                color: goal.isCompleted ? Colors.white54 : Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                decoration: goal.isCompleted ? TextDecoration.lineThrough : null,
                                decorationColor: Colors.white54,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              goal.description,
                              style: GoogleFonts.elMessiri(
                                color: Colors.white.withValues(alpha: 0.6),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (goal.isCompleted)
                        const Icon(Icons.check_circle_rounded, color: Color(0xFF4CAF50), size: 32),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: goal.progressPercentage / 100,
                      minHeight: 10,
                      backgroundColor: Colors.black.withValues(alpha: 0.3),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        goal.isCompleted ? const Color(0xFF4CAF50) : const Color(0xFFD4AF37),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${goal.currentProgress} / ${goal.targetValue}',
                        style: GoogleFonts.elMessiri(color: Colors.white.withValues(alpha: 0.8), fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '${goal.progressPercentage.toStringAsFixed(0)}%',
                        style: GoogleFonts.elMessiri(color: goal.isCompleted ? const Color(0xFF4CAF50) : const Color(0xFFD4AF37), fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  if (!goal.isCompleted) ...[
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: widget.onUpdate,
                            icon: const Icon(Icons.update_rounded, size: 18),
                            label: Text(widget.l10n.updateProgressBtn, style: GoogleFonts.elMessiri(fontWeight: FontWeight.bold, fontSize: 15)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD4AF37),
                              foregroundColor: const Color(0xFF0B3D2E),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: widget.onDelete,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent.withValues(alpha: 0.2),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Icon(Icons.delete_outline_rounded, size: 20),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}