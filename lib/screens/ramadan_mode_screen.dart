import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../widgets/islamic_pattern_background.dart';
import '../app_theme.dart';
import '../services/theme_service.dart';
import '../l10n/app_localizations.dart';
import '../models/ramadan_goal.dart';
import '../services/hijri_calendar_service.dart';

class RamadanModeScreen extends StatefulWidget {
  const RamadanModeScreen({super.key});

  @override
  State<RamadanModeScreen> createState() => _RamadanModeScreenState();
}

class _RamadanModeScreenState extends State<RamadanModeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeCtrl;
  late List<RamadanGoal> _goals;
  int _currentDay = 1;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
    _loadGoals();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadGoals() async {
    _currentDay = _calculateCurrentRamadanDay();
    final prefs = await SharedPreferences.getInstance();
    final goalsJson = prefs.getStringList('ramadan_goals') ?? [];

    if (goalsJson.isEmpty) {
      _goals = RamadanGoalsService.getDefaultGoals(_currentDay);
    } else {
      _goals = goalsJson
          .map((g) => RamadanGoal.fromJson(jsonDecode(g)))
          .toList();
    }

    setState(() => _isLoading = false);
  }

  Future<void> _saveGoals() async {
    final prefs = await SharedPreferences.getInstance();
    final goalsJson = _goals.map((g) => jsonEncode(g.toJson())).toList();
    await prefs.setStringList('ramadan_goals', goalsJson);
  }

  int _calculateCurrentRamadanDay() {
  final hijri = HijriCalendarService.gregorianToHijri(DateTime.now());
  // If in Ramadan (month 9), return the day
  if (hijri.month == 9 && hijri.day <= 30) {
    return hijri.day;
  }
  // If before Ramadan, return 0 or 1 (show countdown)
  if (hijri.month < 9) {
    return 0; // Not started yet
  }
  // If after Ramadan, return 30 (completed)
  return 30;
}

  void _updateGoal(String goalId, int newValue) {
    final index = _goals.indexWhere((g) => g.id == goalId);
    if (index != -1) {
      _goals[index] = _goals[index].copyWith(currentValue: newValue);
      _saveGoals();
      setState(() {});
    }
  }

  void _incrementGoal(String goalId) {
    final goal = _goals.firstWhere((g) => g.id == goalId);
    _updateGoal(goalId, goal.currentValue + 1);
  }

  void _decrementGoal(String goalId) {
    final goal = _goals.firstWhere((g) => g.id == goalId);
    if (goal.currentValue > 0) {
      _updateGoal(goalId, goal.currentValue - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: IslamicPatternBackground(
          child: Center(
            child: CircularProgressIndicator(
              color: Color(0xFFD4AF37),
            ),
          ),
        ),
      );
    }

    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        final l10n = AppLocalizations.of(context);
        final isArabic = Localizations.localeOf(context).languageCode == 'ar';
        final langCode = isArabic ? 'ar' : 'en';

        return Scaffold(
          body: IslamicPatternBackground(
            child: SafeArea(
              child: FadeTransition(
                opacity: _fadeCtrl,
                child: Column(
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                isArabic ? 'رمضان الكريم' : 'Ramadan Mubarak',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.amiri(
                                  color: const Color(0xFFD4AF37),
                                  fontSize: 44,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                isArabic
                                    ? 'اليوم $_currentDay من 30'
                                    : 'Day $_currentDay of 30',
                                style: GoogleFonts.elMessiri(
                                  color: AppTheme.getOnBackgroundColor(context)
                                      .withValues(alpha: 0.7),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          Align(
                            alignment: isArabic
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                            child: IconButton(
                              icon: const Icon(Icons.close_rounded,
                                  color: Color(0xFFD4AF37)),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Progress bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                isArabic ? 'تقدمك' : 'Your Progress',
                                style: GoogleFonts.elMessiri(
                                  color: const Color(0xFFD4AF37),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${((_currentDay / 30) * 100).toStringAsFixed(0)}%',
                                style: GoogleFonts.elMessiri(
                                  color: const Color(0xFFD4AF37),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: _currentDay / 30,
                              minHeight: 8,
                              backgroundColor: Colors.black.withValues(alpha: 0.2),
                              valueColor: AlwaysStoppedAnimation(
                                const Color(0xFFD4AF37).withValues(alpha: 0.8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Goals List
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _goals.length,
                        itemBuilder: (context, index) {
                          final goal = _goals[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _RamadanGoalCard(
                              goal: goal,
                              languageCode: langCode,
                              onIncrement: () => _incrementGoal(goal.id),
                              onDecrement: () => _decrementGoal(goal.id),
                              onUpdate: (value) => _updateGoal(goal.id, value),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RamadanGoalCard extends StatelessWidget {
  final RamadanGoal goal;
  final String languageCode;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final ValueChanged<int> onUpdate;

  const _RamadanGoalCard({
    required this.goal,
    required this.languageCode,
    required this.onIncrement,
    required this.onDecrement,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final isOnTrack = goal.isOnTrack;
    final percentage = goal.percentageComplete;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isOnTrack
                  ? const Color(0xFFD4AF37).withValues(alpha: 0.5)
                  : Colors.orange.withValues(alpha: 0.3),
              width: 1.5,
            ),
            boxShadow: [
              if (isOnTrack)
                BoxShadow(
                  color: const Color(0xFFD4AF37).withValues(alpha: 0.1),
                  blurRadius: 15,
                  spreadRadius: 2,
                )
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          goal.getTitle(languageCode),
                          style: GoogleFonts.elMessiri(
                            color: const Color(0xFFD4AF37),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          goal.getDescription(languageCode),
                          style: GoogleFonts.elMessiri(
                            color: AppTheme.getOnBackgroundColor(context)
                                .withValues(alpha: 0.6),
                            fontSize: 12,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isOnTrack
                          ? Colors.green.withValues(alpha: 0.2)
                          : Colors.orange.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isOnTrack ? Colors.green : Colors.orange,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      isOnTrack
                          ? (languageCode == 'ar' ? 'على المسار' : 'On Track')
                          : (languageCode == 'ar' ? 'متأخر قليلاً' : 'Catch Up'),
                      style: GoogleFonts.elMessiri(
                        color: isOnTrack ? Colors.green : Colors.orange,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Progress bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${goal.currentValue} / ${goal.targetValue} ${goal.getUnit(languageCode)}',
                        style: GoogleFonts.elMessiri(
                          color: AppTheme.getOnBackgroundColor(context),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${percentage.toStringAsFixed(0)}%',
                        style: GoogleFonts.elMessiri(
                          color: const Color(0xFFD4AF37),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: goal.percentageComplete / 100,
                      minHeight: 6,
                      backgroundColor: Colors.black.withValues(alpha: 0.2),
                      valueColor: AlwaysStoppedAnimation(
                        Color.lerp(
                          const Color(0xFFD4AF37),
                          Colors.green,
                          (goal.percentageComplete / 100).clamp(0, 1),
                        )!,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _GoalButton(
                    icon: Icons.remove,
                    onPressed: onDecrement,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _showEditDialog(context),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          languageCode == 'ar' ? 'تحديث يدوي' : 'Manual Update',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.elMessiri(
                            color: const Color(0xFFD4AF37),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  _GoalButton(
                    icon: Icons.add,
                    onPressed: onIncrement,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final controller = TextEditingController(text: goal.currentValue.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(goal.getTitle(languageCode)),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: isArabic ? 'أدخل القيمة' : 'Enter value',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(isArabic ? 'إلغاء' : 'Cancel'),
          ),
          TextButton(
            onPressed: () {
              final newValue = int.tryParse(controller.text) ?? goal.currentValue;
              onUpdate(newValue.clamp(0, goal.targetValue * 2));
              Navigator.pop(context);
            },
            child: Text(isArabic ? 'حفظ' : 'Save'),
          ),
        ],
      ),
    );
  }
}

class _GoalButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _GoalButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  State<_GoalButton> createState() => _GoalButtonState();
}

class _GoalButtonState extends State<_GoalButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.9 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _isPressed
                ? const Color(0xFFD4AF37).withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFFD4AF37).withValues(alpha: 0.5),
            ),
          ),
          child: Icon(
            widget.icon,
            color: const Color(0xFFD4AF37),
            size: 20,
          ),
        ),
      ),
    );
  }
}