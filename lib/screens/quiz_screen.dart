import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/islamic_pattern_background.dart';
import '../app_theme.dart';
import '../services/theme_service.dart';
import '../l10n/app_localizations.dart';
import '../services/quiz_questions_service.dart';

// ---------------------------------------------------------------------------
// Design tokens
// ---------------------------------------------------------------------------
const Color _kGold = Color(0xFFD4AF37);
const Color _kGoldDeep = Color(0xFFB5952F);
const Color _kGoldSoft = Color(0xFFE8CD7A);

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  String? selectedDifficulty;
  List<QuizQuestion>? currentQuestions;
  int currentQuestionIndex = 0;
  List<int?> answers = [];
  bool quizStarted = false;
  bool quizCompleted = false;

  @override
  void initState() {
    super.initState();
  }

  // -------------------------------------------------------------------------
  // Quiz control
  // -------------------------------------------------------------------------
  void _startQuiz(String difficulty) {
    final service = QuizQuestionsService();
    final String currentLangCode =
        Localizations.localeOf(context).languageCode;

    final questions = service.getRandomQuestionsForDifficulty(
      difficulty,
      currentLangCode,
      count: 10,
    );
    setState(() {
      selectedDifficulty = difficulty;
      currentQuestions = questions;
      currentQuestionIndex = 0;
      answers = List<int?>.filled(questions.length, null);
      quizStarted = true;
      quizCompleted = false;
    });
  }

  void _answerQuestion(int answerIndex) {
    if (answers[currentQuestionIndex] != null) return;
    setState(() {
      answers[currentQuestionIndex] = answerIndex;
    });

    Future.delayed(const Duration(milliseconds: 650), () {
      if (!mounted) return;
      if (currentQuestionIndex < (currentQuestions?.length ?? 0) - 1) {
        setState(() {
          currentQuestionIndex++;
        });
      } else {
        setState(() {
          quizCompleted = true;
        });
      }
    });
  }

  void _goToQuestion(int index) {
    setState(() {
      currentQuestionIndex = index;
    });
  }

  void _restartSameDifficulty() {
    _startQuiz(selectedDifficulty!);
  }

  void _restartNewQuestions() {
    final service = QuizQuestionsService();
    final String currentLangCode =
        Localizations.localeOf(context).languageCode;

    final questions = service.getRandomQuestionsForDifficulty(
      selectedDifficulty!,
      currentLangCode,
      count: 10,
    );

    setState(() {
      currentQuestions = questions;
      currentQuestionIndex = 0;
      answers = List<int?>.filled(questions.length, null);
      quizStarted = true;
      quizCompleted = false;
    });
  }

  void _resetQuiz() {
    setState(() {
      selectedDifficulty = null;
      currentQuestions = null;
      currentQuestionIndex = 0;
      answers = [];
      quizStarted = false;
      quizCompleted = false;
    });
  }

  int _getScore() {
    int score = 0;
    for (int i = 0; i < answers.length; i++) {
      if (answers[i] == currentQuestions![i].correctAnswerIndex) {
        score++;
      }
    }
    return score;
  }

  Color _getDifficultyColor(String difficulty) {
    return switch (difficulty) {
      'easy' => Colors.green,
      'medium' => Colors.orange,
      'hard' => Colors.red,
      _ => Colors.blue,
    };
  }

  String _currentPageKey() {
    if (!quizStarted) return 'difficulty';
    if (quizCompleted) return 'results';
    return 'quiz';
  }

  // -------------------------------------------------------------------------
  // Build
  // -------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        final l10n = AppLocalizations.of(context);
        final langCode = Localizations.localeOf(context).languageCode;

        Widget page;
        if (!quizStarted) {
          page = _buildDifficultySelection(
              context, themeService, langCode, l10n);
        } else if (quizCompleted) {
          page = _buildQuizResults(context, themeService, langCode, l10n);
        } else {
          page = _buildQuizScreen(context, themeService, langCode, l10n);
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 450),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.04, 0.02),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: KeyedSubtree(
            key: ValueKey(_currentPageKey()),
            child: page,
          ),
        );
      },
    );
  }

  // =========================================================================
  // DIFFICULTY SELECTION
  // =========================================================================
  Widget _buildDifficultySelection(
    BuildContext context,
    ThemeService themeService,
    String langCode,
    AppLocalizations l10n,
  ) {
    final isArabic = langCode == 'ar';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: IslamicPatternBackground(
        child: SafeArea(
          child: Column(
            children: [
              // ---- Header ----
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Row(
                  children: [
                    _CircleIconButton(
                      icon: isArabic
                          ? Icons.arrow_forward_rounded
                          : Icons.arrow_back_rounded,
                      onTap: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        switch (langCode) {
                          'ar' => 'الاختبارات الإسلامية',
                          'fr' => 'Quiz Islamiques',
                          _ => 'Islamic Quizzes',
                        },
                        textAlign: TextAlign.center,
                        style: themeService.getTextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: _kGold,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              // ---- Body ----
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                    child: Column(
                      children: [
                        // Hero badge
                        _StaggeredEntrance(
                          index: 0,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  _kGold.withValues(alpha: 0.7),
                                  _kGold.withValues(alpha: 0.05),
                                ],
                              ),
                            ),
                            child: Container(
                              width: 96,
                              height: 96,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).scaffoldBackgroundColor,
                              ),
                              child: const Icon(
                                Icons.quiz_rounded,
                                color: _kGold,
                                size: 48,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 26),

                        _StaggeredEntrance(
                          index: 1,
                          child: Text(
                            switch (langCode) {
                              'ar' => 'اختر مستوى الصعوبة',
                              'fr' => 'Sélectionnez le niveau de difficulté',
                              _ => 'Select Difficulty Level',
                            },
                            textAlign: TextAlign.center,
                            style: themeService.getTextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.getOnBackgroundColor(context),
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        _StaggeredEntrance(
                          index: 2,
                          child: Text(
                            switch (langCode) {
                              'ar' =>
                                'اختبر معرفتك الإسلامية بأحد المستويات الثلاثة',
                              'fr' =>
                                'Testez vos connaissances islamiques avec trois niveaux',
                              _ =>
                                'Test your Islamic knowledge with three levels',
                            },
                            textAlign: TextAlign.center,
                            style: themeService.getTextStyle(
                              fontSize: 14,
                              color: AppTheme.getOnBackgroundColor(context)
                                  .withValues(alpha: 0.65),
                              height: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 36),

                        // Easy
                        _StaggeredEntrance(
                          index: 3,
                          child: _DifficultyCard(
                            title: switch (langCode) {
                              'ar' => 'سهل',
                              'fr' => 'Facile',
                              _ => 'Easy',
                            },
                            description: switch (langCode) {
                              'ar' => 'للمبتدئين — أساسيات الإسلام',
                              'fr' => 'Pour débutants — Bases islamiques',
                              _ => 'For Beginners — Islamic Basics',
                            },
                            icon: Icons.school_rounded,
                            color: Colors.green,
                            badge: switch (langCode) {
                              'ar' => 'المستوى ١',
                              'fr' => 'Niveau 1',
                              _ => 'Level 1',
                            },
                            onTap: () => _startQuiz('easy'),
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Medium
                        _StaggeredEntrance(
                          index: 4,
                          child: _DifficultyCard(
                            title: switch (langCode) {
                              'ar' => 'متوسط',
                              'fr' => 'Moyen',
                              _ => 'Medium',
                            },
                            description: switch (langCode) {
                              'ar' => 'المستوى المتقدم — معرفة إسلامية',
                              'fr' =>
                                'Niveau avancé — Connaissances islamiques',
                              _ => 'Advanced Level — Islamic Knowledge',
                            },
                            icon: Icons.trending_up_rounded,
                            color: Colors.orange,
                            badge: switch (langCode) {
                              'ar' => 'المستوى ٢',
                              'fr' => 'Niveau 2',
                              _ => 'Level 2',
                            },
                            onTap: () => _startQuiz('medium'),
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Hard
                        _StaggeredEntrance(
                          index: 5,
                          child: _DifficultyCard(
                            title: switch (langCode) {
                              'ar' => 'صعب',
                              'fr' => 'Difficile',
                              _ => 'Hard',
                            },
                            description: switch (langCode) {
                              'ar' => 'للخبراء — دراسات إسلامية متقدمة',
                              'fr' =>
                                'Pour experts — Études islamiques avancées',
                              _ => 'For Experts — Advanced Islamic Studies',
                            },
                            icon: Icons.psychology_rounded,
                            color: Colors.red,
                            badge: switch (langCode) {
                              'ar' => 'المستوى ٣',
                              'fr' => 'Niveau 3',
                              _ => 'Level 3',
                            },
                            onTap: () => _startQuiz('hard'),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================================
  // QUIZ SCREEN
  // =========================================================================
  Widget _buildQuizScreen(
    BuildContext context,
    ThemeService themeService,
    String langCode,
    AppLocalizations l10n,
  ) {
    final question = currentQuestions![currentQuestionIndex];
    final progress = (currentQuestionIndex + 1) / currentQuestions!.length;
    final isArabic = langCode == 'ar';
    final diffColor = _getDifficultyColor(selectedDifficulty!);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: IslamicPatternBackground(
        child: SafeArea(
          child: Column(
            children: [
              // ---- Header & progress ----
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _CircleIconButton(
                          icon: isArabic
                              ? Icons.arrow_forward_rounded
                              : Icons.arrow_back_rounded,
                          onTap: _resetQuiz,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _kGold.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _kGold.withValues(alpha: 0.35),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            '${currentQuestionIndex + 1} / ${currentQuestions!.length}',
                            style: themeService.getTextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: _kGold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: diffColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: diffColor.withValues(alpha: 0.5),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            switch (selectedDifficulty) {
                              'easy' => switch (langCode) {
                                  'ar' => 'سهل',
                                  'fr' => 'FACILE',
                                  _ => 'EASY',
                                },
                              'medium' => switch (langCode) {
                                  'ar' => 'متوسط',
                                  'fr' => 'MOYEN',
                                  _ => 'MEDIUM',
                                },
                              'hard' => switch (langCode) {
                                  'ar' => 'صعب',
                                  'fr' => 'DIFFICILE',
                                  _ => 'HARD',
                                },
                              _ => '',
                            },
                            style: themeService.getTextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: diffColor,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: progress),
                      duration: const Duration(milliseconds: 450),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, _) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: value,
                            minHeight: 8,
                            backgroundColor:
                                _kGold.withValues(alpha: 0.15),
                            valueColor:
                                AlwaysStoppedAnimation(diffColor),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // ---- Question + options ----
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 420),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.08, 0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: SingleChildScrollView(
                    key: ValueKey(
                        'q_${currentQuestionIndex}_${question.question}'),
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 20),

                          // Question card
                          Container(
                            padding: const EdgeInsets.all(22),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  _kGold.withValues(alpha: 0.14),
                                  _kGold.withValues(alpha: 0.03),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(
                                color: _kGold.withValues(alpha: 0.35),
                                width: 1.4,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: _kGold.withValues(alpha: 0.08),
                                  blurRadius: 18,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.help_outline_rounded,
                                      color: _kGold.withValues(alpha: 0.8),
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      switch (langCode) {
                                        'ar' => 'السؤال',
                                        'fr' => 'Question',
                                        _ => 'Question',
                                      },
                                      style: themeService.getTextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            _kGold.withValues(alpha: 0.85),
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  question.question,
                                  style: themeService.getTextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        AppTheme.getOnBackgroundColor(context),
                                    height: 1.55,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 26),

                          // Options
                          ...List.generate(
                            question.options.length,
                            (index) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _OptionButton(
                                index: index,
                                text: question.options[index],
                                isSelected:
                                    answers[currentQuestionIndex] == index,
                                isAnswered:
                                    answers[currentQuestionIndex] != null,
                                isCorrect: index ==
                                    question.correctAnswerIndex,
                                onTap: answers[currentQuestionIndex] == null
                                    ? () => _answerQuestion(index)
                                    : null,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ---- Navigation ----
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  children: [
                    // Question dots
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      alignment: WrapAlignment.center,
                      children: List.generate(
                        currentQuestions!.length,
                        (index) {
                          final answered = answers[index] != null;
                          final isCurrent = currentQuestionIndex == index;
                          final isCorrect = answered &&
                              answers[index] ==
                                  currentQuestions![index].correctAnswerIndex;
                          final dotColor = answered
                              ? (isCorrect ? Colors.green : Colors.red)
                              : _kGold.withValues(alpha: 0.2);

                          return GestureDetector(
                            onTap: () => _goToQuestion(index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              width: isCurrent ? 30 : 26,
                              height: 26,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isCurrent
                                    ? dotColor.withValues(alpha: 0.4)
                                    : dotColor.withValues(alpha: 0.15),
                                border: Border.all(
                                  color: isCurrent
                                      ? dotColor
                                      : dotColor.withValues(alpha: 0.5),
                                  width: isCurrent ? 2 : 1,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '${index + 1}',
                                  style: themeService.getTextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: isCurrent
                                        ? dotColor
                                        : AppTheme.getOnBackgroundColor(
                                                context)
                                            .withValues(alpha: 0.75),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Prev / Next
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _NavTextButton(
                          label: switch (langCode) {
                            'ar' => 'السابق',
                            'fr' => 'Précédent',
                            _ => 'Previous',
                          },
                          icon: Icons.chevron_left_rounded,
                          enabled: currentQuestionIndex > 0,
                          onTap: () {
                            if (currentQuestionIndex > 0) {
                              setState(() => currentQuestionIndex--);
                            }
                          },
                        ),
                        _NavTextButton(
                          label: switch (langCode) {
                            'ar' => 'التالي',
                            'fr' => 'Suivant',
                            _ => 'Next',
                          },
                          icon: Icons.chevron_right_rounded,
                          trailing: true,
                          enabled: currentQuestionIndex <
                                  currentQuestions!.length - 1 &&
                              answers[currentQuestionIndex] != null,
                          onTap: () {
                            if (currentQuestionIndex <
                                    currentQuestions!.length - 1 &&
                                answers[currentQuestionIndex] != null) {
                              setState(() => currentQuestionIndex++);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================================
  // RESULTS
  // =========================================================================
  Widget _buildQuizResults(
    BuildContext context,
    ThemeService themeService,
    String langCode,
    AppLocalizations l10n,
  ) {
    final score = _getScore();
    final total = currentQuestions!.length;
    final pct = score / total;
    final percentage = (pct * 100).toStringAsFixed(0);

    String getGrade() {
      if (pct >= 0.9) {
        return switch (langCode) {
          'ar' => 'ممتاز',
          'fr' => 'Excellent',
          _ => 'Excellent'
        };
      }
      if (pct >= 0.8) {
        return switch (langCode) {
          'ar' => 'جيد جداً',
          'fr' => 'Très Bien',
          _ => 'Very Good'
        };
      }
      if (pct >= 0.7) {
        return switch (langCode) {
          'ar' => 'جيد',
          'fr' => 'Bien',
          _ => 'Good'
        };
      }
      if (pct >= 0.6) {
        return switch (langCode) {
          'ar' => 'مقبول',
          'fr' => 'Passable',
          _ => 'Fair'
        };
      }
      return switch (langCode) {
        'ar' => 'يحتاج تحسين',
        'fr' => 'À améliorer',
        _ => 'Needs Improvement'
      };
    }

    final gradeColor = pct >= 0.8
        ? Colors.green
        : (pct >= 0.6 ? Colors.orange : Colors.red);

    final diffColor = _getDifficultyColor(selectedDifficulty!);

    final celebrationText = switch (langCode) {
      'ar' => pct >= 0.9
          ? 'ما شاء الله! أداء رائع'
          : (pct >= 0.7
              ? 'أحسنت! استمر في التعلم'
              : 'لا بأس، التعلم رحلة'),
      'fr' => pct >= 0.9
          ? 'MashaAllah ! Excellent travail'
          : (pct >= 0.7
              ? 'Bravo ! Continuez à apprendre'
              : "Ce n'est rien, l'apprentissage est un voyage"),
      _ => pct >= 0.9
          ? 'MashaAllah! Outstanding work'
          : (pct >= 0.7
              ? 'Well done! Keep learning'
              : 'No worries, learning is a journey'),
    };

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: IslamicPatternBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                children: [
                  const SizedBox(height: 8),

                  // ---- Header row ----
                  Row(
                    children: [
                      _CircleIconButton(
                        icon: Icons.close_rounded,
                        onTap: _resetQuiz,
                      ),
                      Expanded(
                        child: Text(
                          switch (langCode) {
                            'ar' => 'نتيجة الاختبار',
                            'fr' => 'Résultat du Quiz',
                            _ => 'Quiz Result',
                          },
                          textAlign: TextAlign.center,
                          style: themeService.getTextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: _kGold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // ---- Animated score ring ----
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: pct),
                    duration: const Duration(milliseconds: 1400),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, _) {
                      return SizedBox(
                        width: 220,
                        height: 220,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 220,
                              height: 220,
                              child: CircularProgressIndicator(
                                value: 1,
                                strokeWidth: 14,
                                backgroundColor: _kGold.withValues(alpha: 0.08),
                                valueColor: AlwaysStoppedAnimation(
                                  _kGold.withValues(alpha: 0.12),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 220,
                              height: 220,
                              child: CircularProgressIndicator(
                                value: value,
                                strokeWidth: 14,
                                strokeCap: StrokeCap.round,
                                backgroundColor: Colors.transparent,
                                valueColor: AlwaysStoppedAnimation(gradeColor),
                              ),
                            ),
                            Container(
                              width: 176,
                              height: 176,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    gradeColor.withValues(alpha: 0.18),
                                    gradeColor.withValues(alpha: 0.02),
                                  ],
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${(value * total).round()}/$total',
                                    style: themeService.getTextStyle(
                                      fontSize: 44,
                                      fontWeight: FontWeight.bold,
                                      color: _kGold,
                                      height: 1.0,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '${(value * 100).toStringAsFixed(0)}%',
                                    style: themeService.getTextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: _kGold.withValues(alpha: 0.75),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 28),

                  // ---- Grade ----
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: gradeColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: gradeColor.withValues(alpha: 0.6),
                        width: 1.4,
                      ),
                    ),
                    child: Text(
                      getGrade(),
                      style: themeService.getTextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: gradeColor,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ---- Celebration text ----
                  Text(
                    celebrationText,
                    textAlign: TextAlign.center,
                    style: themeService.getTextStyle(
                      fontSize: 14,
                      color: AppTheme.getOnBackgroundColor(context)
                          .withValues(alpha: 0.7),
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ---- Difficulty badge ----
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: diffColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: diffColor.withValues(alpha: 0.5),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.bar_chart_rounded,
                            color: diffColor, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          switch (selectedDifficulty) {
                            'easy' => switch (langCode) {
                                'ar' => 'سهل',
                                'fr' => 'FACILE',
                                _ => 'EASY',
                              },
                            'medium' => switch (langCode) {
                                'ar' => 'متوسط',
                                'fr' => 'MOYEN',
                                _ => 'MEDIUM',
                              },
                            'hard' => switch (langCode) {
                                'ar' => 'صعب',
                                'fr' => 'DIFFICILE',
                                _ => 'HARD',
                              },
                            _ => '',
                          },
                          style: themeService.getTextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: diffColor,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 36),

                  // ---- Review section ----
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Row(
                      children: [
                        Container(
                          width: 4,
                          height: 20,
                          decoration: BoxDecoration(
                            color: _kGold,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          switch (langCode) {
                            'ar' => 'مراجعة الإجابات',
                            'fr' => 'Révision des réponses',
                            _ => 'Review Answers',
                          },
                          style: themeService.getTextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _kGold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  ...List.generate(
                    currentQuestions!.length,
                    (index) {
                      final q = currentQuestions![index];
                      final userAnswerIndex = answers[index];
                      final isCorrect =
                          userAnswerIndex == q.correctAnswerIndex;

                      return _ReviewItem(
                        index: index,
                        isCorrect: isCorrect,
                        questionText: q.question,
                        userAnswer: userAnswerIndex != null
                            ? q.options[userAnswerIndex]
                            : switch (langCode) {
                                'ar' => 'لم يتم الإجابة',
                                'fr' => 'Non répondu',
                                _ => 'Not answered',
                              },
                        correctAnswer: q.options[q.correctAnswerIndex],
                        langCode: langCode,
                        themeService: themeService,
                      );
                    },
                  ),

                  const SizedBox(height: 32),

                  // ---- Action buttons ----
                  _ActionButton(
                    icon: Icons.refresh_rounded,
                    label: switch (langCode) {
                      'ar' => 'أعد محاولة نفس الأسئلة',
                      'fr' => 'Réessayer les mêmes questions',
                      _ => 'Retry Same Questions',
                    },
                    gradient: const [Color(0xFF2196F3), Color(0xFF1976D2)],
                    onTap: _restartSameDifficulty,
                  ),
                  const SizedBox(height: 12),
                  _ActionButton(
                    icon: Icons.casino_rounded,
                    label: switch (langCode) {
                      'ar' => 'اختبار جديد بأسئلة مختلفة',
                      'fr' => 'Nouveau quiz — Questions différentes',
                      _ => 'New Quiz — Different Questions',
                    },
                    gradient: const [_kGold, _kGoldDeep],
                    onTap: _restartNewQuestions,
                  ),
                  const SizedBox(height: 12),
                  _ActionButton(
                    icon: Icons.trending_up_rounded,
                    label: switch (langCode) {
                      'ar' => 'تغيير مستوى الصعوبة',
                      'fr' => 'Changer le niveau de difficulté',
                      _ => 'Change Difficulty Level',
                    },
                    gradient: const [Color(0xFF7E57C2), Color(0xFF5E35B1)],
                    onTap: _resetQuiz,
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ===========================================================================
// REUSABLE WIDGETS
// ===========================================================================

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.7),
        border: Border.all(
          color: _kGold.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, color: _kGold, size: 22),
        onPressed: onTap,
      ),
    );
  }
}

class _NavTextButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool enabled;
  final bool trailing;
  final VoidCallback onTap;

  const _NavTextButton({
    required this.label,
    required this.icon,
    required this.enabled,
    required this.onTap,
    this.trailing = false,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        final color = enabled
            ? _kGold
            : AppTheme.getOnBackgroundColor(context).withValues(alpha: 0.3);

        return Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            onTap: enabled ? onTap : null,
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!trailing) ...[
                    Icon(icon, color: color, size: 20),
                    const SizedBox(width: 4),
                  ],
                  Text(
                    label,
                    style: themeService.getTextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  if (trailing) ...[
                    const SizedBox(width: 4),
                    Icon(icon, color: color, size: 20),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Difficulty card
// ---------------------------------------------------------------------------
class _DifficultyCard extends StatefulWidget {
  final String title;
  final String description;
  final String badge;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _DifficultyCard({
    required this.title,
    required this.description,
    required this.badge,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  State<_DifficultyCard> createState() => _DifficultyCardState();
}

class _DifficultyCardState extends State<_DifficultyCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        return MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedScale(
              scale: _isHovered ? 0.98 : 1.0,
              duration: const Duration(milliseconds: 160),
              curve: Curves.easeOut,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      widget.color.withValues(
                          alpha: _isHovered ? 0.22 : 0.14),
                      widget.color.withValues(alpha: 0.04),
                    ],
                  ),
                  border: Border.all(
                    color: widget.color.withValues(
                      alpha: _isHovered ? 0.85 : 0.35,
                    ),
                    width: _isHovered ? 1.8 : 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.color.withValues(
                          alpha: _isHovered ? 0.22 : 0.08),
                      blurRadius: _isHovered ? 22 : 12,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 66,
                      height: 66,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.color.withValues(alpha: 0.18),
                        border: Border.all(
                          color: widget.color.withValues(alpha: 0.4),
                          width: 1.2,
                        ),
                      ),
                      child: Icon(
                        widget.icon,
                        color: widget.color,
                        size: 34,
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: widget.color.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              widget.badge,
                              style: themeService.getTextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: widget.color,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.title,
                            style: themeService.getTextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: widget.color,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.description,
                            style: themeService.getTextStyle(
                              fontSize: 13,
                              color: AppTheme.getOnBackgroundColor(context)
                                  .withValues(alpha: 0.65),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      isRtl
                          ? Icons.arrow_back_rounded
                          : Icons.arrow_forward_rounded,
                      color: widget.color.withValues(alpha: 0.8),
                      size: 22,
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

// ---------------------------------------------------------------------------
// Option button
// ---------------------------------------------------------------------------
class _OptionButton extends StatefulWidget {
  final int index;
  final String text;
  final bool isSelected;
  final bool isAnswered;
  final bool isCorrect;
  final VoidCallback? onTap;

  const _OptionButton({
    required this.index,
    required this.text,
    required this.isSelected,
    required this.isAnswered,
    required this.isCorrect,
    required this.onTap,
  });

  @override
  State<_OptionButton> createState() => _OptionButtonState();
}

class _OptionButtonState extends State<_OptionButton> {
  bool _isHovered = false;

  String get _letter {
    const letters = ['A', 'B', 'C', 'D', 'E', 'F'];
    return widget.index < letters.length
        ? letters[widget.index]
        : '${widget.index + 1}';
  }

  @override
  Widget build(BuildContext context) {
    final Color surface = Theme.of(context).colorScheme.surface;

    Color background;
    Color border;
    Color letterBg;
    Color letterFg;
    IconData? trailingIcon;
    Color? trailingIconColor;

    if (!widget.isAnswered) {
      background = _isHovered
          ? _kGold.withValues(alpha: 0.1)
          : surface.withValues(alpha: 0.35);
      border = _kGold.withValues(alpha: _isHovered ? 0.7 : 0.25);
      letterBg = _kGold.withValues(alpha: _isHovered ? 0.25 : 0.12);
      letterFg = _kGold;
    } else if (widget.isCorrect) {
      background = Colors.green.withValues(alpha: 0.15);
      border = Colors.green.withValues(alpha: 0.85);
      letterBg = Colors.green.withValues(alpha: 0.25);
      letterFg = Colors.green;
      trailingIcon = Icons.check_circle_rounded;
      trailingIconColor = Colors.green;
    } else if (widget.isSelected) {
      background = Colors.red.withValues(alpha: 0.14);
      border = Colors.red.withValues(alpha: 0.8);
      letterBg = Colors.red.withValues(alpha: 0.22);
      letterFg = Colors.red;
      trailingIcon = Icons.cancel_rounded;
      trailingIconColor = Colors.red;
    } else {
      background = surface.withValues(alpha: 0.18);
      border = _kGold.withValues(alpha: 0.15);
      letterBg = _kGold.withValues(alpha: 0.06);
      letterFg = _kGold.withValues(alpha: 0.5);
    }

    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        return MouseRegion(
          onEnter: widget.onTap != null
              ? (_) => setState(() => _isHovered = true)
              : null,
          onExit: widget.onTap != null
              ? (_) => setState(() => _isHovered = false)
              : null,
          cursor: widget.onTap != null
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: background,
                border: Border.all(
                  color: border,
                  width: widget.isAnswered && widget.isSelected ? 2 : 1.4,
                ),
                boxShadow: widget.isAnswered && widget.isCorrect
                    ? [
                        BoxShadow(
                          color: Colors.green.withValues(alpha: 0.22),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : (widget.isAnswered && widget.isSelected
                        ? [
                            BoxShadow(
                              color: Colors.red.withValues(alpha: 0.18),
                              blurRadius: 14,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null),
              ),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 260),
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: letterBg,
                      border: Border.all(
                        color: letterFg.withValues(alpha: 0.5),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _letter,
                        style: themeService.getTextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: letterFg,
                          height: 1.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      widget.text,
                      style: themeService.getTextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.getOnBackgroundColor(context),
                        height: 1.4,
                      ),
                    ),
                  ),
                  if (trailingIcon != null)
                    Padding(
                      padding: const EdgeInsetsDirectional.only(start: 10),
                      child: Icon(
                        trailingIcon,
                        color: trailingIconColor,
                        size: 24,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Review item (expandable)
// ---------------------------------------------------------------------------
class _ReviewItem extends StatefulWidget {
  final int index;
  final bool isCorrect;
  final String questionText;
  final String userAnswer;
  final String correctAnswer;
  final String langCode;
  final ThemeService themeService;

  const _ReviewItem({
    required this.index,
    required this.isCorrect,
    required this.questionText,
    required this.userAnswer,
    required this.correctAnswer,
    required this.langCode,
    required this.themeService,
  });

  @override
  State<_ReviewItem> createState() => _ReviewItemState();
}

class _ReviewItemState extends State<_ReviewItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.isCorrect ? Colors.green : Colors.red;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withValues(alpha: _expanded ? 0.6 : 0.3),
            width: _expanded ? 1.4 : 1,
          ),
        ),
        child: Column(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => setState(() => _expanded = !_expanded),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color.withValues(alpha: 0.2),
                        border: Border.all(
                          color: color.withValues(alpha: 0.5),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        widget.isCorrect
                            ? Icons.check_rounded
                            : Icons.close_rounded,
                        color: color,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '${switch (widget.langCode) {
                          'ar' => 'س',
                          'fr' => 'Q',
                          _ => 'Q',
                        }}${widget.index + 1}',
                        style: widget.themeService.getTextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ),
                    Text(
                      widget.isCorrect
                          ? switch (widget.langCode) {
                              'ar' => 'صحيح',
                              'fr' => 'Correct',
                              _ => 'Correct',
                            }
                          : switch (widget.langCode) {
                              'ar' => 'خاطئ',
                              'fr' => 'Faux',
                              _ => 'Wrong',
                            },
                      style: widget.themeService.getTextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: color.withValues(alpha: 0.85),
                      ),
                    ),
                    const SizedBox(width: 6),
                    AnimatedRotation(
                      turns: _expanded ? 0.5 : 0.0,
                      duration: const Duration(milliseconds: 220),
                      child: Icon(
                        Icons.expand_more_rounded,
                        color: color.withValues(alpha: 0.8),
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 240),
              sizeCurve: Curves.easeOutCubic,
              crossFadeState: _expanded
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              firstChild: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.questionText,
                      style: widget.themeService.getTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.getOnBackgroundColor(context),
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _answerRow(
                      context,
                      label: switch (widget.langCode) {
                        'ar' => 'إجابتك',
                        'fr' => 'Votre réponse',
                        _ => 'Your answer',
                      },
                      value: widget.userAnswer,
                      color: widget.isCorrect ? Colors.green : Colors.red,
                    ),
                    const SizedBox(height: 8),
                    _answerRow(
                      context,
                      label: switch (widget.langCode) {
                        'ar' => 'الإجابة الصحيحة',
                        'fr' => 'Bonne réponse',
                        _ => 'Correct answer',
                      },
                      value: widget.correctAnswer,
                      color: Colors.green,
                    ),
                  ],
                ),
              ),
              secondChild: const SizedBox(width: double.infinity, height: 0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _answerRow(
    BuildContext context, {
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: color.withValues(alpha: 0.25),
          width: 0.8,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 96,
            child: Text(
              label,
              style: widget.themeService.getTextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: widget.themeService.getTextStyle(
                fontSize: 13,
                color: AppTheme.getOnBackgroundColor(context)
                    .withValues(alpha: 0.85),
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Staggered entrance wrapper
// ---------------------------------------------------------------------------
class _StaggeredEntrance extends StatefulWidget {
  final int index;
  final Widget child;
  final Duration baseDelay;

  const _StaggeredEntrance({
    required this.index,
    required this.child,
  }) : baseDelay = const Duration(milliseconds: 80);

  @override
  State<_StaggeredEntrance> createState() => _StaggeredEntranceState();
}

class _StaggeredEntranceState extends State<_StaggeredEntrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    final delay = widget.baseDelay * widget.index;
    Future.delayed(delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}

// ---------------------------------------------------------------------------
// Results action button (gradient, elevated)
// ---------------------------------------------------------------------------
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        return SizedBox(
          width: double.infinity,
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 15,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: gradient,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: gradient.first.withValues(alpha: 0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, color: Colors.white, size: 20),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        label,
                        textAlign: TextAlign.center,
                        style: themeService.getTextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
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