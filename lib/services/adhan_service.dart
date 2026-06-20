import 'package:audioplayers/audioplayers.dart';

class AdhanService {
  static final _audioPlayer = AudioPlayer();

  static const Map<String, String> adhanAssetPaths = {
    'mishary': 'assets/adhan/mishary_adhan.mp3',    // Fix path
    'nasser':  'assets/adhan/nasser_adhan.mp3',     // Fix path
    'qassas':  'assets/adhan/qassas_adhan.mp3'      // Fix path
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

      await _audioPlayer.setReleaseMode(ReleaseMode.stop);
      await _audioPlayer.play(AssetSource(path));
    } catch (e) {
      print('Adhan play error: $e');
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