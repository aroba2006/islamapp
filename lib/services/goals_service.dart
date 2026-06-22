import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class IslamicGoal {
  final String id;
  final String type; // 'quran', 'surah', 'prayer_streak'
  final String title;
  final String description;
  final int targetValue; // days for quran/prayer, surah number for memorization
  final int currentProgress;
  final DateTime createdAt;
  final DateTime? completedAt;
  final bool isCompleted;

  IslamicGoal({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.targetValue,
    required this.currentProgress,
    required this.createdAt,
    this.completedAt,
    this.isCompleted = false,
  });

  // Protected against division by zero
  double get progressPercentage => 
      targetValue == 0 ? 0.0 : (currentProgress / targetValue * 100).clamp(0, 100);

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'title': title,
    'description': description,
    'targetValue': targetValue,
    'currentProgress': currentProgress,
    'createdAt': createdAt.toIso8601String(),
    'completedAt': completedAt?.toIso8601String(),
    'isCompleted': isCompleted,
  };

  factory IslamicGoal.fromJson(Map<String, dynamic> json) => IslamicGoal(
    id: json['id'],
    type: json['type'],
    title: json['title'],
    description: json['description'],
    targetValue: json['targetValue'],
    currentProgress: json['currentProgress'],
    createdAt: DateTime.parse(json['createdAt']),
    completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
    isCompleted: json['isCompleted'] ?? false,
  );

  IslamicGoal copyWith({
    String? id,
    String? type,
    String? title,
    String? description,
    int? targetValue,
    int? currentProgress,
    DateTime? createdAt,
    DateTime? completedAt,
    bool? isCompleted,
  }) =>
      IslamicGoal(
        id: id ?? this.id,
        type: type ?? this.type,
        title: title ?? this.title,
        description: description ?? this.description,
        targetValue: targetValue ?? this.targetValue,
        currentProgress: currentProgress ?? this.currentProgress,
        createdAt: createdAt ?? this.createdAt,
        completedAt: completedAt ?? this.completedAt,
        isCompleted: isCompleted ?? this.isCompleted,
      );
}

class GoalsService {
  static const String _goalsKey = 'islamic_goals';
  
  static Future<void> saveGoal(IslamicGoal goal) async {
    final prefs = await SharedPreferences.getInstance();
    final goals = await getAllGoals();
    
    // Remove if exists, then add new one
    goals.removeWhere((g) => g.id == goal.id);
    goals.add(goal);
    
    final jsonList = goals.map((g) => jsonEncode(g.toJson())).toList();
    await prefs.setStringList(_goalsKey, jsonList);
  }

  static Future<List<IslamicGoal>> getAllGoals() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_goalsKey) ?? [];
    
    return jsonList
        .map((json) => IslamicGoal.fromJson(jsonDecode(json)))
        .toList();
  }

  static Future<void> updateProgress(String goalId, int newProgress) async {
    final goals = await getAllGoals();
    final goalIndex = goals.indexWhere((g) => g.id == goalId);
    
    if (goalIndex != -1) {
      final goal = goals[goalIndex];
      final isNowCompleted = newProgress >= goal.targetValue;
      
      final updatedGoal = goal.copyWith(
        currentProgress: newProgress,
        isCompleted: isNowCompleted,
        completedAt: isNowCompleted ? DateTime.now() : goal.completedAt,
      );
      
      goals[goalIndex] = updatedGoal;
      
      final prefs = await SharedPreferences.getInstance();
      final jsonList = goals.map((g) => jsonEncode(g.toJson())).toList();
      await prefs.setStringList(_goalsKey, jsonList);
    }
  }

  static Future<void> deleteGoal(String goalId) async {
    final prefs = await SharedPreferences.getInstance();
    final goals = await getAllGoals();
    goals.removeWhere((g) => g.id == goalId);
    
    final jsonList = goals.map((g) => jsonEncode(g.toJson())).toList();
    await prefs.setStringList(_goalsKey, jsonList);
  }

  static Future<int> getActiveGoalsCount() async {
    final goals = await getAllGoals();
    return goals.where((g) => !g.isCompleted).length;
  }

  static Future<int> getCompletedGoalsCount() async {
    final goals = await getAllGoals();
    return goals.where((g) => g.isCompleted).length;
  }
}