/// WordNest Asset Paths — centralized asset path constants
class AppAssets {
  AppAssets._();

  // === Image Directories ===
  static const String _imagesBase = 'assets/images';
  static const String backgrounds = '$_imagesBase/backgrounds';
  static const String mascot = '$_imagesBase/mascot';
  static const String map = '$_imagesBase/map';
  static const String icons = '$_imagesBase/icons';
  static const String patterns = '$_imagesBase/patterns';

  // === Audio Directories ===
  static const String _audioBase = 'assets/audio';
  static const String bgm = '$_audioBase/bgm';
  static const String sfx = '$_audioBase/sfx';

  // Specific Audio Assets
  static const String bgmNature = '$bgm/nature.wav';
  static const String sfxWordFound = '$sfx/word_found.wav';
  static const String sfxTap = '$sfx/tap.wav';
  static const String sfxLevelComplete = '$sfx/level_complete.wav';
  static const String sfxWrong = '$sfx/wrong.wav';
  static const String sfxCoin = '$sfx/coin.wav';
  static const String sfxBirdChirp = '$sfx/bird_chirp.wav';

  // === Animation Directory ===
  static const String animations = 'assets/animations';

  // === Data Directory ===
  static const String _dataBase = 'assets/data';
  static const String levels = '$_dataBase/levels';

  // Level data files
  static String levelFile(String division) => '$levels/$division.json';
}
