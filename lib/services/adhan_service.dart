import 'package:audioplayers/audioplayers.dart';
import 'dart:io';

class AdhanService {
  static final _audioPlayer = AudioPlayer();

  static const Map<String, String> adhanAssetPaths = {
    'mishary': 'assets/adhan/mishary_adhan.mp3',
    'nasser':  'assets/adhan/nasser_adhan.mp3',
    'qassas':  'assets/adhan/qassas_adhan.mp3'
  };

  static final Map<String, String> reciterNames = {
    'mishary': 'Mishary Al-Afasi',
    'nasser':  'Nasser Al-Qattami',
    'qassas':  'Mohamed Marawan Qassas'
  };

  static Future<void> playAdhan(String reciterId) async {
    try {
      await _audioPlayer.stop();

      final path = adhanAssetPaths[reciterId] ?? adhanAssetPaths['mishary']!;
      
      // iOS specific: set audio session
      if (Platform.isIOS) {
        await _audioPlayer.setAudioContext(
          AudioContext(
            iOS: AudioContextIOS(
              category: AVAudioSessionCategory.playback,
              options: const {
                AVAudioSessionOptions.defaultToSpeaker,
                AVAudioSessionOptions.duckOthers,
              },
            ),
          ),
        );
      }

      await _audioPlayer.setReleaseMode(ReleaseMode.stop);
      await _audioPlayer.setVolume(1.0);
      
      await _audioPlayer.play(AssetSource(path));
      
    } catch (e) {
      print('❌ Error: $e');
    }
  }

  static Future<void> stopAdhan() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {}
  }

  static Future<void> pauseAdhan() async {
    try {
      await _audioPlayer.pause();
    } catch (e) {}
  }

  static Future<void> resumeAdhan() async {
    try {
      await _audioPlayer.resume();
    } catch (e) {}
  }

  static Stream<Duration> get onDurationChanged => _audioPlayer.onDurationChanged;
  static Stream<Duration> get onPositionChanged => _audioPlayer.onPositionChanged;
  static Stream<PlayerState> get onPlayerStateChanged =>
      _audioPlayer.onPlayerStateChanged;

  static Future<void> dispose() async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.dispose();
    } catch (e) {}
  }
}