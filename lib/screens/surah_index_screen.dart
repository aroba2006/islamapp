import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/quran_page_mapping.dart'; // Ensure this points to your mapping file
import '../services/theme_service.dart';
import '../screens/mushaf_viewer_screen.dart';

class SurahIndexScreen extends StatelessWidget {
  const SurahIndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              isArabic ? 'فهرس السور' : 'Surah Index',
              // ✅ FIXED: Use themeService instead of hardcoded GoogleFonts
              style: themeService.getTextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: ListView.builder(
            itemCount: SURAH_PAGE_MAP.length,
            itemBuilder: (context, index) {
              final surahNumber = index + 1;
              final surah = SURAH_PAGE_MAP[surahNumber]!;
              
              return ListTile(
                leading: CircleAvatar(
                  child: Text('$surahNumber'),
                ),
                title: Text(
                  isArabic ? surah['nameAr'] : surah['nameEn'],
                  // ✅ FIXED: Use themeService instead of hardcoded GoogleFonts
                  style: themeService.getTextStyle(
                    fontSize: 18,
                  ),
                ),
                trailing: Text(
                  isArabic ? 'ص ${surah['startPage']}' : 'Page ${surah['startPage']}',
                  style: themeService.getTextStyle(
                    fontSize: 14,
                  ),
                ),
                onTap: () {
                  // Navigate directly to the selected page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MushafViewerScreen(initialPage: surah['startPage']),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}