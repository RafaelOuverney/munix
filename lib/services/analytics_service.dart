import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';

class AnalyticsService {
  static const String _listeningHistoryKey = 'listening_history';

  static Future<void> recordTrackPlay(String trackId, String genre) async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList(_listeningHistoryKey) ?? [];
    
    final record = {
      'trackId': trackId,
      'genre': genre,
      'timestamp': DateTime.now().toIso8601String(),
    };
    
    history.add(jsonEncode(record));
    await prefs.setStringList(_listeningHistoryKey, history);
  }

  static Future<Map<String, dynamic>> getListeningAnalytics() async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList(_listeningHistoryKey) ?? [];
    
    // Simular dados para demonstração
    final genreStats = {
      'Rock': Random().nextInt(30) + 10,
      'Pop': Random().nextInt(25) + 15,
      'Jazz': Random().nextInt(20) + 5,
      'Electronic': Random().nextInt(15) + 10,
      'Classical': Random().nextInt(10) + 5,
    };
    
    final weeklyListens = List.generate(7, (index) => Random().nextInt(20) + 5);
    
    return {
      'genreStats': genreStats,
      'weeklyListens': weeklyListens,
      'totalPlays': history.length,
    };
  }
}
