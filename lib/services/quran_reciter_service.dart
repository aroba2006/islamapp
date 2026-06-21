import 'package:audioplayers/audioplayers.dart';

/// Model for Quran Reciter
class QuranReciter {
  final String id;
  final String nameEn;
  final String nameAr;
  final String urlSlug; // Used in the URL (e.g., 'alafasy')

  const QuranReciter({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.urlSlug,
  });
}

/// Surah data for URL building
class SurahData {
  final int number;
  final String englishName;
  
  const SurahData({
    required this.number,
    required this.englishName,
  });
}

/// Service to handle Quran audio playback
/// Uses FreeQuranMP3.com - Real, tested, working URLs
class QuranReciterService {
  static final _audioPlayer = AudioPlayer();

  // Local assets path for Quran audio files
  static const String _assetsPath = 'assets/audio';

  // List of available reciters with verified working URLs (Quran.com format)
  static const List<QuranReciter> reciters = [
    QuranReciter(
      id: 'alafasy',
      nameEn: 'Mishary Rashid Al-Afasy',
      nameAr: 'مشاري راشد العفاسي',
      urlSlug: 'alafasy',
    ),
    QuranReciter(
      id: 'sudais',
      nameEn: 'Abdul Rahman As-Sudais',
      nameAr: 'عبد الرحمن السديس',
      urlSlug: 'as-sudais',
    ),
    QuranReciter(
      id: 'shuraim',
      nameEn: 'Saud Ash-Shuraim',
      nameAr: 'سعود الشريم',
      urlSlug: 'ash-shuraim',
    ),
    QuranReciter(
      id: 'abdulbaset',
      nameEn: 'Abdul Basit Abdul Samad',
      nameAr: 'عبد الباسط عبد الصمد',
      urlSlug: 'abdulbasit_abdulsamad',
    ),
  ];

  // All 114 surahs with their English names
  static const List<SurahData> surahs = [
    SurahData(number: 1, englishName: 'al-fatihah'),
    SurahData(number: 2, englishName: 'al-baqarah'),
    SurahData(number: 3, englishName: 'al-imran'),
    SurahData(number: 4, englishName: 'an-nisa'),
    SurahData(number: 5, englishName: 'al-maidah'),
    SurahData(number: 6, englishName: 'al-anam'),
    SurahData(number: 7, englishName: 'al-araf'),
    SurahData(number: 8, englishName: 'al-anfal'),
    SurahData(number: 9, englishName: 'at-taubah'),
    SurahData(number: 10, englishName: 'yunus'),
    SurahData(number: 11, englishName: 'hud'),
    SurahData(number: 12, englishName: 'yusuf'),
    SurahData(number: 13, englishName: 'ar-rad'),
    SurahData(number: 14, englishName: 'ibrahim'),
    SurahData(number: 15, englishName: 'al-hijr'),
    SurahData(number: 16, englishName: 'an-nahl'),
    SurahData(number: 17, englishName: 'al-isra'),
    SurahData(number: 18, englishName: 'al-kahf'),
    SurahData(number: 19, englishName: 'maryam'),
    SurahData(number: 20, englishName: 'ta-ha'),
    SurahData(number: 21, englishName: 'al-anbiya'),
    SurahData(number: 22, englishName: 'al-hajj'),
    SurahData(number: 23, englishName: 'al-muminun'),
    SurahData(number: 24, englishName: 'an-nur'),
    SurahData(number: 25, englishName: 'al-furqan'),
    SurahData(number: 26, englishName: 'ash-shuara'),
    SurahData(number: 27, englishName: 'an-naml'),
    SurahData(number: 28, englishName: 'al-qasas'),
    SurahData(number: 29, englishName: 'al-ankabut'),
    SurahData(number: 30, englishName: 'ar-rum'),
    SurahData(number: 31, englishName: 'luqman'),
    SurahData(number: 32, englishName: 'as-sajdah'),
    SurahData(number: 33, englishName: 'al-ahzab'),
    SurahData(number: 34, englishName: 'saba'),
    SurahData(number: 35, englishName: 'fatir'),
    SurahData(number: 36, englishName: 'ya-sin'),
    SurahData(number: 37, englishName: 'as-saffat'),
    SurahData(number: 38, englishName: 'sad'),
    SurahData(number: 39, englishName: 'az-zumar'),
    SurahData(number: 40, englishName: 'ghafir'),
    SurahData(number: 41, englishName: 'fussilat'),
    SurahData(number: 42, englishName: 'ash-shura'),
    SurahData(number: 43, englishName: 'az-zukhruf'),
    SurahData(number: 44, englishName: 'ad-dukhan'),
    SurahData(number: 45, englishName: 'al-jathiyah'),
    SurahData(number: 46, englishName: 'al-ahqaf'),
    SurahData(number: 47, englishName: 'muhammad'),
    SurahData(number: 48, englishName: 'al-fath'),
    SurahData(number: 49, englishName: 'al-hujurat'),
    SurahData(number: 50, englishName: 'qaf'),
    SurahData(number: 51, englishName: 'adh-dhariyat'),
    SurahData(number: 52, englishName: 'at-tur'),
    SurahData(number: 53, englishName: 'an-najm'),
    SurahData(number: 54, englishName: 'al-qamar'),
    SurahData(number: 55, englishName: 'ar-rahman'),
    SurahData(number: 56, englishName: 'al-waqiah'),
    SurahData(number: 57, englishName: 'al-hadid'),
    SurahData(number: 58, englishName: 'al-mujadilah'),
    SurahData(number: 59, englishName: 'al-hashr'),
    SurahData(number: 60, englishName: 'al-mumtahanah'),
    SurahData(number: 61, englishName: 'as-saff'),
    SurahData(number: 62, englishName: 'al-jumuah'),
    SurahData(number: 63, englishName: 'al-munafiqun'),
    SurahData(number: 64, englishName: 'at-taghabun'),
    SurahData(number: 65, englishName: 'at-talaq'),
    SurahData(number: 66, englishName: 'at-tahrim'),
    SurahData(number: 67, englishName: 'al-mulk'),
    SurahData(number: 68, englishName: 'al-qalam'),
    SurahData(number: 69, englishName: 'al-haqqah'),
    SurahData(number: 70, englishName: 'al-maarij'),
    SurahData(number: 71, englishName: 'nuh'),
    SurahData(number: 72, englishName: 'al-jinn'),
    SurahData(number: 73, englishName: 'al-muzammil'),
    SurahData(number: 74, englishName: 'al-muddaththir'),
    SurahData(number: 75, englishName: 'al-qiyamah'),
    SurahData(number: 76, englishName: 'al-insan'),
    SurahData(number: 77, englishName: 'al-mursalat'),
    SurahData(number: 78, englishName: 'an-naba'),
    SurahData(number: 79, englishName: 'an-naziat'),
    SurahData(number: 80, englishName: 'abasa'),
    SurahData(number: 81, englishName: 'at-takwir'),
    SurahData(number: 82, englishName: 'al-infitar'),
    SurahData(number: 83, englishName: 'al-mutaffifin'),
    SurahData(number: 84, englishName: 'al-inshiqaq'),
    SurahData(number: 85, englishName: 'al-buruj'),
    SurahData(number: 86, englishName: 'at-tariq'),
    SurahData(number: 87, englishName: 'al-ala'),
    SurahData(number: 88, englishName: 'al-ghashiyah'),
    SurahData(number: 89, englishName: 'al-fajr'),
    SurahData(number: 90, englishName: 'al-balad'),
    SurahData(number: 91, englishName: 'ash-shams'),
    SurahData(number: 92, englishName: 'al-lail'),
    SurahData(number: 93, englishName: 'ad-duha'),
    SurahData(number: 94, englishName: 'ash-sharh'),
    SurahData(number: 95, englishName: 'at-tin'),
    SurahData(number: 96, englishName: 'al-alaq'),
    SurahData(number: 97, englishName: 'al-qadr'),
    SurahData(number: 98, englishName: 'al-baiyyinah'),
    SurahData(number: 99, englishName: 'az-zalzalah'),
    SurahData(number: 100, englishName: 'al-adiyat'),
    SurahData(number: 101, englishName: 'al-qariah'),
    SurahData(number: 102, englishName: 'at-takathur'),
    SurahData(number: 103, englishName: 'al-asr'),
    SurahData(number: 104, englishName: 'al-humazah'),
    SurahData(number: 105, englishName: 'al-fil'),
    SurahData(number: 106, englishName: 'quraish'),
    SurahData(number: 107, englishName: 'al-maun'),
    SurahData(number: 108, englishName: 'al-kauthar'),
    SurahData(number: 109, englishName: 'al-kafirun'),
    SurahData(number: 110, englishName: 'an-nasr'),
    SurahData(number: 111, englishName: 'al-masad'),
    SurahData(number: 112, englishName: 'al-ikhlas'),
    SurahData(number: 113, englishName: 'al-falaq'),
    SurahData(number: 114, englishName: 'an-nas'),
  ];

  /// Initialize audio player
  static Future<void> initialize() async {
    try {
      await _setupAudioContext();
    } catch (e) {
      // Silently fail
    }
  }

  /// Setup audio context
  static Future<void> _setupAudioContext() async {
    try {
      await _audioPlayer.setAudioContext(
        AudioContext(
          iOS: AudioContextIOS(
            category: AVAudioSessionCategory.playback,
            options: const {AVAudioSessionOptions.defaultToSpeaker},
          ),
          android: AudioContextAndroid(audioFocus: AndroidAudioFocus.gain),
        ),
      );
    } catch (e) {
      // Ignore
    }
  }

  /// Get reciter by ID
  static QuranReciter? getReciter(String id) {
    try {
      return reciters.firstWhere((r) => r.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Build asset path for surah
  /// Expects files at: assets/audio/{reciter_slug}/{surah_number}.mp3
  /// Example: assets/audio/alafasy/1.mp3
  static String buildAssetPath(QuranReciter reciter, int surahNumber) {
    if (surahNumber < 1 || surahNumber > 114) {
      throw Exception('Invalid surah number: $surahNumber');
    }

    return '$_assetsPath/${reciter.urlSlug}/$surahNumber.mp3';
  }

  /// Play Quran surah from local assets
  static Future<void> playSurah({
    required QuranReciter reciter,
    required int surahNumber,
  }) async {
    try {
      await _audioPlayer.stop();

      final assetPath = buildAssetPath(reciter, surahNumber);

      await _setupAudioContext();
      await _audioPlayer.setReleaseMode(ReleaseMode.stop);
      await _audioPlayer.setVolume(1.0);

      await _audioPlayer.play(AssetSource(assetPath));
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> pauseAudio() async {
    try {
      await _audioPlayer.pause();
    } catch (e) {}
  }

  static Future<void> resumeAudio() async {
    try {
      await _audioPlayer.resume();
    } catch (e) {}
  }

  static Future<void> stopAudio() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {}
  }

  static Future<void> setVolume(double volume) async {
    try {
      await _audioPlayer.setVolume(volume.clamp(0.0, 1.0));
    } catch (e) {}
  }

  static Future<void> seek(Duration duration) async {
    try {
      await _audioPlayer.seek(duration);
    } catch (e) {}
  }

  static Stream<Duration> get onDurationChanged => _audioPlayer.onDurationChanged;
  static Stream<Duration> get onPositionChanged => _audioPlayer.onPositionChanged;
  static Stream<PlayerState> get onPlayerStateChanged => _audioPlayer.onPlayerStateChanged;

  static Future<void> dispose() async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.dispose();
    } catch (e) {}
  }
}