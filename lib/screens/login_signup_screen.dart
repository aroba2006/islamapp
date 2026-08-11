import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLogin = true;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final _loginEmailCtrl = TextEditingController();
  final _loginPasswordCtrl = TextEditingController();

  final _signupEmailCtrl = TextEditingController();
  final _signupUsernameCtrl = TextEditingController();
  final _signupPasswordCtrl = TextEditingController();
  final _signupConfirmPasswordCtrl = TextEditingController();
  DateTime? _selectedBirthday;
  String? _selectedGender;

  @override
  void dispose() {
    _loginEmailCtrl.dispose();
    _loginPasswordCtrl.dispose();
    _signupEmailCtrl.dispose();
    _signupUsernameCtrl.dispose();
    _signupPasswordCtrl.dispose();
    _signupConfirmPasswordCtrl.dispose();
    super.dispose();
  }

  Future<void> _selectBirthday() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 13)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: const Color(0xFFD4AF37),
              onPrimary: Colors.black,
            ),
          ),
          child: child ?? const SizedBox(),
        );
      },
    );
    if (picked != null) setState(() => _selectedBirthday = picked);
  }

  // ✅ FIXED: Using showDialog instead of SnackBar to avoid "No Material Widget" crash
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text('Error', style: TextStyle(color: Colors.red)),
        content: Text(message, style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK', style: TextStyle(color: Color(0xFFD4AF37))),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text('Success', style: TextStyle(color: Colors.green)),
        content: Text(message, style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK', style: TextStyle(color: Color(0xFFD4AF37))),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogin(AuthService authService) async {
    if (_loginEmailCtrl.text.isEmpty || _loginPasswordCtrl.text.isEmpty) {
      _showErrorDialog('Please fill all fields');
      return;
    }

    final success = await authService.login(
      emailOrUsername: _loginEmailCtrl.text,
      password: _loginPasswordCtrl.text,
    );

    if (success && mounted) {
      if (!authService.isEmailVerified) {
         _showErrorDialog('Please verify your email before logging in.');
         await authService.signOut();
         return;
      }
      Navigator.pop(context);
    } else if (!success && mounted) {
      _showErrorDialog(authService.errorMessage ?? 'Login failed');
    }
  }

  Future<void> _handleSignup(AuthService authService) async {
    if (_signupEmailCtrl.text.isEmpty ||
        _signupUsernameCtrl.text.isEmpty ||
        _signupPasswordCtrl.text.isEmpty ||
        _signupConfirmPasswordCtrl.text.isEmpty ||
        _selectedBirthday == null ||
        _selectedGender == null) {
      _showErrorDialog('Please fill all fields');
      return;
    }

    final success = await authService.signUp(
      email: _signupEmailCtrl.text,
      username: _signupUsernameCtrl.text,
      password: _signupPasswordCtrl.text,
      confirmPassword: _signupConfirmPasswordCtrl.text,
      birthday: _selectedBirthday!,
      gender: _selectedGender!,
    );

    if (success && mounted) {
      await authService.sendVerificationEmail();
      _showSuccessDialog('Account created! Please check your email to verify your account.');
      Navigator.pop(context);
    } else if (!success && mounted) {
      _showErrorDialog(authService.errorMessage ?? 'Signup failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Consumer<AuthService>(
      builder: (context, authService, _) {
        return Material( // ✅ Root Material to prevent TextField error
          color: Colors.transparent,
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 500),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: const Color(0xFFD4AF37).withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: const Icon(Icons.close_rounded, color: Colors.white70),
                          onPressed: () => Navigator.pop(context),
                          tooltip: isArabic ? 'إغلاق' : 'Close',
                        ),
                      ),
                      Text(
                        'الإسلام',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: const Color(0xFFD4AF37),
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Islamic App',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.grey[400],
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 30),

                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0.0, 0.2),
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
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoginForm(BuildContext context, AuthService authService, AppLocalizations l10n) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return KeyedSubtree(
      key: const ValueKey('login'),
      child: Column(
        children: [
          _buildInputField(
            controller: _loginEmailCtrl,
            label: isArabic ? 'البريد الإلكتروني أو اسم المستخدم' : 'Email or Username',
            icon: Icons.email_rounded,
            keyboardType: TextInputType.text,
          ),
          const SizedBox(height: 16),
          _buildPasswordField(
            controller: _loginPasswordCtrl,
            label: isArabic ? 'كلمة المرور' : 'Password',
            obscure: _obscurePassword,
            onToggleObscure: () => setState(() => _obscurePassword = !_obscurePassword),
          ),
          const SizedBox(height: 32),
          _buildAuthButton(
            label: isArabic ? 'تسجيل الدخول' : 'Login',
            onPressed: () => _handleLogin(authService),
            isLoading: authService.isLoading,
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () => setState(() => _isLogin = false),
            child: Text(
              isArabic ? 'ليس لديك حساب؟ إنشاء حساب' : 'No account? Sign up',
              style: const TextStyle(
                color: Color(0xFFD4AF37),
                fontSize: 16,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
                decorationColor: Color(0xFFD4AF37),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignupForm(BuildContext context, AuthService authService, AppLocalizations l10n) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return KeyedSubtree(
      key: const ValueKey('signup'),
      child: Column(
        children: [
          _buildInputField(
            controller: _signupEmailCtrl,
            label: isArabic ? 'البريد الإلكتروني' : 'Email',
            icon: Icons.email_rounded,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          _buildInputField(
            controller: _signupUsernameCtrl,
            label: isArabic ? 'اسم المستخدم' : 'Username',
            icon: Icons.person_rounded,
          ),
          const SizedBox(height: 16),
          _buildPasswordField(
            controller: _signupPasswordCtrl,
            label: isArabic ? 'كلمة المرور' : 'Password',
            obscure: _obscurePassword,
            onToggleObscure: () => setState(() => _obscurePassword = !_obscurePassword),
          ),
          const SizedBox(height: 16),
          _buildPasswordField(
            controller: _signupConfirmPasswordCtrl,
            label: isArabic ? 'تأكيد كلمة المرور' : 'Confirm Password',
            obscure: _obscureConfirmPassword,
            onToggleObscure: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _selectBirthday,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFD4AF37).withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_rounded, color: Color(0xFFD4AF37)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _selectedBirthday != null
                          ? '${_selectedBirthday!.day}/${_selectedBirthday!.month}/${_selectedBirthday!.year}'
                          : isArabic ? 'اختر تاريخ الميلاد' : 'Select Birthday',
                      style: TextStyle(
                        color: _selectedBirthday != null ? Colors.white : Colors.grey[400],
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildGenderSelector(),
          const SizedBox(height: 32),
          _buildAuthButton(
            label: isArabic ? 'إنشاء حساب' : 'Sign Up',
            onPressed: () => _handleSignup(authService),
            isLoading: authService.isLoading,
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () => setState(() => _isLogin = true),
            child: Text(
              isArabic ? 'لديك حساب بالفعل؟ تسجيل الدخول' : 'Already have an account? Login',
              style: const TextStyle(
                color: Color(0xFFD4AF37),
                fontSize: 16,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
                decorationColor: Color(0xFFD4AF37),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[400]),
        prefixIcon: Icon(icon, color: const Color(0xFFD4AF37)),
        filled: true,
        fillColor: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: const Color(0xFFD4AF37).withValues(alpha: 0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFD4AF37),
            width: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback onToggleObscure,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[400]),
        prefixIcon: const Icon(Icons.lock_rounded, color: Color(0xFFD4AF37)),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off_rounded : Icons.visibility_rounded,
            color: Colors.grey[400],
          ),
          onPressed: onToggleObscure,
        ),
        filled: true,
        fillColor: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: const Color(0xFFD4AF37).withValues(alpha: 0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFD4AF37),
            width: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildGenderSelector() {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return Row(
      children: [
        Expanded(
          child: _buildGenderOption(isArabic ? 'ذكر' : 'Male', 'male'),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildGenderOption(isArabic ? 'أنثى' : 'Female', 'female'),
        ),
      ],
    );
  }

  Widget _buildGenderOption(String label, String value) {
    final isSelected = _selectedGender == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedGender = value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFD4AF37).withValues(alpha: 0.2)
              : Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFD4AF37)
                : const Color(0xFFD4AF37).withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              value == 'male' ? Icons.male_rounded : Icons.female_rounded,
              color: isSelected ? const Color(0xFFD4AF37) : Colors.grey[400],
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFFD4AF37) : Colors.grey[400],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthButton({
    required String label,
    required VoidCallback onPressed,
    required bool isLoading,
  }) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFD4AF37), Color(0xFFB5952F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD4AF37).withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    label,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}