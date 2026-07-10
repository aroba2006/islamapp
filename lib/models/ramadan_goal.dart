enum RamadanGoalType {
  quranReading,
  tahajjud,
  taraweeh,
  shafaaWatr,
  sadaqat,
  fasting,
  quranMemorization,
  goodDeeds,
}

class RamadanGoal {
  final String id;
  final RamadanGoalType type;
  final String titleEn;
  final String titleAr;
  final String descriptionEn;
  final String descriptionAr;
  final String unitEn;
  final String unitAr;
  final int targetValue; // Total target for 30 days
  final int currentValue; // Current progress
  final int dayNumber; // Current day of Ramadan (1-30)
  final String? notes;

  RamadanGoal({
    required this.id,
    required this.type,
    required this.titleEn,
    required this.titleAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.unitEn,
    required this.unitAr,
    required this.targetValue,
    required this.currentValue,
    required this.dayNumber,
    this.notes,
  });

  /// Percentage of goal completed
  double get percentageComplete => (currentValue / targetValue * 100).clamp(0, 100);

  /// Daily target based on current day
  int get dailyTarget => (targetValue / 30).ceil();

  /// Expected progress based on current day
  int get expectedProgress => dailyTarget * dayNumber;

  /// Is goal on track?
  bool get isOnTrack => currentValue >= expectedProgress;

  /// Days remaining in Ramadan
  int get daysRemaining => 30 - dayNumber;

  /// Remaining value to reach target
  int get remainingValue => (targetValue - currentValue).clamp(0, targetValue);

  String getTitle(String languageCode) => languageCode == 'ar' ? titleAr : titleEn;
  String getDescription(String languageCode) => languageCode == 'ar' ? descriptionAr : descriptionEn;
  String getUnit(String languageCode) => languageCode == 'ar' ? unitAr : unitEn;

  /// Create a copy with updated values
  RamadanGoal copyWith({
    int? currentValue,
    int? dayNumber,
    String? notes,
  }) {
    return RamadanGoal(
      id: id,
      type: type,
      titleEn: titleEn,
      titleAr: titleAr,
      descriptionEn: descriptionEn,
      descriptionAr: descriptionAr,
      unitEn: unitEn,
      unitAr: unitAr,
      targetValue: targetValue,
      currentValue: currentValue ?? this.currentValue,
      dayNumber: dayNumber ?? this.dayNumber,
      notes: notes ?? this.notes,
    );
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.toString(),
        'targetValue': targetValue,
        'currentValue': currentValue,
        'dayNumber': dayNumber,
        'notes': notes,
      };

  /// Create from JSON
  static RamadanGoal fromJson(Map<String, dynamic> json) {
    final typeStr = json['type'] as String;
    final type = RamadanGoalType.values.firstWhere(
      (e) => e.toString() == typeStr,
      orElse: () => RamadanGoalType.quranReading,
    );

    return RamadanGoal(
      id: json['id'] as String,
      type: type,
      titleEn: _getTitleEn(type),
      titleAr: _getTitleAr(type),
      descriptionEn: _getDescriptionEn(type),
      descriptionAr: _getDescriptionAr(type),
      unitEn: _getUnitEn(type),
      unitAr: _getUnitAr(type),
      targetValue: json['targetValue'] as int? ?? 30,
      currentValue: json['currentValue'] as int? ?? 0,
      dayNumber: json['dayNumber'] as int? ?? 1,
      notes: json['notes'] as String?,
    );
  }

  static String _getTitleEn(RamadanGoalType type) => switch (type) {
        RamadanGoalType.quranReading => 'Quran Reading',
        RamadanGoalType.tahajjud => 'Tahajjud (Night Prayer)',
        RamadanGoalType.taraweeh => 'Taraweeh Prayer',
        RamadanGoalType.shafaaWatr => 'Shafaa & Witr',
        RamadanGoalType.sadaqat => 'Sadaqah (Charity)',
        RamadanGoalType.fasting => 'Fasting Days',
        RamadanGoalType.quranMemorization => 'Quran Memorization',
        RamadanGoalType.goodDeeds => 'Good Deeds',
      };

  static String _getTitleAr(RamadanGoalType type) => switch (type) {
        RamadanGoalType.quranReading => 'قراءة القرآن',
        RamadanGoalType.tahajjud => 'قيام الليل (التهجد)',
        RamadanGoalType.taraweeh => 'صلاة التراويح',
        RamadanGoalType.shafaaWatr => 'الشفع والوتر',
        RamadanGoalType.sadaqat => 'الصدقات',
        RamadanGoalType.fasting => 'أيام الصيام',
        RamadanGoalType.quranMemorization => 'حفظ القرآن',
        RamadanGoalType.goodDeeds => 'الأعمال الصالحة',
      };

  static String _getDescriptionEn(RamadanGoalType type) => switch (type) {
        RamadanGoalType.quranReading =>
          'Complete reading of the entire Quran during the month',
        RamadanGoalType.tahajjud =>
          'Awaken at night for special prayers and Quranic recitation',
        RamadanGoalType.taraweeh => 'Pray Taraweeh prayers throughout Ramadan',
        RamadanGoalType.shafaaWatr => 'Pray the recommended Shafaa and Witr prayers',
        RamadanGoalType.sadaqat => 'Give charity to those in need',
        RamadanGoalType.fasting => 'Complete all fasting days in Ramadan',
        RamadanGoalType.quranMemorization => 'Memorize portions of the Quran',
        RamadanGoalType.goodDeeds => 'Perform kind and righteous deeds daily',
      };

  static String _getDescriptionAr(RamadanGoalType type) => switch (type) {
        RamadanGoalType.quranReading =>
          'إكمال قراءة القرآن الكريم خلال الشهر',
        RamadanGoalType.tahajjud =>
          'الاستيقاظ ليلاً لأداء الصلوات والتلاوة',
        RamadanGoalType.taraweeh => 'أداء صلاة التراويح طوال رمضان',
        RamadanGoalType.shafaaWatr => 'أداء صلاة الشفع والوتر',
        RamadanGoalType.sadaqat => 'إعطاء الصدقات للمحتاجين',
        RamadanGoalType.fasting => 'إكمال جميع أيام الصيام',
        RamadanGoalType.quranMemorization => 'حفظ أجزاء من القرآن الكريم',
        RamadanGoalType.goodDeeds => 'القيام بالأعمال الصالحة يومياً',
      };

  static String _getUnitEn(RamadanGoalType type) => switch (type) {
        RamadanGoalType.quranReading => 'complete readings',
        RamadanGoalType.tahajjud => 'nights',
        RamadanGoalType.taraweeh => 'prayers',
        RamadanGoalType.shafaaWatr => 'prayers',
        RamadanGoalType.sadaqat => 'days',
        RamadanGoalType.fasting => 'days',
        RamadanGoalType.quranMemorization => 'verses',
        RamadanGoalType.goodDeeds => 'deeds',
      };

  static String _getUnitAr(RamadanGoalType type) => switch (type) {
        RamadanGoalType.quranReading => 'قراءات كاملة',
        RamadanGoalType.tahajjud => 'ليالي',
        RamadanGoalType.taraweeh => 'صلوات',
        RamadanGoalType.shafaaWatr => 'صلوات',
        RamadanGoalType.sadaqat => 'أيام',
        RamadanGoalType.fasting => 'أيام',
        RamadanGoalType.quranMemorization => 'آيات',
        RamadanGoalType.goodDeeds => 'أعمال',
      };
}

class RamadanGoalsService {
  /// Get default Ramadan goals for the month
  static List<RamadanGoal> getDefaultGoals(int currentDay) {
    return [
      RamadanGoal(
        id: 'quran_reading',
        type: RamadanGoalType.quranReading,
        titleEn: 'Quran Reading',
        titleAr: 'قراءة القرآن',
        descriptionEn: 'Complete reading of the entire Quran during the month',
        descriptionAr: 'إكمال قراءة القرآن الكريم خلال الشهر',
        unitEn: 'complete readings',
        unitAr: 'قراءات كاملة',
        targetValue: 1, // 1 complete Quran reading
        currentValue: 0,
        dayNumber: currentDay,
      ),
      RamadanGoal(
        id: 'tahajjud',
        type: RamadanGoalType.tahajjud,
        titleEn: 'Tahajjud (Night Prayer)',
        titleAr: 'قيام الليل',
        descriptionEn: 'Awaken at night for special prayers',
        descriptionAr: 'الاستيقاظ ليلاً للصلاة',
        unitEn: 'nights',
        unitAr: 'ليالي',
        targetValue: 20, // 20 out of 30 nights
        currentValue: 0,
        dayNumber: currentDay,
      ),
      RamadanGoal(
        id: 'taraweeh',
        type: RamadanGoalType.taraweeh,
        titleEn: 'Taraweeh Prayer',
        titleAr: 'صلاة التراويح',
        descriptionEn: 'Pray Taraweeh prayers throughout Ramadan',
        descriptionAr: 'أداء صلاة التراويح طوال رمضان',
        unitEn: 'prayers',
        unitAr: 'صلوات',
        targetValue: 30, // All 30 nights
        currentValue: 0,
        dayNumber: currentDay,
      ),
      RamadanGoal(
        id: 'shafaa_watr',
        type: RamadanGoalType.shafaaWatr,
        titleEn: 'Shafaa & Witr',
        titleAr: 'الشفع والوتر',
        descriptionEn: 'Pray the even and odd prayers after Taraweeh',
        descriptionAr: 'أداء صلاة الشفع والوتر',
        unitEn: 'prayers',
        unitAr: 'صلوات',
        targetValue: 25, // 25 out of 30
        currentValue: 0,
        dayNumber: currentDay,
      ),
      RamadanGoal(
        id: 'sadaqat',
        type: RamadanGoalType.sadaqat,
        titleEn: 'Sadaqah (Charity)',
        titleAr: 'الصدقات',
        descriptionEn: 'Give charity to those in need',
        descriptionAr: 'إعطاء الصدقات للمحتاجين',
        unitEn: 'days',
        unitAr: 'أيام',
        targetValue: 30, // Give charity every day
        currentValue: 0,
        dayNumber: currentDay,
      ),
      RamadanGoal(
        id: 'fasting',
        type: RamadanGoalType.fasting,
        titleEn: 'Fasting',
        titleAr: 'الصيام',
        descriptionEn: 'Complete all fasting days',
        descriptionAr: 'إكمال جميع أيام الصيام',
        unitEn: 'days',
        unitAr: 'أيام',
        targetValue: 30,
        currentValue: 0,
        dayNumber: currentDay,
      ),
    ];
  }
}