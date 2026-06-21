import 'package:flutter/material.dart';
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
    return Scaffold(
      body: IslamicPatternBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context, l10n),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                    children: [
                      _buildLanguageSection(context, l10n),
                      const SizedBox(height: 24),
                      _buildAdhanSection(context, l10n),
                      const SizedBox(height: 24),
                      _buildNotificationSection(context, l10n),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 20, 12),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.settings,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const Icon(Icons.settings, color: Color(0xFFD4AF37), size: 28),
        ],
      ),
    );
  }

  Widget _buildLanguageSection(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.language,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B5E3F),
          ),
        ),
        const SizedBox(height: 12),
        _buildLanguageOption(context, l10n.arabic, 'ar'),
        const SizedBox(height: 8),
        _buildLanguageOption(context, l10n.english, 'en'),
        const SizedBox(height: 8),
        _buildLanguageOption(context, l10n.french, 'fr'),
      ],
    );
  }

  Widget _buildLanguageOption(BuildContext context, String label, String code) {
    final isSelected = _selectedLanguage == code;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedLanguage = code);
        IslamicApp.of(context)?.setLocale(code);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1B5E3F).withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF1B5E3F) : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Radio<String>(
              value: code,
              groupValue: _selectedLanguage,
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedLanguage = value);
                  IslamicApp.of(context)?.setLocale(value);
                }
              },
              activeColor: const Color(0xFF1B5E3F),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? const Color(0xFF1B5E3F) : Colors.black87,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Color(0xFF1B5E3F), size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAdhanSection(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.adhan,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B5E3F),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.selectAdhanReciter,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 10),
        _buildReciterOption(l10n.misharyAfasi, 'mishary'),
        const SizedBox(height: 8),
        _buildReciterOption(l10n.nasserQattami, 'nasser'),
        const SizedBox(height: 14),
        _buildReciterOption(l10n.mohamedQassas, 'qassas'),
        const SizedBox(height: 16),
        // Play and Stop buttons side by side
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _adhanPlaying ? null : () => _playAdhan(l10n),
                icon: const Icon(Icons.play_arrow),
                label: Text(l10n.playAdhan),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _adhanPlaying ? Colors.grey.shade400 : const Color(0xFF1B5E3F),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _adhanPlaying ? () => _stopAdhan() : null,
                icon: const Icon(Icons.stop),
                label: Text(l10n.stop),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _adhanPlaying ? const Color(0xFF1B5E3F) : Colors.grey.shade400,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReciterOption(String label, String reciterId) {
    final isSelected = _selectedReciter == reciterId;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedReciter = reciterId);
        IslamicApp.of(context)?.setAdhanReciter(reciterId);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1B5E3F).withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF1B5E3F) : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Radio<String>(
              value: reciterId,
              groupValue: _selectedReciter,
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedReciter = value);
                  IslamicApp.of(context)?.setAdhanReciter(value);
                }
              },
              activeColor: const Color(0xFF1B5E3F),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? const Color(0xFF1B5E3F) : Colors.black87,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Color(0xFF1B5E3F), size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSection(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1B5E3F).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1B5E3F).withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.notifications_active, color: Color(0xFF1B5E3F), size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.adhanNotifications,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1B5E3F),
              ),
            ),
          ),
          Switch(
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() => _notificationsEnabled = value);
            },
            activeThumbColor: const Color(0xFF1B5E3F),
            inactiveThumbColor: Colors.grey.shade400,
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.errorMessage}: $e')),
        );
        setState(() => _adhanPlaying = false);
      }
    }
  }

  Future<void> _stopAdhan() async {
    try {
      await AdhanService.stopAdhan();
      setState(() => _adhanPlaying = false);
    } catch (e) {
      // Ignore stop errors
    }
  }
}