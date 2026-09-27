import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import '../constants/assets.dart';
import '../../data/local/hive_service.dart';

/// অডিও সার্ভিস — Audio Service
/// Controls background music (BGM) and sound effects (SFX) with volume and mute toggles
class AudioService {
  static final AudioPlayer _bgmPlayer = AudioPlayer();
  static final AudioPlayer _sfxPlayer = AudioPlayer();

  static bool _isBgmPlaying = false;

  /// Initialize audio settings
  static Future<void> init() async {
    _bgmPlayer.setReleaseMode(ReleaseMode.loop);
  }

  /// Play background music (flute/folk/nature)
  static Future<void> playBgm({String asset = AppAssets.bgmNature}) async {
    if (!HiveService.isMusicEnabled) return;
    try {
      if (!_isBgmPlaying) {
        final path = asset.startsWith('assets/') ? asset.substring(7) : asset;
        await _bgmPlayer.play(AssetSource(path), volume: 0.5);
        _isBgmPlaying = true;
      }
    } catch (e) {
      debugPrint('BGM error: $e');
    }
  }

  /// Stop background music
  static Future<void> stopBgm() async {
    try {
      await _bgmPlayer.stop();
      _isBgmPlaying = false;
    } catch (_) {}
  }

  /// Play sound effects safely
  static Future<void> playSfx(String assetPath) async {
    if (!HiveService.isSoundEnabled) return;
    try {
      final path = assetPath.startsWith('assets/') ? assetPath.substring(7) : assetPath;
      await _sfxPlayer.stop();
      await _sfxPlayer.play(
        AssetSource(path),
        volume: 1.0,
      );
    } catch (e) {
      debugPrint('SFX error: $e');
    }
  }

  /// Word found chime
  static Future<void> playWordFound() => playSfx(AppAssets.sfxWordFound);

  /// Letter selected tap
  static Future<void> playLetterTap() => playSfx(AppAssets.sfxTap);

  /// Level complete celebratory fanfare
  static Future<void> playLevelComplete() => playSfx(AppAssets.sfxLevelComplete);

  /// Wrong selection buzz
  static Future<void> playWrong() => playSfx(AppAssets.sfxWrong);

  /// Coin earned jingling sound
  static Future<void> playCoin() => playSfx(AppAssets.sfxCoin);

  /// Bird chirp mascot sound
  static Future<void> playBirdChirp() => playSfx(AppAssets.sfxBirdChirp);
}
