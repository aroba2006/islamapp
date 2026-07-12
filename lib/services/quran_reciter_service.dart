import 'package:audioplayers/audioplayers.dart';

/// Model for Quran Reciter
class QuranReciter {
  final String id;
  final String nameEn;
  final String nameAr;
  final String folderName; // The exact folder path on the server

  const QuranReciter({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.folderName,
  });
}

/// Service to handle Quran audio playback from ONLINE URLs
class QuranReciterService {
  static final _audioPlayer = AudioPlayer();

  // ✅ The rock-solid, official Quran audio CDN
  static const String _baseUrl = 'https://download.quranicaudio.com/quran';

  // ✅ Your 4 reciters with their EXACT folder names from your links
  static const List<QuranReciter> reciters = [
    QuranReciter(
      id: 'afasy',
      nameEn: 'Mishary Rashid Al-Afasy',
      nameAr: 'مشاري راشد العفاسي',
      folderName: 'mishaari_raashid_al_3afaasee',
    ),
    QuranReciter(
      id: 'sudais',
      nameEn: 'Abdul Rahman As-Sudais',
      nameAr: 'عبد الرحمن السديس',
      folderName: 'abdurrahmaan_as-sudays',
    ),
    QuranReciter(
      id: 'muaiqly',
      nameEn: 'Maher Al-Muaiqly',
      nameAr: 'ماهر المعيقلي',
      folderName: 'maher_256', // NOTE: This is the correct folder name from your link
    ),
    QuranReciter(
      id: 'minshawy',
      nameEn: 'Mohamed Siddiq El-Minshawy',
      nameAr: 'محمد صديق المنشاوي',
      folderName: 'muhammad_siddeeq_al-minshaawee',
    ),
  ];

  static Future<void> initialize() async {
    try {
      await _setupAudioContext();
    } catch (e) {
      // Silently fail
    }
  }

  static Future<void> _setupAudioContext() async {
    try {
      await _audioPlayer.setAudioContext(
        AudioContext(
          iOS: AudioContextIOS(
            category: AVAudioSessionCategory.playback,
            options: const {AVAudioSessionOptions.defaultToSpeaker},
          ),
          android: const AudioContextAndroid(audioFocus: AndroidAudioFocus.gain),
        ),
      );
    } catch (e) {
      // Ignore
    }
  }

  static QuranReciter? getReciter(String id) {
    try {
      return reciters.firstWhere((r) => r.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Constructs the exact URL: base/folder/001.mp3
  static String buildAudioUrl(QuranReciter reciter, int surahNumber) {
    if (surahNumber < 1 || surahNumber > 114) {
      throw Exception('Invalid surah number: $surahNumber');
    }

    // Zero-pad the number (1 becomes 001, 18 becomes 018, 114 becomes 114)
    String fileName = '${surahNumber.toString().padLeft(3, '0')}.mp3';

    return '$_baseUrl/${reciter.folderName}/$fileName';
  }

  /// Play Quran surah from URL
  static Future<void> playSurah({
    required QuranReciter reciter,
    required int surahNumber,
  }) async {
    try {
      await _audioPlayer.stop();

      final audioUrl = buildAudioUrl(reciter, surahNumber);

      await _setupAudioContext();
      await _audioPlayer.setReleaseMode(ReleaseMode.stop);
      await _audioPlayer.setVolume(1.0);

      // Use UrlSource to stream from the CDN
      await _audioPlayer.play(UrlSource(audioUrl));
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