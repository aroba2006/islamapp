import 'dart:io';
import 'dart:ui' show Color;

import 'package:audioplayers/audioplayers.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

/// Model for Quran Reciter
class QuranReciter {
  final String id;
  final String nameEn;
  final String nameAr;
  final String folderName;
  final String? customBaseUrl;
  final String imageFileName;

  const QuranReciter({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.folderName,
    this.customBaseUrl,
    required this.imageFileName,
  });
}

/// Service to handle Quran audio playback with background support
class QuranReciterService {
  static final QuranReciterService _instance = QuranReciterService._internal();
  static AudioHandler? _audioHandler;
  static final _audioPlayer = AudioPlayer();
  static bool _isInitialized = false;

  factory QuranReciterService() {
    return _instance;
  }

  QuranReciterService._internal();

  static const String _defaultBaseUrl = 'https://download.quranicaudio.com/quran';

  static const List<QuranReciter> reciters = [
    QuranReciter(
      id: 'minshawy',
      nameEn: 'Mohamed Siddiq El-Minshawy (Morattal)',
      nameAr: 'محمد صديق المنشاوي (مرتل)',
      folderName: 'minsh',
      customBaseUrl: 'https://server10.mp3quran.net',
      imageFileName: 'minshawi.jpg',
    ),
    QuranReciter(
      id: 'minshawy_mujawwad',
      nameEn: 'Mohamed Siddiq El-Minshawy (Mujawwad)',
      nameAr: 'محمد صديق المنشاوي (مجود)',
      folderName: 'minsh/Almusshaf-Al-Mojawwad',
      customBaseUrl: 'https://server10.mp3quran.net',
      imageFileName: 'minshawi(taj).jpg',
    ),
    QuranReciter(
      id: 'abdulbasit_murattal',
      nameEn: 'Abdul Basit Abdul Samad (Murattal)',
      nameAr: 'عبد الباسط عبد الصمد (مرتل)',
      folderName: 'basit',
      customBaseUrl: 'https://server7.mp3quran.net',
      imageFileName: 'basset.jpg',
    ),
    QuranReciter(
      id: 'abdulbasit_mujawwad',
      nameEn: 'Abdul Basit Abdul Samad (Mujawwad)',
      nameAr: 'عبد الباسط عبد الصمد (مجود)',
      folderName: 'basit/Almusshaf-Al-Mojawwad',
      customBaseUrl: 'https://server7.mp3quran.net',
      imageFileName: 'basset(taj).jpg',
    ),
    QuranReciter(
      id: 'mahmoud_albanna',
      nameEn: 'Mahmoud Ali Al-Banna',
      nameAr: 'محمود علي البنا',
      folderName: 'bna',
      customBaseUrl: 'https://server8.mp3quran.net',
      imageFileName: 'banna.jpg',
    ),
    QuranReciter(
      id: 'husary',
      nameEn: 'Mahmoud Khalil Al-Husary',
      nameAr: 'محمود خليل الحصري',
      folderName: 'husr',
      customBaseUrl: 'https://server13.mp3quran.net',
      imageFileName: 'hosari.jpg',
    ),
    QuranReciter(
      id: 'afasy',
      nameEn: 'Mishary Rashid Al-Afasy',
      nameAr: 'مشاري راشد العفاسي',
      folderName: 'afs',
      customBaseUrl: 'https://server8.mp3quran.net',
      imageFileName: 'afasi.jpg',
    ),
    QuranReciter(
      id: 'sudais',
      nameEn: 'Abdul Rahman As-Sudais',
      nameAr: 'عبد الرحمن السديس',
      folderName: 'sds',
      customBaseUrl: 'https://server11.mp3quran.net',
      imageFileName: 'sudais.jpg',
    ),
    QuranReciter(
      id: 'muaiqly',
      nameEn: 'Maher Al-Muaiqly',
      nameAr: 'ماهر المعيقلي',
      folderName: 'maher',
      customBaseUrl: 'https://server12.mp3quran.net',
      imageFileName: 'maeqly.jpg',
    ),
    QuranReciter(
      id: 'yasser_dosari',
      nameEn: 'Yasser Al-Dosari',
      nameAr: 'ياسر الدوسري',
      folderName: 'yasser',
      customBaseUrl: 'https://server11.mp3quran.net',
      imageFileName: 'dosari.jpg',
    ),
    QuranReciter(
      id: 'nasser_qattami',
      nameEn: 'Nasser Al-Qattami',
      nameAr: 'ناصر القطامي',
      folderName: 'qtm',
      customBaseUrl: 'https://server6.mp3quran.net',
      imageFileName: 'qatami.jpg',
    ),
    QuranReciter(
      id: 'alijaber',
      nameEn: 'Ali Jaber',
      nameAr: 'علي جابر',
      folderName: 'a_jbr',
      customBaseUrl: 'https://server11.mp3quran.net',
      imageFileName: 'alijaber.jpg',
    ),
    QuranReciter(
      id: 'ajmi',
      nameEn: 'Ahmed Al-Ajmi',
      nameAr: 'أحمد بن علي العجمي',
      folderName: 'ajm',
      customBaseUrl: 'https://server10.mp3quran.net',
      imageFileName: 'ajami.jpg',
    ),
    QuranReciter(
      id: 'shatri',
      nameEn: 'Abu Bakr Al-Shatri',
      nameAr: 'أبو بكر الشاطري',
      folderName: 'shatri',
      customBaseUrl: 'https://server11.mp3quran.net',
      imageFileName: 'shatri.jpg',
    ),
    QuranReciter(
      id: 'saad_al_ghamdi',
      nameEn: 'Saad Al-Ghamdi',
      nameAr: 'سعد الغامدي',
      folderName: 's_gmd',
      customBaseUrl: 'https://server7.mp3quran.net',
      imageFileName: 'ghamdi.jpg',
    ),
  ];

  /// Fallback artwork when a reciter has no image. Must be listed in pubspec.yaml assets.
  static const String _logoAsset = 'assets/images/app_logo.png'; // <-- change to your logo path
  static const String _reciterImagesDir = 'assets/images/reciters/';
  static final Map<String, Uri> _artCache = {};

  /// Copies an asset image to a temp file (notifications can't read Flutter assets).
  static Future<Uri?> _assetToFileUri(String assetPath, String cacheKey, String ext) async {
    final cached = _artCache[cacheKey];
    if (cached != null) return cached;
    try {
      final data = await rootBundle.load(assetPath);
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/quran_art_$cacheKey$ext');
      await file.writeAsBytes(data.buffer.asUint8List(), flush: true);
      final uri = Uri.file(file.path);
      _artCache[cacheKey] = uri;
      return uri;
    } catch (e) {
      print('Error preparing notification art ($assetPath): $e');
      return null;
    }
  }

  /// Reciter photo first, app logo as fallback.
  static Future<Uri?> _prepareArt(QuranReciter reciter) async {
    final dot = reciter.imageFileName.lastIndexOf('.');
    final ext = dot >= 0 ? reciter.imageFileName.substring(dot) : '.jpg';
    final photo = await _assetToFileUri(
      '$_reciterImagesDir${reciter.imageFileName}',
      reciter.id,
      ext,
    );
    if (photo != null) return photo;
    return _assetToFileUri(_logoAsset, 'app_logo', '.png');
  }

  /// Initialize audio service for background playback
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await _setupAudioContext();
      
      // Initialize audio_service for background playback
      _audioHandler = await AudioService.init(
        builder: () => _QuranAudioHandler(_audioPlayer),
        config: const AudioServiceConfig(
          androidNotificationChannelId: 'com.islamy.quran.audio',
          androidNotificationChannelName: 'Quran Audio',
          androidNotificationOngoing: false,
          androidStopForegroundOnPause: false,
          notificationColor: Color(0xFFD4AF37),
        ),
      );
      
      _isInitialized = true;
      print('QuranReciterService: notification init OK');
    } catch (e) {
      print('Error initializing QuranReciterService: $e');
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
      print('Error setting up audio context: $e');
    }
  }

  static QuranReciter? getReciter(String id) {
    try {
      return reciters.firstWhere((r) => r.id == id);
    } catch (e) {
      return null;
    }
  }

  static String buildAudioUrl(QuranReciter reciter, int surahNumber) {
    if (surahNumber < 1 || surahNumber > 114) {
      throw Exception('Invalid surah number: $surahNumber');
    }

    String fileName = '${surahNumber.toString().padLeft(3, '0')}.mp3';
    String base = reciter.customBaseUrl ?? _defaultBaseUrl;

    return '$base/${reciter.folderName}/$fileName';
  }

  /// Play Quran surah - works in background!
  static Future<void> playSurah({
    required QuranReciter reciter,
    required int surahNumber,
    String surahNameAr = 'Quran',
    String reciterName = 'Reciter',
  }) async {
    try {
      if (!_isInitialized) await initialize();
      await _setupAudioContext();
      final audioUrl = buildAudioUrl(reciter, surahNumber);

      await _audioPlayer.stop();
      await _audioPlayer.setReleaseMode(ReleaseMode.stop);
      await _audioPlayer.setVolume(1.0);
      await _audioPlayer.play(UrlSource(audioUrl));

      // Update notification
      if (_audioHandler != null) {
        final mediaItem = MediaItem(
          id: '$surahNumber',
          title: surahNameAr,
          artist: reciterName,
          artUri: await _prepareArt(reciter),
        );
        await _audioHandler!.customAction('updateMediaItem', {'mediaItem': mediaItem});
      }
    } catch (e) {
      print('Error playing surah: $e');
      rethrow;
    }
  }

  static Future<void> pauseAudio() async {
    try {
      await _audioPlayer.pause();
      if (_audioHandler != null) {
        await _audioHandler!.pause();
      }
    } catch (e) {
      print('Error pausing: $e');
    }
  }

  static Future<void> resumeAudio() async {
    try {
      await _audioPlayer.resume();
      if (_audioHandler != null) {
        await _audioHandler!.play();
      }
    } catch (e) {
      print('Error resuming: $e');
    }
  }

  static Future<void> stopAudio() async {
    try {
      await _audioPlayer.stop();
      if (_audioHandler != null) {
        await _audioHandler!.stop();
      }
    } catch (e) {
      print('Error stopping: $e');
    }
  }

  static Future<void> setVolume(double volume) async {
    try {
      await _audioPlayer.setVolume(volume.clamp(0.0, 1.0));
    } catch (e) {
      print('Error setting volume: $e');
    }
  }

  static Future<void> seek(Duration duration) async {
    try {
      await _audioPlayer.seek(duration);
      if (_audioHandler != null) {
        await _audioHandler!.seek(duration);
      }
    } catch (e) {
      print('Error seeking: $e');
    }
  }

  static Stream<Duration> get onDurationChanged => _audioPlayer.onDurationChanged;
  static Stream<Duration> get onPositionChanged => _audioPlayer.onPositionChanged;
  static Stream<PlayerState> get onPlayerStateChanged => _audioPlayer.onPlayerStateChanged;

  static Future<void> dispose() async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.dispose();
      if (_audioHandler != null) {
        await _audioHandler!.stop();
      }
    } catch (e) {
      print('Error disposing: $e');
    }
  }
}

/// Audio handler for background playback
class _QuranAudioHandler extends BaseAudioHandler {
  final AudioPlayer _audioPlayer;
  PlayerState _state = PlayerState.stopped;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  _QuranAudioHandler(this._audioPlayer) {
    _setupListeners();
  }

  void _setupListeners() {
    _audioPlayer.onDurationChanged.listen((duration) {
      _duration = duration;
      final item = mediaItem.value;
      if (item != null) mediaItem.add(item.copyWith(duration: duration));
    });

    _audioPlayer.onPositionChanged.listen((position) {
      _position = position;
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      _state = state;
      if (state == PlayerState.stopped) {
        _position = Duration.zero;
        _duration = Duration.zero;
      }
      _broadcast();
    });
  }

  void _broadcast() {
    final playing = _state == PlayerState.playing;
    playbackState.add(PlaybackState(
      controls: [
        MediaControl.rewind,
        playing ? MediaControl.pause : MediaControl.play,
        MediaControl.fastForward,
        MediaControl.stop,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 2],
      processingState: _mapPlayerState(_state),
      playing: playing,
      updatePosition: _position,
      speed: 1.0,
    ));
  }

  AudioProcessingState _mapPlayerState(PlayerState state) {
    switch (state) {
      case PlayerState.playing:
      case PlayerState.paused:
        return AudioProcessingState.ready;
      case PlayerState.completed:
        return AudioProcessingState.completed;
      case PlayerState.stopped:
      case PlayerState.disposed:
        return AudioProcessingState.idle;
    }
  }

  @override
  Future<void> play() async {
    await _audioPlayer.resume();
  }

  @override
  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  @override
  Future<void> stop() async {
    await _audioPlayer.stop();
    await super.stop();
  }

  @override
  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
    _position = position;
    _broadcast();
  }

  @override
  Future<void> fastForward() => seek(_position + const Duration(seconds: 10));

  @override
  Future<void> rewind() {
    final target = _position - const Duration(seconds: 10);
    return seek(target < Duration.zero ? Duration.zero : target);
  }

  @override
  Future<dynamic> customAction(String name, [dynamic args]) async {
    if (name == 'updateMediaItem' && args is Map && args['mediaItem'] is MediaItem) {
      final item = args['mediaItem'] as MediaItem;
      mediaItem.add(_duration > Duration.zero ? item.copyWith(duration: _duration) : item);
      _broadcast();
      return null;
    }
    return super.customAction(name, args);
  }
}