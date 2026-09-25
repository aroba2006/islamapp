import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../services/theme_service.dart';
import '../services/auth_service.dart';
import '../services/ai_service.dart';

class AIQuestionAnswerScreen extends StatefulWidget {
  const AIQuestionAnswerScreen({super.key});

  @override
  State<AIQuestionAnswerScreen> createState() => _AIQuestionAnswerScreenState();
}

class _AIQuestionAnswerScreenState extends State<AIQuestionAnswerScreen> with TickerProviderStateMixin {
  late TextEditingController _questionController;
  late ScrollController _scrollController;
  late AnimationController _fadeCtrl;

  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  bool _isLoggedIn = false;
  bool _cancelCurrentRequest = false;

  @override
  void initState() {
    super.initState();
    _questionController = TextEditingController();
    _scrollController = ScrollController();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

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
    _fadeCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedChat = prefs.getString('ai_chat_history');
    if (savedChat != null) {
      try {
        final List<dynamic> decoded = jsonDecode(savedChat);
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
        Future.delayed(const Duration(milliseconds: 200), () {
          _scrollToBottom();
        });
      } catch (e) {
        debugPrint('Error loading chat history: $e');
      }
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

      if (mounted) {
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
      }
    } catch (e) {
      if (_cancelCurrentRequest) return;
      if (mounted) {
        setState(() => _isLoading = false);
        _showErrorDialog(e.toString());
      }
    }
  }

  Future<void> _saveChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> encoded = _messages.map((m) => {
      'text': m.text,
      'isUser': m.isUser,
      'timestamp': m.timestamp.toIso8601String(),
    }).toList();
    await prefs.setString('ai_chat_history', jsonEncode(encoded));
  }

  void _showDisclaimerDialog() {
    final lang = Localizations.localeOf(context).languageCode;
    final isArabic = lang == 'ar';
    final isFrench = lang == 'fr';
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final title = isArabic ? 'ملاحظة هامة' : (isFrench ? 'Note Importante' : 'Important Note');
    final message = isArabic
        ? 'هذا مساعد ذكاء اصطناعي ولا يُضمن أن تكون إجاباته صحيحة بنسبة 100٪. قد يخطئ الذكاء الاصطناعي، وأنت مسؤول عن التحقق من المعلومات.\n\nفي الفتاوى والمسائل الدينية الدقيقة، يُرجى استشارة عالم إسلامي أو شيخ مؤهل.'
        : (isFrench
            ? 'Ceci est un assistant IA et ses réponses ne sont pas garanties à 100 % correctes. L\'IA peut faire des erreurs et vous êtes responsable de la vérification des informations.\n\nPour les questions religieuses importantes ou les fatwas, veuillez consulter un érudit islamique qualifié ou un Cheikh.'
            : 'This is an AI assistant and its responses are not guaranteed to be 100% correct. AI can make mistakes, and you are responsible for verifying the information.\n\nFor critical religious matters or fatwas, please consult a qualified Islamic scholar or Sheikh.');
    final btnText = isArabic ? 'مفهوم' : (isFrench ? 'Compris' : 'Understood');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: const Color(0xFFD4AF37).withValues(alpha: 0.5), width: 1.5),
        ),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Color(0xFFD4AF37),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: TextStyle(
            color: isDarkMode ? Colors.grey[300] : Colors.black87,
            height: 1.6,
            fontSize: 15,
          ),
          textAlign: isArabic ? TextAlign.right : TextAlign.left,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4AF37),
                foregroundColor: isDarkMode ? const Color(0xFF0B3D2E) : Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                btnText,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _stopResponse() {
    if (!_isLoading) return;
    
    final lang = Localizations.localeOf(context).languageCode;
    final isArabic = lang == 'ar';
    final isFrench = lang == 'fr';
    final stoppedText = isArabic ? '[تم إيقاف الرد]' : (isFrench ? '[Réponse arrêtée]' : '[Response stopped]');

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

      if (mounted) {
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
      }
    } catch (e) {
      if (_cancelCurrentRequest) return;
      if (mounted) {
        setState(() => _isLoading = false);
        _showErrorDialog(e.toString());
      }
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
        title: Text(
          isArabic ? 'خطأ' : (isFrench ? 'Erreur' : 'Error'),
          style: const TextStyle(color: Color(0xFFD4AF37)),
        ),
        content: Text(
          error,
          style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[400] : Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              l10n.close,
              style: const TextStyle(color: Color(0xFFD4AF37)),
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
        title: Text(
          isArabic ? 'مسح المحادثة' : (isFrench ? 'Effacer la conversation' : 'Clear Chat'),
          style: TextStyle(color: isDarkMode ? Colors.grey[300] : Colors.black87),
        ),
        content: Text(
          isArabic
              ? 'هل أنت متأكد من رغبتك في مسح جميع الرسائل؟'
              : (isFrench
                  ? 'Êtes-vous sûr de vouloir effacer tous les messages ?'
                  : 'Are you sure you want to clear all messages?'),
          style: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              isArabic ? 'إلغاء' : (isFrench ? 'Annuler' : 'Cancel'),
              style: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.black54),
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
              style: const TextStyle(color: Color(0xFFD4AF37)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    final isArabic = lang == 'ar';
    final isFrench = lang == 'fr';
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final headerTitle = isArabic ? 'سؤال وجواب إسلامي' : (isFrench ? 'Q&R Islamique' : 'Islamic Q&A');
    final headerSubtitle = isArabic ? 'اسأل أسئلة متعلقة بالإسلام' : (isFrench ? 'Posez des questions sur l\'Islam' : 'Ask questions related to Islam');
    final aiWarningText = isArabic
        ? 'الذكاء الاصطناعي قد يخطئ. يرجى التحقق من المعلومات الهامة.'
        : (isFrench 
            ? 'L\'IA peut faire des erreurs. Vérifiez les informations importantes.' 
            : 'AI can make mistakes. Verify important information.');

    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        return FadeTransition(
          opacity: _fadeCtrl,
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              centerTitle: true,
              title: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    headerTitle,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: const Color(0xFFD4AF37),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    headerSubtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isDarkMode ? Colors.grey[500] : Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFFD4AF37)),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                if (_messages.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.delete_rounded, color: Color(0xFFD4AF37)),
                    onPressed: _clearChat,
                    tooltip: isArabic ? 'مسح المحادثة' : (isFrench ? 'Effacer' : 'Clear chat'),
                  ),
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: _messages.isEmpty
                      ? _buildEmptyState(isArabic, isFrench, isDarkMode)
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          itemCount: _messages.length + (_isLoading ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == _messages.length) {
                              return _buildLoadingMessage(isArabic, isFrench, isDarkMode);
                            }
                            return _buildMessageBubble(_messages[index], index, isArabic, isFrench, isDarkMode);
                          },
                        ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + MediaQuery.of(context).padding.bottom),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: const Color(0xFFD4AF37).withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
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
                                  color: const Color(0xFFD4AF37).withValues(alpha: 0.4),
                                  width: 1.5,
                                ),
                                color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.5),
                              ),
                              child: TextField(
                                controller: _questionController,
                                maxLines: null,
                                minLines: 1,
                                enabled: !_isLoading,
                                textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                                decoration: InputDecoration(
                                  hintText: isArabic
                                      ? 'اسأل سؤالاً دينياً أو شخصياً...'
                                      : (isFrench
                                          ? 'Posez une question religieuse ou personnelle...'
                                          : 'Ask a religious or personal question...'),
                                  hintStyle: TextStyle(color: isDarkMode ? Colors.grey[600] : Colors.black54),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                ),
                                style: TextStyle(
                                  color: isDarkMode ? Colors.grey[100] : Colors.black87,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFFD4AF37), Color(0xFFE6C200)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: _isLoading ? _stopResponse : _sendQuestion,
                                borderRadius: BorderRadius.circular(28),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: _isLoading
                                      ? Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2.5,
                                                valueColor: AlwaysStoppedAnimation<Color>(
                                                  Theme.of(context).scaffoldBackgroundColor,
                                                ),
                                              ),
                                            ),
                                            Icon(
                                              Icons.stop_rounded, 
                                              color: Theme.of(context).scaffoldBackgroundColor, 
                                              size: 14
                                            ),
                                          ],
                                        )
                                      : const Icon(Icons.send_rounded, color: Colors.black87, size: 22),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        aiWarningText,
                        style: TextStyle(
                          fontSize: 11,
                          color: isDarkMode ? Colors.grey[500] : Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(bool isArabic, bool isFrench, bool isDarkMode) {
    final title = isArabic ? 'ابدأ محادثتك' : (isFrench ? 'Commencez votre conversation' : 'Start Your Conversation');
    final desc = isArabic
        ? 'اسأل أي سؤال ديني أو شخصي متعلق بالإسلام والحصول على إجابات فورية'
        : (isFrench
            ? 'Posez toute question religieuse ou personnelle liée à l\'Islam et obtenez des réponses instantanées'
            : 'Ask any religious or personal question related to Islam and get instant answers');

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFD4AF37).withValues(alpha: 0.15),
                    const Color(0xFFD4AF37).withValues(alpha: 0.05),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.question_answer_rounded,
                color: Color(0xFFD4AF37),
                size: 48,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: const Color(0xFFD4AF37),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              desc,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDarkMode ? Colors.grey[400] : Colors.black54,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // NEW: Helper method to parse markdown `**bold**` into real bold RichText
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

    return RichText(
      text: TextSpan(children: spans),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, int index, bool isArabic, bool isFrench, bool isDarkMode) {
    final bool isAlignedRight = isArabic ? message.isUser : !message.isUser;
    final bool isSystemMessage = !message.isUser && message.text.startsWith('[');

    final textStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: message.isUser 
          ? Colors.black87 
          : (isSystemMessage 
              ? Colors.orange 
              : (isDarkMode ? Colors.grey[100] : Colors.black87)),
      height: 1.5,
      fontSize: isSystemMessage ? 13 : 15,
      fontStyle: isSystemMessage ? FontStyle.italic : FontStyle.normal,
    ) ?? const TextStyle();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset((isAlignedRight ? 30 : -30) * (1 - value), 0),
            child: Opacity(opacity: value, child: child),
          );
        },
        child: Align(
          alignment: isAlignedRight ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.8,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: message.isUser
                  ? const LinearGradient(
                      colors: [Color(0xFFD4AF37), Color(0xFFE6C200)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : LinearGradient(
                      colors: [
                        Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.8),
                        Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.6),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomLeft: Radius.circular(isAlignedRight ? 20 : 4),
                bottomRight: Radius.circular(isAlignedRight ? 4 : 20),
              ),
              border: !message.isUser
                  ? Border.all(
                      color: isSystemMessage 
                          ? Colors.orange.withValues(alpha: 0.5) 
                          : const Color(0xFFD4AF37).withValues(alpha: 0.3),
                      width: 1.2,
                    )
                  : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Render true bold text instead of raw asterisks
                _buildFormattedMarkdownText(message.text, textStyle),
                const SizedBox(height: 6),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatTime(message.timestamp),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: message.isUser 
                            ? Colors.black54 
                            : (isDarkMode ? Colors.grey[600] : Colors.black54),
                        fontSize: 11,
                      ),
                    ),
                    
                    // --- USER MESSAGE ACTIONS (Edit & Copy) ---
                    if (message.isUser) ...[
                      const SizedBox(width: 12),
                      InkWell(
                        onTap: () {
                          // Populates the text field with the previous prompt
                          _questionController.text = message.text;
                        },
                        child: const Icon(Icons.edit_rounded, size: 14, color: Colors.black54),
                      ),
                      const SizedBox(width: 12),
                      InkWell(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: message.text));
                          final copiedText = isArabic ? 'تم النسخ إلى الحافظة' : (isFrench ? 'Copié dans le presse-papiers' : 'Copied to clipboard');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(copiedText), duration: const Duration(seconds: 2), backgroundColor: const Color(0xFF0B3D2E)),
                          );
                        },
                        child: const Icon(Icons.copy_rounded, size: 14, color: Colors.black54),
                      ),
                    ],

                    // --- AI MESSAGE ACTIONS (Redo & Copy) ---
                    if (!message.isUser && !isSystemMessage) ...[
                      const SizedBox(width: 12),
                      InkWell(
                        onTap: () {
                          // Finds the immediately preceding user message to resubmit
                          if (index > 0 && _messages[index - 1].isUser) {
                            _redoResponse(_messages[index - 1].text);
                          }
                        },
                        child: Icon(Icons.refresh_rounded, size: 14, color: isDarkMode ? Colors.grey[400] : Colors.black54),
                      ),
                      const SizedBox(width: 12),
                      InkWell(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: message.text));
                          final copiedText = isArabic ? 'تم النسخ إلى الحافظة' : (isFrench ? 'Copié dans le presse-papiers' : 'Copied to clipboard');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(copiedText),
                              duration: const Duration(seconds: 2),
                              backgroundColor: const Color(0xFF0B3D2E),
                            ),
                          );
                        },
                        child: Icon(
                          Icons.copy_rounded,
                          size: 14,
                          color: isDarkMode ? Colors.grey[400] : Colors.black54,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingMessage(bool isArabic, bool isFrench, bool isDarkMode) {
    final bool isAlignedRight = !isArabic;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Align(
        alignment: isAlignedRight ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.8),
                Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.6),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20),
              topRight: const Radius.circular(20),
              bottomLeft: Radius.circular(isAlignedRight ? 20 : 4),
              bottomRight: Radius.circular(isAlignedRight ? 4 : 20),
            ),
            border: Border.all(
              color: const Color(0xFFD4AF37).withValues(alpha: 0.3),
              width: 1.2,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD4AF37)),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                isArabic ? 'الذكاء الاصطناعي يفكر...' : (isFrench ? 'L\'IA réfléchit...' : 'AI is thinking...'),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDarkMode ? Colors.grey[400] : Colors.black54,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

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