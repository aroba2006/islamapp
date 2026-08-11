import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class GoodDeed {
  final String id;
  final String title;
  final String category;
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
        id: json['id'] as String,
        title: json['title'] as String,
        category: json['category'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
        notes: json['notes'] as String?,
      );
}

class DeedsService {
  static const String _storageKey = 'islamic_good_deeds_list';
  static final List<GoodDeed> _inMemoryFallback = [];

  static Future<List<GoodDeed>> getAllDeeds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? rawJson = prefs.getString(_storageKey);
      if (rawJson == null || rawJson.isEmpty) {
        return List.from(_inMemoryFallback);
      }
      final List<dynamic> list = jsonDecode(rawJson);
      return list.map((item) => GoodDeed.fromJson(item as Map<String, dynamic>)).toList();
    } catch (e) {
      print('DeedsService.getAllDeeds error: $e');
      return List.from(_inMemoryFallback);
    }
  }

  static Future<bool> addDeed(GoodDeed deed) async {
    try {
      _inMemoryFallback.insert(0, deed);
      final deeds = await getAllDeeds();
      if (!deeds.any((d) => d.id == deed.id)) {
        deeds.insert(0, deed);
      }
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(deeds.map((d) => d.toJson()).toList());
      return await prefs.setString(_storageKey, encoded);
    } catch (e) {
      print('DeedsService.addDeed error: $e');
      return true;
    }
  }

  static Future<bool> deleteDeed(String id) async {
    try {
      _inMemoryFallback.removeWhere((d) => d.id == id);
      final deeds = await getAllDeeds();
      deeds.removeWhere((d) => d.id == id);
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(deeds.map((d) => d.toJson()).toList());
      return await prefs.setString(_storageKey, encoded);
    } catch (e) {
      print('DeedsService.deleteDeed error: $e');
      return true;
    }
  }

  static Future<int> getTotalDeeds() async {
    final deeds = await getAllDeeds();
    return deeds.length;
  }

  static Future<int> getDeedCountToday() async {
    final deeds = await getAllDeeds();
    final now = DateTime.now();
    return deeds.where((d) =>
      d.timestamp.year == now.year &&
      d.timestamp.month == now.month &&
      d.timestamp.day == now.day
    ).length;
  }

  static Future<int> getCurrentStreak() async {
    final deeds = await getAllDeeds();
    if (deeds.isEmpty) return 0;

    final dates = deeds
        .map((d) => DateTime(d.timestamp.year, d.timestamp.month, d.timestamp.day))
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a));

    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    int streak = 0;
    DateTime checkDate = todayDate;

    if (!dates.contains(todayDate)) {
      checkDate = todayDate.subtract(const Duration(days: 1));
      if (!dates.contains(checkDate)) return 0;
    }

    while (dates.contains(checkDate)) {
      streak++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    return streak;
  }
}