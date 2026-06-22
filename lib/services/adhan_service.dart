import 'package:audioplayers/audioplayers.dart';
import 'dart:io';

class AdhanService {
  static final _audioPlayer = AudioPlayer();

  static const Map<String, String> adhanAssetPaths = {
    'mishary': 'adhan/afasiadhan.mp3',
    'nasser':  'adhan/qatamiadhan.mp3',
    'qassas':  'adhan/moqassas.mp3',
    'refaat': 'adhan/refaatadhan.mp3',
    'tobar': 'adhan/adhantobar.mp3',
  };

  static final Map<String, String> reciterNames = {
    'mishary': 'Mishary Al-Afasi',
    'nasser':  'Nasser Al-Qattami',
    'qassas':  'Mohamed Marawan Qassas',
    'refaat': 'Mohamed Refaat',
    'tobar': 'Nasraldin Tobar',
  };

  /// Initialize audio player - call this once at app startup
  static Future<void> initialize() async {
    try {
      await _setupAudioContext();
    } catch (e) {
      // Silently fail - audio may still work
    }
  }

  /// Setup audio context for both iOS and Android
  static Future<void> _setupAudioContext() async {
    try {
      if (Platform.isIOS) {
        await _audioPlayer.setAudioContext(
          AudioContext(
            iOS: AudioContextIOS(
              category: AVAudioSessionCategory.playback,
              options: const {
                AVAudioSessionOptions.defaultToSpeaker,
              },
            ),
          ),
        );
      } else if (Platform.isAndroid) {
        await _audioPlayer.setAudioContext(
          AudioContext(
            android: const AudioContextAndroid(
              audioFocus: AndroidAudioFocus.gain,
            ),
          ),
        );
      }
    } catch (e) {
      // Ignore errors during context setup
    }
  }

  static Future<void> playAdhan(String reciterId) async {
    try {
      // Stop any currently playing audio
      await _audioPlayer.stop();

      // Verify reciter ID is valid
      final path = adhanAssetPaths[reciterId];
      if (path == null) {
        throw Exception('Invalid reciter ID: $reciterId');
      }

      // Ensure audio context is set
      await _setupAudioContext();

      // Set audio parameters
      await _audioPlayer.setReleaseMode(ReleaseMode.stop);
      await _audioPlayer.setVolume(1.0);

      // Play the asset
      await _audioPlayer.play(AssetSource(path));
      
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> stopAdhan() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      // Ignore
    }
  }

  static Future<void> pauseAdhan() async {
    try {
      await _audioPlayer.pause();
    } catch (e) {
      // Ignore
    }
  }

  static Future<void> resumeAdhan() async {
    try {
      await _audioPlayer.resume();
    } catch (e) {
      // Ignore
    }
  }

  /// Get current playback state
  static Stream<Duration> get onDurationChanged => _audioPlayer.onDurationChanged;
  static Stream<Duration> get onPositionChanged => _audioPlayer.onPositionChanged;
  static Stream<PlayerState> get onPlayerStateChanged =>
      _audioPlayer.onPlayerStateChanged;

  static Future<void> dispose() async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.dispose();
    } catch (e) {
      // Ignore
    }
  }
}