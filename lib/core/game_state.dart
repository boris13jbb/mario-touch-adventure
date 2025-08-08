import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Professional game state management with persistence
class GameState extends ChangeNotifier {
  static const String _prefsKey = 'mario_touch_adventure_state';
  
  // Player progress
  int _currentLevel = 1;
  int _maxLevelUnlocked = 1;
  int _totalScore = 0;
  int _totalCoins = 0;
  int _totalLives = 3;
  int _gamesPlayed = 0;
  int _gamesWon = 0;
  
  // Current game state
  int _currentScore = 0;
  int _currentCoins = 0;
  int _currentLives = 3;
  bool _isGameActive = false;
  bool _isPaused = false;
  
  // Achievements and statistics
  Map<String, dynamic> _achievements = {};
  Map<String, int> _statistics = {
    'total_play_time': 0,
    'coins_collected': 0,
    'enemies_defeated': 0,
    'levels_completed': 0,
    'perfect_levels': 0,
  };
  
  // Settings
  bool _soundEnabled = true;
  bool _musicEnabled = true;
  bool _vibrationEnabled = true;
  double _gameSpeed = 1.0;
  
  // Getters
  int get currentLevel => _currentLevel;
  int get maxLevelUnlocked => _maxLevelUnlocked;
  int get totalScore => _totalScore;
  int get totalCoins => _totalCoins;
  int get totalLives => _totalLives;
  int get gamesPlayed => _gamesPlayed;
  int get gamesWon => _gamesWon;
  int get currentScore => _currentScore;
  int get currentCoins => _currentCoins;
  int get currentLives => _currentLives;
  bool get isGameActive => _isGameActive;
  bool get isPaused => _isPaused;
  Map<String, dynamic> get achievements => _achievements;
  Map<String, int> get statistics => _statistics;
  bool get soundEnabled => _soundEnabled;
  bool get musicEnabled => _musicEnabled;
  bool get vibrationEnabled => _vibrationEnabled;
  double get gameSpeed => _gameSpeed;
  
  /// Initialize game state from persistent storage
  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stateJson = prefs.getString(_prefsKey);
      
      if (stateJson != null) {
        final state = json.decode(stateJson);
        _loadFromMap(state);
      }
    } catch (e) {
      debugPrint('Error loading game state: $e');
    }
  }
  
  /// Save current state to persistent storage
  Future<void> saveState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stateJson = json.encode(_toMap());
      await prefs.setString(_prefsKey, stateJson);
    } catch (e) {
      debugPrint('Error saving game state: $e');
    }
  }
  
  /// Start a new game
  void startNewGame() {
    _currentScore = 0;
    _currentCoins = 0;
    _currentLives = 3;
    _isGameActive = true;
    _isPaused = false;
    _gamesPlayed++;
    notifyListeners();
  }
  
  /// Pause/unpause the game
  void togglePause() {
    _isPaused = !_isPaused;
    notifyListeners();
  }
  
  /// Add score points
  void addScore(int points) {
    _currentScore += points;
    _totalScore += points;
    _checkAchievements();
    notifyListeners();
  }
  
  /// Collect a coin
  void collectCoin() {
    _currentCoins++;
    _totalCoins++;
    _statistics['coins_collected'] = (_statistics['coins_collected'] ?? 0) + 1;
    addScore(10);
    notifyListeners();
  }
  
  /// Defeat an enemy
  void defeatEnemy() {
    _statistics['enemies_defeated'] = (_statistics['enemies_defeated'] ?? 0) + 1;
    addScore(25);
    notifyListeners();
  }
  
  /// Lose a life
  void loseLife() {
    if (_currentLives > 0) {
      _currentLives--;
      _totalLives--;
      if (_currentLives <= 0) {
        _gameOver();
      }
      notifyListeners();
    }
  }
  
  /// Complete a level
  void completeLevel() {
    _statistics['levels_completed'] = (_statistics['levels_completed'] ?? 0) + 1;
    
    // Check for perfect level (no lives lost)
    if (_currentLives == 3) {
      _statistics['perfect_levels'] = (_statistics['perfect_levels'] ?? 0) + 1;
    }
    
    // Unlock next level if needed
    if (_currentLevel >= _maxLevelUnlocked) {
      _maxLevelUnlocked = _currentLevel + 1;
    }
    
    _currentLevel++;
    notifyListeners();
  }
  
  /// Game over
  void _gameOver() {
    _isGameActive = false;
    if (_currentLevel > 1) {
      _gamesWon++;
    }
    notifyListeners();
  }
  
  /// Set current level
  void setLevel(int level) {
    if (level <= _maxLevelUnlocked) {
      _currentLevel = level;
      notifyListeners();
    }
  }
  
  /// Update settings
  void updateSettings({
    bool? soundEnabled,
    bool? musicEnabled,
    bool? vibrationEnabled,
    double? gameSpeed,
  }) {
    if (soundEnabled != null) _soundEnabled = soundEnabled;
    if (musicEnabled != null) _musicEnabled = musicEnabled;
    if (vibrationEnabled != null) _vibrationEnabled = vibrationEnabled;
    if (gameSpeed != null) _gameSpeed = gameSpeed;
    notifyListeners();
  }
  
  /// Check and unlock achievements
  void _checkAchievements() {
    // First coin achievement
    if (_totalCoins == 1 && !_achievements.containsKey('first_coin')) {
      _achievements['first_coin'] = {
        'name': 'Primera Moneda',
        'description': 'Recolectaste tu primera moneda',
        'unlocked_at': DateTime.now().toIso8601String(),
      };
    }
    
    // Score milestones
    if (_totalScore >= 100 && !_achievements.containsKey('score_100')) {
      _achievements['score_100'] = {
        'name': 'Puntaje 100',
        'description': 'Alcanzaste 100 puntos',
        'unlocked_at': DateTime.now().toIso8601String(),
      };
    }
    
    // Level completion achievements
    if (_maxLevelUnlocked >= 5 && !_achievements.containsKey('level_5')) {
      _achievements['level_5'] = {
        'name': 'Nivel 5',
        'description': 'Desbloqueaste el nivel 5',
        'unlocked_at': DateTime.now().toIso8601String(),
      };
    }
  }
  
  /// Reset all progress (for testing)
  Future<void> resetProgress() async {
    _currentLevel = 1;
    _maxLevelUnlocked = 1;
    _totalScore = 0;
    _totalCoins = 0;
    _totalLives = 3;
    _gamesPlayed = 0;
    _gamesWon = 0;
    _achievements.clear();
    _statistics.clear();
    await saveState();
    notifyListeners();
  }
  
  /// Convert state to map for persistence
  Map<String, dynamic> _toMap() {
    return {
      'currentLevel': _currentLevel,
      'maxLevelUnlocked': _maxLevelUnlocked,
      'totalScore': _totalScore,
      'totalCoins': _totalCoins,
      'totalLives': _totalLives,
      'gamesPlayed': _gamesPlayed,
      'gamesWon': _gamesWon,
      'achievements': _achievements,
      'statistics': _statistics,
      'soundEnabled': _soundEnabled,
      'musicEnabled': _musicEnabled,
      'vibrationEnabled': _vibrationEnabled,
      'gameSpeed': _gameSpeed,
    };
  }
  
  /// Load state from map
  void _loadFromMap(Map<String, dynamic> state) {
    _currentLevel = state['currentLevel'] ?? 1;
    _maxLevelUnlocked = state['maxLevelUnlocked'] ?? 1;
    _totalScore = state['totalScore'] ?? 0;
    _totalCoins = state['totalCoins'] ?? 0;
    _totalLives = state['totalLives'] ?? 3;
    _gamesPlayed = state['gamesPlayed'] ?? 0;
    _gamesWon = state['gamesWon'] ?? 0;
    _achievements = Map<String, dynamic>.from(state['achievements'] ?? {});
    _statistics = Map<String, int>.from(state['statistics'] ?? {});
    _soundEnabled = state['soundEnabled'] ?? true;
    _musicEnabled = state['musicEnabled'] ?? true;
    _vibrationEnabled = state['vibrationEnabled'] ?? true;
    _gameSpeed = state['gameSpeed']?.toDouble() ?? 1.0;
  }
}
