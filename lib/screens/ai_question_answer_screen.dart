import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../services/theme_service.dart';
import '../services/auth_service.dart';
import '../services/ai_service.dart';
import '../app_theme.dart';
import '../widgets/islamic_pattern_background.dart';

class AIQuestionAnswerScreen extends StatefulWidget {
  const AIQuestionAnswerScreen({super.key});

  @override
  State<AIQuestionAnswerScreen> createState() => _AIQuestionAnswerScreenState();
}

class _AIQuestionAnswerScreenState extends State<AIQuestionAnswerScreen>
    with TickerProviderStateMixin {
  late TextEditingController _questionController;
  late ScrollController _scrollController;
  late FocusNode _inputFocus;

  late AnimationController _fadeCtrl;
  late AnimationController _emptyPulseCtrl;

  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  bool _isLoggedIn = false;
  bool _cancelCurrentRequest = false;

  static const int _maxChars = 800;
  static const Color _gold = Color(0xFFD4AF37);

  @override
  void initState() {
    super.initState();
    _questionController = TextEditingController();
    _scrollController = ScrollController();
    _inputFocus = FocusNode();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    _emptyPulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _isLoggedIn = Provider.of<AuthService>(context, listen: false).isLoggedIn;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showDisclaimerDialog();
    });

    _loadChatHistory();
  }

  @override
  void dispose() {
    _questionController.dispose();
    _scrollController.dispose();
    _inputFocus.dispose();
    _fadeCtrl.dispose();
    _emptyPulseCtrl.dispose();
    super.dispose();
  }

  // ───────────────────────────── HISTORY ─────────────────────────────

  Future<void> _loadChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedChat = prefs.getString('ai_chat_history');
    if (savedChat == null) return;
    try {
      final List<dynamic> decoded = jsonDecode(savedChat);
      if (!mounted) return;
      setState(() {
        _messages.clear();
        for (var item in decoded) {
          _messages.add(ChatMessage(
            text: item['text'],
            isUser: item['isUser'],
            timestamp: DateTime.parse(item['timestamp']),
          ));
        }
      });
      Future.delayed(const Duration(milliseconds: 200), _scrollToBottom);
    } catch (e) {
      debugPrint('Error loading chat history: $e');
    }
  }

  Future<void> _saveChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> encoded = _messages
        .map((m) => {
              'text': m.text,
              'isUser': m.isUser,
              'timestamp': m.timestamp.toIso8601String(),
            })
        .toList();
    await prefs.setString('ai_chat_history', jsonEncode(encoded));
  }

  // ───────────────────────────── DISCLAIMER ─────────────────────────────

  void _showDisclaimerDialog() {
    if (!mounted) return;
    final lang = Localizations.localeOf(context).languageCode;
    final isArabic = lang == 'ar';
    final isFrench = lang == 'fr';
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final title = isArabic
        ? 'ملاحظة هامة قبل البدء'
        : (isFrench
            ? 'Note importante avant de commencer'
            : 'Important note before you begin');
    final subtitle = isArabic
        ? 'يرجى قراءة هذه النقاط بعناية'
        : (isFrench
            ? 'Veuillez lire attentivement ces points'
            : 'Please read these points carefully');
    final bullet1 = isArabic
        ? 'قد يحتوي رد الذكاء الاصطناعي على أخطاء أو معلومات غير مكتملة.'
        : (isFrench
            ? 'Les réponses de l\'IA peuvent contenir des erreurs ou des informations incomplètes.'
            : 'AI responses may contain errors or incomplete information.');
    final bullet2 = isArabic
        ? 'أنت مسؤول عن التحقق من المعلومات قبل الاعتماد عليها.'
        : (isFrench
            ? 'Vous êtes responsable de vérifier les informations avant de vous y fier.'
            : 'You are responsible for verifying information before relying on it.');
    final bullet3 = isArabic
        ? 'في الفتاوى والمسائل الدينية الدقيقة، يُرجى استشارة عالم إسلامي مؤهل.'
        : (isFrench
            ? 'Pour les fatwas et les questions religieuses sensibles, consultez un érudit islamique qualifié.'
            : 'For fatwas and sensitive religious matters, consult a qualified Islamic scholar.');
    final btnText = isArabic
        ? 'فهمت، تابع'
        : (isFrench ? 'Compris, continuer' : 'Understood, continue');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: _gold.withValues(alpha: 0.5),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: _gold.withValues(alpha: 0.18),
                blurRadius: 26,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.orange.withValues(alpha: 0.15),
                    ),
                    child: const Icon(Icons.warning_amber_rounded,
                        color: Colors.orange, size: 26),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: _gold,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: isDarkMode
                                ? Colors.grey[400]
                                : Colors.black54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _DisclaimerBullet(
                index: 1,
                text: bullet1,
                isArabic: isArabic,
                isDarkMode: isDarkMode,
              ),
              const SizedBox(height: 10),
              _DisclaimerBullet(
                index: 2,
                text: bullet2,
                isArabic: isArabic,
                isDarkMode: isDarkMode,
              ),
              const SizedBox(height: 10),
              _DisclaimerBullet(
                index: 3,
                text: bullet3,
                isArabic: isArabic,
                isDarkMode: isDarkMode,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _gold,
                    foregroundColor: isDarkMode
                        ? const Color(0xFF0B3D2E)
                        : Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(
                    btnText,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ───────────────────────────── SCROLL ─────────────────────────────

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  // ───────────────────────────── ACTIONS ─────────────────────────────

  void _stopResponse() {
    if (!_isLoading) return;
    final lang = Localizations.localeOf(context).languageCode;
    final isArabic = lang == 'ar';
    final isFrench = lang == 'fr';
    final stoppedText = isArabic
        ? '[تم إيقاف الرد]'
        : (isFrench ? '[Réponse arrêtée]' : '[Response stopped]');

    setState(() {
      _cancelCurrentRequest = true;
      _isLoading = false;
      _messages.add(ChatMessage(
        text: stoppedText,
        isUser: false,
        timestamp: DateTime.now(),
      ));
    });
    _saveChatHistory();
    _scrollToBottom();
  }

  Future<void> _sendQuestion() async {
    final question = _questionController.text.trim();
    if (question.isEmpty || _isLoading) return;

    setState(() {
      _cancelCurrentRequest = false;
      _messages.add(ChatMessage(
        text: question,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isLoading = true;
    });

    _saveChatHistory();
    _questionController.clear();
    _scrollToBottom();

    try {
      final aiService = AIService();
      final response = await aiService.getIslamicAnswer(
        question: question,
        context: context,
      );
      if (_cancelCurrentRequest) return;
      if (!mounted) return;
      setState(() {
        _messages.add(ChatMessage(
          text: response,
          isUser: false,
          timestamp: DateTime.now(),
        ));
        _isLoading = false;
      });
      _saveChatHistory();
      _scrollToBottom();
    } catch (e) {
      if (_cancelCurrentRequest) return;
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showErrorDialog(e.toString());
    } finally {
      _cancelCurrentRequest = false;
    }
  }

  Future<void> _redoResponse(String prompt) async {
    if (_isLoading) return;

    setState(() {
      _cancelCurrentRequest = false;
      _isLoading = true;
    });
    _scrollToBottom();

    try {
      final aiService = AIService();
      final response = await aiService.getIslamicAnswer(
        question: prompt,
        context: context,
      );
      if (_cancelCurrentRequest) return;
      if (!mounted) return;
      setState(() {
        _messages.add(ChatMessage(
          text: response,
          isUser: false,
          timestamp: DateTime.now(),
        ));
        _isLoading = false;
      });
      _saveChatHistory();
      _scrollToBottom();
    } catch (e) {
      if (_cancelCurrentRequest) return;
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showErrorDialog(e.toString());
    } finally {
      _cancelCurrentRequest = false;
    }
  }

  void _showErrorDialog(String error) {
    final lang = Localizations.localeOf(context).languageCode;
    final isArabic = lang == 'ar';
    final isFrench = lang == 'fr';
    final l10n = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: _gold.withValues(alpha: 0.4), width: 1.2),
        ),
        title: Row(
          children: [
            const Icon(Icons.error_outline_rounded,
                color: Colors.redAccent, size: 26),
            const SizedBox(width: 10),
            Text(
              isArabic ? 'خطأ' : (isFrench ? 'Erreur' : 'Error'),
              style: const TextStyle(color: _gold, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          error,
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[400]
                : Colors.black87,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              l10n.close,
              style: const TextStyle(
                  color: _gold, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _clearChat() {
    final lang = Localizations.localeOf(context).languageCode;
    final isArabic = lang == 'ar';
    final isFrench = lang == 'fr';
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: _gold.withValues(alpha: 0.4), width: 1.2),
        ),
        title: Text(
          isArabic
              ? 'مسح المحادثة'
              : (isFrench ? 'Effacer la conversation' : 'Clear Chat'),
          style: TextStyle(
              color: isDarkMode ? Colors.grey[200] : Colors.black87,
              fontWeight: FontWeight.bold),
        ),
        content: Text(
          isArabic
              ? 'سيتم حذف جميع الرسائل نهائياً. هل أنت متأكد؟'
              : (isFrench
                  ? 'Tous les messages seront définitivement supprimés. Êtes-vous sûr ?'
                  : 'All messages will be permanently deleted. Are you sure?'),
          style: TextStyle(
            color: isDarkMode ? Colors.grey[400] : Colors.black87,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              isArabic ? 'إلغاء' : (isFrench ? 'Annuler' : 'Cancel'),
              style: TextStyle(
                  color: isDarkMode ? Colors.grey[400] : Colors.black54),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() => _messages.clear());
              _saveChatHistory();
              Navigator.pop(ctx);
            },
            child: Text(
              isArabic ? 'مسح' : (isFrench ? 'Effacer' : 'Clear'),
              style: const TextStyle(
                  color: _gold, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(String text) {
    final lang = Localizations.localeOf(context).languageCode;
    final isArabic = lang == 'ar';
    final isFrench = lang == 'fr';
    Clipboard.setData(ClipboardData(text: text));
    final msg = isArabic
        ? 'تم النسخ إلى الحافظة'
        : (isFrench ? 'Copié dans le presse-papiers' : 'Copied to clipboard');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded,
                color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Text(msg),
          ],
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF0B3D2E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _useSuggestion(String s) {
    _questionController.text = s;
    _inputFocus.requestFocus();
  }

  // ───────────────────────────── BUILD ─────────────────────────────

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    final isArabic = lang == 'ar';
    final isFrench = lang == 'fr';
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final headerTitle = isArabic
        ? 'سؤال وجواب إسلامي'
        : (isFrench ? 'Q&R Islamique' : 'Islamic Q&A');
    final headerSubtitle = isArabic
        ? 'مساعدك الذكي للأسئلة الدينية'
        : (isFrench
            ? 'Votre assistant IA pour questions religieuses'
            : 'Your AI assistant for religious questions');
    final aiWarningText = isArabic
        ? 'الذكاء الاصطناعي قد يخطئ. تحقق من المعلومات الهامة.'
        : (isFrench
            ? 'L\'IA peut faire des erreurs. Vérifiez les informations importantes.'
            : 'AI can make mistakes. Verify important information.');

    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        return FadeTransition(
          opacity: _fadeCtrl,
          child: Scaffold(
            appBar: _buildAppBar(
              context,
              isArabic,
              isFrench,
              isDarkMode,
              headerTitle,
              headerSubtitle,
            ),
            body: IslamicPatternBackground(
              child: Column(
                children: [
                  Expanded(
                    child: _messages.isEmpty
                        ? _buildEmptyState(isArabic, isFrench, isDarkMode)
                        : ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                            itemCount: _messages.length + (_isLoading ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == _messages.length) {
                                return _buildLoadingMessage(
                                    isArabic, isFrench, isDarkMode);
                              }
                              return _buildMessageBubble(
                                _messages[index],
                                index,
                                isArabic,
                                isFrench,
                                isDarkMode,
                              );
                            },
                          ),
                  ),
                  _buildInputArea(
                    context,
                    isArabic,
                    isFrench,
                    isDarkMode,
                    aiWarningText,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ───────────────────────────── APP BAR ─────────────────────────────

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    bool isArabic,
    bool isFrench,
    bool isDarkMode,
    String title,
    String subtitle,
  ) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      centerTitle: true,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: Theme.of(context)
              .scaffoldBackgroundColor
              .withValues(alpha: 0.85),
          border: Border(
            bottom: BorderSide(
              color: _gold.withValues(alpha: 0.25),
              width: 1,
            ),
          ),
        ),
      ),
      leadingWidth: 64,
      leading: Center(
        child: _HeaderIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          tooltip: isArabic ? 'رجوع' : 'Back',
          onTap: () => Navigator.pop(context),
        ),
      ),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [_gold, Color(0xFFE6C200)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _gold.withValues(alpha: 0.4),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: const Icon(Icons.auto_awesome_rounded,
                    color: Colors.white, size: 15),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: _gold,
                      fontWeight: FontWeight.w700,
                      fontSize: 19,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 1),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isDarkMode ? Colors.grey[500] : Colors.black54,
                  fontSize: 11,
                  letterSpacing: 0.3,
                ),
          ),
        ],
      ),
      actions: [
        if (_messages.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _HeaderIconButton(
              icon: Icons.delete_sweep_outlined,
              tooltip: isArabic
                  ? 'مسح المحادثة'
                  : (isFrench ? 'Effacer' : 'Clear chat'),
              onTap: _clearChat,
            ),
          ),
      ],
    );
  }

  // ───────────────────────────── EMPTY STATE ─────────────────────────────

  Widget _buildEmptyState(bool isArabic, bool isFrench, bool isDarkMode) {
    final title = isArabic
        ? 'ابدأ محادثتك مع المساعد'
        : (isFrench
            ? 'Commencez votre conversation'
            : 'Start Your Conversation');
    final desc = isArabic
        ? 'اطرح أي سؤال ديني أو فقهي أو شخصي متعلق بالإسلام، واحصل على ردود فورية مبسّطة من الذكاء الاصطناعي.'
        : (isFrench
            ? 'Posez n\'importe quelle question religieuse, juridique ou personnelle liée à l\'Islam et obtenez des réponses instantanées.'
            : 'Ask any religious, jurisprudential, or personal question related to Islam and get instant answers from AI.');

    final suggestions = isArabic
        ? [
            'ما هي أركان الإسلام الخمسة؟',
            'كيف أصلي صلاة الوتر؟',
            'ما فضل قراءة سورة الكهف يوم الجمعة؟',
            'كيف أتوب توبة نصوحة؟',
          ]
        : isFrench
            ? [
                'Quels sont les cinq piliers de l\'Islam ?',
                'Comment prier la salat al-witr ?',
                'Quel est le mérite de sourate Al-Kahf le vendredi ?',
                'Comment faire une repentance sincère ?',
              ]
            : [
                'What are the five pillars of Islam?',
                'How do I pray Witr salah?',
                'What is the virtue of Surat Al-Kahf on Friday?',
                'How do I make a sincere repentance?',
              ];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _emptyPulseCtrl,
            builder: (context, child) {
              final scale = 1.0 + (_emptyPulseCtrl.value * 0.06);
              return Transform.scale(scale: scale, child: child);
            },
            child: Container(
              padding: const EdgeInsets.all(26),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _gold.withValues(alpha: 0.22),
                    _gold.withValues(alpha: 0.05),
                  ],
                ),
                border: Border.all(
                  color: _gold.withValues(alpha: 0.4),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _gold.withValues(alpha: 0.22),
                    blurRadius: 24,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.question_answer_rounded,
                color: _gold,
                size: 52,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: _gold,
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDarkMode ? Colors.grey[400] : Colors.black54,
              fontSize: 14,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: _gold.withValues(alpha: 0.3),
                  thickness: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  isArabic
                      ? 'أسئلة مقترحة'
                      : (isFrench ? 'Suggestions' : 'Try asking'),
                  style: TextStyle(
                    color: _gold.withValues(alpha: 0.9),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: _gold.withValues(alpha: 0.3),
                  thickness: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...suggestions.map(
            (s) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _SuggestionChip(
                text: s,
                isArabic: isArabic,
                isDarkMode: isDarkMode,
                onTap: () => _useSuggestion(s),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────────────────── INPUT AREA ─────────────────────────────

  Widget _buildInputArea(
    BuildContext context,
    bool isArabic,
    bool isFrench,
    bool isDarkMode,
    String aiWarningText,
  ) {
    final charCount = _questionController.text.characters.length;
    final overLimit = charCount > _maxChars;

    return Container(
      padding: EdgeInsets.fromLTRB(
          16, 12, 16, 12 + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color:
            Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.9),
        border: Border(
          top: BorderSide(
            color: _gold.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: _inputFocus.hasFocus
                          ? _gold.withValues(alpha: 0.8)
                          : _gold.withValues(alpha: 0.35),
                      width: _inputFocus.hasFocus ? 1.8 : 1.4,
                    ),
                    color: Theme.of(context)
                        .scaffoldBackgroundColor
                        .withValues(alpha: 0.6),
                    boxShadow: _inputFocus.hasFocus
                        ? [
                            BoxShadow(
                              color: _gold.withValues(alpha: 0.15),
                              blurRadius: 12,
                              spreadRadius: 1,
                            ),
                          ]
                        : [],
                  ),
                  child: TextField(
                    controller: _questionController,
                    focusNode: _inputFocus,
                    maxLines: null,
                    minLines: 1,
                    maxLength: _maxChars,
                    enabled: !_isLoading,
                    textDirection:
                        isArabic ? TextDirection.rtl : TextDirection.ltr,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) {
                      if (!_isLoading) _sendQuestion();
                    },
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: isArabic
                          ? 'اكتب سؤالك هنا...'
                          : (isFrench
                              ? 'Écrivez votre question ici...'
                              : 'Type your question here...'),
                      hintStyle: TextStyle(
                        color:
                            isDarkMode ? Colors.grey[600] : Colors.black45,
                        fontSize: 15,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                    ),
                    style: TextStyle(
                      color:
                          isDarkMode ? Colors.grey[100] : Colors.black87,
                      fontSize: 15.5,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              _buildSendButton(isArabic, isFrench, isDarkMode),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 12,
                      color: isDarkMode
                          ? Colors.grey[500]
                          : Colors.grey[600],
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        aiWarningText,
                        style: TextStyle(
                          fontSize: 11,
                          color: isDarkMode
                              ? Colors.grey[500]
                              : Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              if (charCount > 0)
                Text(
                  '$charCount / $_maxChars',
                  style: TextStyle(
                    fontSize: 11,
                    color: overLimit
                        ? Colors.redAccent
                        : (isDarkMode
                            ? Colors.grey[500]
                            : Colors.grey[600]),
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSendButton(bool isArabic, bool isFrench, bool isDarkMode) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _isLoading
              ? [Colors.redAccent, Colors.redAccent.withValues(alpha: 0.8)]
              : [_gold, const Color(0xFFE6C200)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: (_isLoading ? Colors.redAccent : _gold)
                .withValues(alpha: 0.35),
            blurRadius: 14,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isLoading ? _stopResponse : _sendQuestion,
          borderRadius: BorderRadius.circular(28),
          child: Padding(
            padding: const EdgeInsets.all(13),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              transitionBuilder: (child, animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: _isLoading
                  ? const Stack(
                      key: ValueKey('stop'),
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        Icon(Icons.stop_rounded,
                            color: Colors.white, size: 13),
                      ],
                    )
                  : const Icon(
                      Icons.send_rounded,
                      key: ValueKey('send'),
                      color: Colors.black87,
                      size: 22,
                    ),
            ),
          ),
        ),
      ),
    );
  }

  // ───────────────────────────── MESSAGE ─────────────────────────────

  /// Detects the primary text direction based on the first strong
  /// directional character found in the text.
  TextDirection _detectTextDirection(String text) {
    final rtl = RegExp(
      r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]',
    );
    final ltr = RegExp(r'[A-Za-z]');
    for (final rune in text.runes) {
      final ch = String.fromCharCode(rune);
      if (rtl.hasMatch(ch)) return TextDirection.rtl;
      if (ltr.hasMatch(ch)) return TextDirection.ltr;
    }
    return TextDirection.ltr;
  }

  Widget _buildFormattedMarkdownText(String text, TextStyle baseStyle) {
    final spans = <InlineSpan>[];
    final regex = RegExp(r'\*\*(.*?)\*\*');
    int currentIndex = 0;

    for (final match in regex.allMatches(text)) {
      if (match.start > currentIndex) {
        spans.add(TextSpan(
          text: text.substring(currentIndex, match.start),
          style: baseStyle,
        ));
      }
      spans.add(TextSpan(
        text: match.group(1),
        style: baseStyle.copyWith(fontWeight: FontWeight.bold),
      ));
      currentIndex = match.end;
    }

    if (currentIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(currentIndex),
        style: baseStyle,
      ));
    }

    return RichText(text: TextSpan(children: spans));
  }

  Widget _buildMessageBubble(
    ChatMessage message,
    int index,
    bool isArabic,
    bool isFrench,
    bool isDarkMode,
  ) {
    final bool isUserMessage = message.isUser;
    final bool isSystemMessage =
        !message.isUser && message.text.startsWith('[');

    // Physical side rules:
    //   Arabic (RTL app)   → user on RIGHT, AI on LEFT
    //   English / French   → user on LEFT,  AI on RIGHT
    final bool userOnRight = isArabic;
    final bool thisMessageOnRight =
        (isUserMessage && userOnRight) || (!isUserMessage && !userOnRight);

    // Direction of the *content* inside the bubble (auto-detected)
    final TextDirection contentDirection = _detectTextDirection(message.text);

    final textStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: isUserMessage
              ? Colors.black87
              : (isSystemMessage
                  ? Colors.orange
                  : (isDarkMode ? Colors.grey[100] : Colors.black87)),
          height: 1.55,
          fontSize: isSystemMessage ? 13 : 15,
          fontStyle: isSystemMessage ? FontStyle.italic : FontStyle.normal,
        ) ??
        const TextStyle();

    final copyLabel = isArabic ? 'نسخ' : (isFrench ? 'Copier' : 'Copy');
    final editLabel = isArabic ? 'تعديل' : (isFrench ? 'Éditer' : 'Edit');
    final redoLabel = isArabic ? 'إعادة' : (isFrench ? 'Refaire' : 'Redo');

    final Widget avatar = _MessageAvatar(
      isUser: isUserMessage,
      isSystem: isSystemMessage,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          final fromX = thisMessageOnRight ? 30.0 : -30.0;
          return Transform.translate(
            offset: Offset(fromX * (1 - value), 0),
            child: Opacity(opacity: value, child: child),
          );
        },
        child: Row(
          // Force LTR so main-axis start = LEFT and end = RIGHT, always.
          textDirection: TextDirection.ltr,
          mainAxisAlignment: thisMessageOnRight
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!thisMessageOnRight) ...[
              avatar,
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.78,
                ),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
                decoration: BoxDecoration(
                  gradient: isUserMessage
                      ? const LinearGradient(
                          colors: [_gold, Color(0xFFE6C200)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : LinearGradient(
                          colors: [
                            Theme.of(context)
                                .scaffoldBackgroundColor
                                .withValues(alpha: 0.9),
                            Theme.of(context)
                                .scaffoldBackgroundColor
                                .withValues(alpha: 0.65),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                    bottomLeft: Radius.circular(thisMessageOnRight ? 20 : 4),
                    bottomRight: Radius.circular(thisMessageOnRight ? 4 : 20),
                  ),
                  border: !isUserMessage
                      ? Border.all(
                          color: isSystemMessage
                              ? Colors.orange.withValues(alpha: 0.5)
                              : _gold.withValues(alpha: 0.3),
                          width: 1.2,
                        )
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: (isUserMessage ? _gold : Colors.black)
                          .withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                // Direction for the bubble's inner content
                child: Directionality(
                  textDirection: contentDirection,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFormattedMarkdownText(message.text, textStyle),
                      const SizedBox(height: 8),
                      // Meta row is always LTR — icon + timestamp + buttons
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.schedule_rounded,
                              size: 11,
                              color: isUserMessage
                                  ? Colors.black54
                                  : (isDarkMode
                                      ? Colors.grey[600]
                                      : Colors.black45),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatRelativeTime(
                                message.timestamp,
                                isArabic: isArabic,
                                isFrench: isFrench,
                              ),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: isUserMessage
                                        ? Colors.black54
                                        : (isDarkMode
                                            ? Colors.grey[600]
                                            : Colors.black45),
                                    fontSize: 11,
                                  ),
                            ),
                            if (isUserMessage) ...[
                              const SizedBox(width: 10),
                              _MiniPillButton(
                                icon: Icons.edit_rounded,
                                label: editLabel,
                                onTap: () {
                                  _questionController.text = message.text;
                                  _inputFocus.requestFocus();
                                },
                                darkForeground: false,
                              ),
                              const SizedBox(width: 6),
                              _MiniPillButton(
                                icon: Icons.copy_rounded,
                                label: copyLabel,
                                onTap: () => _copyToClipboard(message.text),
                                darkForeground: false,
                              ),
                            ] else if (!isSystemMessage) ...[
                              const SizedBox(width: 10),
                              _MiniPillButton(
                                icon: Icons.refresh_rounded,
                                label: redoLabel,
                                onTap: () {
                                  if (index > 0 &&
                                      _messages[index - 1].isUser) {
                                    _redoResponse(_messages[index - 1].text);
                                  }
                                },
                                darkForeground: isDarkMode,
                              ),
                              const SizedBox(width: 6),
                              _MiniPillButton(
                                icon: Icons.copy_rounded,
                                label: copyLabel,
                                onTap: () => _copyToClipboard(message.text),
                                darkForeground: isDarkMode,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (thisMessageOnRight) ...[
              const SizedBox(width: 8),
              avatar,
            ],
          ],
        ),
      ),
    );
  }

  // ───────────────────────────── TYPING ─────────────────────────────

  Widget _buildLoadingMessage(
      bool isArabic, bool isFrench, bool isDarkMode) {
    final label = isArabic
        ? 'الذكاء الاصطناعي يفكر'
        : (isFrench ? 'L\'IA réfléchit' : 'AI is thinking');

    // Loading bubble is always AI, so it sits on the opposite side of the user.
    final bool aiOnRight = !isArabic; // Arabic → AI left; EN/FR → AI right

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        textDirection: TextDirection.ltr, // physical layout, always LTR
        mainAxisAlignment:
            aiOnRight ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!aiOnRight) ...[
            const _MessageAvatar(isUser: false, isSystem: false),
            const SizedBox(width: 8),
          ],
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context)
                      .scaffoldBackgroundColor
                      .withValues(alpha: 0.9),
                  Theme.of(context)
                      .scaffoldBackgroundColor
                      .withValues(alpha: 0.65),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomLeft: Radius.circular(aiOnRight ? 20 : 4),
                bottomRight: Radius.circular(aiOnRight ? 4 : 20),
              ),
              border: Border.all(
                color: _gold.withValues(alpha: 0.3),
                width: 1.2,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const _BouncingDots(color: _gold),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color:
                            isDarkMode ? Colors.grey[400] : Colors.black54,
                        fontSize: 14,
                      ),
                ),
              ],
            ),
          ),
          if (aiOnRight) ...[
            const SizedBox(width: 8),
            const _MessageAvatar(isUser: false, isSystem: false),
          ],
        ],
      ),
    );
  }

  // ───────────────────────────── TIME HELPERS ─────────────────────────────

  String _formatRelativeTime(DateTime dt,
      {required bool isArabic, required bool isFrench}) {
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 45) {
      return isArabic
          ? 'الآن'
          : (isFrench ? 'À l\'instant' : 'Just now');
    }
    if (diff.inMinutes < 60) {
      return isArabic
          ? 'منذ ${diff.inMinutes} د'
          : (isFrench
              ? 'il y a ${diff.inMinutes}m'
              : '${diff.inMinutes}m ago');
    }
    if (diff.inHours < 24) {
      return isArabic
          ? 'منذ ${diff.inHours} س'
          : (isFrench
              ? 'il y a ${diff.inHours}h'
              : '${diff.inHours}h ago');
    }
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }
}

// ───────────────────────────── CHAT MESSAGE MODEL ─────────────────────────────

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

// ───────────────────────────── SHARED WIDGETS ─────────────────────────────

class _HeaderIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;

  const _HeaderIconButton({
    required this.icon,
    required this.onTap,
    this.tooltip,
  });

  @override
  State<_HeaderIconButton> createState() => _HeaderIconButtonState();
}

class _HeaderIconButtonState extends State<_HeaderIconButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final button = MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: _hover
                ? const Color(0xFFD4AF37).withValues(alpha: 0.2)
                : (isDark
                    ? const Color(0xFF144D32).withValues(alpha: 0.55)
                    : const Color(0xFFE8F3EE).withValues(alpha: 0.75)),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFD4AF37)
                  .withValues(alpha: _hover ? 0.6 : 0.3),
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
    if (widget.tooltip != null) {
      return Tooltip(message: widget.tooltip!, child: button);
    }
    return button;
  }
}

class _DisclaimerBullet extends StatelessWidget {
  final int index;
  final String text;
  final bool isArabic;
  final bool isDarkMode;

  const _DisclaimerBullet({
    required this.index,
    required this.text,
    required this.isArabic,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFFD4AF37), Color(0xFFE6C200)],
            ),
          ),
          child: Text(
            '$index',
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: isDarkMode ? Colors.grey[300] : Colors.black87,
              height: 1.55,
              fontSize: 13.5,
            ),
            textAlign: isArabic ? TextAlign.right : TextAlign.left,
          ),
        ),
      ],
    );
  }
}

class _SuggestionChip extends StatefulWidget {
  final String text;
  final bool isArabic;
  final bool isDarkMode;
  final VoidCallback onTap;

  const _SuggestionChip({
    required this.text,
    required this.isArabic,
    required this.isDarkMode,
    required this.onTap,
  });

  @override
  State<_SuggestionChip> createState() => _SuggestionChipState();
}

class _SuggestionChipState extends State<_SuggestionChip> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFD4AF37);
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: _hover
                ? gold.withValues(alpha: 0.14)
                : (widget.isDarkMode
                    ? const Color(0xFF144D32).withValues(alpha: 0.35)
                    : Colors.white.withValues(alpha: 0.65)),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: gold.withValues(alpha: _hover ? 0.65 : 0.28),
              width: _hover ? 1.6 : 1.2,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: gold.withValues(alpha: 0.18),
                ),
                child: Icon(Icons.lightbulb_outline_rounded,
                    color: gold, size: 16),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.text,
                  textAlign:
                      widget.isArabic ? TextAlign.right : TextAlign.left,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: widget.isDarkMode
                        ? Colors.grey[200]
                        : Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                widget.isArabic
                    ? Icons.arrow_back_rounded
                    : Icons.arrow_forward_rounded,
                color: gold.withValues(alpha: 0.7),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MessageAvatar extends StatelessWidget {
  final bool isUser;
  final bool isSystem;

  const _MessageAvatar({required this.isUser, required this.isSystem});

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFD4AF37);
    if (isUser) {
      return Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [gold, const Color(0xFFE6C200)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: gold.withValues(alpha: 0.35),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: const Icon(Icons.person_rounded,
            color: Colors.black87, size: 18),
      );
    }
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            gold.withValues(alpha: 0.28),
            gold.withValues(alpha: 0.08),
          ],
        ),
        border: Border.all(
          color: gold.withValues(alpha: 0.5),
          width: 1.4,
        ),
        boxShadow: [
          BoxShadow(
            color: gold.withValues(alpha: 0.22),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Icon(
        isSystem ? Icons.info_outline_rounded : Icons.auto_awesome_rounded,
        color: gold,
        size: 17,
      ),
    );
  }
}

class _MiniPillButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool darkForeground;

  const _MiniPillButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.darkForeground,
  });

  @override
  State<_MiniPillButton> createState() => _MiniPillButtonState();
}

class _MiniPillButtonState extends State<_MiniPillButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final base = widget.darkForeground
        ? Colors.grey[400] ?? Colors.white70
        : Colors.black87;
    final bg = widget.darkForeground
        ? Colors.white.withValues(alpha: 0.06)
        : Colors.black.withValues(alpha: 0.06);
    final hoverBg = widget.darkForeground
        ? Colors.white.withValues(alpha: 0.14)
        : Colors.black.withValues(alpha: 0.14);

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _hover ? hoverBg : bg,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 12, color: base),
              const SizedBox(width: 4),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: base,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BouncingDots extends StatefulWidget {
  final Color color;
  const _BouncingDots({required this.color});

  @override
  State<_BouncingDots> createState() => _BouncingDotsState();
}

class _BouncingDotsState extends State<_BouncingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  double _dotOffset(int i) {
    final phase = (_ctrl.value + i * 0.22) % 1.0;
    return (phase < 0.5 ? phase : 1 - phase) * -3.5;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            return Padding(
              padding: EdgeInsets.only(right: i == 2 ? 0 : 4),
              child: Transform.translate(
                offset: Offset(0, _dotOffset(i)),
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}