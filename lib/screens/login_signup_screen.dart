import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  bool _isLogin = true;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _rememberMe = true;

  final _loginEmailCtrl = TextEditingController();
  final _loginPasswordCtrl = TextEditingController();

  final _signupEmailCtrl = TextEditingController();
  final _signupUsernameCtrl = TextEditingController();
  final _signupPasswordCtrl = TextEditingController();
  final _signupConfirmPasswordCtrl = TextEditingController();
  DateTime? _selectedBirthday;
  String? _selectedGender;

  late AnimationController _entranceCtrl;
  late FocusNode _loginEmailFocus;
  late FocusNode _loginPasswordFocus;

  static const Color _gold = Color(0xFFD4AF37);
  static const Color _deepGreen = Color(0xFF1B5E3F);

  @override
  void initState() {
    super.initState();
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
    _loginEmailFocus = FocusNode();
    _loginPasswordFocus = FocusNode();
    _signupPasswordCtrl.addListener(_onPasswordChanged);
  }

  @override
  void dispose() {
    _loginEmailCtrl.dispose();
    _loginPasswordCtrl.dispose();
    _signupEmailCtrl.dispose();
    _signupUsernameCtrl.dispose();
    _signupPasswordCtrl.removeListener(_onPasswordChanged);
    _signupPasswordCtrl.dispose();
    _signupConfirmPasswordCtrl.dispose();
    _loginEmailFocus.dispose();
    _loginPasswordFocus.dispose();
    _entranceCtrl.dispose();
    super.dispose();
  }

  void _onPasswordChanged() {
    if (mounted) setState(() {});
  }

  // ─────────────── HELPERS ───────────────

  bool get _isArabic =>
      Localizations.localeOf(context).languageCode == 'ar';
  bool get _isFrench =>
      Localizations.localeOf(context).languageCode == 'fr';

  String _t(String ar, String en, String fr) {
    if (_isArabic) return ar;
    if (_isFrench) return fr;
    return en;
  }

  // ─────────────── BIRTHDAY ───────────────

  Future<void> _selectBirthday() async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 13)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: _gold,
                  onPrimary: isDark ? Colors.black : Colors.white,
                ),
          ),
          child: child ?? const SizedBox(),
        );
      },
    );
    if (picked != null) {
      HapticFeedback.selectionClick();
      setState(() => _selectedBirthday = picked);
    }
  }

  // ─────────────── DIALOGS ───────────────

  void _showStatusDialog({
    required String title,
    required String message,
    required bool success,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = success ? const Color(0xFF4CAF50) : Colors.redAccent;
    final icon = success
        ? Icons.check_circle_rounded
        : Icons.error_outline_rounded;

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF0B3D2E).withValues(alpha: 0.96)
                    : const Color(0xFFF8FAF9).withValues(alpha: 0.98),
                borderRadius: BorderRadius.circular(24),
                border:
                    Border.all(color: color.withValues(alpha: 0.5), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.2),
                    blurRadius: 24,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 68,
                    height: 68,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          color,
                          color.withValues(alpha: 0.7),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: 0.4),
                          blurRadius: 16,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Icon(icon, color: Colors.white, size: 34),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _gold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.5,
                      height: 1.55,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'OK',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    _showStatusDialog(
      title: _t('حدث خطأ', 'Error', 'Erreur'),
      message: message,
      success: false,
    );
  }

  void _showSuccessDialog(String message) {
    _showStatusDialog(
      title: _t('نجحت العملية', 'Success', 'Succès'),
      message: message,
      success: true,
    );
  }

  // ─────────────── AUTH ACTIONS ───────────────

  Future<void> _handleLogin(AuthService authService) async {
    if (_loginEmailCtrl.text.isEmpty || _loginPasswordCtrl.text.isEmpty) {
      HapticFeedback.mediumImpact();
      _showErrorDialog(_t(
        'يرجى تعبئة جميع الحقول',
        'Please fill all fields',
        'Veuillez remplir tous les champs',
      ));
      return;
    }

    HapticFeedback.selectionClick();
    final success = await authService.login(
      emailOrUsername: _loginEmailCtrl.text,
      password: _loginPasswordCtrl.text,
    );

    if (!mounted) return;
    if (success) {
      if (!authService.isEmailVerified) {
        _showErrorDialog(_t(
          'يرجى تأكيد بريدك الإلكتروني قبل تسجيل الدخول.',
          'Please verify your email before logging in.',
          'Veuillez vérifier votre e-mail avant de vous connecter.',
        ));
        await authService.signOut();
        return;
      }
      Navigator.pop(context);
    } else {
      _showErrorDialog(authService.errorMessage ??
          _t('فشل تسجيل الدخول', 'Login failed', 'Échec de connexion'));
    }
  }

  Future<void> _handleSignup(AuthService authService) async {
    if (_signupEmailCtrl.text.isEmpty ||
        _signupUsernameCtrl.text.isEmpty ||
        _signupPasswordCtrl.text.isEmpty ||
        _signupConfirmPasswordCtrl.text.isEmpty ||
        _selectedBirthday == null ||
        _selectedGender == null) {
      HapticFeedback.mediumImpact();
      _showErrorDialog(_t(
        'يرجى تعبئة جميع الحقول',
        'Please fill all fields',
        'Veuillez remplir tous les champs',
      ));
      return;
    }

    if (_signupPasswordCtrl.text != _signupConfirmPasswordCtrl.text) {
      HapticFeedback.mediumImpact();
      _showErrorDialog(_t(
        'كلمتا المرور غير متطابقتين',
        'Passwords do not match',
        'Les mots de passe ne correspondent pas',
      ));
      return;
    }

    HapticFeedback.selectionClick();
    final success = await authService.signUp(
      email: _signupEmailCtrl.text,
      username: _signupUsernameCtrl.text,
      password: _signupPasswordCtrl.text,
      confirmPassword: _signupConfirmPasswordCtrl.text,
      birthday: _selectedBirthday!,
      gender: _selectedGender!,
    );

    if (!mounted) return;
    if (success) {
      await authService.sendVerificationEmail();
      if (!mounted) return;
      _showSuccessDialog(_t(
        'تم إنشاء حسابك بنجاح! يرجى تفقّد بريدك الإلكتروني لتأكيد الحساب.',
        'Account created! Please check your email to verify your account.',
        'Compte créé ! Veuillez vérifier votre e-mail pour confirmer votre compte.',
      ));
      Navigator.pop(context);
    } else {
      _showErrorDialog(authService.errorMessage ??
          _t('فشل إنشاء الحساب', 'Signup failed', 'Échec de l\'inscription'));
    }
  }

  // ─────────────── BUILD ───────────────

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Consumer<AuthService>(
      builder: (context, authService, _) {
        return Scaffold(
          backgroundColor: isDarkMode
              ? const Color(0xFF071C14)
              : const Color(0xFFF5F0E1),
          body: Stack(
            children: [
              // Decorative gradient blobs
              Positioned(
                top: -80,
                right: -80,
                child: _Blob(
                  size: 260,
                  color: _gold.withValues(alpha: isDarkMode ? 0.15 : 0.22),
                ),
              ),
              Positioned(
                bottom: -100,
                left: -80,
                child: _Blob(
                  size: 300,
                  color:
                      _deepGreen.withValues(alpha: isDarkMode ? 0.25 : 0.15),
                ),
              ),

              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 24),
                    child: FadeTransition(
                      opacity: _entranceCtrl,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.05),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: _entranceCtrl,
                          curve: Curves.easeOutCubic,
                        )),
                        child: _buildCard(
                            context, authService, l10n, isDarkMode),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCard(
    BuildContext context,
    AuthService authService,
    AppLocalizations? l10n,
    bool isDarkMode,
  ) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 500),
      decoration: BoxDecoration(
        color: isDarkMode
            ? const Color(0xFF0B3D2E).withValues(alpha: 0.9)
            : Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: _gold.withValues(alpha: 0.35),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: _gold.withValues(alpha: 0.15),
            blurRadius: 40,
            spreadRadius: 6,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(28, 20, 28, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Close button
          Align(
            alignment: Alignment.topRight,
            child: _GlassIconButton(
              icon: Icons.close_rounded,
              tooltip: _t('إغلاق', 'Close', 'Fermer'),
              onTap: () => Navigator.pop(context),
            ),
          ),

          // ── Hero branding ──
          _buildHero(isDarkMode),
          const SizedBox(height: 26),

          // ── Segmented toggle ──
          _buildSegmentToggle(isDarkMode),
          const SizedBox(height: 24),

          // ── Forms ──
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 0.08),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  )),
                  child: child,
                ),
              );
            },
            child: _isLogin
                ? _buildLoginForm(context, authService, l10n)
                : _buildSignupForm(context, authService, l10n),
          ),
        ],
      ),
    );
  }

  // ─────────────── HERO ───────────────

  Widget _buildHero(bool isDarkMode) {
    return Column(
      children: [
        Container(
          width: 88,
          height: 88,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [_gold, Color(0xFFE6C200)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: _gold.withValues(alpha: 0.5),
                blurRadius: 26,
                spreadRadius: 3,
              ),
            ],
          ),
          child: const Icon(
            Icons.mosque_rounded,
            color: Colors.white,
            size: 44,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          _t('تطبيق إسلامي', 'Islamic App', 'App Islamique'),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: _gold,
            fontSize: 30,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          _isLogin
              ? _t(
                  'مرحباً بعودتك، سجّل الدخول لمتابعة رحلتك الروحية',
                  'Welcome back, sign in to continue your journey',
                  'Bon retour, connectez-vous pour continuer',
                )
              : _t(
                  'انضم إلينا وابدأ رحلتك مع القرآن والأذكار والأهداف',
                  'Join us and start your journey with Quran, azkar & goals',
                  'Rejoignez-nous et commencez votre parcours',
                ),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isDarkMode
                ? Colors.white.withValues(alpha: 0.65)
                : Colors.black.withValues(alpha: 0.6),
            fontSize: 13,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  // ─────────────── SEGMENT TOGGLE ───────────────

  Widget _buildSegmentToggle(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: isDarkMode
            ? Colors.black.withValues(alpha: 0.3)
            : Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _gold.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _SegmentTab(
              label: _t('تسجيل الدخول', 'Sign In', 'Connexion'),
              icon: Icons.login_rounded,
              isSelected: _isLogin,
              onTap: () {
                if (!_isLogin) {
                  HapticFeedback.selectionClick();
                  setState(() => _isLogin = true);
                }
              },
            ),
          ),
          Expanded(
            child: _SegmentTab(
              label: _t('إنشاء حساب', 'Sign Up', 'Inscription'),
              icon: Icons.person_add_alt_1_rounded,
              isSelected: !_isLogin,
              onTap: () {
                if (_isLogin) {
                  HapticFeedback.selectionClick();
                  setState(() => _isLogin = false);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────── LOGIN FORM ───────────────

  Widget _buildLoginForm(
    BuildContext context,
    AuthService authService,
    AppLocalizations? l10n,
  ) {
    return KeyedSubtree(
      key: const ValueKey('login'),
      child: Column(
        children: [
          _buildInputField(
            controller: _loginEmailCtrl,
            label: _t('البريد الإلكتروني أو اسم المستخدم',
                'Email or Username', 'E-mail ou nom d\'utilisateur'),
            icon: Icons.email_rounded,
            keyboardType: TextInputType.text,
            focusNode: _loginEmailFocus,
            nextFocus: _loginPasswordFocus,
          ),
          const SizedBox(height: 16),
          _buildPasswordField(
            controller: _loginPasswordCtrl,
            label: _t('كلمة المرور', 'Password', 'Mot de passe'),
            obscure: _obscurePassword,
            onToggleObscure: () => setState(
                () => _obscurePassword = !_obscurePassword),
            focusNode: _loginPasswordFocus,
            onSubmitted: (_) => _handleLogin(authService),
          ),
          const SizedBox(height: 14),
          _buildRememberForgotRow(),
          const SizedBox(height: 22),
          _buildAuthButton(
            label: _t('تسجيل الدخول', 'Sign In', 'Se connecter'),
            onPressed: () => _handleLogin(authService),
            isLoading: authService.isLoading,
          ),
        ],
      ),
    );
  }

  Widget _buildRememberForgotRow() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            setState(() => _rememberMe = !_rememberMe);
          },
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: _rememberMe
                      ? _gold
                      : Colors.transparent,
                  border: Border.all(
                    color: _gold.withValues(alpha: 0.6),
                    width: 1.5,
                  ),
                ),
                child: _rememberMe
                    ? const Icon(Icons.check_rounded,
                        size: 14, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 8),
              Text(
                _t('تذكرني', 'Remember me', 'Se souvenir de moi'),
                style: TextStyle(
                  fontSize: 13,
                  color: isDarkMode
                      ? Colors.white.withValues(alpha: 0.7)
                      : Colors.black.withValues(alpha: 0.65),
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            _showErrorDialog(_t(
              'ميزة استعادة كلمة المرور قريباً',
              'Forgot password feature coming soon',
              'Fonction bientôt disponible',
            ));
          },
          child: Text(
            _t('هل نسيت كلمة المرور؟', 'Forgot password?',
                'Mot de passe oublié ?'),
            style: const TextStyle(
              fontSize: 13,
              color: _gold,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────── SIGNUP FORM ───────────────

  Widget _buildSignupForm(
    BuildContext context,
    AuthService authService,
    AppLocalizations? l10n,
  ) {
    return KeyedSubtree(
      key: const ValueKey('signup'),
      child: Column(
        children: [
          _buildInputField(
            controller: _signupEmailCtrl,
            label: _t('البريد الإلكتروني', 'Email', 'E-mail'),
            icon: Icons.email_rounded,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          _buildInputField(
            controller: _signupUsernameCtrl,
            label: _t('اسم المستخدم', 'Username', 'Nom d\'utilisateur'),
            icon: Icons.person_rounded,
          ),
          const SizedBox(height: 16),
          _buildPasswordField(
            controller: _signupPasswordCtrl,
            label: _t('كلمة المرور', 'Password', 'Mot de passe'),
            obscure: _obscurePassword,
            onToggleObscure: () => setState(
                () => _obscurePassword = !_obscurePassword),
            showStrength: true,
          ),
          const SizedBox(height: 16),
          _buildPasswordField(
            controller: _signupConfirmPasswordCtrl,
            label: _t('تأكيد كلمة المرور', 'Confirm Password',
                'Confirmer le mot de passe'),
            obscure: _obscureConfirmPassword,
            onToggleObscure: () => setState(
                () => _obscureConfirmPassword = !_obscureConfirmPassword),
          ),
          const SizedBox(height: 16),
          _buildBirthdayField(),
          const SizedBox(height: 16),
          _buildGenderSelector(),
          const SizedBox(height: 26),
          _buildAuthButton(
            label: _t('إنشاء حساب', 'Sign Up', 'Créer un compte'),
            onPressed: () => _handleSignup(authService),
            isLoading: authService.isLoading,
          ),
        ],
      ),
    );
  }

  // ─────────────── BIRTHDAY FIELD ───────────────

  Widget _buildBirthdayField() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final hasValue = _selectedBirthday != null;

    return GestureDetector(
      onTap: _selectBirthday,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isDarkMode
              ? Colors.black.withValues(alpha: 0.25)
              : Colors.grey.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: hasValue
                ? _gold.withValues(alpha: 0.6)
                : _gold.withValues(alpha: 0.3),
            width: hasValue ? 1.5 : 1.2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _gold.withValues(alpha: 0.15),
              ),
              child: const Icon(Icons.calendar_today_rounded,
                  color: _gold, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _t('تاريخ الميلاد', 'Birthday', 'Date de naissance'),
                    style: TextStyle(
                      fontSize: 11,
                      letterSpacing: 0.8,
                      fontWeight: FontWeight.w600,
                      color: _gold.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    hasValue
                        ? '${_selectedBirthday!.day}/${_selectedBirthday!.month}/${_selectedBirthday!.year}'
                        : _t('اختر تاريخ ميلادك', 'Select your birthday',
                            'Sélectionnez votre date'),
                    style: TextStyle(
                      color: hasValue
                          ? (isDarkMode ? Colors.white : Colors.black87)
                          : (isDarkMode
                              ? Colors.white.withValues(alpha: 0.4)
                              : Colors.black.withValues(alpha: 0.4)),
                      fontSize: 14.5,
                      fontWeight:
                          hasValue ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: _gold.withValues(alpha: 0.6),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────── GENDER SELECTOR ───────────────

  Widget _buildGenderSelector() {
    return Row(
      children: [
        Expanded(
          child: _buildGenderOption(
            _t('ذكر', 'Male', 'Homme'),
            'male',
            Icons.male_rounded,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildGenderOption(
            _t('أنثى', 'Female', 'Femme'),
            'female',
            Icons.female_rounded,
          ),
        ),
      ],
    );
  }

  Widget _buildGenderOption(String label, String value, IconData icon) {
    final isSelected = _selectedGender == value;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() => _selectedGender = value);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    _gold.withValues(alpha: 0.28),
                    _gold.withValues(alpha: 0.12),
                  ],
                )
              : null,
          color: isSelected
              ? null
              : (isDarkMode
                  ? Colors.black.withValues(alpha: 0.25)
                  : Colors.grey.withValues(alpha: 0.06)),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? _gold
                : _gold.withValues(alpha: 0.3),
            width: isSelected ? 1.8 : 1.2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: _gold.withValues(alpha: 0.25),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? _gold
                  : (isDarkMode ? Colors.white54 : Colors.black45),
              size: 22,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? _gold
                    : (isDarkMode ? Colors.white70 : Colors.black54),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────── INPUTS ───────────────

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    FocusNode? focusNode,
    FocusNode? nextFocus,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      focusNode: focusNode,
      textInputAction:
          nextFocus != null ? TextInputAction.next : TextInputAction.done,
      onSubmitted: (_) {
        if (nextFocus != null) {
          FocusScope.of(context).requestFocus(nextFocus);
        }
      },
      style: TextStyle(
        color: isDarkMode ? Colors.white : Colors.black87,
        fontSize: 15,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: isDarkMode ? Colors.grey[400] : Colors.black54,
          fontSize: 14,
        ),
        floatingLabelStyle: const TextStyle(color: _gold, fontSize: 13),
        prefixIcon: Icon(icon, color: _gold, size: 20),
        filled: true,
        fillColor: isDarkMode
            ? Colors.black.withValues(alpha: 0.25)
            : Colors.grey.withValues(alpha: 0.06),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: _gold.withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: _gold.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _gold, width: 2),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback onToggleObscure,
    FocusNode? focusNode,
    ValueChanged<String>? onSubmitted,
    bool showStrength = false,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          obscureText: obscure,
          focusNode: focusNode,
          textInputAction:
              onSubmitted != null ? TextInputAction.done : TextInputAction.next,
          onSubmitted: onSubmitted,
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black87,
            fontSize: 15,
          ),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(
              color: isDarkMode ? Colors.grey[400] : Colors.black54,
              fontSize: 14,
            ),
            floatingLabelStyle: const TextStyle(color: _gold, fontSize: 13),
            prefixIcon:
                const Icon(Icons.lock_rounded, color: _gold, size: 20),
            suffixIcon: IconButton(
              icon: Icon(
                obscure
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded,
                color: isDarkMode ? Colors.grey[400] : Colors.black45,
                size: 20,
              ),
              onPressed: onToggleObscure,
            ),
            filled: true,
            fillColor: isDarkMode
                ? Colors.black.withValues(alpha: 0.25)
                : Colors.grey.withValues(alpha: 0.06),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: _gold.withValues(alpha: 0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: _gold.withValues(alpha: 0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: _gold, width: 2),
            ),
          ),
        ),
        if (showStrength && controller.text.isNotEmpty) ...[
          const SizedBox(height: 10),
          _PasswordStrengthMeter(password: controller.text),
        ],
      ],
    );
  }

  // ─────────────── AUTH BUTTON ───────────────

  Widget _buildAuthButton({
    required String label,
    required VoidCallback onPressed,
    required bool isLoading,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [_gold, Color(0xFFE6C200)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: _gold.withValues(alpha: 0.4),
              blurRadius: 20,
              spreadRadius: 1,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isLoading ? null : onPressed,
            borderRadius: BorderRadius.circular(14),
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.black87),
                        strokeWidth: 2.5,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          label,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.4,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded,
                            color: Colors.black87, size: 20),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// DECORATIVE BLOB
// ═══════════════════════════════════════════════════════════════

class _Blob extends StatelessWidget {
  final double size;
  final Color color;
  const _Blob({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, color.withValues(alpha: 0)],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// SEGMENT TAB
// ═══════════════════════════════════════════════════════════════

class _SegmentTab extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _SegmentTab({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDarkMode
                  ? const Color(0xFF144D32).withValues(alpha: 0.9)
                  : Colors.white)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color:
                        const Color(0xFFD4AF37).withValues(alpha: 0.18),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 17,
              color: isSelected
                  ? const Color(0xFFD4AF37)
                  : (isDarkMode ? Colors.white54 : Colors.black45),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight:
                    isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected
                    ? const Color(0xFFD4AF37)
                    : (isDarkMode ? Colors.white54 : Colors.black45),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// PASSWORD STRENGTH METER
// ═══════════════════════════════════════════════════════════════

class _PasswordStrengthMeter extends StatelessWidget {
  final String password;
  const _PasswordStrengthMeter({required this.password});

  int _score(String p) {
    if (p.isEmpty) return 0;
    int score = 0;
    if (p.length >= 8) score++;
    if (p.length >= 12) score++;
    if (RegExp(r'[A-Z]').hasMatch(p)) score++;
    if (RegExp(r'[a-z]').hasMatch(p)) score++;
    if (RegExp(r'\d').hasMatch(p)) score++;
    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-+=~`\[\];/\\]').hasMatch(p)) {
      score++;
    }
    return score.clamp(0, 5);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final score = _score(password);
    final labels = ['Too weak', 'Weak', 'Fair', 'Good', 'Strong', 'Very strong'];
    final colors = [
      Colors.redAccent,
      Colors.redAccent,
      Colors.orange,
      Colors.amber,
      Colors.lightGreen,
      const Color(0xFF4CAF50),
    ];
    final idx = score.clamp(0, 5);
    final label = labels[idx];
    final color = colors[idx];

    return Row(
      children: [
        Expanded(
          child: Row(
            children: List.generate(5, (i) {
              return Expanded(
                child: Container(
                  margin:
                      EdgeInsets.only(right: i == 4 ? 0 : 4),
                  height: 5,
                  decoration: BoxDecoration(
                    color: i < score
                        ? color
                        : (isDarkMode
                            ? Colors.white.withValues(alpha: 0.1)
                            : Colors.black.withValues(alpha: 0.08)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// GLASS ICON BUTTON
// ═══════════════════════════════════════════════════════════════

class _GlassIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;

  const _GlassIconButton({
    required this.icon,
    required this.onTap,
    this.tooltip,
  });

  @override
  State<_GlassIconButton> createState() => _GlassIconButtonState();
}

class _GlassIconButtonState extends State<_GlassIconButton> {
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
                    : Colors.grey.withValues(alpha: 0.08)),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFD4AF37)
                  .withValues(alpha: _hover ? 0.6 : 0.3),
            ),
          ),
          child: Icon(widget.icon,
              color: const Color(0xFFD4AF37), size: 20),
        ),
      ),
    );
    if (widget.tooltip != null) {
      return Tooltip(message: widget.tooltip!, child: button);
    }
    return button;
  }
}