import 'package:audioplayers/audioplayers.dart';

class AdhanService {
  static final _audioPlayer = AudioPlayer();

  static const Map<String, String> adhanAssetPaths = {
    'mishary': 'adhan/afasiadhan.mpeg',
    'nasser':  'adhan/qatamiadhan.mpeg',
    'qassas' : 'adhan/moqassas.mpeg'
  };

  static final Map<String, String> reciterNames = {
    'mishary': 'Mishary Al-Afasi',
    'nasser':  'Nasser Al-Qattami',
    'qassas' : 'Mohamed Marawan Qassas'
  };

  static Future<void> playAdhan(String reciterId) async {
    try {
      await _audioPlayer.stop();

      final path = adhanAssetPaths[reciterId] ?? adhanAssetPaths['mishary']!;

      await _audioPlayer.setReleaseMode(ReleaseMode.stop);
      await _audioPlayer.play(AssetSource(path));
    } catch (e) {
      // Silent catch for production
    }
  }

  static Future<void> stopAdhan() async {
    try {
      await _audioPlayer.stop();
    } catch (e) { //ignore error
    }
  }

  static Future<void> pauseAdhan() async {
    try {
      await _audioPlayer.pause();
    } catch (e) { //ignore error
    }
  }

  static Future<void> resumeAdhan() async {
    try {
      await _audioPlayer.resume();
    } catch (e) { //ignore error
    }
  }

  static Stream<Duration> get onDurationChanged => _audioPlayer.onDurationChanged;
  static Stream<Duration> get onPositionChanged => _audioPlayer.onPositionChanged;
  static Stream<PlayerState> get onPlayerStateChanged =>
      _audioPlayer.onPlayerStateChanged;

  static Future<void> dispose() async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.dispose();
    } catch (e) { //ignore error
    }
  }
}