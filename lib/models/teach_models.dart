// Models for TeachMeScreen - Optional, for better organization

class TeachingCategory {
  final String id;
  final String titleEn;
  final String titleAr;
  final String titleFr;
  final String iconType;

  TeachingCategory({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.titleFr,
    required this.iconType,
  });
}

class TeachingStep {
  final String number;
  final String titleEn;
  final String titleAr;
  final String titleFr;
  final String descEn;
  final String descAr;
  final String descFr;
  final String iconType;

  TeachingStep({
    required this.number,
    required this.titleEn,
    required this.titleAr,
    required this.titleFr,
    required this.descEn,
    required this.descAr,
    required this.descFr,
    required this.iconType,
  });

  String getTitle(String langCode) {
    if (langCode == 'ar') return titleAr;
    if (langCode == 'fr') return titleFr;
    return titleEn;
  }

  String getDescription(String langCode) {
    if (langCode == 'ar') return descAr;
    if (langCode == 'fr') return descFr;
    return descEn;
  }
}

class SpecialCondition {
  final String situationEn;
  final String situationAr;
  final String situationFr;
  final String solutionEn;
  final String solutionAr;
  final String solutionFr;
  final String iconType;

  SpecialCondition({
    required this.situationEn,
    required this.situationAr,
    required this.situationFr,
    required this.solutionEn,
    required this.solutionAr,
    required this.solutionFr,
    required this.iconType,
  });

  String getSituation(String langCode) {
    if (langCode == 'ar') return situationAr;
    if (langCode == 'fr') return situationFr;
    return situationEn;
  }

  String getSolution(String langCode) {
    if (langCode == 'ar') return solutionAr;
    if (langCode == 'fr') return solutionFr;
    return solutionEn;
  }
}

class TeachingContent {
  final String categoryId;
  final List<TeachingStep> steps;
  final List<SpecialCondition> conditions;

  TeachingContent({
    required this.categoryId,
    required this.steps,
    required this.conditions,
  });
}
