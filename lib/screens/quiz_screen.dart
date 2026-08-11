import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/islamic_pattern_background.dart';
import '../app_theme.dart';
import '../services/theme_service.dart';
import '../l10n/app_localizations.dart';
import '../services/quiz_questions_service.dart';

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

  void _startQuiz(String difficulty) {
    final service = QuizQuestionsService();
    
    // 1. Get the current language code
    final String currentLangCode = Localizations.localeOf(context).languageCode;

    // 2. Pass currentLangCode to get properly translated questions
    final questions = service.getRandomQuestionsForDifficulty(difficulty, currentLangCode, count: 10);
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
    setState(() {
      answers[currentQuestionIndex] = answerIndex;
    });

    // Auto-advance to next question after 500ms
    Future.delayed(const Duration(milliseconds: 500), () {
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
    
    // Get the current language code
    final String currentLangCode = Localizations.localeOf(context).languageCode;
    
    // Pass both the difficulty and the language code
    final questions = service.getRandomQuestionsForDifficulty(selectedDifficulty!, currentLangCode, count: 10);

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

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        final l10n = AppLocalizations.of(context);
        // Grab the language code to pass down for 3-way translations
        final langCode = Localizations.localeOf(context).languageCode;

        if (!quizStarted) {
          return _buildDifficultySelection(context, themeService, langCode, l10n);
        }

        if (quizCompleted) {
          return _buildQuizResults(context, themeService, langCode, l10n);
        }

        return _buildQuizScreen(context, themeService, langCode, l10n);
      },
    );
  }

  Widget _buildDifficultySelection(BuildContext context, ThemeService themeService, String langCode, AppLocalizations l10n) {
    final isArabic = langCode == 'ar';
    
    return Scaffold(
      body: IslamicPatternBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(isArabic ? Icons.arrow_forward : Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
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
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFD4AF37),
                        ),
                      ),
                    ),
                    const SizedBox(width: 56),
                  ],
                ),
              ),
              
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    child: Column(
                      children: [
                        Text(
                          switch (langCode) {
                            'ar' => 'اختر مستوى الصعوبة',
                            'fr' => 'Sélectionnez le niveau de difficulté',
                            _ => 'Select Difficulty Level',
                          },
                          style: themeService.getTextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.getOnBackgroundColor(context),
                          ),
                        ),
                        const SizedBox(height: 40),
                        
                        // Easy Level
                        _DifficultyCard(
                          title: switch (langCode) {
                            'ar' => 'سهل',
                            'fr' => 'Facile',
                            _ => 'Easy',
                          },
                          description: switch (langCode) {
                            'ar' => 'للمبتدئين - أساسيات الإسلام',
                            'fr' => 'Pour débutants - Bases islamiques',
                            _ => 'For Beginners - Islamic Basics',
                          },
                          icon: Icons.school_rounded,
                          color: Colors.green,
                          onTap: () => _startQuiz('easy'),
                        ),
                        const SizedBox(height: 20),
                        
                        // Medium Level
                        _DifficultyCard(
                          title: switch (langCode) {
                            'ar' => 'متوسط',
                            'fr' => 'Moyen',
                            _ => 'Medium',
                          },
                          description: switch (langCode) {
                            'ar' => 'المستوى المتقدم - معرفة إسلامية',
                            'fr' => 'Niveau avancé - Connaissances islamiques',
                            _ => 'Advanced Level - Islamic Knowledge',
                          },
                          icon: Icons.trending_up_rounded,
                          color: Colors.orange,
                          onTap: () => _startQuiz('medium'),
                        ),
                        const SizedBox(height: 20),
                        
                        // Hard Level
                        _DifficultyCard(
                          title: switch (langCode) {
                            'ar' => 'صعب',
                            'fr' => 'Difficile',
                            _ => 'Hard',
                          },
                          description: switch (langCode) {
                            'ar' => 'للخبراء - دراسات إسلامية متقدمة',
                            'fr' => 'Pour experts - Études islamiques avancées',
                            _ => 'For Experts - Advanced Islamic Studies',
                          },
                          icon: Icons.psychology_rounded,
                          color: Colors.red,
                          onTap: () => _startQuiz('hard'),
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
    );
  }

  Widget _buildQuizScreen(BuildContext context, ThemeService themeService, String langCode, AppLocalizations l10n) {
    final question = currentQuestions![currentQuestionIndex];
    final progress = (currentQuestionIndex + 1) / currentQuestions!.length;
    final isArabic = langCode == 'ar';

    return Scaffold(
      body: IslamicPatternBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Header with progress
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(isArabic ? Icons.arrow_forward : Icons.arrow_back),
                          onPressed: () => _resetQuiz(),
                        ),
                        Text(
                          '${currentQuestionIndex + 1}/${currentQuestions!.length}',
                          style: themeService.getTextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFD4AF37),
                          ),
                        ),
                        const SizedBox(width: 56),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: const Color(0xFFD4AF37).withValues(alpha: 0.2),
                        valueColor: AlwaysStoppedAnimation(
                          switch (selectedDifficulty) {
                            'easy' => Colors.green,
                            'medium' => Colors.orange,
                            'hard' => Colors.red,
                            _ => Colors.blue,
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Question and Options
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        
                        // Question
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.4),
                            border: Border.all(
                              color: const Color(0xFFD4AF37).withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            question.question,
                            style: themeService.getTextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.getOnBackgroundColor(context),
                              height: 1.5,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Options
                        ...List.generate(
                          question.options.length,
                          (index) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _OptionButton(
                              text: question.options[index],
                              isSelected: answers[currentQuestionIndex] == index,
                              isAnswered: answers[currentQuestionIndex] != null,
                              isCorrect: index == question.correctAnswerIndex,
                              onTap: answers[currentQuestionIndex] == null 
                                ? () => _answerQuestion(index)
                                : null,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),

              // Navigation buttons
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: currentQuestionIndex > 0
                        ? () => setState(() => currentQuestionIndex--)
                        : null,
                      child: Text(
                        switch (langCode) {
                          'ar' => 'السابق',
                          'fr' => 'Précédent',
                          _ => 'Previous',
                        },
                        style: themeService.getTextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: List.generate(
                            currentQuestions!.length,
                            (index) => GestureDetector(
                              onTap: () => _goToQuestion(index),
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: answers[index] != null
                                    ? const Color(0xFFD4AF37).withValues(alpha: 0.6)
                                    : Theme.of(context).colorScheme.surface.withValues(alpha: 0.4),
                                  border: Border.all(
                                    color: currentQuestionIndex == index
                                      ? const Color(0xFFD4AF37)
                                      : const Color(0xFFD4AF37).withValues(alpha: 0.2),
                                    width: currentQuestionIndex == index ? 2 : 1,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    '${index + 1}',
                                    style: themeService.getTextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: currentQuestionIndex == index
                                        ? const Color(0xFFD4AF37)
                                        : AppTheme.getOnBackgroundColor(context),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: currentQuestionIndex < currentQuestions!.length - 1 && answers[currentQuestionIndex] != null
                        ? () => setState(() => currentQuestionIndex++)
                        : null,
                      child: Text(
                         switch (langCode) {
                          'ar' => 'التالي',
                          'fr' => 'Suivant',
                          _ => 'Next',
                        },
                        style: themeService.getTextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

  Widget _buildQuizResults(BuildContext context, ThemeService themeService, String langCode, AppLocalizations l10n) {
    final score = _getScore();
    final total = currentQuestions!.length;
    final percentage = ((score / total) * 100).toStringAsFixed(1);
    
    String getGrade() {
      final pct = score / total;
      if (pct >= 0.9) return switch(langCode) { 'ar' => 'ممتاز', 'fr' => 'Excellent', _ => 'Excellent' };
      if (pct >= 0.8) return switch(langCode) { 'ar' => 'جيد جداً', 'fr' => 'Très Bien', _ => 'Very Good' };
      if (pct >= 0.7) return switch(langCode) { 'ar' => 'جيد', 'fr' => 'Bien', _ => 'Good' };
      if (pct >= 0.6) return switch(langCode) { 'ar' => 'مقبول', 'fr' => 'Passable', _ => 'Fair' };
      return switch(langCode) { 'ar' => 'يحتاج تحسين', 'fr' => 'À améliorer', _ => 'Needs Improvement' };
    }

    return Scaffold(
      body: IslamicPatternBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  
                  // Score Circle
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFD4AF37).withValues(alpha: 0.3),
                          const Color(0xFFD4AF37).withValues(alpha: 0.1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(
                        color: const Color(0xFFD4AF37),
                        width: 3,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$score/$total',
                            style: themeService.getTextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFD4AF37),
                            ),
                          ),
                          Text(
                            '$percentage%',
                            style: themeService.getTextStyle(
                              fontSize: 24,
                              color: const Color(0xFFD4AF37).withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Grade
                  Text(
                    getGrade(),
                    style: themeService.getTextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.getOnBackgroundColor(context),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Difficulty Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: _getDifficultyColor(selectedDifficulty!).withValues(alpha: 0.2),
                      border: Border.all(
                        color: _getDifficultyColor(selectedDifficulty!),
                      ),
                    ),
                    child: Text(
                      switch (selectedDifficulty) {
                        'easy' => switch (langCode) { 'ar' => 'سهل', 'fr' => 'FACILE', _ => 'EASY' },
                        'medium' => switch (langCode) { 'ar' => 'متوسط', 'fr' => 'MOYEN', _ => 'MEDIUM' },
                        'hard' => switch (langCode) { 'ar' => 'صعب', 'fr' => 'DIFFICILE', _ => 'HARD' },
                        _ => selectedDifficulty!.toUpperCase(),
                      },
                      style: themeService.getTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _getDifficultyColor(selectedDifficulty!),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 60),
                  
                  // Review Answers
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.3),
                      border: Border.all(
                        color: const Color(0xFFD4AF37).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          switch (langCode) {
                            'ar' => 'ملخص الإجابات',
                            'fr' => 'Résumé des réponses',
                            _ => 'Answer Summary',
                          },
                          style: themeService.getTextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...List.generate(
                          currentQuestions!.length,
                          (index) {
                            final isCorrect = answers[index] == currentQuestions![index].correctAnswerIndex;
                            final correctText = switch (langCode) { 'ar' => 'صحيح', 'fr' => 'Correct', _ => 'Correct' };
                            final wrongText = switch (langCode) { 'ar' => 'خاطئ', 'fr' => 'Faux', _ => 'Wrong' };

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  Icon(
                                    isCorrect ? Icons.check_circle : Icons.cancel,
                                    color: isCorrect ? Colors.green : Colors.red,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Q${index + 1}: ${isCorrect ? correctText : wrongText}',
                                      style: themeService.getTextStyle(
                                        fontSize: 14,
                                        color: AppTheme.getOnBackgroundColor(context),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Action Buttons
                  Column(
                    children: [
                      // Restart with same questions
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _restartSameDifficulty,
                          icon: const Icon(Icons.refresh),
                          label: Text(
                            switch (langCode) {
                              'ar' => 'أعد محاولة نفس الأسئلة',
                              'fr' => 'Réessayer les mêmes questions',
                              _ => 'Retry Same Questions',
                            }
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: Colors.blue,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Restart with new questions
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _restartNewQuestions,
                          icon: const Icon(Icons.casino),
                          label: Text(
                            switch (langCode) {
                              'ar' => 'اختبار جديد بأسئلة مختلفة',
                              'fr' => 'Nouveau quiz - Questions différentes',
                              _ => 'New Quiz - Different Questions',
                            }
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: Colors.amber,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Change difficulty
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _resetQuiz,
                          icon: const Icon(Icons.trending_up),
                          label: Text(
                            switch (langCode) {
                              'ar' => 'تغيير مستوى الصعوبة',
                              'fr' => 'Changer le niveau de difficulté',
                              _ => 'Change Difficulty Level',
                            }
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: Colors.deepPurple,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    return switch (difficulty) {
      'easy' => Colors.green,
      'medium' => Colors.orange,
      'hard' => Colors.red,
      _ => Colors.blue,
    };
  }
}

class _DifficultyCard extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _DifficultyCard({
    required this.title,
    required this.description,
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
              duration: const Duration(milliseconds: 150),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    colors: [
                      widget.color.withValues(alpha: 0.15),
                      widget.color.withValues(alpha: 0.05),
                    ],
                  ),
                  border: Border.all(
                    color: widget.color.withValues(
                      alpha: _isHovered ? 0.8 : 0.3,
                    ),
                    width: _isHovered ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.color.withValues(alpha: 0.2),
                      ),
                      child: Icon(
                        widget.icon,
                        color: widget.color,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: themeService.getTextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: widget.color,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.description,
                            style: themeService.getTextStyle(
                              fontSize: 13,
                              color: AppTheme.getOnBackgroundColor(context)
                                  .withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: widget.color,
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

class _OptionButton extends StatefulWidget {
  final String text;
  final bool isSelected;
  final bool isAnswered;
  final bool isCorrect;
  final VoidCallback? onTap;

  const _OptionButton({
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

  @override
  Widget build(BuildContext context) {
    Color getBackgroundColor() {
      if (!widget.isAnswered) {
        return Theme.of(context).colorScheme.surface.withValues(
          alpha: _isHovered ? 0.6 : 0.3,
        );
      }
      if (widget.isCorrect) {
        return Colors.green.withValues(alpha: 0.3);
      }
      if (widget.isSelected) {
        return Colors.red.withValues(alpha: 0.3);
      }
      return Theme.of(context).colorScheme.surface.withValues(alpha: 0.2);
    }

    Color getBorderColor() {
      if (!widget.isAnswered) {
        return const Color(0xFFD4AF37).withValues(
          alpha: _isHovered ? 0.8 : 0.2,
        );
      }
      if (widget.isCorrect) return Colors.green;
      if (widget.isSelected) return Colors.red;
      return const Color(0xFFD4AF37).withValues(alpha: 0.2);
    }

    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        return MouseRegion(
          onEnter: widget.onTap != null ? (_) => setState(() => _isHovered = true) : null,
          onExit: widget.onTap != null ? (_) => setState(() => _isHovered = false) : null,
          cursor: widget.onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: getBackgroundColor(),
                border: Border.all(
                  color: getBorderColor(),
                  width: widget.isSelected && widget.isAnswered ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.text,
                      style: themeService.getTextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.getOnBackgroundColor(context),
                      ),
                    ),
                  ),
                  if (widget.isAnswered)
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Icon(
                        widget.isCorrect ? Icons.check_circle : Icons.cancel,
                        color: widget.isCorrect ? Colors.green : Colors.red,
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