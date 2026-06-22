import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class GoodDeed {
  final String id;
  final String title;
  final String category; // 'prayer', 'charity', 'learning', 'family', 'other'
  final DateTime timestamp;
  final String? notes;

  GoodDeed({
    required this.id,
    required this.title,
    required this.category,
    required this.timestamp,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'category': category,
    'timestamp': timestamp.toIso8601String(),
    'notes': notes,
  };

  factory GoodDeed.fromJson(Map<String, dynamic> json) => GoodDeed(
    id: json['id'],
    title: json['title'],
    category: json['category'],
    timestamp: DateTime.parse(json['timestamp']),
    notes: json['notes'],
  );
}

class DeedsService {
  static const String _deedsKey = 'good_deeds';
  static const String _streakKey = 'deeds_streak';

  static Future<void> addDeed(GoodDeed deed) async {
    final prefs = await SharedPreferences.getInstance();
    final deeds = await getAllDeeds();
    deeds.add(deed);
    
    final jsonList = deeds.map((d) => jsonEncode(d.toJson())).toList();
    await prefs.setStringList(_deedsKey, jsonList);
    
    // Update streak
    await _updateStreak();
  }

  static Future<List<GoodDeed>> getAllDeeds() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_deedsKey) ?? [];
    
    return jsonList
        .map((json) => GoodDeed.fromJson(jsonDecode(json)))
        .toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp)); // Recent first
  }

  static Future<void> deleteDeed(String deedId) async {
    final prefs = await SharedPreferences.getInstance();
    final deeds = await getAllDeeds();
    deeds.removeWhere((d) => d.id == deedId);
    
    final jsonList = deeds.map((d) => jsonEncode(d.toJson())).toList();
    await prefs.setStringList(_deedsKey, jsonList);
    
    await _updateStreak();
  }

  static Future<int> getTotalDeeds() async {
    final deeds = await getAllDeeds();
    return deeds.length;
  }

  static Future<int> getDeedCountToday() async {
    final deeds = await getAllDeeds();
    final now = DateTime.now();
    
    return deeds
        .where((d) =>
            d.timestamp.day == now.day &&
            d.timestamp.month == now.month &&
            d.timestamp.year == now.year)
        .length;
  }

  static Future<Map<String, int>> getDeedsByCategory() async {
    final deeds = await getAllDeeds();
    final categoryCounts = <String, int>{};
    
    for (var deed in deeds) {
      categoryCounts[deed.category] = (categoryCounts[deed.category] ?? 0) + 1;
    }
    
    return categoryCounts;
  }

  static Future<int> getCurrentStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_streakKey) ?? 0;
  }

  static Future<void> _updateStreak() async {
    final deeds = await getAllDeeds();
    if (deeds.isEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_streakKey, 0);
      return;
    }

    int streak = 0;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    // Check if there's a deed today
    final hasToday = deeds.any((d) {
      final deedDate = DateTime(d.timestamp.year, d.timestamp.month, d.timestamp.day);
      return deedDate == today;
    });

    if (!hasToday) {
      // Reset streak if no deed today
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_streakKey, 0);
      return;
    }

    // Count consecutive days with deeds
    streak = 1;
    for (int i = 1; i < 365; i++) {
      final checkDate = today.subtract(Duration(days: i));
      final hasDeeds = deeds.any((d) {
        final deedDate = DateTime(d.timestamp.year, d.timestamp.month, d.timestamp.day);
        return deedDate == checkDate;
      });

      if (hasDeeds) {
        streak++;
      } else {
        break;
      }
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_streakKey, streak);
  }

  static Future<List<GoodDeed>> getDeeds({
    DateTime? from,
    DateTime? to,
    String? categoryFilter,
  }) async {
    var deeds = await getAllDeeds();

    if (categoryFilter != null) {
      deeds = deeds.where((d) => d.category == categoryFilter).toList();
    }

    if (from != null && to != null) {
      deeds = deeds
          .where((d) => d.timestamp.isAfter(from) && d.timestamp.isBefore(to))
          .toList();
    }

    return deeds;
  }

  // Get deeds for chart/stats
  static Future<List<int>> getDeedsPerDay(int days) async {
    final deeds = await getAllDeeds();
    final List<int> deedsPerDay = List.filled(days, 0);
    final now = DateTime.now();

    for (int i = 0; i < days; i++) {
      final date = now.subtract(Duration(days: i));
      final count = deeds
          .where((d) =>
              d.timestamp.day == date.day &&
              d.timestamp.month == date.month &&
              d.timestamp.year == date.year)
          .length;
      deedsPerDay[i] = count;
    }

    return deedsPerDay.reversed.toList();
  }
}