import 'package:audioplayers/audioplayers.dart';

/// Model for Quran Reciter
class QuranReciter {
  final String id;
  final String nameEn;
  final String nameAr;
  final String assetFolder; 
  final Map<int, String> fileNames; // UPGRADED: Now holds multiple files mapped to Surah IDs

  const QuranReciter({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.assetFolder,
    required this.fileNames,
  });
}

/// Service to handle Quran audio playback from LOCAL ASSETS
class QuranReciterService {
  static final _audioPlayer = AudioPlayer();

  // Base path for Quran audio files
  static const String _basePath = 'reciters';

  // List of available reciters matching YOUR exact file structure
  static const List<QuranReciter> reciters = [
    QuranReciter(
      id: 'afasi',
      nameEn: 'Mishary Rashid Al-Afasy',
      nameAr: 'مشاري راشد العفاسي',
      assetFolder: 'afasi',
      fileNames: {
        1: 'alfatihah-afasi.mp3',
       99: 'alzalzalah-afasi.mp3', // <-- UPDATE THIS TO YOUR EXACT FILE NAME
      },
    ),
    QuranReciter(
      id: 'sudais',
      nameEn: 'Abdul Rahman As-Sudais',
      nameAr: 'عبد الرحمن السديس',
      assetFolder: 'sudais',
      fileNames: {
        1: 'alfatihah-sudais.mp3',
       99: 'alzalzalah-sudais.mp3', // <-- UPDATE THIS TO YOUR EXACT FILE NAME
      },
    ),
    QuranReciter(
      id: 'muaiqly',
      nameEn: 'Maher Al-Muaiqly',
      nameAr: 'ماهر المعيقلي',
      assetFolder: 'muaiqly',
      fileNames: {
        1: 'alfatihah-mieqly.mp3',
        99: 'alzalzalah-maiq.mp3', // <-- UPDATE THIS TO YOUR EXACT FILE NAME
      },
    ),
    QuranReciter(
      id: 'minshawy',
      nameEn: 'Mohamed Siddiq El-Minshawy',
      nameAr: 'محمد صديق المنشاوي',
      assetFolder: 'minshawy',
      fileNames: {
        1: 'alfatihah-minshawy.mp3',
       99: 'alzalzalaah-minshawy.mp3', // <-- UPDATE THIS TO YOUR EXACT FILE NAME
      },
    ),
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
          android: const AudioContextAndroid(audioFocus: AndroidAudioFocus.gain),
        ),
      );
    } catch (e) {
      // Ignore - not all platforms support audio context
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

  /// Build asset path for surah using the fileNames map
  static String buildAssetPath(QuranReciter reciter, int surahNumber) {
    if (surahNumber < 1 || surahNumber > 114) {
      throw Exception('Invalid surah number: $surahNumber');
    }

    // Check if we have the file for this specific Surah
    if (reciter.fileNames.containsKey(surahNumber)) {
      final fileName = reciter.fileNames[surahNumber]!;
      return '$_basePath/${reciter.assetFolder}/$fileName';
    }

    // If the Surah isn't in our map, throw an error so the UI knows
    throw Exception('Surah $surahNumber not yet available for ${reciter.nameEn}.');
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

      // Use AssetSource with explicit MIME type for MP3
      await _audioPlayer.play(
        AssetSource(
          assetPath,
          mimeType: 'audio/mpeg',
        ),
      );
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