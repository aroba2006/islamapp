import 'package:shared_preferences/shared_preferences.dart';

class ReciterPreferences {
  // The key used to store the reciter in local storage
  static const String _key = 'default_reciter';

  // Define your reciter IDs here (these should match whatever IDs you use for your audio API)
  // For example, if you use mp3quran.net or everyayah.com
  static const String alBanna = 'mahmoud_ali_al_banna';
  static const String minshawi = 'muhammad_siddiq_al_minshawi';
  // Add more reciters here...

  // The default reciter if none is saved yet
  static const String defaultReciter = minshawi;

  /// Saves the selected reciter ID to local storage.
  static Future<void> setReciter(String reciterId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, reciterId);
  }

  /// Retrieves the saved reciter ID. If none exists, returns the default.
  static Future<String> getReciter() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key) ?? defaultReciter;
  }
}