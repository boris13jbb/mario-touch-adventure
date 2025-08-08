import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Professional audio manager for game sound effects and music
class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;
  AudioManager._internal();

  // Audio players
  final AudioPlayer _musicPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();
  
  // State
  bool _isInitialized = false;
  bool _soundEnabled = true;
  bool _musicEnabled = true;
  double _musicVolume = 0.7;
  double _sfxVolume = 0.8;
  
  // Background music
  String? _currentMusic;
  bool _isMusicPlaying = false;
  
  /// Initialize audio system
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Set up music player
      await _musicPlayer.setReleaseMode(ReleaseMode.loop);
      await _musicPlayer.setVolume(_musicVolume);
      
      // Set up SFX player
      await _sfxPlayer.setReleaseMode(ReleaseMode.stop);
      await _sfxPlayer.setVolume(_sfxVolume);
      
      _isInitialized = true;
      debugPrint('AudioManager initialized successfully');
    } catch (e) {
      debugPrint('Error initializing AudioManager: $e');
    }
  }
  
  /// Play background music
  Future<void> playMusic(String assetPath) async {
    if (!_isInitialized || !_musicEnabled || _currentMusic == assetPath) return;
    
    try {
      await _musicPlayer.stop();
      await _musicPlayer.play(AssetSource(assetPath));
      _currentMusic = assetPath;
      _isMusicPlaying = true;
    } catch (e) {
      debugPrint('Error playing music: $e');
    }
  }
  
  /// Stop background music
  Future<void> stopMusic() async {
    if (!_isInitialized) return;
    
    try {
      await _musicPlayer.stop();
      _currentMusic = null;
      _isMusicPlaying = false;
    } catch (e) {
      debugPrint('Error stopping music: $e');
    }
  }
  
  /// Pause background music
  Future<void> pauseMusic() async {
    if (!_isInitialized || !_isMusicPlaying) return;
    
    try {
      await _musicPlayer.pause();
    } catch (e) {
      debugPrint('Error pausing music: $e');
    }
  }
  
  /// Resume background music
  Future<void> resumeMusic() async {
    if (!_isInitialized || !_musicEnabled || !_isMusicPlaying) return;
    
    try {
      await _musicPlayer.resume();
    } catch (e) {
      debugPrint('Error resuming music: $e');
    }
  }
  
  /// Play sound effect
  Future<void> playSfx(String assetPath) async {
    if (!_isInitialized || !_soundEnabled) return;
    
    try {
      await _sfxPlayer.play(AssetSource(assetPath));
    } catch (e) {
      debugPrint('Error playing SFX: $e');
    }
  }
  
  /// Play coin collection sound
  Future<void> playCoinSound() async {
    await playSfx('audio/coin_collect.mp3');
  }
  
  /// Play jump sound
  Future<void> playJumpSound() async {
    await playSfx('audio/jump.mp3');
  }
  
  /// Play attack sound
  Future<void> playAttackSound() async {
    await playSfx('audio/attack.mp3');
  }
  
  /// Play enemy defeat sound
  Future<void> playEnemyDefeatSound() async {
    await playSfx('audio/enemy_defeat.mp3');
  }
  
  /// Play level complete sound
  Future<void> playLevelCompleteSound() async {
    await playSfx('audio/level_complete.mp3');
  }
  
  /// Play game over sound
  Future<void> playGameOverSound() async {
    await playSfx('audio/game_over.mp3');
  }
  
  /// Play button click sound
  Future<void> playButtonClickSound() async {
    await playSfx('audio/button_click.mp3');
  }
  
  /// Play achievement unlock sound
  Future<void> playAchievementSound() async {
    await playSfx('audio/achievement.mp3');
  }
  
  /// Update settings
  void updateSettings({
    bool? soundEnabled,
    bool? musicEnabled,
    double? musicVolume,
    double? sfxVolume,
  }) {
    if (soundEnabled != null) _soundEnabled = soundEnabled;
    if (musicEnabled != null) {
      _musicEnabled = musicEnabled;
      if (!_musicEnabled) {
        pauseMusic();
      } else if (_isMusicPlaying) {
        resumeMusic();
      }
    }
    if (musicVolume != null) {
      _musicVolume = musicVolume;
      _musicPlayer.setVolume(_musicVolume);
    }
    if (sfxVolume != null) {
      _sfxVolume = sfxVolume;
      _sfxPlayer.setVolume(_sfxVolume);
    }
  }
  
  /// Get current settings
  Map<String, dynamic> getSettings() {
    return {
      'soundEnabled': _soundEnabled,
      'musicEnabled': _musicEnabled,
      'musicVolume': _musicVolume,
      'sfxVolume': _sfxVolume,
    };
  }
  
  /// Dispose resources
  Future<void> dispose() async {
    try {
      await _musicPlayer.dispose();
      await _sfxPlayer.dispose();
      _isInitialized = false;
    } catch (e) {
      debugPrint('Error disposing AudioManager: $e');
    }
  }
}
