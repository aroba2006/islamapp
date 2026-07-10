import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/quran_page_mapping.dart'; // Ensure this points to your mapping file
import '../screens/mushaf_viewer_screen.dart';

class SurahIndexScreen extends StatelessWidget {
  const SurahIndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(title: Text(isArabic ? 'فهرس السور' : 'Surah Index')),
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
              style: GoogleFonts.amiri(fontSize: 18),
            ),
            trailing: Text(
              isArabic ? 'ص ${surah['startPage']}' : 'Page ${surah['startPage']}',
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
  }
}