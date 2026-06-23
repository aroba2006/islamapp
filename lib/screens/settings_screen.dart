import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import '../services/adhan_service.dart';
import '../widgets/islamic_pattern_background.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late String _selectedReciter;
  late String _selectedLanguage;
  bool _notificationsEnabled = true;
  bool _adhanPlaying = false;

  @override
  void initState() {
    super.initState();
    _selectedReciter = 'mishary';
    _selectedLanguage = 'ar';
    _loadSavedSettings();
  }

  Future<void> _loadSavedSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedReciter = prefs.getString('adhanReciter') ?? 'mishary';
      _selectedLanguage = prefs.getString('locale') ?? 'ar';
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectedLanguage = Localizations.localeOf(context).languageCode;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isArabic = _selectedLanguage == 'ar';

    return Scaffold(
      body: IslamicPatternBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context, l10n, isArabic),
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF0B3D2E).withValues(alpha: 0.7),
                            border: Border(top: BorderSide(color: const Color(0xFFD4AF37).withValues(alpha: 0.3))),
                          ),
                          child: ListView(
                            padding: const EdgeInsets.fromLTRB(24, 30, 24, 40),
                            children: [
                              _buildLanguageSection(context, l10n),
                              const SizedBox(height: 32),
                              _buildAdhanSection(context, l10n),
                              const SizedBox(height: 32),
                              _buildNotificationSection(context, l10n),
                            ],
                          ),
                        ),
                      ),
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

  Widget _buildHeader(BuildContext context, AppLocalizations l10n, bool isArabic) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFFD4AF37), size: 24),
          ),
          Expanded(
            child: Text(
              l10n.settings,
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

  Widget _buildLanguageSection(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.language_rounded, color: Color(0xFFD4AF37), size: 24),
            const SizedBox(width: 12),
            Text(
              l10n.language,
              style: GoogleFonts.elMessiri(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _InteractiveOptionCard(
          label: l10n.arabic,
          isSelected: _selectedLanguage == 'ar',
          onTap: () {
            setState(() => _selectedLanguage = 'ar');
            IslamicApp.of(context)?.setLocale('ar');
          },
        ),
        const SizedBox(height: 12),
        _InteractiveOptionCard(
          label: l10n.english,
          isSelected: _selectedLanguage == 'en',
          onTap: () {
            setState(() => _selectedLanguage = 'en');
            IslamicApp.of(context)?.setLocale('en');
          },
        ),
        const SizedBox(height: 12),
        _InteractiveOptionCard(
          label: l10n.french,
          isSelected: _selectedLanguage == 'fr',
          onTap: () {
            setState(() => _selectedLanguage = 'fr');
            IslamicApp.of(context)?.setLocale('fr');
          },
        ),
      ],
    );
  }

  Widget _buildAdhanSection(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.mosque_rounded, color: Color(0xFFD4AF37), size: 24),
            const SizedBox(width: 12),
            Text(
              l10n.adhan,
              style: GoogleFonts.elMessiri(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          l10n.selectAdhanReciter,
          style: GoogleFonts.elMessiri(fontSize: 16, color: Colors.white.withValues(alpha: 0.6)),
        ),
        const SizedBox(height: 16),
        _InteractiveOptionCard(label: l10n.misharyAfasi, isSelected: _selectedReciter == 'mishary', onTap: () => _updateReciter('mishary')),
        const SizedBox(height: 12),
        _InteractiveOptionCard(label: l10n.nasserQattami, isSelected: _selectedReciter == 'nasser', onTap: () => _updateReciter('nasser')),
        const SizedBox(height: 12),
        _InteractiveOptionCard(label: l10n.mohamedQassas, isSelected: _selectedReciter == 'qassas', onTap: () => _updateReciter('qassas')),
        const SizedBox(height: 12),
        _InteractiveOptionCard(label: l10n.moRefaat, isSelected: _selectedReciter == 'refaat', onTap: () => _updateReciter('refaat')),
        const SizedBox(height: 12),
        _InteractiveOptionCard(label: l10n.nasTobar, isSelected: _selectedReciter == 'tobar', onTap: () => _updateReciter('tobar')),
        const SizedBox(height: 24),
        
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _adhanPlaying ? null : () => _playAdhan(l10n),
                icon: const Icon(Icons.play_arrow_rounded, size: 24),
                label: Text(l10n.playAdhan, style: GoogleFonts.elMessiri(fontSize: 18, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4AF37),
                  foregroundColor: const Color(0xFF0B3D2E),
                  disabledBackgroundColor: Colors.black.withValues(alpha: 0.3),
                  disabledForegroundColor: Colors.white54,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _adhanPlaying ? () => _stopAdhan() : null,
                icon: const Icon(Icons.stop_rounded, size: 24),
                label: Text(l10n.stop, style: GoogleFonts.elMessiri(fontSize: 18, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent.withValues(alpha: 0.8),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.black.withValues(alpha: 0.3),
                  disabledForegroundColor: Colors.white54,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _updateReciter(String reciterId) {
    setState(() => _selectedReciter = reciterId);
    IslamicApp.of(context)?.setAdhanReciter(reciterId);
  }

  Widget _buildNotificationSection(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFD4AF37).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD4AF37).withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.notifications_active_rounded, color: Color(0xFFD4AF37), size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              l10n.adhanNotifications,
              style: GoogleFonts.elMessiri(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          Switch(
            value: _notificationsEnabled,
            onChanged: (value) => setState(() => _notificationsEnabled = value),
            activeThumbColor: const Color(0xFFD4AF37),
            activeTrackColor: const Color(0xFFD4AF37).withValues(alpha: 0.3),
            inactiveThumbColor: Colors.white54,
            inactiveTrackColor: Colors.black.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }

  Future<void> _playAdhan(AppLocalizations l10n) async {
    try {
      await AdhanService.stopAdhan();
      await Future.delayed(const Duration(milliseconds: 200));
      setState(() => _adhanPlaying = true);
      await AdhanService.playAdhan(_selectedReciter);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${l10n.errorMessage}: $e', style: GoogleFonts.elMessiri()), backgroundColor: Colors.redAccent));
        setState(() => _adhanPlaying = false);
      }
    }
  }

  Future<void> _stopAdhan() async {
    try {
      await AdhanService.stopAdhan();
      setState(() => _adhanPlaying = false);
    } catch (e) {}
  }
}

// ── CUSTOM INTERACTIVE OPTION CARD FOR MOBILE TOUCH ──
class _InteractiveOptionCard extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _InteractiveOptionCard({required this.label, required this.isSelected, required this.onTap});

  @override
  State<_InteractiveOptionCard> createState() => _InteractiveOptionCardState();
}

class _InteractiveOptionCardState extends State<_InteractiveOptionCard> {
  bool _isHovered = false;
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _scale = 0.97),
        onTapUp: (_) => setState(() => _scale = 1.0),
        onTapCancel: () => setState(() => _scale = 1.0),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 150),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: widget.isSelected || _isHovered
                  ? const Color(0xFFD4AF37).withValues(alpha: 0.15) 
                  : const Color(0xFF144D32).withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: widget.isSelected || _isHovered ? const Color(0xFFD4AF37) : const Color(0xFFD4AF37).withValues(alpha: 0.2),
                width: widget.isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  widget.isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                  color: widget.isSelected ? const Color(0xFFD4AF37) : Colors.white54,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.label,
                    style: GoogleFonts.elMessiri(
                      fontSize: 18,
                      fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.normal,
                      color: widget.isSelected ? const Color(0xFFD4AF37) : Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}