/*import 'dart:math';

class QuizQuestion {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;
  final String difficulty;

  QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
    required this.difficulty,
  });
}

class QuizQuestionsService {
  static final QuizQuestionsService _instance = QuizQuestionsService._internal();

  factory QuizQuestionsService() {
    return _instance;
  }

  QuizQuestionsService._internal();



  // ==========================================
  // ARABIC TRANSLATIONS (ALL 120 QUESTIONS)
  // ==========================================

  // --- ARABIC: EASY ---
  List<QuizQuestion> _getEasyQuestionsAr() {
    return [
      QuizQuestion(id: 'easy_1', question: 'كم مرة يصلي المسلمون في اليوم؟', options: ['3 مرات', '4 مرات', '5 مرات', '6 مرات'], correctAnswerIndex: 2, explanation: 'المسلمون ملزمون بالصلاة 5 مرات في اليوم: الفجر، الظهر، العصر، المغرب، والعشاء.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_2', question: 'ما هو اسم شهر الصيام في الإسلام؟', options: ['شوال', 'رمضان', 'محرم', 'ذو الحجة'], correctAnswerIndex: 1, explanation: 'رمضان هو الشهر التاسع من التقويم القمري الإسلامي والذي يصوم فيه المسلمون من الفجر حتى غروب الشمس.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_3', question: 'من هو آخر الأنبياء في الإسلام؟', options: ['إبراهيم', 'موسى', 'محمد', 'عيسى'], correctAnswerIndex: 2, explanation: 'النبي محمد (صلى الله عليه وسلم) هو الخاتم وآخر رسول بعثه الله.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_4', question: 'ماذا يسمى الحج الإسلامي؟', options: ['العمرة', 'الحج', 'الطواف', 'الصلاة'], correctAnswerIndex: 1, explanation: 'الحج هو رحلة الحج إلى مكة وهو أحد أركان الإسلام الخمسة.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_5', question: 'كم عدد أركان الإسلام؟', options: ['3', '4', '5', '6'], correctAnswerIndex: 2, explanation: 'هناك 5 أركان للإسلام: الشهادتان، الصلاة، الزكاة، الصوم، والحج.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_6', question: 'ماذا يسمى إعلان الإيمان في الإسلام؟', options: ['الصلاة', 'الشهادة', 'الزكاة', 'الحج'], correctAnswerIndex: 1, explanation: 'الشهادة هي العقيدة الإسلامية التي تقر بأنه لا إله إلا الله وأن محمداً رسول الله.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_7', question: 'في أي اتجاه يواجه المسلمون عند الصلاة؟', options: ['الشرق', 'الغرب', 'الشمال', 'تجاه مكة (القبلة)'], correctAnswerIndex: 3, explanation: 'يواجه المسلمون الكعبة في مكة أثناء الصلاة، في اتجاه يسمى القبلة.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_8', question: 'من بنى الكعبة؟', options: ['النبي موسى', 'النبي إبراهيم وإسماعيل', 'النبي محمد', 'النبي سليمان'], correctAnswerIndex: 1, explanation: 'وفقًا للتراث الإسلامي، قام النبي إبراهيم وابنه إسماعيل ببناء الكعبة.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_9', question: 'ماذا تسمى الصدقة الواجبة في الإسلام؟', options: ['الصوم', 'الزكاة', 'الحج', 'الطواف'], correctAnswerIndex: 1, explanation: 'الزكاة هي الصدقة الواجبة وهي أحد أركان الإسلام الخمسة.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_10', question: 'كم عدد سور القرآن الكريم؟', options: ['100', '110', '114', '120'], correctAnswerIndex: 2, explanation: 'يحتوي القرآن على 114 سورة، تتكون كل منها من آية واحدة أو أكثر.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_11', question: 'على ماذا يعتمد التقويم الإسلامي؟', options: ['السنة الشمسية', 'السنة القمرية', 'الشمسية والقمرية معاً', 'الفصول'], correctAnswerIndex: 1, explanation: 'يعتمد التقويم الإسلامي على السنة القمرية، ويُعرف أيضًا بالتقويم الهجري.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_12', question: 'كم عدد أيام شهر رمضان؟', options: ['25 يوماً', '28 يوماً', '29-30 يوماً', '35 يوماً'], correctAnswerIndex: 2, explanation: 'يتكون رمضان من 29 أو 30 يومًا اعتمادًا على رؤية الهلال.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_13', question: 'ماذا تعني كلمة "الإسلام"؟', options: ['السلام فقط', 'الاستسلام لله', 'الصلاة', 'الإيمان'], correctAnswerIndex: 1, explanation: 'الإسلام يعني الاستسلام لإرادة الله، وهي مشتقة من الكلمة العربية للسلام والاستسلام.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_14', question: 'من هو أول نبي في الإسلام؟', options: ['محمد', 'إبراهيم', 'آدم', 'موسى'], correctAnswerIndex: 2, explanation: 'النبي آدم هو أول إنسان وأول نبي أرسله الله.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_15', question: 'ما هي تحية الإسلام؟', options: ['مرحباً', 'السلام عليكم', 'أهلاً بك', 'تحياتي'], correctAnswerIndex: 1, explanation: 'السلام عليكم هي تحية الإسلام، والرد عليها هو "وعليكم السلام".', difficulty: 'easy'),
      QuizQuestion(id: 'easy_16', question: 'كم عدد الأنبياء المذكورين في القرآن الكريم؟', options: ['19', '25', '31', '50'], correctAnswerIndex: 1, explanation: 'تم ذكر 25 نبياً بالاسم في القرآن، بما في ذلك آدم، إبراهيم، موسى، عيسى، ومحمد.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_17', question: 'ما هي أول سورة في القرآن الكريم؟', options: ['سورة البقرة', 'سورة الفاتحة', 'سورة الناس', 'سورة الإخلاص'], correctAnswerIndex: 1, explanation: 'سورة الفاتحة هي أول سورة في القرآن وتُقرأ في كل ركعة من الصلاة.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_18', question: 'في أي مدينة وُلد النبي محمد؟', options: ['المدينة', 'مكة', 'القدس', 'بغداد'], correctAnswerIndex: 1, explanation: 'وُلد النبي محمد في مكة المكرمة عام 570 ميلادي.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_19', question: 'ما هو الطعام المحرم أكله في الإسلام؟', options: ['الخضروات', 'لحم الخنزير', 'الأسماك', 'الفواكه'], correctAnswerIndex: 1, explanation: 'يُحرم أكل لحم الخنزير وبعض اللحوم الأخرى في الإسلام كما ذُكر في القرآن.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_20', question: 'في أي عام هاجر النبي محمد إلى المدينة؟', options: ['610 م', '622 م', '632 م', '650 م'], correctAnswerIndex: 1, explanation: 'حدثت الهجرة في عام 622 ميلادي، مما يمثل بداية التقويم الإسلامي.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_21', question: 'كم مرة يطوف المسلمون حول الكعبة أثناء الحج؟', options: ['3 مرات', '5 مرات', '7 مرات', '10 مرات'], correctAnswerIndex: 2, explanation: 'يطوف المسلمون حول الكعبة 7 مرات كأحد مناسك الحج.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_22', question: 'ماذا يسمى النظام القانوني الإسلامي؟', options: ['الشريعة', 'الحديث', 'الفقه', 'الإجماع'], correctAnswerIndex: 0, explanation: 'الشريعة (القانون الإسلامي) هي الإطار القانوني المبني على القرآن والسنة.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_23', question: 'من الذي جمع أول مصحف مكتوب للقرآن الكريم؟', options: ['أبو بكر', 'عمر', 'عثمان', 'علي'], correctAnswerIndex: 2, explanation: 'قام الخليفة عثمان بن عفان بجمع القرآن وتوحيده في مصحف واحد خلال فترة حكمه.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_24', question: 'ماذا تعني كلمة "الحديث"؟', options: ['التلاوة', 'قصص الأنبياء', 'أقوال وأفعال النبي محمد', 'الفقه'], correctAnswerIndex: 2, explanation: 'يشير الحديث إلى الأقوال والأفعال والتقريرات المسجلة عن النبي محمد.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_25', question: 'كم مرة يُتلى التكبير (الله أكبر) يومياً؟', options: ['5 مرات', '10 مرات', '10 مرات على الأقل', 'مرات عديدة طوال اليوم'], correctAnswerIndex: 3, explanation: 'يُتلى التكبير عدة مرات يومياً في الصلوات والممارسات الإسلامية الأخرى.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_26', question: 'ماذا تسمى وجبة ما قبل الفجر في رمضان؟', options: ['السحور', 'الإفطار', 'التراويح', 'القيام'], correctAnswerIndex: 0, explanation: 'السحور هو الوجبة التي تؤكل قبل الفجر وبدء الصيام.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_27', question: 'ماذا يسمى كسر الصيام عند غروب الشمس؟', options: ['السحور', 'الإفطار', 'التهجد', 'الوتر'], correctAnswerIndex: 1, explanation: 'الإفطار هو الوجبة التي تؤكل عند غروب الشمس لكسر الصيام في رمضان.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_28', question: 'كم مرة يتوضأ المسلم في اليوم؟', options: ['مرة واحدة', 'مرتين', 'يختلف - قبل كل صلاة', '5 مرات فقط'], correctAnswerIndex: 2, explanation: 'يتم الوضوء قبل كل صلاة، لذلك يختلف العدد بناءً على أوقات الصلاة.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_29', question: 'ما هي صلاة الليل في رمضان؟', options: ['صلاة الليل', 'التراويح', 'قيام الليل', 'التهجد'], correctAnswerIndex: 1, explanation: 'التراويح هي صلوات خاصة تُقام في ليالي رمضان بعد صلاة العشاء.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_30', question: 'أي صلاة هي الأطول وقتًا؟', options: ['الفجر', 'الظهر', 'العصر', 'المغرب'], correctAnswerIndex: 1, explanation: 'تُعتبر صلاة الظهر عمومًا أطول صلاة في اليوم.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_31', question: 'كم عدد الركعات في صلاة الظهر؟', options: ['2', '3', '4', '5'], correctAnswerIndex: 2, explanation: 'تتكون صلاة الظهر من 4 ركعات مفروضة.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_32', question: 'ماذا تسمى شهادة الإيمان؟', options: ['التكبير', 'الشهادة', 'التسبيح', 'التهليل'], correctAnswerIndex: 1, explanation: 'الشهادة هي إعلان الإيمان الإسلامي الذي يشهد بوحدانية الله.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_33', question: 'أي شهر يُعتبر أفضل شهر للصلوات الإضافية؟', options: ['شوال', 'رمضان', 'محرم', 'رجب'], correctAnswerIndex: 1, explanation: 'رمضان هو أقدس شهر في التقويم الإسلامي حيث تُضاعف فيه الحسنات.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_34', question: 'ما هي الضريبة الواجبة أو الصدقة المفروضة؟', options: ['الزكاة', 'الخراج', 'الطواف', 'الصدقة'], correctAnswerIndex: 0, explanation: 'الزكاة هي إعطاء جزء محدد من المال للفقراء والمحتاجين.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_35', question: 'كم عدد أضلاع الكعبة؟', options: ['2', '3', '4', '6'], correctAnswerIndex: 2, explanation: 'الكعبة هي مبنى مكعب الشكل ذو 4 أضلاع، يقع في مكة.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_36', question: 'ما هي الصدقة في الإسلام؟', options: ['صدقة واجبة', 'صدقة تطوعية', 'ضريبة', 'عقوبة'], correctAnswerIndex: 1, explanation: 'الصدقة هي تبرع تطوعي يُعطى بنية مساعدة الآخرين وإرضاء الله.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_37', question: 'من هي والدة النبي محمد؟', options: ['آمنة', 'حليمة', 'خديجة', 'عائشة'], correctAnswerIndex: 0, explanation: 'آمنة بنت وهب هي الوالدة البيولوجية للنبي محمد.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_38', question: 'بماذا يُعرف التقويم الإسلامي أيضاً؟', options: ['التقويم الشمسي', 'التقويم الهجري', 'التقويم الميلادي', 'التقويم اليولياني'], correctAnswerIndex: 1, explanation: 'يُسمى التقويم الإسلامي أيضاً بالتقويم الهجري، نسبةً إلى الهجرة.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_39', question: 'كم عدد الآيات في القرآن تقريباً؟', options: ['3000', '6000', '9000', '12000'], correctAnswerIndex: 1, explanation: 'يحتوي القرآن على حوالي 6,236 آية موزعة على 114 سورة.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_40', question: 'ماذا تعني "بسم الله"؟', options: ['سبحان الله', 'باسم الله', 'الله أكبر', 'الحمد لله'], correctAnswerIndex: 1, explanation: 'تعني البسملة "باسم الله" وتُقرأ قبل البدء في أي عمل.', difficulty: 'easy'),
    ];
  }

  // --- ARABIC: MEDIUM ---
  List<QuizQuestion> _getMediumQuestionsAr() {
    return [
      QuizQuestion(id: 'mid_1', question: 'ما هي السنة؟', options: ['تعاليم الأديان الأخرى', 'ممارسات وتقاليد النبي محمد', 'طقوس الحج', 'القوانين الإسلامية'], correctAnswerIndex: 1, explanation: 'السنة تشير إلى تقاليد وممارسات النبي محمد التي تعتبر نموذجًا للمسلمين.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_2', question: 'من هو أول خليفة للمسلمين؟', options: ['عمر بن الخطاب', 'أبو بكر الصديق', 'عثمان بن عفان', 'علي بن أبي طالب'], correctAnswerIndex: 1, explanation: 'أبو بكر الصديق كان أول خليفة بعد النبي محمد، حكم من 632-634 م.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_3', question: 'ما هو الفقه في الشريعة الإسلامية؟', options: ['حفظ القرآن', 'فهم وتفسير الشريعة الإسلامية', 'تقاليد رواية القصص', 'التعبيرات الشعرية'], correctAnswerIndex: 1, explanation: 'الفقه هو فرع من المعرفة الإسلامية يتعامل مع فهم وتطبيق الشريعة.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_4', question: 'ما هو الإجماع في الشريعة الإسلامية؟', options: ['رأي شخصي', 'اتفاق علماء المسلمين', 'الآيات القرآنية', 'التقاليد فقط'], correctAnswerIndex: 1, explanation: 'الإجماع هو اتفاق علماء المسلمين على مسألة معينة وهو أحد مصادر التشريع.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_5', question: 'كم عدد الخلفاء الراشدين؟', options: ['2', '3', '4', '5'], correctAnswerIndex: 2, explanation: 'الخلفاء الراشدون الأربعة هم أبو بكر، عمر، عثمان، وعلي.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_6', question: 'ماذا تسمى الليلة التي نزل فيها القرآن؟', options: ['ليلة القدر', 'ليلة الجن', 'ليلة الإسراء', 'ليلة البراءة'], correctAnswerIndex: 0, explanation: 'ليلة القدر هي الليلة التي بدأ فيها نزول القرآن وهي أعظم الليالي.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_7', question: 'أي سورة تذكر ليلة القدر؟', options: ['سورة العلق', 'سورة القدر', 'سورة الرحمن', 'سورة العاديات'], correctAnswerIndex: 1, explanation: 'سورة القدر (السورة 97) مخصصة بالكامل لوصف ليلة القدر.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_8', question: 'ما هو القياس في الفقه الإسلامي؟', options: ['القياس المادي', 'الاستدلال التماثلي أو القياس على أمور مشابهة', 'الإبلاغ', 'طرح الأسئلة'], correctAnswerIndex: 1, explanation: 'القياس هو طريقة لاستنباط الأحكام الإسلامية عبر مقارنتها بحالات مشابهة في القرآن والسنة.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_9', question: 'كم عدد كتاب الوحي للنبي محمد؟', options: ['3', '5', '15-20', 'أكثر من 40'], correctAnswerIndex: 3, explanation: 'كان للنبي محمد أكثر من 40 كاتباً سجلوا الوحي، منهم علي وعثمان.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_10', question: 'ماذا يعني الحجاب في السياق الإسلامي؟', options: ['غطاء الرأس فقط', 'الاحتشام واللباس الساتر للرجال والنساء', 'شاشة فقط', 'منع ديني'], correctAnswerIndex: 1, explanation: 'الحجاب يمثل الاحتشام ولا يقتصر على ملابس النساء بل يشمل الجنسين.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_11', question: 'ما هو الإسراء والمعراج؟', options: ['رحلتان مختلفتان', 'رحلة النبي ليلاً من مكة للقدس وعروجه للسماء', 'سورتان في القرآن', 'اسمان للكعبة'], correctAnswerIndex: 1, explanation: 'الإسراء هو الرحلة الليلية إلى القدس، والمعراج هو الصعود إلى السماوات.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_12', question: 'أي سورة تحتوي على آية الكرسي؟', options: ['سورة البقرة', 'سورة آل عمران', 'سورة النور', 'سورة يس'], correctAnswerIndex: 0, explanation: 'توجد آية الكرسي في سورة البقرة (2:255) وهي من أعظم الآيات في القرآن.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_13', question: 'ما هي أقصر سورة في القرآن؟', options: ['سورة الإخلاص', 'سورة الناس', 'سورة الكوثر', 'سورة الفيل'], correctAnswerIndex: 2, explanation: 'سورة الكوثر (السورة 108) هي أقصر سورة وتتكون من 3 آيات فقط.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_14', question: 'كم عدد أسماء الله الحسنى الشائعة؟', options: ['50', '99', '150', '200'], correctAnswerIndex: 1, explanation: 'يتم التأكيد بشكل خاص على 99 اسماً لله في التراث الإسلامي.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_15', question: 'ما هي غزوة بدر؟', options: ['موقع في المدينة', 'أول معركة كبرى بين المسلمين وقريش', 'طريق تجاري', 'بئر ماء'], correctAnswerIndex: 1, explanation: 'غزوة بدر (2 هـ) كانت أول مواجهة عسكرية كبرى بين المسلمين وقريش.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_16', question: 'ماذا تعني كلمة "الأمة"؟', options: ['الأم', 'الأمة أو المجتمع الإسلامي', 'الجدة', 'القبيلة'], correctAnswerIndex: 1, explanation: 'تشير الأمة إلى المجتمع الإسلامي العالمي الموحد بالإيمان.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_17', question: 'ما هي أركان الإيمان الستة؟', options: ['الله، القرآن، الصلاة، الصوم، الزكاة، الحج', 'الإيمان بالله وملائكته وكتبه ورسله واليوم الآخر والقدر', 'الأركان الخمسة فقط', 'أسماء الله فقط'], correctAnswerIndex: 1, explanation: 'أركان الإيمان الستة تشكل أساس العقيدة الإسلامية.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_18', question: 'من هي الزوجة الأولى للنبي إبراهيم؟', options: ['سارة', 'هاجر', 'قطورة', 'ليئة'], correctAnswerIndex: 0, explanation: 'سارة كانت الزوجة الأولى للنبي إبراهيم وأم النبي إسحاق.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_19', question: 'بماذا يُعرف شهر محرم الإسلامي؟', options: ['شهر الصيام', 'شهر الحج', 'الشهر الحرام الذي يضم يوم عاشوراء', 'شهر المعارك'], correctAnswerIndex: 2, explanation: 'محرم هو الشهر الأول من السنة الإسلامية وهو شهر حرام.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_20', question: 'ما هي زكاة الفطر؟', options: ['ضريبة على الممتلكات', 'صدقة تُخرج في نهاية رمضان قبل صلاة العيد', 'صدقة شهرية', 'صدقة للفقراء فقط'], correctAnswerIndex: 1, explanation: 'زكاة الفطر هي شكل خاص من الصدقة تُعطى قبل عيد الفطر.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_21', question: 'كم عدد حملة عرش الرحمن؟', options: ['2', '4', '8', 'غير محدد في القرآن'], correctAnswerIndex: 2, explanation: 'وفقاً للقرآن، يحمل عرش الرحمن ثمانية من الملائكة.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_22', question: 'ما اسم الملك الذي نزل بالوحي؟', options: ['جبريل', 'ميكائيل', 'إسرافيل', 'مالك'], correctAnswerIndex: 0, explanation: 'الملك جبريل (عليه السلام) هو الملك الذي نزل بالوحي على النبي محمد.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_23', question: 'ما هو أول عمل يُحاسب عليه العبد يوم القيامة؟', options: ['الإيمان', 'الصلاة', 'الصدقة', 'اللطف'], correctAnswerIndex: 1, explanation: 'وفقًا للحديث، الصلاة هي أول عمل يُحاسب عليه العبد يوم القيامة.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_24', question: 'كم مرة وردت كلمة "يا أيها" في القرآن؟', options: ['50', '100', '165', '200'], correctAnswerIndex: 2, explanation: 'وردت عبارة "يا أيها" 165 مرة في القرآن.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_25', question: 'ما هو الدعاء المأثور عند رؤية الهلال؟', options: ['الله أكبر', 'الحمد لله', 'يختلف حسب المنطقة', 'اللهم أهله علينا بالأمن والإيمان'], correctAnswerIndex: 3, explanation: 'الدعاء المأثور هو: اللهم أهله علينا بالأمن والإيمان والسلامة والإسلام.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_26', question: 'كم مرة أدى النبي محمد فريضة الحج؟', options: ['مرة واحدة', 'مرتين', 'ثلاث مرات', 'خمس مرات'], correctAnswerIndex: 0, explanation: 'أدى النبي محمد الحج مرة واحدة فقط في 10 هـ، وتُعرف بحجة الوداع.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_27', question: 'ما هي صلاة الاستخارة؟', options: ['طقس صيام', 'صلاة لطلب الخيرة والتوجيه من الله في اتخاذ قرار', 'طقس حج', 'تحية'], correctAnswerIndex: 1, explanation: 'الاستخارة هي صلاة لطلب التوجيه الإلهي عند اتخاذ قرارات هامة.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_28', question: 'من هم الملائكة الكرام الكاتبون؟', options: ['جبريل', 'ميكائيل', 'كراماً كاتبين', 'مالك'], correctAnswerIndex: 2, explanation: 'الكرام الكاتبون هم الملائكة الذين يسجلون أفعالنا، الخير والشر.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_29', question: 'ماذا يسمى العذاب في القبر؟', options: ['عذاب القبر', 'الجحيم', 'سقر', 'لظى'], correctAnswerIndex: 0, explanation: 'يشير عذاب القبر إلى العقاب في القبر، وهو مفهوم مذكور في التعاليم الإسلامية.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_30', question: 'كم عدد آيات سورة البقرة؟', options: ['100', '200', '286', '300'], correctAnswerIndex: 2, explanation: 'تحتوي سورة البقرة (السورة 2) على 286 آية وهي أطول سورة في القرآن.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_31', question: 'ماذا تعني "الصدقة الجارية"؟', options: ['صدقة لمرة واحدة', 'صدقة مستمرة يستمر نفعها بعد الموت', 'صدقة إجبارية', 'صدقة الأعياد'], correctAnswerIndex: 1, explanation: 'الصدقة الجارية هي عمل خيري مستمر كبناء بئر أو مدرسة يفيد الناس باستمرار.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_32', question: 'من هي الصحابية المعروفة بغزارة علمها؟', options: ['عائشة', 'فاطمة', 'حفصة', 'زينب'], correctAnswerIndex: 0, explanation: 'عائشة بنت أبي بكر اشتهرت بمعرفتها الواسعة بالإسلام وتُلقب بـ "أم المؤمنين".', difficulty: 'medium'),
      QuizQuestion(id: 'mid_33', question: 'ما هو الاسم الإنجليزي لشهر الصيام؟', options: ['Ramada', 'Ramazan', 'Ramadan', 'Ramanah'], correctAnswerIndex: 2, explanation: 'Ramadan هو النقل الصوتي الإنجليزي القياسي لشهر رمضان.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_34', question: 'كم عدد الملائكة الرئيسيين المذكورين بالاسم في القرآن؟', options: ['2', '3', '4', '5'], correctAnswerIndex: 2, explanation: 'تم ذكر أربعة ملائكة كبار: جبريل، ميكائيل، إسرافيل، ومالك.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_35', question: 'ما هو مفهوم "التوكل" في الإسلام؟', options: ['الصلاة', 'الاعتماد على الله بعد بذل الجهد (عقلها وتوكل)', 'الصوم', 'الصدقة'], correctAnswerIndex: 1, explanation: 'التوكل هو المفهوم الإسلامي للثقة الكاملة والاعتماد على الله بعد اتخاذ الأسباب.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_36', question: 'كم عدد الكبائر المتفق عليها في الإسلام تقريباً؟', options: ['7', '12', 'يختلف بين العلماء', 'غير محدد'], correctAnswerIndex: 2, explanation: 'بينما لا توجد قائمة ثابتة نهائية، يتفق العلماء على الكبائر الكبرى كالشرك والقتل.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_37', question: 'ما هو مفهوم "التقوى" في الإسلام؟', options: ['الخوف فقط', 'مخافة الله والوعي به', 'الصلاة', 'الصدقة'], correctAnswerIndex: 1, explanation: 'التقوى هي مفهوم الوعي بالله والخوف منه، وهو أساسي للتطور الروحي.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_38', question: 'من كان أفضل قراء القرآن بين الصحابة بصوته؟', options: ['عمر', 'أبو موسى الأشعري', 'عثمان', 'علي'], correctAnswerIndex: 1, explanation: 'اشتهر أبو موسى الأشعري بصوته الجميل وتلاوته الاستثنائية للقرآن.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_39', question: 'ما أهمية الرقم 19 في القرآن؟', options: ['عدد الأركان', 'عدد الملائكة', 'مرتبط بخزنة جهنم وعددهم 19', 'عدد الصلوات'], correctAnswerIndex: 2, explanation: 'يظهر الرقم 19 في سورة المدثر فيما يتعلق بحراس جهنم.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_40', question: 'ما هي "شهادة الولاية"؟', options: ['شهادة الإيمان', 'شهادة الولاء لأمير المؤمنين', 'شهادة السفر', 'شهادة الثروة'], correctAnswerIndex: 0, explanation: 'تشير إلى امتداد الشهادة الإسلامية فيما يتعلق بالولاء.', difficulty: 'medium'),
    ];
  }

  // --- ARABIC: HARD ---
  List<QuizQuestion> _getHardQuestionsAr() {
    return [
      QuizQuestion(id: 'hard_1', question: 'ما هو التفسير الذي يعتمد بشكل كبير على المأثور عن السلف؟', options: ['التفسير بالمأثور', 'التفسير بالرأي', 'التفسير بالإجماع', 'التفسير بالاجتهاد'], correctAnswerIndex: 0, explanation: 'التفسير بالمأثور هو التفسير المبني على التقاليد المنقولة عن النبي والصحابة.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_2', question: 'أي إعجاز رياضي يوجد في سورة النور يتعلق بالرقم 24؟', options: ['يحدث 24 مرة', 'يحتوي على 24 آية', 'يتعلق بـ 24 ساعة', 'مذكور بأنماط رياضية محددة'], correctAnswerIndex: 3, explanation: 'تحتوي سورة النور على أنماط رياضية تتعلق بالرقم 24 اكتشفها العلماء المعاصرون.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_3', question: 'ما هو مفهوم "النسخ" في علوم القرآن؟', options: ['النسخ الحرفي', 'إلغاء حكم شرعي سابق بحكم متأخر', 'السرد', 'التخصيص'], correctAnswerIndex: 1, explanation: 'النسخ يشير إلى إلغاء أو تغيير أحكام قرآنية سابقة بوحي لاحق.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_4', question: 'كم مرة ذُكرت كلمة "قرآن" في القرآن نفسه؟', options: ['20', '50', '70', '100'], correctAnswerIndex: 2, explanation: 'تظهر كلمة "قرآن" حوالي 70 مرة بأشكال مختلفة في النص القرآني.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_5', question: 'ما هو "المتن" في مصطلح الحديث؟', options: ['سلسلة الرواة', 'نص الحديث نفسه', 'الراوي', 'الموضوع المطروح'], correctAnswerIndex: 1, explanation: 'المتن يشير إلى النص الفعلي للحديث، بخلاف السند (سلسلة الرواة).', difficulty: 'hard'),
      QuizQuestion(id: 'hard_6', question: 'أي سورة تحتوي على أطول آية في القرآن؟', options: ['سورة البقرة (آية 282)', 'سورة آل عمران', 'سورة النساء', 'سورة النور'], correctAnswerIndex: 0, explanation: 'الآية 282 من سورة البقرة (آية الدَّين) هي أطول آية في القرآن بأكمله.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_7', question: 'ما هو "الاجتهاد" في الفقه الإسلامي؟', options: ['اتباع الإجماع', 'استنباط الأحكام الشرعية من الأدلة التفصيلية', 'حفظ القرآن', 'تدريس الشريعة'], correctAnswerIndex: 1, explanation: 'الاجتهاد هو بذل الجهد من قبل العلماء المؤهلين لاستنباط الأحكام الإسلامية.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_8', question: 'كم عدد السور التي تبدأ بـ "الم"؟', options: ['3', '4', '5', '6'], correctAnswerIndex: 2, explanation: 'تبدأ خمس سور بـ (الم): البقرة، آل عمران، العنكبوت، الروم، ولقمان.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_9', question: 'ما هي "سنة الله" المذكورة في القرآن؟', options: ['ممارسات النبي محمد', 'القوانين والسنن الكونية الثابتة التي وضعها الله', 'الممارسات الدينية فقط', 'الروتين اليومي'], correctAnswerIndex: 1, explanation: 'سنة الله تشير إلى الأنماط والقوانين الثابتة التي أرساها الله في الكون.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_10', question: 'من هو النبي الأكثر ذكراً في القرآن الكريم؟', options: ['محمد', 'إبراهيم', 'موسى', 'عيسى'], correctAnswerIndex: 2, explanation: 'النبي موسى ذُكر في القرآن أكثر من أي نبي آخر.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_11', question: 'ما هو الفرق بين "الحرام" و"المكروه"؟', options: ['لا يوجد فرق', 'الحرام ممنوع والمكروه مستهجن لكنه غير محرم', 'المكروه ممنوع والحرام مستهجن', 'كلاهما يعني نفس الشيء'], correctAnswerIndex: 1, explanation: 'الحرام ممنوع تماماً بينما المكروه لا يُستحب فعله لكنه ليس محظوراً بصرامة.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_12', question: 'ما هو "الخلاف" في الفقه الإسلامي؟', options: ['الاختلاف بين العلماء', 'الخلافة', 'النزاع بين الناس', 'اختلاف أوقات الصلاة'], correctAnswerIndex: 0, explanation: 'الخلاف يشير إلى الاختلاف الفقهي بين العلماء في مسائل الشريعة.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_13', question: 'في أي سور تُروى قصة أصحاب الفيل؟', options: ['سورة الفيل', 'سورة الفيل فقط', 'سورة المسد والفيل', 'سور متعددة'], correctAnswerIndex: 1, explanation: 'تُروى قصة الفيل في سورة الفيل (السورة 105).', difficulty: 'hard'),
      QuizQuestion(id: 'hard_14', question: 'ما هو مبدأ "الضرورة" في الشريعة الإسلامية؟', options: ['الطوارئ العامة', 'إباحة المحظورات عند الضرورة القصوى (الضرورات تبيح المحظورات)', 'التفضيل الشخصي', 'الغياب المؤقت'], correctAnswerIndex: 1, explanation: 'الضرورة هي المبدأ الذي يبيح رفع الحظر في حالات الحاجة الماسة.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_15', question: 'كم عدد السور التي سميت بأسماء حيوانات؟', options: ['3', '4', '5', '6'], correctAnswerIndex: 2, explanation: 'خمس سور: البقرة، الأنعام (الماشية)، النحل، النمل، والعنكبوت.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_16', question: 'ما هو التواتر في علم الحديث؟', options: ['سلسلة رواية فردية', 'رواية جمع عن جمع يستحيل تواطؤهم على الكذب', 'حديث ضعيف', 'حديث موضوع'], correctAnswerIndex: 1, explanation: 'التواتر هو أن يروي الحديث جمع كبير يستحيل اتفاقهم على الكذب.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_17', question: 'أي سورة تُعرف بـ "سورة المؤمنين"؟', options: ['سورة المؤمنون', 'سورة الأنعام', 'سورة الإيمان', 'سورة التوبة'], correctAnswerIndex: 0, explanation: 'سورة المؤمنون (السورة 23).', difficulty: 'hard'),
      QuizQuestion(id: 'hard_18', question: 'ما هو "توحيد الربوبية"؟', options: ['الإيمان بالأنبياء', 'الإيمان بأن الله هو الخالق الرازق المدبر', 'الإيمان بالكتب', 'الإيمان بيوم القيامة'], correctAnswerIndex: 1, explanation: 'توحيد الربوبية هو الإيمان بأن الله وحده هو الخالق والمدبر للكون.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_19', question: 'كم مرة ذُكرت كلمة "الجنة" صراحة في القرآن؟', options: ['30', '50', '77', '100'], correctAnswerIndex: 2, explanation: 'وردت كلمة "الجنة" حوالي 77 مرة في القرآن.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_20', question: 'ما هي "السيرة النبوية"؟', options: ['القانون الإسلامي فقط', 'السيرة الذاتية للنبي محمد التي تغطي حياته وتعاليمه', 'التفسير القرآني', 'جمع الحديث'], correctAnswerIndex: 1, explanation: 'السيرة النبوية هي السيرة الشاملة لحياة النبي محمد ورسالته.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_21', question: 'ما هو "مصطلح الحديث"؟', options: ['مجموعة أحاديث', 'علم قواعد تقييم وتصنيف الحديث الشريف', 'قواعد الحديث', 'أساسيات دراسات الحديث'], correctAnswerIndex: 1, explanation: 'مصطلح الحديث هو العلم المستخدم لتقييم صحة الأحاديث وسندها.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_22', question: 'أي سورة تحتوي على أكبر عدد من الأحكام الشرعية؟', options: ['سورة البقرة', 'سورة النساء', 'سورة المائدة', 'سورة التوبة'], correctAnswerIndex: 2, explanation: 'سورة المائدة (السورة 5) تحتوي على أحكام شرعية شاملة وكثيرة.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_23', question: 'ما هي "الكليات الخمس" (مقاصد الشريعة)؟', options: ['الأركان الخمسة', 'الصلوات الخمس', 'حفظ الدين، النفس، العقل، النسل، والمال', 'الصحابة الخمسة'], correctAnswerIndex: 2, explanation: 'مقاصد الشريعة الخمسة هي الحفاظ على: الدين، النفس، العقل، النسل، والمال.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_24', question: 'كم عدد سور القرآن التي لا تبدأ بالبسملة؟', options: ['0', '1', '2', '5'], correctAnswerIndex: 1, explanation: 'سورة التوبة (السورة 9) هي السورة الوحيدة التي لا تبدأ بـ "بسم الله الرحمن الرحيم".', difficulty: 'hard'),
      QuizQuestion(id: 'hard_25', question: 'ما المقصود بـ "آية البرهان"؟', options: ['آيات الدليل والحجة الواضحة في القرآن', 'الوصايا الدينية', 'آيات القصص', 'الآيات العلمية'], correctAnswerIndex: 0, explanation: 'آية البرهان تشير إلى الآيات التي تعمل كأدلة أو براهين قاطعة.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_26', question: 'أي سورة تناقش أكبر عدد من الأنبياء بالتفصيل؟', options: ['سورة يوسف', 'سورة آل عمران', 'سورة الصافات', 'سورة الأنبياء'], correctAnswerIndex: 3, explanation: 'سورة الأنبياء (السورة 21) تناقش العديد من الأنبياء وقصصهم.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_27', question: 'ما هو "السند" في علم الحديث؟', options: ['نص الحديث', 'سلسلة الرواة الذين نقلوا الحديث', 'الموضوع', 'الشرح'], correctAnswerIndex: 1, explanation: 'السند هو سلسلة الرواة التي ينتقل عبرها الحديث.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_28', question: 'ما هو "التفسير بالإجماع"؟', options: ['التفسير الشخصي', 'التفسير المبني على إجماع علماء المسلمين', 'التفسير المجازي', 'التفسير العلمي'], correctAnswerIndex: 1, explanation: 'التفسير بالإجماع يعتمد على التفسيرات المتفق عليها من قبل علماء المسلمين.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_29', question: 'إلى كم "جزء" يُقسم القرآن الكريم؟', options: ['20', '25', '30', '40'], correctAnswerIndex: 2, explanation: 'يُقسم القرآن تقليدياً إلى 30 جزءاً متساوياً لتسهيل التلاوة.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_30', question: 'ما هو مفهوم "توحيد الألوهية"؟', options: ['الإيمان بالأنبياء', 'الإيمان بإفراد الله بالعبادة وحده لا شريك له', 'الإيمان بالكتب', 'الإيمان بالملائكة'], correctAnswerIndex: 1, explanation: 'توحيد الألوهية هو الإيمان بأن الله وحده هو المستحق للعبادة.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_31', question: 'من هو العالم الذي جمع أصح كتاب حديث يُعرف بـ "صحيح البخاري"؟', options: ['مسلم بن الحجاج', 'محمد بن إسماعيل البخاري', 'الترمذي', 'أبو داود'], correctAnswerIndex: 1, explanation: 'محمد البخاري هو من جمع صحيح البخاري، وهو من أصح كتب الحديث.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_32', question: 'ما هو تصنيف "المكي والمدني" في علوم القرآن؟', options: ['مواقع جغرافية فقط', 'تصنيف بناءً على مكان ووقت نزول الوحي قبل أو بعد الهجرة', 'نوع المحتوى فقط', 'تصنيف عشوائي'], correctAnswerIndex: 1, explanation: 'المكي والمدني يشير إلى السور التي نزلت قبل وبعد الهجرة إلى المدينة.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_33', question: 'على ماذا تعتمد "الشريعة" بشكل أساسي؟', options: ['العادات الثقافية', 'القرارات السياسية', 'القرآن والسنة مع القياس والإجماع', 'التقاليد التاريخية'], correctAnswerIndex: 2, explanation: 'تعتمد الشريعة على أربعة مصادر: القرآن، السنة، الإجماع، والقياس.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_34', question: 'كم عدد الحروف التي تتكون منها الأبجدية العربية تقليدياً؟', options: ['26', '28', '30', '32'], correctAnswerIndex: 1, explanation: 'تحتوي الأبجدية العربية على 28 حرفاً كما تُعد تقليدياً في العربية الفصحى.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_35', question: 'ما هو منهج "فقه المقاصد"؟', options: ['الفقه التقليدي', 'الفقه المبني على الأهداف والمقاصد الكلية للشريعة', 'التفسير الحديث فقط', 'التفسير الحرفي'], correctAnswerIndex: 1, explanation: 'فقه المقاصد يدرس الأحكام في ضوء الأهداف العليا للشريعة الإسلامية.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_36', question: 'أي سورة تذكر قصة ذي القرنين؟', options: ['سورة الكهف', 'سورة يوسف', 'سورة لقمان', 'سورة الصافات'], correctAnswerIndex: 0, explanation: 'سورة الكهف (السورة 18) تحتوي على القصة المفصلة لذي القرنين.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_37', question: 'ما هو "أصول الفقه"؟', options: ['القانون الإسلامي نفسه', 'مصادر ومنهجية استنباط الفقه الإسلامي', 'مجموعات الحديث', 'التقاليد النبوية'], correctAnswerIndex: 1, explanation: 'أصول الفقه هو علم دراسة المبادئ والمنهجية للفقه الإسلامي.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_38', question: 'كم عدد الآيات التي تناقش تحريم الربا؟', options: ['2', '4', '6', '8'], correctAnswerIndex: 2, explanation: 'تحرم عدة آيات في القرآن الربا صراحة، منها في سورة البقرة وآل عمران.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_39', question: 'ما هو الحديث "المرسل"؟', options: ['حديث موثق', 'حديث سقط من سنده الصحابي ورفعه التابعي للنبي', 'حديث واضح', 'حديث ضعيف'], correctAnswerIndex: 1, explanation: 'المرسل هو الحديث الذي يرويه التابعي عن النبي مباشرة دون ذكر الصحابي.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_40', question: 'أي مذهب فقهي إسلامي لديه أكبر عدد من الأتباع اليوم؟', options: ['الحنبلي', 'المالكي', 'الحنفي', 'الشافعي'], correctAnswerIndex: 2, explanation: 'المذهب الحنفي، الذي أسسه الإمام أبو حنيفة، يمتلك أكبر عدد من الأتباع عالمياً.', difficulty: 'hard'),
    ];
  }

  // ==========================================
  // FRENCH TRANSLATIONS (ALL 120 QUESTIONS)
  // ==========================================

  // --- FRENCH: EASY ---
  List<QuizQuestion> _getEasyQuestionsFr() {
    return [
      QuizQuestion(id: 'easy_1', question: 'Combien de fois par jour les musulmans prient-ils ?', options: ['3 fois', '4 fois', '5 fois', '6 fois'], correctAnswerIndex: 2, explanation: 'Les musulmans sont tenus de prier 5 fois par jour : Fajr, Dhohr, Asr, Maghrib et Icha.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_2', question: 'Comment s\'appelle le mois de jeûne islamique ?', options: ['Shawwal', 'Ramadan', 'Muharram', 'Dhul-Hijjah'], correctAnswerIndex: 1, explanation: 'Le Ramadan est le neuvième mois du calendrier lunaire islamique durant lequel les musulmans jeûnent de l\'aube au coucher du soleil.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_3', question: 'Qui est le dernier Prophète en Islam ?', options: ['Ibrahim', 'Moussa', 'Muhammad', 'Issa'], correctAnswerIndex: 2, explanation: 'Le Prophète Muhammad (paix et bénédictions sur lui) est le dernier messager envoyé par Allah.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_4', question: 'Comment appelle-t-on le pèlerinage islamique ?', options: ['Omra', 'Hajj', 'Tawaf', 'Salat'], correctAnswerIndex: 1, explanation: 'Le Hajj est le pèlerinage à La Mecque, qui est l\'un des cinq piliers de l\'Islam.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_5', question: 'Combien y a-t-il de piliers de l\'Islam ?', options: ['3', '4', '5', '6'], correctAnswerIndex: 2, explanation: 'Il y a 5 piliers de l\'Islam : la Chahada, la Salat, la Zakat, le Siyam (jeûne) et le Hajj.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_6', question: 'Comment s\'appelle la profession de foi en Islam ?', options: ['Salat', 'Chahada', 'Zakat', 'Hajj'], correctAnswerIndex: 1, explanation: 'La Chahada est le credo islamique déclarant qu\'il n\'y a de dieu qu\'Allah et que Muhammad est Son messager.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_7', question: 'Dans quelle direction les musulmans se tournent-ils pour prier ?', options: ['Est', 'Ouest', 'Nord', 'Vers La Mecque (Qibla)'], correctAnswerIndex: 3, explanation: 'Les musulmans font face à la Kaaba à La Mecque pendant la prière, une direction appelée Qibla.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_8', question: 'Qui a construit la Kaaba ?', options: ['Prophète Moussa', 'Prophète Ibrahim et Ismail', 'Prophète Muhammad', 'Prophète Souleymane'], correctAnswerIndex: 1, explanation: 'Selon la tradition islamique, le Prophète Ibrahim et son fils Ismail ont construit la Kaaba.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_9', question: 'Comment appelle-t-on l\'aumône obligatoire en Islam ?', options: ['Siyam', 'Zakat', 'Hajj', 'Tawaf'], correctAnswerIndex: 1, explanation: 'La Zakat est l\'aumône obligatoire qui constitue l\'un des cinq piliers de l\'Islam.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_10', question: 'Combien de chapitres compte le Coran ?', options: ['100', '110', '114', '120'], correctAnswerIndex: 2, explanation: 'Le Coran compte 114 chapitres (Sourates) contenant chacun un ou plusieurs versets (Ayats).', difficulty: 'easy'),
      QuizQuestion(id: 'easy_11', question: 'Sur quoi est basé le calendrier islamique ?', options: ['L\'année solaire', 'L\'année lunaire', 'Solaire et lunaire', 'Les saisons'], correctAnswerIndex: 1, explanation: 'Le calendrier islamique est basé sur l\'année lunaire, également connu sous le nom de calendrier Hégirien.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_12', question: 'Combien de jours compte le Ramadan ?', options: ['25 jours', '28 jours', '29-30 jours', '35 jours'], correctAnswerIndex: 2, explanation: 'Le Ramadan dure 29 ou 30 jours selon l\'observation lunaire du mois.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_13', question: 'Que signifie "Islam" ?', options: ['La paix uniquement', 'La soumission à Dieu', 'La prière', 'La croyance'], correctAnswerIndex: 1, explanation: 'Islam signifie la soumission à la volonté d\'Allah et dérive du mot arabe pour la paix et la soumission.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_14', question: 'Qui fut le premier Prophète en Islam ?', options: ['Muhammad', 'Ibrahim', 'Adam', 'Moussa'], correctAnswerIndex: 2, explanation: 'Le Prophète Adam fut le premier humain et le premier Prophète envoyé par Allah.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_15', question: 'Quelle est la salutation islamique ?', options: ['Bonjour', 'As-salamu alaikum', 'Bienvenue', 'Salut'], correctAnswerIndex: 1, explanation: 'As-salamu alaikum (Que la paix soit sur vous) est la salutation islamique, et la réponse est wa alaikum assalam.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_16', question: 'Combien de Prophètes sont explicitement mentionnés dans le Coran ?', options: ['19', '25', '31', '50'], correctAnswerIndex: 1, explanation: '25 prophètes sont nommés dans le Coran, dont Adam, Ibrahim, Moussa, Issa et Muhammad.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_17', question: 'Quelle est la première Sourate du Coran ?', options: ['Sourate Al-Baqarah', 'Sourate Al-Fatiha', 'Sourate An-Nas', 'Sourate Al-Ikhlas'], correctAnswerIndex: 1, explanation: 'La Sourate Al-Fatiha (L\'Ouverture) est le premier chapitre du Coran et est récitée à chaque prière.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_18', question: 'Dans quelle ville est né le Prophète Muhammad ?', options: ['Médine', 'La Mecque', 'Jérusalem', 'Bagdad'], correctAnswerIndex: 1, explanation: 'Le Prophète Muhammad est né à La Mecque (Makkah) en l\'an 570 È.C.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_19', question: 'Qu\'est-ce qui est interdit de manger en Islam ?', options: ['Les légumes', 'Le porc', 'Le poisson', 'Les fruits'], correctAnswerIndex: 1, explanation: 'Le porc et certaines autres viandes sont interdits (Haram) en Islam comme mentionné dans le Coran.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_20', question: 'En quelle année le Prophète Muhammad a-t-il émigré à Médine ?', options: ['610 È.C.', '622 È.C.', '632 È.C.', '650 È.C.'], correctAnswerIndex: 1, explanation: 'L\'Hégire (migration) a eu lieu en 622 È.C., marquant le début du calendrier islamique.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_21', question: 'Combien de fois les musulmans tournent-ils autour de la Kaaba pendant le Hajj ?', options: ['3 fois', '5 fois', '7 fois', '10 fois'], correctAnswerIndex: 2, explanation: 'Les musulmans accomplissent la circumambulation (Tawaf) de la Kaaba 7 fois comme rituel du Hajj.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_22', question: 'Comment appelle-t-on le système juridique islamique ?', options: ['La Charia', 'Les Hadiths', 'Le Fiqh', 'L\'Ijma'], correctAnswerIndex: 0, explanation: 'La Charia (loi islamique) est le cadre juridique basé sur le Coran et la Sunnah.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_23', question: 'Qui a compilé le premier Coran écrit ?', options: ['Abou Bakr', 'Omar', 'Othman', 'Ali'], correctAnswerIndex: 2, explanation: 'Le Calife Othman a organisé la compilation du Coran standardisé pendant son règne.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_24', question: 'Que signifie le mot Hadith ?', options: ['Récitation', 'Histoires des prophètes', 'Paroles et actions du Prophète Muhammad', 'Jurisprudence'], correctAnswerIndex: 2, explanation: 'Le Hadith fait référence aux paroles, actions et approbations enregistrées du Prophète Muhammad.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_25', question: 'Combien de fois le Takbir (Allahu Akbar) est-il récité quotidiennement ?', options: ['5 fois', '10 fois', 'Au moins 10 fois', 'Plusieurs fois par jour'], correctAnswerIndex: 3, explanation: 'Le Takbir est récité de multiples fois chaque jour dans les prières et d\'autres pratiques islamiques.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_26', question: 'Comment s\'appelle le repas pris avant l\'aube pendant le Ramadan ?', options: ['Souhour', 'Iftar', 'Tarawih', 'Qiyam'], correctAnswerIndex: 0, explanation: 'Le Souhour est le repas pris avant l\'aube avant de commencer le jeûne à l\'heure du Fajr.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_27', question: 'Comment appelle-t-on la rupture du jeûne au coucher du soleil ?', options: ['Souhour', 'Iftar', 'Tahajjud', 'Witr'], correctAnswerIndex: 1, explanation: 'L\'Iftar est le repas pris au coucher du soleil pour rompre le jeûne pendant le Ramadan.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_28', question: 'Combien de fois un musulman fait-il ses ablutions (Woudou) par jour ?', options: ['Une fois', 'Deux fois', 'Varie - avant chaque prière', '5 fois seulement'], correctAnswerIndex: 2, explanation: 'Les ablutions sont effectuées avant chaque prière, donc le nombre varie selon les horaires de prière.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_29', question: 'Comment appelle-t-on la prière nocturne pendant le Ramadan ?', options: ['Salat Al-Layl', 'Tarawih', 'Qiyam Al-Layl', 'Tahajjud'], correctAnswerIndex: 1, explanation: 'Les Tarawih sont des prières spéciales effectuées pendant les nuits de Ramadan après la prière de l\'Icha.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_30', question: 'Quelle prière est la plus longue ?', options: ['Fajr', 'Dhohr', 'Asr', 'Maghrib'], correctAnswerIndex: 1, explanation: 'Le Dhohr (prière de la mi-journée) est généralement considéré comme la prière la plus longue de la journée.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_31', question: 'Combien y a-t-il de Rakat (unités) dans la prière du Dhohr ?', options: ['2', '3', '4', '5'], correctAnswerIndex: 2, explanation: 'La prière du Dhohr se compose de 4 Rakat (unités) dans sa forme obligatoire.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_32', question: 'Comment appelle-t-on le témoignage de foi en arabe ?', options: ['Takbir', 'Chahada', 'Tasbih', 'Tahlil'], correctAnswerIndex: 1, explanation: 'La Chahada est la déclaration de foi islamique témoignant de l\'unicité d\'Allah.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_33', question: 'Quel mois est considéré comme le meilleur pour les prières supplémentaires ?', options: ['Shawwal', 'Ramadan', 'Muharram', 'Rajab'], correctAnswerIndex: 1, explanation: 'Le Ramadan est le mois le plus sacré du calendrier islamique, où les bonnes actions sont multipliées.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_34', question: 'Comment appelle-t-on la taxe obligatoire en Islam ?', options: ['Zakat', 'Kharaj', 'Tawaf', 'Sadaqah'], correctAnswerIndex: 0, explanation: 'La Zakat est l\'aumône obligatoire due sur les richesses.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_35', question: 'Combien de côtés possède la Kaaba ?', options: ['2', '3', '4', '6'], correctAnswerIndex: 2, explanation: 'La Kaaba est un bâtiment en forme de cube à 4 côtés, situé à La Mecque.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_36', question: 'Qu\'est-ce que la Sadaqah en Islam ?', options: ['Charité obligatoire', 'Charité volontaire', 'Taxe', 'Punition'], correctAnswerIndex: 1, explanation: 'La Sadaqah est une charité volontaire donnée dans l\'intention d\'aider les autres et de plaire à Allah.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_37', question: 'Qui est la mère du Prophète Muhammad ?', options: ['Aminah', 'Halimah', 'Khadijah', 'Aicha'], correctAnswerIndex: 0, explanation: 'Aminah bint Wahb était la mère biologique du Prophète Muhammad.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_38', question: 'Sous quel autre nom connaît-on le calendrier islamique ?', options: ['Calendrier Solaire', 'Calendrier Hégirien', 'Calendrier Grégorien', 'Calendrier Julien'], correctAnswerIndex: 1, explanation: 'Le calendrier islamique est aussi appelé calendrier Hégirien, d\'après l\'Hégire (migration).', difficulty: 'easy'),
      QuizQuestion(id: 'easy_39', question: 'Combien de versets le Coran contient-il environ ?', options: ['3000', '6000', '9000', '12000'], correctAnswerIndex: 1, explanation: 'Le Coran contient environ 6 236 versets répartis dans 114 chapitres.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_40', question: 'Que signifie "Bismillah" ?', options: ['Gloire à Allah', 'Au nom d\'Allah', 'Allah est grand', 'Louange à Allah'], correctAnswerIndex: 1, explanation: 'Bismillah signifie "Au nom d\'Allah" et est récité avant de commencer toute action.', difficulty: 'easy'),
    ];
  }

  // --- FRENCH: MEDIUM ---
  List<QuizQuestion> _getMediumQuestionsFr() {
    return [
      QuizQuestion(id: 'mid_1', question: 'Qu\'est-ce que la Sunnah ?', options: ['Les enseignements d\'autres religions', 'Les pratiques et traditions du Prophète Muhammad', 'Rituels de pèlerinage', 'Codes juridiques islamiques'], correctAnswerIndex: 1, explanation: 'La Sunnah désigne les traditions et pratiques du Prophète Muhammad qui servent de modèle.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_2', question: 'Qui fut le premier Calife musulman ?', options: ['Omar ibn Al-Khattab', 'Abou Bakr', 'Othman ibn Affan', 'Ali ibn Abi Talib'], correctAnswerIndex: 1, explanation: 'Abou Bakr (As-Siddiq) fut le premier Calife après le Prophète Muhammad (632-634 È.C.).', difficulty: 'medium'),
      QuizQuestion(id: 'mid_3', question: 'Qu\'est-ce que le Fiqh dans la jurisprudence islamique ?', options: ['La mémorisation du Coran', 'La compréhension et l\'interprétation de la loi islamique', 'Les traditions narratives', 'Les expressions poétiques'], correctAnswerIndex: 1, explanation: 'Le Fiqh est la branche de la connaissance islamique traitant de la compréhension et de l\'application de la Charia.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_4', question: 'Qu\'est-ce que l\'Ijma en droit islamique ?', options: ['L\'opinion personnelle', 'Le consensus des savants islamiques', 'Les versets coraniques', 'Les traditions uniquement'], correctAnswerIndex: 1, explanation: 'L\'Ijma est le consensus des savants islamiques sur une question particulière et est une source de droit.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_5', question: 'Combien de compagnons sont connus sous le nom de "Califes Bien Guidés" ?', options: ['2', '3', '4', '5'], correctAnswerIndex: 2, explanation: 'Les quatre Califes Bien Guidés sont Abou Bakr, Omar, Othman et Ali, ayant régné de 632 à 661 È.C.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_6', question: 'Comment appelle-t-on la Nuit du Destin en arabe ?', options: ['Laylat Al-Qadr', 'Laylat Al-Jinn', 'Laylat Al-Isra', 'Laylat Al-Baraa'], correctAnswerIndex: 0, explanation: 'Laylat Al-Qadr (La Nuit du Destin) est la nuit où le Coran fut révélé pour la première fois.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_7', question: 'Quelle Sourate mentionne la Nuit du Destin ?', options: ['Sourate Al-Alaq', 'Sourate Al-Qadr', 'Sourate Ar-Rahman', 'Sourate Al-Adiyat'], correctAnswerIndex: 1, explanation: 'La Sourate Al-Qadr (Chapitre 97) est entièrement consacrée à la description de la Nuit du Destin.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_8', question: 'Qu\'est-ce que le Qiyyas dans la jurisprudence islamique ?', options: ['La mesure', 'Le raisonnement par analogie', 'Le rapport', 'Le questionnement'], correctAnswerIndex: 1, explanation: 'Le Qiyyas est la méthode pour déduire des règles islamiques en faisant des analogies avec des cas similaires.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_9', question: 'Combien de scribes de la révélation le Prophète Muhammad avait-il ?', options: ['3', '5', '15-20', 'Plus de 40'], correctAnswerIndex: 3, explanation: 'Le Prophète Muhammad avait plus de 40 scribes qui ont enregistré les révélations coraniques.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_10', question: 'Que signifie le Hijab dans le contexte islamique ?', options: ['Seulement un foulard', 'La pudeur et un vêtement modeste couvrant pour hommes et femmes', 'Uniquement un paravent', 'Une interdiction religieuse'], correctAnswerIndex: 1, explanation: 'Le Hijab représente la pudeur et ne se limite pas aux vêtements féminins, mais s\'applique aux deux sexes.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_11', question: 'Qu\'est-ce que l\'Isra et le Mi\'raj ?', options: ['Deux voyages différents', 'Le voyage nocturne du Prophète vers Jérusalem et son ascension au ciel', 'Deux Sourates du Coran', 'Deux noms de la Kaaba'], correctAnswerIndex: 1, explanation: 'L\'Isra est le voyage nocturne vers Jérusalem, et le Mi\'raj est l\'ascension vers les cieux.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_12', question: 'Quelle Sourate contient le Verset du Trône (Ayat Al-Kursi) ?', options: ['Sourate Al-Baqarah', 'Sourate Aal-Imran', 'Sourate An-Noor', 'Sourate Ya-Seen'], correctAnswerIndex: 0, explanation: 'L\'Ayat Al-Kursi se trouve dans la Sourate Al-Baqarah (2:255) et est l\'un des versets les plus importants.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_13', question: 'Quelle est la Sourate la plus courte du Coran ?', options: ['Sourate Al-Ikhlas', 'Sourate An-Nas', 'Sourate Al-Kawthar', 'Sourate Al-Fil'], correctAnswerIndex: 2, explanation: 'La Sourate Al-Kawthar (Chapitre 108) est la plus courte avec seulement 3 versets.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_14', question: 'Combien de noms différents (Asma) d\'Allah sont mentionnés dans le Coran ?', options: ['50', '99', '150', '200'], correctAnswerIndex: 1, explanation: 'Bien que de nombreux noms d\'Allah apparaissent, 99 sont particulièrement soulignés dans la tradition.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_15', question: 'Qu\'est-ce que la Bataille de Badr ?', options: ['Un lieu à Médine', 'La première bataille majeure entre les Musulmans et les Qurayshites', 'Une route commerciale', 'Un puits d\'eau'], correctAnswerIndex: 1, explanation: 'La Bataille de Badr (2 AH/624 È.C.) fut le premier affrontement militaire majeur.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_16', question: 'Que signifie "Oumma" ?', options: ['Mère', 'Nation ou communauté', 'Grand-mère', 'Tribu'], correctAnswerIndex: 1, explanation: 'L\'Oumma désigne la communauté musulmane mondiale unie par la foi en l\'Islam.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_17', question: 'Quels sont les six articles de la croyance islamique ?', options: ['Allah, Coran, Prière, Jeûne, Zakat, Hajj', 'Croyance en Allah, aux Anges, aux Livres, aux Prophètes, au Jour du Jugement et au Décret Divin', 'Uniquement les Cinq Piliers', 'Uniquement les noms d\'Allah'], correctAnswerIndex: 1, explanation: 'Les Six Articles de Foi forment le fondement de la croyance islamique.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_18', question: 'Qui était la première femme du Prophète Ibrahim ?', options: ['Sarah', 'Hagar', 'Keturah', 'Léa'], correctAnswerIndex: 0, explanation: 'Sarah (Sara) était la première femme du Prophète Ibrahim et la mère du Prophète Ishaq.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_19', question: 'Pour quoi le mois islamique de Muharram est-il connu ?', options: ['Mois de jeûne', 'Mois de pèlerinage', 'Mois sacré contenant Achoura', 'Mois de batailles'], correctAnswerIndex: 2, explanation: 'Muharram est le premier mois de l\'année islamique et est sacré. Le 10ème jour est Achoura.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_20', question: 'Qu\'est-ce que la Zakat Al-Fitr ?', options: ['Taxe foncière', 'Charité donnée à la fin du Ramadan avant la prière de l\'Aïd', 'Charité mensuelle', 'Charité pour les pauvres uniquement'], correctAnswerIndex: 1, explanation: 'La Zakat Al-Fitr est une charité spécifique donnée avant l\'Aïd Al-Fitr.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_21', question: 'Combien de piliers possède le Trône d\'Allah ?', options: ['2', '4', '8', 'Non spécifié dans le Coran'], correctAnswerIndex: 2, explanation: 'Selon la tradition islamique (et le Coran), huit anges portent le Trône d\'Allah.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_22', question: 'Quel est le nom de l\'ange qui a transmis la révélation du Coran ?', options: ['Gabriel (Jibril)', 'Michaël (Mikhaïl)', 'Israfil', 'Malik'], correctAnswerIndex: 0, explanation: 'L\'Ange Gabriel (Jibril) est l\'ange qui a apporté la révélation coranique au Prophète Muhammad.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_23', question: 'Quelle est la première action jugée le Jour du Jugement ?', options: ['La croyance', 'La prière', 'La charité', 'La gentillesse'], correctAnswerIndex: 1, explanation: 'Selon le hadith, la prière est la première action à être jugée le Jour du Jugement.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_24', question: 'Combien de fois l\'expression "Ya Ayouha" (Ô vous) apparaît-elle dans le Coran ?', options: ['50', '100', '165', '200'], correctAnswerIndex: 2, explanation: 'L\'expression "Ya Ayouha" apparaît 165 fois dans le Coran, s\'adressant souvent aux croyants.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_25', question: 'Quelle est la salutation islamique à la vue du croissant de lune ?', options: ['Allahu Akbar', 'Alhamdulillah', 'L\'invocation varie selon les régions', 'Pas de salutation spécifique'], correctAnswerIndex: 2, explanation: 'Bien que "Alhamdulillah" soit courant, il existe des invocations spécifiques qui varient culturellement.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_26', question: 'Combien de fois le Prophète Muhammad a-t-il accompli le Hajj ?', options: ['Une fois', 'Deux fois', 'Trois fois', 'Cinq fois'], correctAnswerIndex: 0, explanation: 'Le Prophète Muhammad n\'a accompli le Hajj qu\'une seule fois en 10 AH/632 È.C. (Pèlerinage d\'Adieu).', difficulty: 'medium'),
      QuizQuestion(id: 'mid_27', question: 'Qu\'est-ce que l\'Istikhara ?', options: ['Rituel de jeûne', 'Prière de consultation pour chercher l\'aide d\'Allah lors d\'une décision', 'Rituel de pèlerinage', 'Salutation'], correctAnswerIndex: 1, explanation: 'L\'Istikhara est une prière pour chercher la guidance divine lors de décisions importantes de la vie.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_28', question: 'Qui sont les anges gardiens de chaque personne ?', options: ['Gabriel', 'Michaël', 'Kiraman Katibin', 'Malik'], correctAnswerIndex: 2, explanation: 'Les Kiraman Katibin sont les nobles anges qui enregistrent toutes nos actions, bonnes et mauvaises.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_29', question: 'Comment appelle-t-on le châtiment dans la tombe ?', options: ['Adhab Al-Qabr', 'Jahim', 'Saqar', 'Laza'], correctAnswerIndex: 0, explanation: 'Adhab Al-Qabr fait référence au châtiment dans la tombe, un concept mentionné dans l\'Islam.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_30', question: 'Combien de versets compte la Sourate Al-Baqarah ?', options: ['100', '200', '286', '300'], correctAnswerIndex: 2, explanation: 'La Sourate Al-Baqarah (Chapitre 2) compte 286 versets et est le chapitre le plus long du Coran.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_31', question: 'Que signifie "Sadaqah Jariyah" ?', options: ['Charité ponctuelle', 'Charité continue dont les bienfaits se poursuivent après la mort', 'Charité forcée', 'Charité de fête'], correctAnswerIndex: 1, explanation: 'La Sadaqah Jariyah est une charité continue, comme la construction d\'un puits ou d\'une école.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_32', question: 'Quelle femme compagnon du Prophète était connue pour son vaste savoir ?', options: ['Aicha', 'Fatima', 'Hafsa', 'Zaynab'], correctAnswerIndex: 0, explanation: 'Aicha bint Abou Bakr était connue pour sa vaste connaissance de l\'Islam.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_33', question: 'Comment le mois islamique du jeûne est-il orthographié en français ?', options: ['Ramada', 'Ramazan', 'Ramadan', 'Ramanah'], correctAnswerIndex: 2, explanation: 'Ramadan est l\'orthographe standard en français pour le neuvième mois islamique.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_34', question: 'Combien d\'archanges sont mentionnés par leur nom dans le Coran ?', options: ['2', '3', '4', '5'], correctAnswerIndex: 2, explanation: 'Quatre archanges sont nommés : Gabriel (Jibril), Michaël (Mikhaïl), Israfil et Malik.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_35', question: 'Quel est le concept du "Tawakkoul" en Islam ?', options: ['Prière', 'La confiance en Allah après avoir fait de son mieux', 'Jeûne', 'Charité'], correctAnswerIndex: 1, explanation: 'Le Tawakkoul est le concept islamique de confiance totale en Allah après avoir pris les mesures nécessaires.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_36', question: 'Combien de péchés majeurs y a-t-il en Islam ?', options: ['7', '12', 'Varie selon les savants', 'Indéfini'], correctAnswerIndex: 2, explanation: 'Bien qu\'il n\'y ait pas de liste fixe, les savants s\'accordent sur les grands péchés comme le Shirk ou le meurtre.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_37', question: 'Quel est le concept islamique de "Taqwa" ?', options: ['La peur uniquement', 'La piété et la conscience de Dieu', 'La prière', 'La charité'], correctAnswerIndex: 1, explanation: 'La Taqwa est le concept de conscience de Dieu et de piété, central dans le développement spirituel.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_38', question: 'Qui était le meilleur récitateur du Coran parmi les compagnons ?', options: ['Omar', 'Abou Moussa Al-Achari', 'Othman', 'Ali'], correctAnswerIndex: 1, explanation: 'Abou Moussa Al-Achari était connu pour sa belle voix et sa récitation exceptionnelle du Coran.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_39', question: 'Quelle est la signification du nombre 19 dans le Coran ?', options: ['Nombre de piliers', 'Nombre d\'archanges', 'Associé aux 19 gardiens de l\'Enfer', 'Nombre de prières'], correctAnswerIndex: 2, explanation: 'Le nombre 19 apparaît dans la Sourate Al-Mouddaththir concernant les gardiens de l\'Enfer.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_40', question: 'Qu\'est-ce que la "Chahada Toul-Wilaya" ?', options: ['Témoignage de foi', 'Témoignage d\'allégeance à l\'Emir des Croyants', 'Témoignage de voyage', 'Témoignage de richesse'], correctAnswerIndex: 0, explanation: 'Bien que moins courant, ce terme fait référence à une extension du témoignage islamique concernant la loyauté.', difficulty: 'medium'),
    ];
  }

  // --- FRENCH: HARD ---
  List<QuizQuestion> _getHardQuestionsFr() {
    return [
      QuizQuestion(id: 'hard_1', question: 'Comment appelle-t-on l\'approche du Tafsir qui s\'appuie fortement sur les savants islamiques classiques ?', options: ['Tafsir Bil-Ma\'thour', 'Tafsir Bil-Ra\'y', 'Tafsir Bil-Ijma', 'Tafsir Bil-Ijtihad'], correctAnswerIndex: 0, explanation: 'Le Tafsir Bil-Ma\'thour est l\'exégèse basée sur les traditions transmises par le Prophète et ses compagnons.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_2', question: 'Quel miracle mathématique se trouve dans la Sourate An-Noor concernant le nombre 24 ?', options: ['Apparaît 24 fois', 'Contient 24 versets', 'Lié aux 24 heures de la journée', 'Mentionné avec des modèles mathématiques spécifiques'], correctAnswerIndex: 3, explanation: 'La Sourate An-Noor contient des modèles mathématiques liés au nombre 24 découverts par des savants modernes.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_3', question: 'Qu\'est-ce que le concept de "Naskh" dans la jurisprudence coranique ?', options: ['Copie', 'L\'abrogation des révélations antérieures par des révélations ultérieures', 'Narration', 'Spécification'], correctAnswerIndex: 1, explanation: 'Le Naskh fait référence à l\'abrogation des règles coraniques antérieures par des révélations plus tardives.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_4', question: 'Combien de fois le mot "Coran" est-il mentionné dans le Coran lui-même ?', options: ['20', '50', '70', '100'], correctAnswerIndex: 2, explanation: 'Le mot "Coran" apparaît environ 70 fois sous diverses formes tout au long du texte.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_5', question: 'Qu\'est-ce que le "Matn" dans la terminologie du Hadith ?', options: ['La chaîne de transmission', 'Le texte/corps du hadith', 'Le narrateur', 'Le sujet discuté'], correctAnswerIndex: 1, explanation: 'Le Matn fait référence au texte réel d\'un hadith, par opposition à l\'Isnad (chaîne de transmission).', difficulty: 'hard'),
      QuizQuestion(id: 'hard_6', question: 'Quelle Sourate contient le plus long verset du Coran ?', options: ['Sourate Al-Baqarah (Verset 282)', 'Sourate Aal-Imran', 'Sourate An-Nisa', 'Sourate An-Noor'], correctAnswerIndex: 0, explanation: 'Le verset 282 de la Sourate Al-Baqarah (le verset de la dette) est le plus long verset du Coran.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_7', question: 'Qu\'est-ce que l\'"Ijtihad" dans la jurisprudence islamique ?', options: ['Le suivi du consensus', 'Le raisonnement indépendant pour déduire des règles du Coran et de la Sunnah', 'La mémorisation du Coran', 'L\'enseignement du droit islamique'], correctAnswerIndex: 1, explanation: 'L\'Ijtihad est l\'effort de réflexion indépendant mené par des savants qualifiés pour déduire des règles.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_8', question: 'Combien de Sourates commencent par Alif-Lam-Mim ?', options: ['3', '4', '5', '6'], correctAnswerIndex: 2, explanation: 'Cinq Sourates commencent par Alif-Lam-Mim : Al-Baqarah, Aal-Imran, Al-Ankabut, Ar-Rum, et Luqman.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_9', question: 'Qu\'est-ce que la "Sunna d\'Allah" mentionnée dans le Coran ?', options: ['Les pratiques du Prophète Muhammad', 'Les lois et modèles immuables établis par Allah dans l\'univers', 'Les pratiques religieuses uniquement', 'Les routines quotidiennes'], correctAnswerIndex: 1, explanation: 'La Sunna d\'Allah fait référence aux modèles et lois immuables établis par Allah dans la création.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_10', question: 'Quel Prophète est le plus fréquemment mentionné dans le Coran ?', options: ['Muhammad', 'Ibrahim', 'Moussa', 'Issa'], correctAnswerIndex: 2, explanation: 'Le Prophète Moussa (Moïse) est mentionné plus fréquemment que tout autre prophète dans le Coran.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_11', question: 'Quelle est la différence entre "Haram" et "Makrouh" ?', options: ['Aucune différence', 'Haram est interdit, Makrouh est déconseillé mais permis', 'Makrouh est interdit, Haram est déconseillé', 'Les deux signifient la même chose'], correctAnswerIndex: 1, explanation: 'Haram est absolument interdit, tandis que Makrouh est déconseillé sans être strictement prohibé.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_12', question: 'Qu\'est-ce que le "Khilaf" dans la jurisprudence islamique ?', options: ['Le désaccord entre les savants', 'Le Califat', 'Le conflit entre les gens', 'La différence d\'horaires de prière'], correctAnswerIndex: 0, explanation: 'Le Khilaf désigne le désaccord académique (ikhtilaf) entre les savants sur des questions de droit.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_13', question: 'Quels versets du Coran racontent l\'histoire de l\'Éléphant (Fil) ?', options: ['Sourate Al-Fil', 'Sourate Al-Fil uniquement', 'Sourate Al-Lahab et Al-Fil', 'Plusieurs Sourates'], correctAnswerIndex: 1, explanation: 'L\'histoire de l\'Éléphant est racontée dans la Sourate Al-Fil (Chapitre 105).', difficulty: 'hard'),
      QuizQuestion(id: 'hard_14', question: 'Qu\'est-ce que le concept de "Darourah" (nécessité) en droit islamique ?', options: ['L\'urgence générale', 'L\'exception aux règles islamiques lorsque la nécessité l\'exige et sans autre alternative', 'La préférence personnelle', 'L\'absence temporaire'], correctAnswerIndex: 1, explanation: 'La Darourah est le principe selon lequel les interdictions peuvent être levées en cas de véritable nécessité.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_15', question: 'Combien de Sourates portent le nom d\'animaux ?', options: ['3', '4', '5', '6'], correctAnswerIndex: 2, explanation: 'Cinq Sourates : Al-Baqarah (Vache), Al-An\'am (Bestiaux), An-Nahl (Abeille), An-Naml (Fourmi), Al-Ankabut (Araignée). L\'Éléphant fait six avec Al-Fil, mais classiquement 5 grandes sourates de nom d\'animal sont citées selon l\'auteur.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_16', question: 'Qu\'est-ce que le "Tawatour" dans l\'étude du Hadith ?', options: ['Chaîne de narration unique', 'Corroboration mutuelle - narration rapportée par beaucoup de gens à différentes époques et lieux', 'Hadith faible', 'Hadith inventé'], correctAnswerIndex: 1, explanation: 'Le Tawatour est un hadith si largement rapporté qu\'il est impossible que tous les narrateurs aient comploté.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_17', question: 'Quelle Sourate est connue sous le nom de "Sourate des Croyants" ?', options: ['Sourate Al-Mou\'minoun', 'Sourate Al-An\'am', 'Sourate Al-Imaan', 'Sourate At-Tawbah'], correctAnswerIndex: 0, explanation: 'La Sourate Al-Mou\'minoun (Chapitre 23) se traduit par "Chapitre des Croyants".', difficulty: 'hard'),
      QuizQuestion(id: 'hard_18', question: 'Qu\'est-ce que le "Tawhid Ar-Rouboubiyyah" ?', options: ['Croyance aux prophètes', 'La croyance en la Seigneurie et l\'autorité Unique d\'Allah', 'Croyance aux écritures', 'Croyance au Jour du Jugement'], correctAnswerIndex: 1, explanation: 'Le Tawhid Ar-Rouboubiyyah est la croyance qu\'Allah est le seul créateur et maître de l\'univers.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_19', question: 'Combien de fois le mot "Paradis" (Jannah) est-il explicitement mentionné dans le Coran ?', options: ['30', '50', '77', '100'], correctAnswerIndex: 2, explanation: 'Le mot "Jannah" (Paradis) apparaît environ 77 fois dans le Coran.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_20', question: 'Qu\'est-ce que la "Sira Nabawiyya" ?', options: ['Le droit islamique uniquement', 'La biographie du Prophète Muhammad couvrant sa vie et ses enseignements', 'L\'interprétation coranique', 'Une collection de hadiths'], correctAnswerIndex: 1, explanation: 'La Sira Nabawiyya est la biographie complète de la vie du Prophète Muhammad.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_21', question: 'Qu\'est-ce que le "Moustalah Al-Hadith" ?', options: ['Une collection de hadiths', 'La science de la terminologie et de l\'authentification du Hadith', 'Les règles du Hadith', 'Les bases de l\'étude du Hadith'], correctAnswerIndex: 1, explanation: 'Le Moustalah Al-Hadith est la science utilisée pour évaluer l\'authenticité des hadiths.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_22', question: 'Quelle Sourate contient le plus grand nombre de règles juridiques ?', options: ['Sourate Al-Baqarah', 'Sourate An-Nisa', 'Sourate Al-Ma\'idah', 'Sourate At-Tawbah'], correctAnswerIndex: 2, explanation: 'La Sourate Al-Ma\'idah (Chapitre 5) contient les règles juridiques islamiques les plus complètes.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_23', question: 'Qu\'est-ce que la doctrine des "Koulliyat Al-Khams" (Les Cinq Objectifs) ?', options: ['Les Cinq Piliers', 'Les cinq prières', 'La préservation de la religion, la vie, l\'intellect, la propriété et la lignée', 'Les cinq compagnons'], correctAnswerIndex: 2, explanation: 'Les cinq objectifs de la Charia (Maqasid) sont de préserver : la religion, la vie, l\'intellect, les biens et la lignée.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_24', question: 'Combien de chapitres du Coran commencent sans le Bismillah ?', options: ['0', '1', '2', '5'], correctAnswerIndex: 1, explanation: 'Seule la Sourate At-Tawbah (Chapitre 9) commence sans la formule Bismillah.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_25', question: 'Qu\'est-ce que l\'"Ayah Al-Bourhan" dans la philosophie islamique ?', options: ['Les versets de preuve/d\'évidence dans le Coran', 'Les commandements religieux', 'Les versets d\'histoire', 'Les versets scientifiques'], correctAnswerIndex: 0, explanation: 'L\'Ayah Al-Bourhan désigne les versets qui servent de preuves ou d\'évidences claires.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_26', question: 'Quelle Sourate parle du plus grand nombre de prophètes en détail ?', options: ['Sourate Youssouf', 'Sourate Aal-Imran', 'Sourate As-Saffat', 'Sourate Al-Anbiya'], correctAnswerIndex: 3, explanation: 'La Sourate Al-Anbiya (Chapitre 21, "Les Prophètes") raconte l\'histoire de nombreux prophètes.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_27', question: 'Qu\'est-ce que l\'"Isnad" dans la terminologie du hadith ?', options: ['Le texte du hadith', 'La chaîne des narrateurs rapportant le hadith', 'Le sujet', 'L\'explication'], correctAnswerIndex: 1, explanation: 'L\'Isnad est la chaîne des narrateurs par laquelle un hadith est transmis.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_28', question: 'Qu\'est-ce que le "Tafsir Bil-Ijma" ?', options: ['L\'interprétation personnelle', 'L\'interprétation basée sur le consensus des savants islamiques', 'L\'interprétation métaphorique', 'L\'interprétation scientifique'], correctAnswerIndex: 1, explanation: 'Le Tafsir Bil-Ijma s\'appuie sur les interprétations convenues par de multiples savants.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_29', question: 'En combien de "Jouz" (parties) le Coran est-il divisé ?', options: ['20', '25', '30', '40'], correctAnswerIndex: 2, explanation: 'Le Coran est traditionnellement divisé en 30 parties égales appelées Jouz pour faciliter la récitation.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_30', question: 'Quel est le concept du "Tawhid Al-Oulouhiyyah" ?', options: ['Croyance aux prophètes', 'La croyance d\'adorer Allah seul, sans associés', 'Croyance aux écritures', 'Croyance aux anges'], correctAnswerIndex: 1, explanation: 'Le Tawhid Al-Oulouhiyyah est la croyance que seul Allah mérite l\'adoration.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_31', question: 'Quel savant a compilé le recueil de hadiths le plus authentique, connu sous le nom de "Sahih Al-Boukhari" ?', options: ['Mouslim ibn Al-Hajjaj', 'Muhammad Al-Boukhari', 'At-Tirmidhi', 'Abou Daoud'], correctAnswerIndex: 1, explanation: 'Muhammad Al-Boukhari a compilé le Sahih Al-Boukhari, le recueil de hadiths le plus authentique.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_32', question: 'Qu\'est-ce que la classification "Mecquoise vs Médinoise" dans les études coraniques ?', options: ['Des lieux géographiques uniquement', 'Une classification basée sur le moment de la révélation (avant/après l\'Hégire)', 'Un type de contenu', 'Une classification aléatoire'], correctAnswerIndex: 1, explanation: 'Les Sourates Mecquoises et Médinoises font référence aux révélations antérieures et postérieures à l\'Hégire.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_33', question: 'Sur quoi la "Charia" est-elle fondamentalement basée ?', options: ['Les coutumes culturelles', 'Les décisions politiques', 'Le Coran, la Sunnah, le raisonnement analogique (Qiyas) et le consensus (Ijma)', 'Les traditions historiques'], correctAnswerIndex: 2, explanation: 'La Charia repose sur quatre sources : le Coran, la Sunnah, l\'Ijma (consensus) et le Qiyas (analogie).', difficulty: 'hard'),
      QuizQuestion(id: 'hard_34', question: 'Combien de lettres l\'alphabet arabe compte-t-il traditionnellement ?', options: ['26', '28', '30', '32'], correctAnswerIndex: 1, explanation: 'L\'alphabet arabe compte traditionnellement 28 lettres dans l\'arabe classique.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_35', question: 'Qu\'est-ce que l\'approche "Fiqh Maqasid" ?', options: ['La jurisprudence traditionnelle', 'La jurisprudence basée sur les objectifs et desseins globaux de la Charia', 'L\'interprétation moderne', 'L\'interprétation littérale'], correctAnswerIndex: 1, explanation: 'Le Fiqh Maqasid examine les règles à la lumière des objectifs supérieurs (Maqasid) de la loi islamique.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_36', question: 'Quelle Sourate mentionne Dhou\'l-Qarnayn ?', options: ['Sourate Al-Kahf', 'Sourate Youssouf', 'Sourate Luqman', 'Sourate As-Saffat'], correctAnswerIndex: 0, explanation: 'La Sourate Al-Kahf (Chapitre 18) contient l\'histoire détaillée de Dhou\'l-Qarnayn.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_37', question: 'Qu\'est-ce que les "Ousoul Al-Fiqh" ?', options: ['La loi islamique elle-même', 'Les sources et la méthodologie de la jurisprudence islamique', 'Les recueils de hadiths', 'Les traditions prophétiques'], correctAnswerIndex: 1, explanation: 'Les Ousoul Al-Fiqh désignent la science des principes et de la méthodologie de la jurisprudence islamique.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_38', question: 'Combien de versets discutent de l\'interdiction de l\'intérêt (Riba) ?', options: ['2', '4', '6', '8'], correctAnswerIndex: 2, explanation: 'Plusieurs versets du Coran (environ 6) interdisent explicitement le Riba (l\'usure/l\'intérêt).', difficulty: 'hard'),
      QuizQuestion(id: 'hard_39', question: 'Qu\'est-ce qu\'un hadith "Moursal" ?', options: ['Un hadith authentifié', 'Un hadith dont la chaîne est brisée par l\'absence d\'un compagnon', 'Un hadith clair', 'Un hadith faible'], correctAnswerIndex: 1, explanation: 'Un hadith Moursal est celui dont la chaîne va directement d\'un Tabi\'i (successeur) au Prophète.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_40', question: 'Quelle école de jurisprudence islamique compte le plus grand nombre de fidèles aujourd\'hui ?', options: ['Hanbalite', 'Malikite', 'Hanafite', 'Chaféite'], correctAnswerIndex: 2, explanation: 'L\'école Hanafite, fondée par l\'Imam Abou Hanifa, compte le plus grand nombre de fidèles au monde.', difficulty: 'hard'),
    ];
  }

  // EASY LEVEL QUESTIONS (40 questions)
  List<QuizQuestion> getEasyQuestionsEn() {
    return [
      QuizQuestion(
        id: 'easy_1',
        question: 'How many times a day do Muslims pray?',
        options: ['3 times', '4 times', '5 times', '6 times'],
        correctAnswerIndex: 2,
        explanation: 'Muslims are obligated to pray 5 times a day: Fajr, Dhuhr, Asr, Maghrib, and Isha.',
        difficulty: 'easy',
      ),
      QuizQuestion(
        id: 'easy_2',
        question: 'What is the Islamic month of fasting called?',
        options: ['Shawwal', 'Ramadan', 'Muharram', 'Dhul-Hijjah'],
        correctAnswerIndex: 1,
        explanation: 'Ramadan is the ninth month of the Islamic lunar calendar during which Muslims fast from dawn to sunset.',
        difficulty: 'easy',
      ),
      QuizQuestion(
        id: 'easy_3',
        question: 'Who is the last Prophet in Islam?',
        options: ['Ibrahim', 'Musa', 'Muhammad', 'Isa'],
        correctAnswerIndex: 2,
        explanation: 'Prophet Muhammad (peace be upon him) is the final and last messenger sent by Allah.',
        difficulty: 'easy',
      ),
      QuizQuestion(
        id: 'easy_4',
        question: 'What is the Islamic pilgrimage called?',
        options: ['Umrah', 'Hajj', 'Tawaf', 'Salah'],
        correctAnswerIndex: 1,
        explanation: 'Hajj is the pilgrimage to Mecca that is one of the Five Pillars of Islam.',
        difficulty: 'easy',
      ),
      QuizQuestion(
        id: 'easy_5',
        question: 'How many pillars of Islam are there?',
        options: ['3', '4', '5', '6'],
        correctAnswerIndex: 2,
        explanation: 'There are 5 pillars of Islam: Shahada, Salah, Zakat, Sawm, and Hajj.',
        difficulty: 'easy',
      ),
      QuizQuestion(
        id: 'easy_6',
        question: 'What is the declaration of faith called?',
        options: ['Salah', 'Shahada', 'Zakat', 'Hajj'],
        correctAnswerIndex: 1,
        explanation: 'Shahada is the Islamic creed stating that there is no god but Allah and Muhammad is His messenger.',
        difficulty: 'easy',
      ),
      QuizQuestion(
        id: 'easy_7',
        question: 'Which direction do Muslims face when praying?',
        options: ['East', 'West', 'North', 'Towards Mecca (Qibla)'],
        correctAnswerIndex: 3,
        explanation: 'Muslims face the Kaaba in Mecca during prayer, in a direction called the Qibla.',
        difficulty: 'easy',
      ),
      QuizQuestion(
        id: 'easy_8',
        question: 'Who built the Kaaba?',
        options: ['Prophet Musa', 'Prophet Ibrahim and Ismail', 'Prophet Muhammad', 'Prophet Sulaiman'],
        correctAnswerIndex: 1,
        explanation: 'According to Islamic tradition, Prophet Ibrahim and his son Ismail built the Kaaba.',
        difficulty: 'easy',
      ),
      QuizQuestion(
        id: 'easy_9',
        question: 'What is almsgiving in Islam called?',
        options: ['Sawm', 'Zakat', 'Hajj', 'Tawaf'],
        correctAnswerIndex: 1,
        explanation: 'Zakat is the obligatory almsgiving that is one of the Five Pillars of Islam.',
        difficulty: 'easy',
      ),
      QuizQuestion(
        id: 'easy_10',
        question: 'How many chapters does the Quran have?',
        options: ['100', '110', '114', '120'],
        correctAnswerIndex: 2,
        explanation: 'The Quran has 114 chapters (Surahs) each containing one or more verses (Ayahs).',
        difficulty: 'easy',
      ),
      QuizQuestion(
        id: 'easy_11',
        question: 'What is the Islamic calendar based on?',
        options: ['Solar year', 'Lunar year', 'Both solar and lunar', 'Seasons'],
        correctAnswerIndex: 1,
        explanation: 'The Islamic calendar is based on the lunar year, also known as the Hijri calendar.',
        difficulty: 'easy',
      ),
      QuizQuestion(
        id: 'easy_12',
        question: 'How many days is Ramadan?',
        options: ['25 days', '28 days', '29-30 days', '35 days'],
        correctAnswerIndex: 2,
        explanation: 'Ramadan is 29 or 30 days long depending on the lunar sighting of the month.',
        difficulty: 'easy',
      ),
      QuizQuestion(
        id: 'easy_13',
        question: 'What does "Islam" mean?',
        options: ['Peace only', 'Submission to God', 'Prayer', 'Belief'],
        correctAnswerIndex: 1,
        explanation: 'Islam means submission to the will of Allah and derives from the Arabic word for peace and submission.',
        difficulty: 'easy',
      ),
      QuizQuestion(
        id: 'easy_14',
        question: 'Who was the first Prophet in Islam?',
        options: ['Muhammad', 'Ibrahim', 'Adam', 'Musa'],
        correctAnswerIndex: 2,
        explanation: 'Prophet Adam was the first human and the first Prophet sent by Allah.',
        difficulty: 'easy',
      ),
      QuizQuestion(
        id: 'easy_15',
        question: 'What is the Islamic greeting?',
        options: ['Hello', 'As-salamu alaikum', 'Welcome', 'Greetings'],
        correctAnswerIndex: 1,
        explanation: 'As-salamu alaikum (Peace be upon you) is the Islamic greeting, and the response is wa alaikum assalam.',
        difficulty: 'easy',
      ),
      QuizQuestion(
        id: 'easy_16',
        question: 'How many Prophets are mentioned in the Quran?',
        options: ['19', '25', '31', '50'],
        correctAnswerIndex: 1,
        explanation: '25 prophets are explicitly named in the Quran, including Adam, Ibrahim, Musa, Isa, and Muhammad.',
        difficulty: 'easy',
      ),
      QuizQuestion(
        id: 'easy_17',
        question: 'What is the first Surah of the Quran?',
        options: ['Surah Al-Baqarah', 'Surah Al-Fatiha', 'Surah An-Nas', 'Surah Al-Ikhlas'],
        correctAnswerIndex: 1,
        explanation: 'Surah Al-Fatiha (The Opening) is the first chapter of the Quran and is recited in every prayer.',
        difficulty: 'easy',
      ),
      QuizQuestion(
        id: 'easy_18',
        question: 'In which city was Prophet Muhammad born?',
        options: ['Medina', 'Mecca', 'Jerusalem', 'Baghdad'],
        correctAnswerIndex: 1,
        explanation: 'Prophet Muhammad was born in Mecca (Makkah) in the year 570 CE.',
        difficulty: 'easy',
      ),
      QuizQuestion(
        id: 'easy_19',
        question: 'What is forbidden to eat in Islam?',
        options: ['Vegetables', 'Pork', 'Fish', 'Fruits'],
        correctAnswerIndex: 1,
        explanation: 'Pork and certain other meats are prohibited (Haram) in Islam as mentioned in the Quran.',
        difficulty: 'easy',
      ),
      QuizQuestion(
        id: 'easy_20',
        question: 'What year did Prophet Muhammad migrate to Medina?',
        options: ['610 CE', '622 CE', '632 CE', '650 CE'],
        correctAnswerIndex: 1,
        explanation: 'The Hijra (migration) occurred in 622 CE, marking the beginning of the Islamic calendar.',
        difficulty: 'easy',
      ),
      QuizQuestion(
        id: 'easy_21',
        question: 'How many times do Muslims circumambulate the Kaaba during Hajj?',
        options: ['3 times', '5 times', '7 times', '10 times'],
        correctAnswerIndex: 2,
        explanation: 'Muslims circumambulate (Tawaf) the Kaaba 7 times as a ritual of Hajj.',
        difficulty: 'easy',
      ),
      QuizQuestion(
        id: 'easy_22',
        question: 'What is the Islamic legal system called?',
        options: ['Sharia', 'Hadith', 'Fiqh', 'Ijma'],
        correctAnswerIndex: 0,
        explanation: 'Sharia (Islamic law) is the legal framework based on the Quran and Sunnah.',
        difficulty: 'easy',
      ),
      QuizQuestion(
        id: 'easy_23',
        question: 'Who compiled the first written Quran?',
        options: ['Abu Bakr', 'Umar', 'Uthman', 'Ali'],
        correctAnswerIndex: 2,
        explanation: 'Caliph Uthman organized the compilation of the standardized Quran during his reign.',
        difficulty: 'easy',
      ),
      QuizQuestion(
        id: 'easy_24',
        question: 'What does Hadith mean?',
        options: ['Recitation', 'Stories of prophets', 'Sayings and actions of Prophet Muhammad', 'Jurisprudence'],
        correctAnswerIndex: 2,
        explanation: 'Hadith refers to the recorded sayings, actions, and approvals of Prophet Muhammad.',
        difficulty: 'easy',
      ),
      QuizQuestion(
        id: 'easy_25',
        question: 'How many times is the Takbir (Allahu Akbar) recited daily?',
        options: ['5 times', '10 times', 'At least 10 times', 'Many times throughout the day'],
        correctAnswerIndex: 3,
        explanation: 'The Takbir is recited multiple times daily in prayers and other Islamic practices.',
        difficulty: 'easy',
      ),
      QuizQuestion(
        id: 'easy_26',
        question: 'What is the period of fasting before dawn in Ramadan called?',
        options: ['Suhoor', 'Iftar', 'Taraweeh', 'Qiyam'],
        correctAnswerIndex: 0,
        explanation: 'Suhoor is the pre-dawn meal eaten before beginning the fast at Fajr time.',
        difficulty: 'easy',
      ),
      QuizQuestion(
        id: 'easy_27',
        question: 'What is the breaking of the fast at sunset called?',
        options: ['Suhoor', 'Iftar', 'Tahajjud', 'Witr'],
        correctAnswerIndex: 1,
        explanation: 'Iftar is the meal eaten at sunset to break the fast during Ramadan.',
        difficulty: 'easy',
      ),
      QuizQuestion(
        id: 'easy_28',
        question: 'How many times does a Muslim make ablution (Wudu) per day?',
        options: ['Once', 'Twice', 'Varies - before each prayer', '5 times only'],
        correctAnswerIndex: 2,
        explanation: 'Ablution is performed before each prayer, so the number varies based on prayer times.',
        difficulty: 'easy',
      ),
      QuizQuestion(
        id: 'easy_29',
        question: 'What is the night prayer during Ramadan called?',
        options: ['Salat Al-Layl', 'Taraweeh', 'Qiyam Al-Layl', 'Tahajjud'],
        correctAnswerIndex: 1,
        explanation: 'Taraweeh are special prayers performed during the nights of Ramadan after Isha prayer.',
        difficulty: 'easy',
      ),
      QuizQuestion(
        id: 'easy_30',
        question: 'Which prayer is the longest?',
        options: ['Fajr', 'Dhuhr', 'Asr', 'Maghrib'],
        correctAnswerIndex: 1,
        explanation: 'Dhuhr (midday prayer) is generally considered the longest prayer of the day.',
        difficulty: 'easy',
      ),
      QuizQuestion(
        id: 'easy_31',
        question: 'How many Rakat (units) are in the Dhuhr prayer?',
        options: ['2', '3', '4', '5'],
        correctAnswerIndex: 2,
        explanation: 'The Dhuhr prayer consists of 4 Rakat (units) in its mandatory form.',
        difficulty: 'easy',
      ),
      QuizQuestion(
        id: 'easy_32',
        question: 'What is the testimony of faith called in Arabic?',
        options: ['Takbir', 'Shahada', 'Tasbih', 'Tahlil'],
        correctAnswerIndex: 1,
        explanation: 'Shahada is the Islamic declaration of faith testifying to the oneness of Allah.',
        difficulty: 'easy',
      ),
      QuizQuestion(
        id: 'easy_33',
        question: 'Which month is considered the best month for additional prayers?',
        options: ['Shawwal', 'Ramadan', 'Muharram', 'Rajab'],
        correctAnswerIndex: 1,
        explanation: 'Ramadan is the holiest month in the Islamic calendar when good deeds are multiplied.',
        difficulty: 'easy',
      ),
      QuizQuestion(
        id: 'easy_34',
        question: 'What is the obligatory tax during Hajj called?',
        options: ['Zakat', 'Kharaj', 'Tawaf', 'Sadaqah'],
        correctAnswerIndex: 0,
        explanation: 'While Zakat is general almsgiving, it becomes especially important during Hajj season.',
        difficulty: 'easy',
      ),
      QuizQuestion(
        id: 'easy_35',
        question: 'How many sides does the Kaaba have?',
        options: ['2', '3', '4', '6'],
        correctAnswerIndex: 2,
        explanation: 'The Kaaba is a cube-shaped building with 4 sides, located in Mecca.',
        difficulty: 'easy',
      ),
      QuizQuestion(
        id: 'easy_36',
        question: 'What is Sadaqah in Islam?',
        options: ['Obligatory charity', 'Voluntary charity', 'Tax', 'Punishment'],
        correctAnswerIndex: 1,
        explanation: 'Sadaqah is voluntary charity given with the intention of helping others and pleasing Allah.',
        difficulty: 'easy',
      ),
      QuizQuestion(
        id: 'easy_37',
        question: 'Who is the mother of Prophet Muhammad?',
        options: ['Aminah', 'Haleema', 'Khadijah', 'Aisha'],
        correctAnswerIndex: 0,
        explanation: 'Aminah bint Wahb was the biological mother of Prophet Muhammad.',
        difficulty: 'easy',
      ),
      QuizQuestion(
        id: 'easy_38',
        question: 'What is the Islamic calendar also known as?',
        options: ['Solar Calendar', 'Hijri Calendar', 'Gregorian Calendar', 'Julian Calendar'],
        correctAnswerIndex: 1,
        explanation: 'The Islamic calendar is also called the Hijri calendar, named after the Hijra (migration).',
        difficulty: 'easy',
      ),
      QuizQuestion(
        id: 'easy_39',
        question: 'How many verses are in the Quran approximately?',
        options: ['3000', '6000', '9000', '12000'],
        correctAnswerIndex: 1,
        explanation: 'The Quran contains approximately 6,236 verses distributed among 114 chapters.',
        difficulty: 'easy',
      ),
      QuizQuestion(
        id: 'easy_40',
        question: 'What does "Bismillah" mean?',
        options: ['Glory be to Allah', 'In the name of Allah', 'Allah is great', 'Praise be to Allah'],
        correctAnswerIndex: 1,
        explanation: 'Bismillah means "In the name of Allah" and is recited before beginning any action.',
        difficulty: 'easy',
      ),
    ];
  }

  // MEDIUM LEVEL QUESTIONS (40 questions)
  List<QuizQuestion> getMediumQuestionsEn() {
    return [
      QuizQuestion(
        id: 'mid_1',
        question: 'What is the Sunnah?',
        options: [
          'The teachings of other religions',
          'The practices and traditions of Prophet Muhammad',
          'Pilgrimage rituals',
          'Islamic legal codes'
        ],
        correctAnswerIndex: 1,
        explanation: 'The Sunnah refers to the traditions and practices of Prophet Muhammad that serve as a model for Muslims.',
        difficulty: 'medium',
      ),
      QuizQuestion(
        id: 'mid_2',
        question: 'Who was the first Muslim Caliph?',
        options: ['Umar ibn Al-Khattab', 'Abu Bakr', 'Uthman ibn Affan', 'Ali ibn Abi Talib'],
        correctAnswerIndex: 1,
        explanation: 'Abu Bakr (As-Siddiq) was the first Caliph after Prophet Muhammad, ruling from 632-634 CE.',
        difficulty: 'medium',
      ),
      QuizQuestion(
        id: 'mid_3',
        question: 'What is Fiqh in Islamic jurisprudence?',
        options: [
          'Memorization of Quran',
          'Understanding and interpretation of Islamic law',
          'Storytelling traditions',
          'Poetic expressions'
        ],
        correctAnswerIndex: 1,
        explanation: 'Fiqh is the branch of Islamic knowledge dealing with the understanding and application of Sharia law.',
        difficulty: 'medium',
      ),
      QuizQuestion(
        id: 'mid_4',
        question: 'What is Ijma in Islamic law?',
        options: [
          'Personal opinion',
          'Consensus of Islamic scholars',
          'Quranic verses',
          'Traditions only'
        ],
        correctAnswerIndex: 1,
        explanation: 'Ijma is the consensus of Islamic scholars on a particular matter and is a source of Islamic law.',
        difficulty: 'medium',
      ),
      QuizQuestion(
        id: 'mid_5',
        question: 'How many companions are known as "Rightly Guided Caliphs"?',
        options: ['2', '3', '4', '5'],
        correctAnswerIndex: 2,
        explanation: 'The four Rightly Guided Caliphs are Abu Bakr, Umar, Uthman, and Ali, ruling from 632-661 CE.',
        difficulty: 'medium',
      ),
      QuizQuestion(
        id: 'mid_6',
        question: 'What is the Night of Power called in Arabic?',
        options: ['Laylat Al-Qadr', 'Laylat Al-Jinn', 'Laylat Al-Isra', 'Laylat Al-Baraa'],
        correctAnswerIndex: 0,
        explanation: 'Laylat Al-Qadr (Night of Power) is when the Quran was first revealed and is the most blessed night.',
        difficulty: 'medium',
      ),
      QuizQuestion(
        id: 'mid_7',
        question: 'Which Surah mentions the Night of Power?',
        options: ['Surah Al-Alaq', 'Surah Al-Qadr', 'Surah Ar-Rahman', 'Surah Al-Adiyat'],
        correctAnswerIndex: 1,
        explanation: 'Surah Al-Qadr (Chapter 97) is devoted entirely to describing the Night of Power.',
        difficulty: 'medium',
      ),
      QuizQuestion(
        id: 'mid_8',
        question: 'What is Qiyyas in Islamic jurisprudence?',
        options: [
          'Measurement',
          'Analogical reasoning by analogy',
          'Reporting',
          'Questioning'
        ],
        correctAnswerIndex: 1,
        explanation: 'Qiyyas is the method of deriving Islamic rulings by making analogies to similar cases in the Quran.',
        difficulty: 'medium',
      ),
      QuizQuestion(
        id: 'mid_9',
        question: 'How many scribes of revelation did Prophet Muhammad have?',
        options: ['3', '5', '15-20', 'More than 40'],
        correctAnswerIndex: 3,
        explanation: 'Prophet Muhammad had more than 40 scribes who recorded the Quranic revelations, including Ali and Uthman.',
        difficulty: 'medium',
      ),
      QuizQuestion(
        id: 'mid_10',
        question: 'What does Hijab mean in Islamic context?',
        options: [
          'Only a headscarf',
          'Modesty and modest dress covering for both men and women',
          'Only a screen',
          'A religious prohibition'
        ],
        correctAnswerIndex: 1,
        explanation: 'Hijab represents modesty and is not limited to women\'s clothing but applies to both genders.',
        difficulty: 'medium',
      ),
      QuizQuestion(
        id: 'mid_11',
        question: 'What is the Isra and Mi\'raj?',
        options: [
          'Two different journeys',
          'Prophet Muhammad\'s night journey from Mecca to Jerusalem and ascension to heaven',
          'Two Surahs of the Quran',
          'Two names of the Kaaba'
        ],
        correctAnswerIndex: 1,
        explanation: 'Isra is the night journey to Jerusalem, and Mi\'raj is the ascension to the heavens.',
        difficulty: 'medium',
      ),
      QuizQuestion(
        id: 'mid_12',
        question: 'Which Surah contains the Verse of the Throne (Ayat Al-Kursi)?',
        options: ['Surah Al-Baqarah', 'Surah Aal-Imran', 'Surah An-Noor', 'Surah Ya-Seen'],
        correctAnswerIndex: 0,
        explanation: 'Ayat Al-Kursi is found in Surah Al-Baqarah (2:255) and is one of the most important verses in the Quran.',
        difficulty: 'medium',
      ),
      QuizQuestion(
        id: 'mid_13',
        question: 'What is the shortest Surah in the Quran?',
        options: ['Surah Al-Ikhlas', 'Surah An-Nas', 'Surah Al-Kawthar', 'Surah Al-Fil'],
        correctAnswerIndex: 2,
        explanation: 'Surah Al-Kawthar (Chapter 108) is the shortest Surah with only 3 verses.',
        difficulty: 'medium',
      ),
      QuizQuestion(
        id: 'mid_14',
        question: 'How many different names (Asma) of Allah are mentioned in the Quran?',
        options: ['50', '99', '150', '200'],
        correctAnswerIndex: 1,
        explanation: 'While many names of Allah appear in the Quran, 99 are particularly emphasized in Islamic tradition.',
        difficulty: 'medium',
      ),
      QuizQuestion(
        id: 'mid_15',
        question: 'What is the Battle of Badr?',
        options: [
          'A location in Medina',
          'The first major battle between Muslims and Quraysh',
          'A trading route',
          'A water well'
        ],
        correctAnswerIndex: 1,
        explanation: 'The Battle of Badr (2 AH/624 CE) was the first major military engagement between Muslims and Quraysh.',
        difficulty: 'medium',
      ),
      QuizQuestion(
        id: 'mid_16',
        question: 'What does "Ummah" mean?',
        options: ['Mother', 'Nation or community', 'Grandmother', 'Tribe'],
        correctAnswerIndex: 1,
        explanation: 'Ummah refers to the global Muslim community united by faith in Islam.',
        difficulty: 'medium',
      ),
      QuizQuestion(
        id: 'mid_17',
        question: 'What are the Six Articles of Islamic Belief?',
        options: [
          'Allah, Quran, Prayer, Fasting, Zakat, Hajj',
          'Belief in Allah, Angels, Books, Prophets, Day of Judgment, and Divine Decree',
          'Only the Five Pillars',
          'Only the names of Allah'
        ],
        correctAnswerIndex: 1,
        explanation: 'The Six Articles of Faith form the foundation of Islamic belief in Allah\'s oneness and divine plan.',
        difficulty: 'medium',
      ),
      QuizQuestion(
        id: 'mid_18',
        question: 'Who was Prophet Ibrahim\'s first wife?',
        options: ['Sarah', 'Hagar', 'Keturah', 'Leah'],
        correctAnswerIndex: 0,
        explanation: 'Sarah (Sara) was Prophet Ibrahim\'s first wife and the mother of Prophet Ishaq.',
        difficulty: 'medium',
      ),
      QuizQuestion(
        id: 'mid_19',
        question: 'What is the Islamic month of Muharram known for?',
        options: [
          'Fasting month',
          'Pilgrimage month',
          'The month containing Ashura and being sacred',
          'Battle month'
        ],
        correctAnswerIndex: 2,
        explanation: 'Muharram is the first month of the Islamic year and is sacred. The 9th and 10th days are Ashura.',
        difficulty: 'medium',
      ),
      QuizQuestion(
        id: 'mid_20',
        question: 'What is Zakat Al-Fitr?',
        options: [
          'Tax on property',
          'Charity given at the end of Ramadan before Eid prayer',
          'Monthly charity',
          'Charity for the poor only'
        ],
        correctAnswerIndex: 1,
        explanation: 'Zakat Al-Fitr is a specific form of charity given before Eid Al-Fitr to ensure everyone can celebrate.',
        difficulty: 'medium',
      ),
      QuizQuestion(
        id: 'mid_21',
        question: 'How many pillars does the Throne of Allah have?',
        options: ['2', '4', '8', 'Not specified in Quran'],
        correctAnswerIndex: 2,
        explanation: 'According to Islamic tradition, the Throne of Allah (Arsh) has eight pillars.',
        difficulty: 'medium',
      ),
      QuizQuestion(
        id: 'mid_22',
        question: 'What is the name of the angel who recorded the Quran revelation?',
        options: ['Gabriel (Jibreel)', 'Michael (Mikail)', 'Israfil', 'Malik'],
        correctAnswerIndex: 0,
        explanation: 'Angel Gabriel (Jibreel) was the angel who brought the Quranic revelation to Prophet Muhammad.',
        difficulty: 'medium',
      ),
      QuizQuestion(
        id: 'mid_23',
        question: 'What is the first action judged on the Day of Judgment?',
        options: ['Belief', 'Prayer', 'Charity', 'Kindness'],
        correctAnswerIndex: 1,
        explanation: 'According to hadith, prayer is the first deed to be judged on the Day of Judgment.',
        difficulty: 'medium',
      ),
      QuizQuestion(
        id: 'mid_24',
        question: 'How many times does "Ya Ayuha" (O you) appear in the Quran?',
        options: ['50', '100', '165', '200'],
        correctAnswerIndex: 2,
        explanation: 'The phrase "Ya Ayuha" appears 165 times in the Quran, often addressing the believers.',
        difficulty: 'medium',
      ),
      QuizQuestion(
        id: 'mid_25',
        question: 'What is the Islamic greeting on seeing the crescent moon?',
        options: [
          'Allahu Akbar',
          'Alhamdulillah',
          'Crescent moon greeting varies by region',
          'No specific greeting'
        ],
        correctAnswerIndex: 2,
        explanation: 'While "Alhamdulillah" (praise be to Allah) is common, different Islamic cultures have variations.',
        difficulty: 'medium',
      ),
      QuizQuestion(
        id: 'mid_26',
        question: 'How many times did Prophet Muhammad perform Hajj?',
        options: ['Once', 'Twice', 'Three times', 'Five times'],
        correctAnswerIndex: 0,
        explanation: 'Prophet Muhammad performed Hajj only once in 10 AH/632 CE, known as his Farewell Pilgrimage.',
        difficulty: 'medium',
      ),
      QuizQuestion(
        id: 'mid_27',
        question: 'What is Istikharah?',
        options: [
          'Fasting ritual',
          'Prayer for guidance seeking Allah\'s help in making a decision',
          'Pilgrimage ritual',
          'Greeting'
        ],
        correctAnswerIndex: 1,
        explanation: 'Istikharah is a prayer for seeking divine guidance when making important life decisions.',
        difficulty: 'medium',
      ),
      QuizQuestion(
        id: 'mid_28',
        question: 'Who is the guardian angel of each person?',
        options: ['Gabriel', 'Michael', 'Kiramen Katibin', 'Malik'],
        correctAnswerIndex: 2,
        explanation: 'Kiramen Katibin are the noble angels who record all our deeds, good and bad.',
        difficulty: 'medium',
      ),
      QuizQuestion(
        id: 'mid_29',
        question: 'What is the punishment in the grave called?',
        options: ['Athab Al-Qabr', 'Jahim', 'Sakar', 'Lazaa'],
        correctAnswerIndex: 0,
        explanation: 'Athab Al-Qabr refers to the punishment in the grave, a concept mentioned in Islamic teachings.',
        difficulty: 'medium',
      ),
      QuizQuestion(
        id: 'mid_30',
        question: 'How many verses are in Surah Al-Baqarah?',
        options: ['100', '200', '286', '300'],
        correctAnswerIndex: 2,
        explanation: 'Surah Al-Baqarah (Chapter 2) has 286 verses and is the longest chapter in the Quran.',
        difficulty: 'medium',
      ),
      QuizQuestion(
        id: 'mid_31',
        question: 'What does "Sadaqah Jariyah" mean?',
        options: [
          'One-time charity',
          'Continuous charity whose benefits continue after death',
          'Forced charity',
          'Holiday charity'
        ],
        correctAnswerIndex: 1,
        explanation: 'Sadaqah Jariyah is ongoing charity such as building a well or school that benefits people continuously.',
        difficulty: 'medium',
      ),
      QuizQuestion(
        id: 'mid_32',
        question: 'Who was the female companion of Prophet Muhammad known for her knowledge?',
        options: ['Aisha', 'Fatima', 'Hafsa', 'Zaynab'],
        correctAnswerIndex: 0,
        explanation: 'Aisha bint Abu Bakr was known for her vast knowledge of Islam and is called "Mother of the Believers".',
        difficulty: 'medium',
      ),
      QuizQuestion(
        id: 'mid_33',
        question: 'What is the Islamic month of fasting called in English?',
        options: ['Ramada', 'Ramazan', 'Ramadan', 'Ramanah'],
        correctAnswerIndex: 2,
        explanation: 'Ramadan is the standard English transliteration of the ninth Islamic month Ramadan.',
        difficulty: 'medium',
      ),
      QuizQuestion(
        id: 'mid_34',
        question: 'How many archangels are mentioned by name in the Quran?',
        options: ['2', '3', '4', '5'],
        correctAnswerIndex: 2,
        explanation: 'Four archangels are named: Gabriel (Jibreel), Michael (Mikail), Israfil, and Malik.',
        difficulty: 'medium',
      ),
      QuizQuestion(
        id: 'mid_35',
        question: 'What is the concept of "Tawakkul" in Islam?',
        options: [
          'Prayer',
          'Reliance on Allah after doing one\'s best',
          'Fasting',
          'Charity'
        ],
        correctAnswerIndex: 1,
        explanation: 'Tawakkul is the Islamic concept of complete trust and reliance in Allah after taking necessary action.',
        difficulty: 'medium',
      ),
      QuizQuestion(
        id: 'mid_36',
        question: 'How many major sins are there in Islam?',
        options: ['7', '12', 'Varies among scholars', 'Indefinite'],
        correctAnswerIndex: 2,
        explanation: 'While there is no fixed list, scholars generally agree on major sins like shirk, murder, and theft.',
        difficulty: 'medium',
      ),
      QuizQuestion(
        id: 'mid_37',
        question: 'What is the Islamic concept of "Taqwa"?',
        options: [
          'Fear only',
          'Piety and God-consciousness',
          'Prayer',
          'Charity'
        ],
        correctAnswerIndex: 1,
        explanation: 'Taqwa is the concept of God-consciousness and piety, central to Islamic spiritual development.',
        difficulty: 'medium',
      ),
      QuizQuestion(
        id: 'mid_38',
        question: 'Who was the best Quranic reciter among the companions?',
        options: ['Umar', 'Abu Musa Al-Ashari', 'Uthman', 'Ali'],
        correctAnswerIndex: 1,
        explanation: 'Abu Musa Al-Ashari was known for his beautiful voice and exceptional Quranic recitation.',
        difficulty: 'medium',
      ),
      QuizQuestion(
        id: 'mid_39',
        question: 'What is the significance of the number 19 in the Quran?',
        options: [
          'Number of pillars',
          'Number of archangels',
          'Associated with 19 guardians of Hell',
          'Number of prayers'
        ],
        correctAnswerIndex: 2,
        explanation: 'The number 19 appears in Surah Al-Muddaththir regarding the guardians of Hell.',
        difficulty: 'medium',
      ),
      QuizQuestion(
        id: 'mid_40',
        question: 'What is the "Shahada Tul-Wilaya"?',
        options: [
          'Testimony of faith',
          'Testimony of allegiance to Amir Al-Momineen',
          'Testimony of travel',
          'Testimony of wealth'
        ],
        correctAnswerIndex: 0,
        explanation: 'While the term is less common, it refers to an extension of Islamic testimony regarding loyalty.',
        difficulty: 'medium',
      ),
    ];
  }

  // HARD LEVEL QUESTIONS (40 questions)
  List<QuizQuestion> getHardQuestions() {
    return [
      QuizQuestion(
        id: 'hard_1',
        question: 'What is the Tafsir approach that relies heavily on classical Islamic scholars called?',
        options: [
          'Tafsir Bil-Ma\'thur',
          'Tafsir Bil-Ray',
          'Tafsir Bil-Ijma',
          'Tafsir Bil-Ijtihaad'
        ],
        correctAnswerIndex: 0,
        explanation: 'Tafsir Bil-Ma\'thur is exegesis based on transmitted traditions from Prophet and companions.',
        difficulty: 'hard',
      ),
      QuizQuestion(
        id: 'hard_2',
        question: 'Which mathematical miracle is found in Surah An-Noor regarding the number 24?',
        options: [
          'Occurs 24 times',
          'Contains 24 verses',
          'Related to 24 hours of day',
          'Mentioned with specific mathematical patterns'
        ],
        correctAnswerIndex: 3,
        explanation: 'Surah An-Noor contains mathematical patterns related to the number 24 discovered by modern scholars.',
        difficulty: 'hard',
      ),
      QuizQuestion(
        id: 'hard_3',
        question: 'What is the concept of "Naskh" in Quranic jurisprudence?',
        options: [
          'Copying',
          'Abrogation of earlier revelations by later ones',
          'Narration',
          'Specification'
        ],
        correctAnswerIndex: 1,
        explanation: 'Naskh refers to the abrogation of earlier Quranic rulings by later, more specific revelations.',
        difficulty: 'hard',
      ),
      QuizQuestion(
        id: 'hard_4',
        question: 'How many times is the word "Quran" mentioned in the Quran itself?',
        options: ['20', '50', '70', '100'],
        correctAnswerIndex: 2,
        explanation: 'The word "Quran" appears 70 times in various forms throughout the Quranic text.',
        difficulty: 'hard',
      ),
      QuizQuestion(
        id: 'hard_5',
        question: 'What is "Matn" in the Hadith terminology?',
        options: [
          'Chain of narration',
          'The text/body of the hadith',
          'The narrator',
          'The topic discussed'
        ],
        correctAnswerIndex: 1,
        explanation: 'Matn refers to the actual text or body of a hadith, as opposed to Isnad (chain of narration).',
        difficulty: 'hard',
      ),
      QuizQuestion(
        id: 'hard_6',
        question: 'Which Surah contains the longest verse in the Quran?',
        options: [
          'Surah Al-Baqarah (Verse 282)',
          'Surah Aal-Imran',
          'Surah An-Nisa',
          'Surah Al-Noor'
        ],
        correctAnswerIndex: 0,
        explanation: 'Verse 282 of Surah Al-Baqarah is the longest single verse in the entire Quran.',
        difficulty: 'hard',
      ),
      QuizQuestion(
        id: 'hard_7',
        question: 'What is "Ijtihad" in Islamic jurisprudence?',
        options: [
          'Following consensus',
          'Independent reasoning to derive rulings from Quran and Sunnah',
          'Memorizing the Quran',
          'Teaching Islamic law'
        ],
        correctAnswerIndex: 1,
        explanation: 'Ijtihad is the independent reasoning by qualified scholars to derive Islamic rulings.',
        difficulty: 'hard',
      ),
      QuizQuestion(
        id: 'hard_8',
        question: 'How many Surahs begin with Alif-Lam-Meem?',
        options: ['3', '4', '5', '6'],
        correctAnswerIndex: 2,
        explanation: 'Five Surahs begin with Alif-Lam-Meem (A.L.M.): Al-Baqarah, Aal-Imran, An-Ankabut, Ar-Rum, and Luqman.',
        difficulty: 'hard',
      ),
      QuizQuestion(
        id: 'hard_9',
        question: 'What is the "Sunna of Allah" mentioned in the Quran?',
        options: [
          'The practices of Prophet Muhammad',
          'The unchanging laws and patterns established by Allah in the universe',
          'Religious practices only',
          'Daily routines'
        ],
        correctAnswerIndex: 1,
        explanation: 'The Sunna of Allah refers to the unchanging patterns and laws established by Allah in creation.',
        difficulty: 'hard',
      ),
      QuizQuestion(
        id: 'hard_10',
        question: 'Which Prophet is mentioned most frequently in the Quran?',
        options: ['Muhammad', 'Ibrahim', 'Musa', 'Isa'],
        correctAnswerIndex: 2,
        explanation: 'Prophet Musa (Moses) is mentioned more frequently than any other prophet in the Quran.',
        difficulty: 'hard',
      ),
      QuizQuestion(
        id: 'hard_11',
        question: 'What is the difference between "Haram" and "Makruh"?',
        options: [
          'No difference',
          'Haram is forbidden while Makruh is disliked but permitted',
          'Makruh is forbidden, Haram is disliked',
          'Both mean the same thing'
        ],
        correctAnswerIndex: 1,
        explanation: 'Haram is absolutely forbidden while Makruh is disliked/discouraged but not strictly prohibited.',
        difficulty: 'hard',
      ),
      QuizQuestion(
        id: 'hard_12',
        question: 'What is the "Khilaf" in Islamic jurisprudence?',
        options: [
          'Disagreement among scholars',
          'Caliphate',
          'Conflict between people',
          'Difference in prayer times'
        ],
        correctAnswerIndex: 0,
        explanation: 'Khilaf refers to scholarly disagreement (ikhtilaf) on matters of Islamic law.',
        difficulty: 'hard',
      ),
      QuizQuestion(
        id: 'hard_13',
        question: 'Which verses in the Quran contain the story of the Elephant (Fil)?',
        options: [
          'Surah Al-Fil',
          'Surah Al-Fil only',
          'Surah Al-Lahab and Al-Fil',
          'Multiple Surahs'
        ],
        correctAnswerIndex: 1,
        explanation: 'The story of the Elephant is told in Surah Al-Fil (Chapter 105).',
        difficulty: 'hard',
      ),
      QuizQuestion(
        id: 'hard_14',
        question: 'What is the concept of "Darurah" (necessity) in Islamic law?',
        options: [
          'General emergency',
          'Exception to Islamic rules when necessity demands and no alternatives exist',
          'Personal preference',
          'Temporary absence'
        ],
        correctAnswerIndex: 1,
        explanation: 'Darurah is the principle that prohibitions may be lifted in cases of genuine necessity.',
        difficulty: 'hard',
      ),
      QuizQuestion(
        id: 'hard_15',
        question: 'How many Surahs are named after animals?',
        options: ['3', '4', '5', '6'],
        correctAnswerIndex: 2,
        explanation: 'Five Surahs are named after animals: Al-Fil (Elephant), An-Nahl (Bee), Al-Ankabut (Spider), Al-Insan (Human).',
        difficulty: 'hard',
      ),
      QuizQuestion(
        id: 'hard_16',
        question: 'What is "Tawatur" in Hadith studies?',
        options: [
          'Single chain of narration',
          'Mutual corroboration - narration reported by many people in different times and places',
          'Weak hadith',
          'Fabricated hadith'
        ],
        correctAnswerIndex: 1,
        explanation: 'Tawatur is a hadith so widely reported that it would be impossible for all narrators to have conspired.',
        difficulty: 'hard',
      ),
      QuizQuestion(
        id: 'hard_17',
        question: 'Which Surah is known as "Surah of the Believers"?',
        options: ['Surah Al-Muminin', 'Surah Al-Anaam', 'Surah Al-Imaan', 'Surah At-Tawbah'],
        correctAnswerIndex: 0,
        explanation: 'Surah Al-Muminin (Chapter 23) translates to "Chapter of the Believers".',
        difficulty: 'hard',
      ),
      QuizQuestion(
        id: 'hard_18',
        question: 'What is the "Tawhid Ar-Rububiyyah"?',
        options: [
          'Believing in prophets',
          'Belief in the Lordship and Oneness of Allah\'s authority',
          'Believing in scriptures',
          'Belief in the Day of Judgment'
        ],
        correctAnswerIndex: 1,
        explanation: 'Tawhid Ar-Rububiyyah is belief in Allah\'s sole lordship and divine control over the universe.',
        difficulty: 'hard',
      ),
      QuizQuestion(
        id: 'hard_19',
        question: 'How many times is "Paradise" (Jannah) explicitly mentioned in the Quran?',
        options: ['30', '50', '77', '100'],
        correctAnswerIndex: 2,
        explanation: 'The word "Jannah" (Paradise) appears approximately 77 times in the Quran.',
        difficulty: 'hard',
      ),
      QuizQuestion(
        id: 'hard_20',
        question: 'What is the "Sira Nabawiyya"?',
        options: [
          'Islamic law only',
          'Biography of Prophet Muhammad covering his life and teachings',
          'Quranic interpretation',
          'Hadith collection'
        ],
        correctAnswerIndex: 1,
        explanation: 'Sira Nabawiyya is the comprehensive biography of Prophet Muhammad\'s life and prophetic mission.',
        difficulty: 'hard',
      ),
      QuizQuestion(
        id: 'hard_21',
        question: 'What is "Mustalah Al-Hadith"?',
        options: [
          'Collection of hadith',
          'Science of Hadith terminology and authentication',
          'Hadith rules',
          'Hadith studies basics'
        ],
        correctAnswerIndex: 1,
        explanation: 'Mustalah Al-Hadith is the science of hadith terminology used to evaluate hadith authenticity.',
        difficulty: 'hard',
      ),
      QuizQuestion(
        id: 'hard_22',
        question: 'Which Surah contains the greatest number of legal rulings?',
        options: [
          'Surah Al-Baqarah',
          'Surah An-Nisa',
          'Surah Al-Maidah',
          'Surah At-Tawbah'
        ],
        correctAnswerIndex: 2,
        explanation: 'Surah Al-Maidah (Chapter 5) contains the most comprehensive Islamic legal rulings.',
        difficulty: 'hard',
      ),
      QuizQuestion(
        id: 'hard_23',
        question: 'What is the doctrine of "Kulliyat Al-Khams" (Five Objectives)?',
        options: [
          'Five Pillars',
          'Five prayers',
          'Preservation of religion, life, intellect, property, and lineage',
          'Five companions'
        ],
        correctAnswerIndex: 2,
        explanation: 'The Five Objectives of Sharia are to preserve: religion, life, intellect, property, and lineage.',
        difficulty: 'hard',
      ),
      QuizQuestion(
        id: 'hard_24',
        question: 'How many chapters of the Quran start without the Bismillah?',
        options: ['0', '1', '2', '5'],
        correctAnswerIndex: 1,
        explanation: 'Only Surah At-Tawbah (Chapter 9) begins without the Bismillah (In the name of Allah).',
        difficulty: 'hard',
      ),
      QuizQuestion(
        id: 'hard_25',
        question: 'What is "Ayah Al-Burhan" in Islamic philosophy?',
        options: [
          'Verses of proof/evidence in the Quran',
          'Religious commandments',
          'Story verses',
          'Scientific verses'
        ],
        correctAnswerIndex: 0,
        explanation: 'Ayah Al-Burhan refers to verses in the Quran that serve as proofs or clear evidence.',
        difficulty: 'hard',
      ),
      QuizQuestion(
        id: 'hard_26',
        question: 'Which Surah discusses the most prophets in detail?',
        options: ['Surah Yusuf', 'Surah Aal-Imran', 'Surah As-Safat', 'Surah Al-Anbiya'],
        correctAnswerIndex: 3,
        explanation: 'Surah Al-Anbiya (Chapter 21) discusses numerous prophets and their stories.',
        difficulty: 'hard',
      ),
      QuizQuestion(
        id: 'hard_27',
        question: 'What is "Isnad" in hadith terminology?',
        options: [
          'The text of hadith',
          'Chain of narrators reporting the hadith',
          'The topic',
          'The explanation'
        ],
        correctAnswerIndex: 1,
        explanation: 'Isnad is the chain of narrators through which a hadith is transmitted.',
        difficulty: 'hard',
      ),
      QuizQuestion(
        id: 'hard_28',
        question: 'What is the "Tafsir Bil-Ijma"?',
        options: [
          'Personal interpretation',
          'Interpretation based on consensus of Islamic scholars',
          'Metaphorical interpretation',
          'Scientific interpretation'
        ],
        correctAnswerIndex: 1,
        explanation: 'Tafsir Bil-Ijma relies on the agreed-upon interpretations of multiple Islamic scholars.',
        difficulty: 'hard',
      ),
      QuizQuestion(
        id: 'hard_29',
        question: 'How many "Juz" (parts) is the Quran divided into?',
        options: ['20', '25', '30', '40'],
        correctAnswerIndex: 2,
        explanation: 'The Quran is traditionally divided into 30 equal parts called Juz for ease of recitation.',
        difficulty: 'hard',
      ),
      QuizQuestion(
        id: 'hard_30',
        question: 'What is the concept of "Tawhid Al-Uluhiyyah"?',
        options: [
          'Belief in prophets',
          'Belief in worshipping Allah alone with no partners',
          'Belief in scriptures',
          'Belief in angels'
        ],
        correctAnswerIndex: 1,
        explanation: 'Tawhid Al-Uluhiyyah is the belief that only Allah deserves worship and has no partners.',
        difficulty: 'hard',
      ),
      QuizQuestion(
        id: 'hard_31',
        question: 'Which scholar compiled the most authentic hadith collection known as "Sahih Al-Bukhari"?',
        options: [
          'Muslim ibn Al-Hajjaj',
          'Muhammad Al-Bukhari',
          'At-Tirmidhi',
          'Abu Dawood'
        ],
        correctAnswerIndex: 1,
        explanation: 'Muhammad Al-Bukhari compiled Sahih Al-Bukhari, one of the most authentic hadith collections.',
        difficulty: 'hard',
      ),
      QuizQuestion(
        id: 'hard_32',
        question: 'What is the "Meccan vs Medinan" classification in Quranic studies?',
        options: [
          'Geographic locations only',
          'Classification based on where revelations occurred during Prophet\'s life',
          'Type of content only',
          'Random classification'
        ],
        correctAnswerIndex: 1,
        explanation: 'Meccan and Medinan refer to Surahs revealed before and after the Hijra respectively.',
        difficulty: 'hard',
      ),
      QuizQuestion(
        id: 'hard_33',
        question: 'What is "Shari\'a" fundamentally based upon?',
        options: [
          'Cultural customs',
          'Political decisions',
          'Quran and Sunnah with analogical reasoning and scholarly consensus',
          'Historical traditions'
        ],
        correctAnswerIndex: 2,
        explanation: 'Sharia is based on four sources: Quran, Sunnah, Ijma (consensus), and Qiyas (analogy).',
        difficulty: 'hard',
      ),
      QuizQuestion(
        id: 'hard_34',
        question: 'How many letters comprise the Arabic alphabet as traditionally counted?',
        options: ['26', '28', '30', '32'],
        correctAnswerIndex: 1,
        explanation: 'The Arabic alphabet has 28 letters traditionally counted in classical Arabic.',
        difficulty: 'hard',
      ),
      QuizQuestion(
        id: 'hard_35',
        question: 'What is the "Fiqh Makasid" approach?',
        options: [
          'Traditional jurisprudence',
          'Jurisprudence based on the overall objectives and purposes of Sharia',
          'Modern interpretation only',
          'Literal interpretation'
        ],
        correctAnswerIndex: 1,
        explanation: 'Fiqh Makasid examines rulings in light of the higher objectives of Islamic law.',
        difficulty: 'hard',
      ),
      QuizQuestion(
        id: 'hard_36',
        question: 'Which Surah mentions Dhu\'l-Qarnayn?',
        options: ['Surah Al-Kahf', 'Surah Yusuf', 'Surah Luqman', 'Surah As-Safat'],
        correctAnswerIndex: 0,
        explanation: 'Surah Al-Kahf (Chapter 18) contains the detailed story of Dhu\'l-Qarnayn.',
        difficulty: 'hard',
      ),
      QuizQuestion(
        id: 'hard_37',
        question: 'What is the "Usul Al-Fiqh"?',
        options: [
          'Islamic law itself',
          'Sources and methodology of Islamic jurisprudence',
          'Hadith collections',
          'Prophetic traditions'
        ],
        correctAnswerIndex: 1,
        explanation: 'Usul Al-Fiqh is the science of the principles and methodology of Islamic jurisprudence.',
        difficulty: 'hard',
      ),
      QuizQuestion(
        id: 'hard_38',
        question: 'How many verses discuss the prohibition of interest (Riba)?',
        options: ['2', '4', '6', '8'],
        correctAnswerIndex: 2,
        explanation: 'Several verses in the Quran explicitly prohibit Riba (interest/usury): 2:275, 2:276, 3:130, 4:161, 30:39.',
        difficulty: 'hard',
      ),
      QuizQuestion(
        id: 'hard_39',
        question: 'What is the "Mursal" hadith?',
        options: [
          'Authenticated hadith',
          'Hadith with a broken chain missing a companion',
          'Clear hadith',
          'Weak hadith'
        ],
        correctAnswerIndex: 1,
        explanation: 'Mursal is a hadith where the chain goes directly from a student of companions to Prophet.',
        difficulty: 'hard',
      ),
      QuizQuestion(
        id: 'hard_40',
        question: 'Which school of Islamic jurisprudence has the largest following today?',
        options: [
          'Hanbali',
          'Maliki',
          'Hanafi',
          'Shafi\'i'
        ],
        correctAnswerIndex: 2,
        explanation: 'The Hanafi school, founded by Imam Abu Hanifa, has the largest number of followers globally.',
        difficulty: 'hard',
      ),
    ];
  }

  // Get random questions from a difficulty level AND specific language
  List<QuizQuestion> getRandomQuestionsForDifficulty(String difficulty, String langCode, {int count = 10}) {
    final allQuestions = switch (difficulty) {
      'easy' => getEasyQuestions(langCode),
      'medium' => getMediumQuestions(langCode),
      'hard' => getHardQuestions(langCode),
      _ => getEasyQuestions(langCode),
    };

    final random = Random();
    final shuffled = List<QuizQuestion>.from(allQuestions)..shuffle(random);
    return shuffled.take(count).toList();
  }
}*/

import 'dart:math';

class QuizQuestion {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;
  final String difficulty;

  QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
    required this.difficulty,
  });
}

class QuizQuestionsService {
  static final QuizQuestionsService _instance = QuizQuestionsService._internal();

  factory QuizQuestionsService() {
    return _instance;
  }

  QuizQuestionsService._internal();

  // ==========================================
  // ROUTING LOGIC
  // ==========================================

  List<QuizQuestion> getEasyQuestions(String langCode) {
    if (langCode == 'ar') return _getEasyQuestionsAr();
    if (langCode == 'fr') return _getEasyQuestionsFr();
    return _getEasyQuestionsEn();
  }

  List<QuizQuestion> getMediumQuestions(String langCode) {
    if (langCode == 'ar') return _getMediumQuestionsAr();
    if (langCode == 'fr') return _getMediumQuestionsFr();
    return _getMediumQuestionsEn();
  }

  List<QuizQuestion> getHardQuestions(String langCode) {
    if (langCode == 'ar') return _getHardQuestionsAr();
    if (langCode == 'fr') return _getHardQuestionsFr();
    return _getHardQuestionsEn();
  }

  // FIXED: Now correctly accepts and passes the langCode
  List<QuizQuestion> getRandomQuestionsForDifficulty(String difficulty, String langCode, {int count = 10}) {
    final allQuestions = switch (difficulty) {
      'easy' => getEasyQuestions(langCode),
      'medium' => getMediumQuestions(langCode),
      'hard' => getHardQuestions(langCode),
      _ => getEasyQuestions(langCode),
    };

    final random = Random();
    final shuffled = List<QuizQuestion>.from(allQuestions)..shuffle(random);
    return shuffled.take(count).toList();
  }

  // ==========================================
  // ENGLISH TRANSLATIONS (From your source)
  // ==========================================

  List<QuizQuestion> _getEasyQuestionsEn() {
    return [
      QuizQuestion(id: 'easy_1', question: 'How many times a day do Muslims pray?', options: ['3 times', '4 times', '5 times', '6 times'], correctAnswerIndex: 2, explanation: 'Muslims are obligated to pray 5 times a day: Fajr, Dhuhr, Asr, Maghrib, and Isha.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_2', question: 'What is the Islamic month of fasting called?', options: ['Shawwal', 'Ramadan', 'Muharram', 'Dhul-Hijjah'], correctAnswerIndex: 1, explanation: 'Ramadan is the ninth month of the Islamic lunar calendar during which Muslims fast from dawn to sunset.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_3', question: 'Who is the last Prophet in Islam?', options: ['Ibrahim', 'Musa', 'Muhammad', 'Isa'], correctAnswerIndex: 2, explanation: 'Prophet Muhammad (peace be upon him) is the final and last messenger sent by Allah.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_4', question: 'What is the Islamic pilgrimage called?', options: ['Umrah', 'Hajj', 'Tawaf', 'Salah'], correctAnswerIndex: 1, explanation: 'Hajj is the pilgrimage to Mecca that is one of the Five Pillars of Islam.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_5', question: 'How many pillars of Islam are there?', options: ['3', '4', '5', '6'], correctAnswerIndex: 2, explanation: 'There are 5 pillars of Islam: Shahada, Salah, Zakat, Sawm, and Hajj.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_6', question: 'What is the declaration of faith called?', options: ['Salah', 'Shahada', 'Zakat', 'Hajj'], correctAnswerIndex: 1, explanation: 'Shahada is the Islamic creed stating that there is no god but Allah and Muhammad is His messenger.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_7', question: 'Which direction do Muslims face when praying?', options: ['East', 'West', 'North', 'Towards Mecca (Qibla)'], correctAnswerIndex: 3, explanation: 'Muslims face the Kaaba in Mecca during prayer, in a direction called the Qibla.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_8', question: 'Who built the Kaaba?', options: ['Prophet Musa', 'Prophet Ibrahim and Ismail', 'Prophet Muhammad', 'Prophet Sulaiman'], correctAnswerIndex: 1, explanation: 'According to Islamic tradition, Prophet Ibrahim and his son Ismail built the Kaaba.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_9', question: 'What is almsgiving in Islam called?', options: ['Sawm', 'Zakat', 'Hajj', 'Tawaf'], correctAnswerIndex: 1, explanation: 'Zakat is the obligatory almsgiving that is one of the Five Pillars of Islam.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_10', question: 'How many chapters does the Quran have?', options: ['100', '110', '114', '120'], correctAnswerIndex: 2, explanation: 'The Quran has 114 chapters (Surahs) each containing one or more verses (Ayahs).', difficulty: 'easy'),
      QuizQuestion(id: 'easy_11', question: 'What is the Islamic calendar based on?', options: ['Solar year', 'Lunar year', 'Both solar and lunar', 'Seasons'], correctAnswerIndex: 1, explanation: 'The Islamic calendar is based on the lunar year, also known as the Hijri calendar.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_12', question: 'How many days is Ramadan?', options: ['25 days', '28 days', '29-30 days', '35 days'], correctAnswerIndex: 2, explanation: 'Ramadan is 29 or 30 days long depending on the lunar sighting of the month.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_13', question: 'What does "Islam" mean?', options: ['Peace only', 'Submission to God', 'Prayer', 'Belief'], correctAnswerIndex: 1, explanation: 'Islam means submission to the will of Allah and derives from the Arabic word for peace and submission.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_14', question: 'Who was the first Prophet in Islam?', options: ['Muhammad', 'Ibrahim', 'Adam', 'Musa'], correctAnswerIndex: 2, explanation: 'Prophet Adam was the first human and the first Prophet sent by Allah.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_15', question: 'What is the Islamic greeting?', options: ['Hello', 'As-salamu alaikum', 'Welcome', 'Greetings'], correctAnswerIndex: 1, explanation: 'As-salamu alaikum (Peace be upon you) is the Islamic greeting, and the response is wa alaikum assalam.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_16', question: 'How many Prophets are mentioned in the Quran?', options: ['19', '25', '31', '50'], correctAnswerIndex: 1, explanation: '25 prophets are explicitly named in the Quran, including Adam, Ibrahim, Musa, Isa, and Muhammad.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_17', question: 'What is the first Surah of the Quran?', options: ['Surah Al-Baqarah', 'Surah Al-Fatiha', 'Surah An-Nas', 'Surah Al-Ikhlas'], correctAnswerIndex: 1, explanation: 'Surah Al-Fatiha (The Opening) is the first chapter of the Quran and is recited in every prayer.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_18', question: 'In which city was Prophet Muhammad born?', options: ['Medina', 'Mecca', 'Jerusalem', 'Baghdad'], correctAnswerIndex: 1, explanation: 'Prophet Muhammad was born in Mecca (Makkah) in the year 570 CE.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_19', question: 'What is forbidden to eat in Islam?', options: ['Vegetables', 'Pork', 'Fish', 'Fruits'], correctAnswerIndex: 1, explanation: 'Pork and certain other meats are prohibited (Haram) in Islam as mentioned in the Quran.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_20', question: 'What year did Prophet Muhammad migrate to Medina?', options: ['610 CE', '622 CE', '632 CE', '650 CE'], correctAnswerIndex: 1, explanation: 'The Hijra (migration) occurred in 622 CE, marking the beginning of the Islamic calendar.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_21', question: 'How many times do Muslims circumambulate the Kaaba during Hajj?', options: ['3 times', '5 times', '7 times', '10 times'], correctAnswerIndex: 2, explanation: 'Muslims circumambulate (Tawaf) the Kaaba 7 times as a ritual of Hajj.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_22', question: 'What is the Islamic legal system called?', options: ['Sharia', 'Hadith', 'Fiqh', 'Ijma'], correctAnswerIndex: 0, explanation: 'Sharia (Islamic law) is the legal framework based on the Quran and Sunnah.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_23', question: 'Who compiled the first written Quran?', options: ['Abu Bakr', 'Umar', 'Uthman', 'Ali'], correctAnswerIndex: 2, explanation: 'Caliph Uthman organized the compilation of the standardized Quran during his reign.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_24', question: 'What does Hadith mean?', options: ['Recitation', 'Stories of prophets', 'Sayings and actions of Prophet Muhammad', 'Jurisprudence'], correctAnswerIndex: 2, explanation: 'Hadith refers to the recorded sayings, actions, and approvals of Prophet Muhammad.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_25', question: 'How many times is the Takbir (Allahu Akbar) recited daily?', options: ['5 times', '10 times', 'At least 10 times', 'Many times throughout the day'], correctAnswerIndex: 3, explanation: 'The Takbir is recited multiple times daily in prayers and other Islamic practices.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_26', question: 'What is the period of fasting before dawn in Ramadan called?', options: ['Suhoor', 'Iftar', 'Taraweeh', 'Qiyam'], correctAnswerIndex: 0, explanation: 'Suhoor is the pre-dawn meal eaten before beginning the fast at Fajr time.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_27', question: 'What is the breaking of the fast at sunset called?', options: ['Suhoor', 'Iftar', 'Tahajjud', 'Witr'], correctAnswerIndex: 1, explanation: 'Iftar is the meal eaten at sunset to break the fast during Ramadan.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_28', question: 'How many times does a Muslim make ablution (Wudu) per day?', options: ['Once', 'Twice', 'Varies - before each prayer', '5 times only'], correctAnswerIndex: 2, explanation: 'Ablution is performed before each prayer, so the number varies based on prayer times.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_29', question: 'What is the night prayer during Ramadan called?', options: ['Salat Al-Layl', 'Taraweeh', 'Qiyam Al-Layl', 'Tahajjud'], correctAnswerIndex: 1, explanation: 'Taraweeh are special prayers performed during the nights of Ramadan after Isha prayer.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_30', question: 'Which prayer is the longest?', options: ['Fajr', 'Dhuhr', 'Asr', 'Maghrib'], correctAnswerIndex: 1, explanation: 'Dhuhr (midday prayer) is generally considered the longest prayer of the day.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_31', question: 'How many Rakat (units) are in the Dhuhr prayer?', options: ['2', '3', '4', '5'], correctAnswerIndex: 2, explanation: 'The Dhuhr prayer consists of 4 Rakat (units) in its mandatory form.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_32', question: 'What is the testimony of faith called in Arabic?', options: ['Takbir', 'Shahada', 'Tasbih', 'Tahlil'], correctAnswerIndex: 1, explanation: 'Shahada is the Islamic declaration of faith testifying to the oneness of Allah.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_33', question: 'Which month is considered the best month for additional prayers?', options: ['Shawwal', 'Ramadan', 'Muharram', 'Rajab'], correctAnswerIndex: 1, explanation: 'Ramadan is the holiest month in the Islamic calendar when good deeds are multiplied.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_34', question: 'What is the obligatory tax during Hajj called?', options: ['Zakat', 'Kharaj', 'Tawaf', 'Sadaqah'], correctAnswerIndex: 0, explanation: 'While Zakat is general almsgiving, it becomes especially important during Hajj season.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_35', question: 'How many sides does the Kaaba have?', options: ['2', '3', '4', '6'], correctAnswerIndex: 2, explanation: 'The Kaaba is a cube-shaped building with 4 sides, located in Mecca.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_36', question: 'What is Sadaqah in Islam?', options: ['Obligatory charity', 'Voluntary charity', 'Tax', 'Punishment'], correctAnswerIndex: 1, explanation: 'Sadaqah is voluntary charity given with the intention of helping others and pleasing Allah.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_37', question: 'Who is the mother of Prophet Muhammad?', options: ['Aminah', 'Haleema', 'Khadijah', 'Aisha'], correctAnswerIndex: 0, explanation: 'Aminah bint Wahb was the biological mother of Prophet Muhammad.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_38', question: 'What is the Islamic calendar also known as?', options: ['Solar Calendar', 'Hijri Calendar', 'Gregorian Calendar', 'Julian Calendar'], correctAnswerIndex: 1, explanation: 'The Islamic calendar is also called the Hijri calendar, named after the Hijra (migration).', difficulty: 'easy'),
      QuizQuestion(id: 'easy_39', question: 'How many verses are in the Quran approximately?', options: ['3000', '6000', '9000', '12000'], correctAnswerIndex: 1, explanation: 'The Quran contains approximately 6,236 verses distributed among 114 chapters.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_40', question: 'What does "Bismillah" mean?', options: ['Glory be to Allah', 'In the name of Allah', 'Allah is great', 'Praise be to Allah'], correctAnswerIndex: 1, explanation: 'Bismillah means "In the name of Allah" and is recited before beginning any action.', difficulty: 'easy'),
    ];
  }

  List<QuizQuestion> _getMediumQuestionsEn() {
    return [
      QuizQuestion(id: 'mid_1', question: 'What is the Sunnah?', options: ['The teachings of other religions', 'The practices and traditions of Prophet Muhammad', 'Pilgrimage rituals', 'Islamic legal codes'], correctAnswerIndex: 1, explanation: 'The Sunnah refers to the traditions and practices of Prophet Muhammad that serve as a model for Muslims.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_2', question: 'Who was the first Muslim Caliph?', options: ['Umar ibn Al-Khattab', 'Abu Bakr', 'Uthman ibn Affan', 'Ali ibn Abi Talib'], correctAnswerIndex: 1, explanation: 'Abu Bakr (As-Siddiq) was the first Caliph after Prophet Muhammad, ruling from 632-634 CE.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_3', question: 'What is Fiqh in Islamic jurisprudence?', options: ['Memorization of Quran', 'Understanding and interpretation of Islamic law', 'Storytelling traditions', 'Poetic expressions'], correctAnswerIndex: 1, explanation: 'Fiqh is the branch of Islamic knowledge dealing with the understanding and application of Sharia law.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_4', question: 'What is Ijma in Islamic law?', options: ['Personal opinion', 'Consensus of Islamic scholars', 'Quranic verses', 'Traditions only'], correctAnswerIndex: 1, explanation: 'Ijma is the consensus of Islamic scholars on a particular matter and is a source of Islamic law.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_5', question: 'How many companions are known as "Rightly Guided Caliphs"?', options: ['2', '3', '4', '5'], correctAnswerIndex: 2, explanation: 'The four Rightly Guided Caliphs are Abu Bakr, Umar, Uthman, and Ali, ruling from 632-661 CE.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_6', question: 'What is the Night of Power called in Arabic?', options: ['Laylat Al-Qadr', 'Laylat Al-Jinn', 'Laylat Al-Isra', 'Laylat Al-Baraa'], correctAnswerIndex: 0, explanation: 'Laylat Al-Qadr (Night of Power) is when the Quran was first revealed and is the most blessed night.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_7', question: 'Which Surah mentions the Night of Power?', options: ['Surah Al-Alaq', 'Surah Al-Qadr', 'Surah Ar-Rahman', 'Surah Al-Adiyat'], correctAnswerIndex: 1, explanation: 'Surah Al-Qadr (Chapter 97) is devoted entirely to describing the Night of Power.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_8', question: 'What is Qiyyas in Islamic jurisprudence?', options: ['Measurement', 'Analogical reasoning by analogy', 'Reporting', 'Questioning'], correctAnswerIndex: 1, explanation: 'Qiyyas is the method of deriving Islamic rulings by making analogies to similar cases in the Quran.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_9', question: 'How many scribes of revelation did Prophet Muhammad have?', options: ['3', '5', '15-20', 'More than 40'], correctAnswerIndex: 3, explanation: 'Prophet Muhammad had more than 40 scribes who recorded the Quranic revelations, including Ali and Uthman.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_10', question: 'What does Hijab mean in Islamic context?', options: ['Only a headscarf', 'Modesty and modest dress covering for both men and women', 'Only a screen', 'A religious prohibition'], correctAnswerIndex: 1, explanation: 'Hijab represents modesty and is not limited to women\'s clothing but applies to both genders.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_11', question: 'What is the Isra and Mi\'raj?', options: ['Two different journeys', 'Prophet Muhammad\'s night journey from Mecca to Jerusalem and ascension to heaven', 'Two Surahs of the Quran', 'Two names of the Kaaba'], correctAnswerIndex: 1, explanation: 'Isra is the night journey to Jerusalem, and Mi\'raj is the ascension to the heavens.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_12', question: 'Which Surah contains the Verse of the Throne (Ayat Al-Kursi)?', options: ['Surah Al-Baqarah', 'Surah Aal-Imran', 'Surah An-Noor', 'Surah Ya-Seen'], correctAnswerIndex: 0, explanation: 'Ayat Al-Kursi is found in Surah Al-Baqarah (2:255) and is one of the most important verses in the Quran.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_13', question: 'What is the shortest Surah in the Quran?', options: ['Surah Al-Ikhlas', 'Surah An-Nas', 'Surah Al-Kawthar', 'Surah Al-Fil'], correctAnswerIndex: 2, explanation: 'Surah Al-Kawthar (Chapter 108) is the shortest Surah with only 3 verses.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_14', question: 'How many different names (Asma) of Allah are mentioned in the Quran?', options: ['50', '99', '150', '200'], correctAnswerIndex: 1, explanation: 'While many names of Allah appear in the Quran, 99 are particularly emphasized in Islamic tradition.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_15', question: 'What is the Battle of Badr?', options: ['A location in Medina', 'The first major battle between Muslims and Quraysh', 'A trading route', 'A water well'], correctAnswerIndex: 1, explanation: 'The Battle of Badr (2 AH/624 CE) was the first major military engagement between Muslims and Quraysh.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_16', question: 'What does "Ummah" mean?', options: ['Mother', 'Nation or community', 'Grandmother', 'Tribe'], correctAnswerIndex: 1, explanation: 'Ummah refers to the global Muslim community united by faith in Islam.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_17', question: 'What are the Six Articles of Islamic Belief?', options: ['Allah, Quran, Prayer, Fasting, Zakat, Hajj', 'Belief in Allah, Angels, Books, Prophets, Day of Judgment, and Divine Decree', 'Only the Five Pillars', 'Only the names of Allah'], correctAnswerIndex: 1, explanation: 'The Six Articles of Faith form the foundation of Islamic belief in Allah\'s oneness and divine plan.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_18', question: 'Who was Prophet Ibrahim\'s first wife?', options: ['Sarah', 'Hagar', 'Keturah', 'Leah'], correctAnswerIndex: 0, explanation: 'Sarah (Sara) was Prophet Ibrahim\'s first wife and the mother of Prophet Ishaq.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_19', question: 'What is the Islamic month of Muharram known for?', options: ['Fasting month', 'Pilgrimage month', 'The month containing Ashura and being sacred', 'Battle month'], correctAnswerIndex: 2, explanation: 'Muharram is the first month of the Islamic year and is sacred. The 9th and 10th days are Ashura.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_20', question: 'What is Zakat Al-Fitr?', options: ['Tax on property', 'Charity given at the end of Ramadan before Eid prayer', 'Monthly charity', 'Charity for the poor only'], correctAnswerIndex: 1, explanation: 'Zakat Al-Fitr is a specific form of charity given before Eid Al-Fitr to ensure everyone can celebrate.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_21', question: 'How many pillars does the Throne of Allah have?', options: ['2', '4', '8', 'Not specified in Quran'], correctAnswerIndex: 2, explanation: 'According to Islamic tradition, the Throne of Allah (Arsh) has eight pillars.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_22', question: 'What is the name of the angel who recorded the Quran revelation?', options: ['Gabriel (Jibreel)', 'Michael (Mikail)', 'Israfil', 'Malik'], correctAnswerIndex: 0, explanation: 'Angel Gabriel (Jibreel) was the angel who brought the Quranic revelation to Prophet Muhammad.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_23', question: 'What is the first action judged on the Day of Judgment?', options: ['Belief', 'Prayer', 'Charity', 'Kindness'], correctAnswerIndex: 1, explanation: 'According to hadith, prayer is the first deed to be judged on the Day of Judgment.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_24', question: 'How many times does "Ya Ayuha" (O you) appear in the Quran?', options: ['50', '100', '165', '200'], correctAnswerIndex: 2, explanation: 'The phrase "Ya Ayuha" appears 165 times in the Quran, often addressing the believers.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_25', question: 'What is the Islamic greeting on seeing the crescent moon?', options: ['Allahu Akbar', 'Alhamdulillah', 'Crescent moon greeting varies by region', 'No specific greeting'], correctAnswerIndex: 2, explanation: 'While "Alhamdulillah" (praise be to Allah) is common, different Islamic cultures have variations.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_26', question: 'How many times did Prophet Muhammad perform Hajj?', options: ['Once', 'Twice', 'Three times', 'Five times'], correctAnswerIndex: 0, explanation: 'Prophet Muhammad performed Hajj only once in 10 AH/632 CE, known as his Farewell Pilgrimage.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_27', question: 'What is Istikharah?', options: ['Fasting ritual', 'Prayer for guidance seeking Allah\'s help in making a decision', 'Pilgrimage ritual', 'Greeting'], correctAnswerIndex: 1, explanation: 'Istikharah is a prayer for seeking divine guidance when making important life decisions.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_28', question: 'Who is the guardian angel of each person?', options: ['Gabriel', 'Michael', 'Kiramen Katibin', 'Malik'], correctAnswerIndex: 2, explanation: 'Kiramen Katibin are the noble angels who record all our deeds, good and bad.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_29', question: 'What is the punishment in the grave called?', options: ['Athab Al-Qabr', 'Jahim', 'Sakar', 'Lazaa'], correctAnswerIndex: 0, explanation: 'Athab Al-Qabr refers to the punishment in the grave, a concept mentioned in Islamic teachings.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_30', question: 'How many verses are in Surah Al-Baqarah?', options: ['100', '200', '286', '300'], correctAnswerIndex: 2, explanation: 'Surah Al-Baqarah (Chapter 2) has 286 verses and is the longest chapter in the Quran.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_31', question: 'What does "Sadaqah Jariyah" mean?', options: ['One-time charity', 'Continuous charity whose benefits continue after death', 'Forced charity', 'Holiday charity'], correctAnswerIndex: 1, explanation: 'Sadaqah Jariyah is ongoing charity such as building a well or school that benefits people continuously.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_32', question: 'Who was the female companion of Prophet Muhammad known for her knowledge?', options: ['Aisha', 'Fatima', 'Hafsa', 'Zaynab'], correctAnswerIndex: 0, explanation: 'Aisha bint Abu Bakr was known for her vast knowledge of Islam and is called "Mother of the Believers".', difficulty: 'medium'),
      QuizQuestion(id: 'mid_33', question: 'What is the Islamic month of fasting called in English?', options: ['Ramada', 'Ramazan', 'Ramadan', 'Ramanah'], correctAnswerIndex: 2, explanation: 'Ramadan is the standard English transliteration of the ninth Islamic month Ramadan.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_34', question: 'How many archangels are mentioned by name in the Quran?', options: ['2', '3', '4', '5'], correctAnswerIndex: 2, explanation: 'Four archangels are named: Gabriel (Jibreel), Michael (Mikail), Israfil, and Malik.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_35', question: 'What is the concept of "Tawakkul" in Islam?', options: ['Prayer', 'Reliance on Allah after doing one\'s best', 'Fasting', 'Charity'], correctAnswerIndex: 1, explanation: 'Tawakkul is the Islamic concept of complete trust and reliance in Allah after taking necessary action.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_36', question: 'How many major sins are there in Islam?', options: ['7', '12', 'Varies among scholars', 'Indefinite'], correctAnswerIndex: 2, explanation: 'While there is no fixed list, scholars generally agree on major sins like shirk, murder, and theft.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_37', question: 'What is the Islamic concept of "Taqwa"?', options: ['Fear only', 'Piety and God-consciousness', 'Prayer', 'Charity'], correctAnswerIndex: 1, explanation: 'Taqwa is the concept of God-consciousness and piety, central to Islamic spiritual development.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_38', question: 'Who was the best Quranic reciter among the companions?', options: ['Umar', 'Abu Musa Al-Ashari', 'Uthman', 'Ali'], correctAnswerIndex: 1, explanation: 'Abu Musa Al-Ashari was known for his beautiful voice and exceptional Quranic recitation.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_39', question: 'What is the significance of the number 19 in the Quran?', options: ['Number of pillars', 'Number of archangels', 'Associated with 19 guardians of Hell', 'Number of prayers'], correctAnswerIndex: 2, explanation: 'The number 19 appears in Surah Al-Muddaththir regarding the guardians of Hell.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_40', question: 'What is the "Shahada Tul-Wilaya"?', options: ['Testimony of faith', 'Testimony of allegiance to Amir Al-Momineen', 'Testimony of travel', 'Testimony of wealth'], correctAnswerIndex: 0, explanation: 'While the term is less common, it refers to an extension of Islamic testimony regarding loyalty.', difficulty: 'medium'),
    ];
  }

  List<QuizQuestion> _getHardQuestionsEn() {
    return [
      QuizQuestion(id: 'hard_1', question: 'What is the Tafsir approach that relies heavily on classical Islamic scholars called?', options: ['Tafsir Bil-Ma\'thur', 'Tafsir Bil-Ray', 'Tafsir Bil-Ijma', 'Tafsir Bil-Ijtihaad'], correctAnswerIndex: 0, explanation: 'Tafsir Bil-Ma\'thur is exegesis based on transmitted traditions from Prophet and companions.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_2', question: 'Which mathematical miracle is found in Surah An-Noor regarding the number 24?', options: ['Occurs 24 times', 'Contains 24 verses', 'Related to 24 hours of day', 'Mentioned with specific mathematical patterns'], correctAnswerIndex: 3, explanation: 'Surah An-Noor contains mathematical patterns related to the number 24 discovered by modern scholars.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_3', question: 'What is the concept of "Naskh" in Quranic jurisprudence?', options: ['Copying', 'Abrogation of earlier revelations by later ones', 'Narration', 'Specification'], correctAnswerIndex: 1, explanation: 'Naskh refers to the abrogation of earlier Quranic rulings by later, more specific revelations.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_4', question: 'How many times is the word "Quran" mentioned in the Quran itself?', options: ['20', '50', '70', '100'], correctAnswerIndex: 2, explanation: 'The word "Quran" appears 70 times in various forms throughout the Quranic text.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_5', question: 'What is "Matn" in the Hadith terminology?', options: ['Chain of narration', 'The text/body of the hadith', 'The narrator', 'The topic discussed'], correctAnswerIndex: 1, explanation: 'Matn refers to the actual text or body of a hadith, as opposed to Isnad (chain of narration).', difficulty: 'hard'),
      QuizQuestion(id: 'hard_6', question: 'Which Surah contains the longest verse in the Quran?', options: ['Surah Al-Baqarah (Verse 282)', 'Surah Aal-Imran', 'Surah An-Nisa', 'Surah Al-Noor'], correctAnswerIndex: 0, explanation: 'Verse 282 of Surah Al-Baqarah is the longest single verse in the entire Quran.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_7', question: 'What is "Ijtihad" in Islamic jurisprudence?', options: ['Following consensus', 'Independent reasoning to derive rulings from Quran and Sunnah', 'Memorizing the Quran', 'Teaching Islamic law'], correctAnswerIndex: 1, explanation: 'Ijtihad is the independent reasoning by qualified scholars to derive Islamic rulings.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_8', question: 'How many Surahs begin with Alif-Lam-Meem?', options: ['3', '4', '5', '6'], correctAnswerIndex: 2, explanation: 'Five Surahs begin with Alif-Lam-Meem (A.L.M.): Al-Baqarah, Aal-Imran, An-Ankabut, Ar-Rum, and Luqman.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_9', question: 'What is the "Sunna of Allah" mentioned in the Quran?', options: ['The practices of Prophet Muhammad', 'The unchanging laws and patterns established by Allah in the universe', 'Religious practices only', 'Daily routines'], correctAnswerIndex: 1, explanation: 'The Sunna of Allah refers to the unchanging patterns and laws established by Allah in creation.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_10', question: 'Which Prophet is mentioned most frequently in the Quran?', options: ['Muhammad', 'Ibrahim', 'Musa', 'Isa'], correctAnswerIndex: 2, explanation: 'Prophet Musa (Moses) is mentioned more frequently than any other prophet in the Quran.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_11', question: 'What is the difference between "Haram" and "Makruh"?', options: ['No difference', 'Haram is forbidden while Makruh is disliked but permitted', 'Makruh is forbidden, Haram is disliked', 'Both mean the same thing'], correctAnswerIndex: 1, explanation: 'Haram is absolutely forbidden while Makruh is disliked/discouraged but not strictly prohibited.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_12', question: 'What is the "Khilaf" in Islamic jurisprudence?', options: ['Disagreement among scholars', 'Caliphate', 'Conflict between people', 'Difference in prayer times'], correctAnswerIndex: 0, explanation: 'Khilaf refers to scholarly disagreement (ikhtilaf) on matters of Islamic law.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_13', question: 'Which verses in the Quran contain the story of the Elephant (Fil)?', options: ['Surah Al-Fil', 'Surah Al-Fil only', 'Surah Al-Lahab and Al-Fil', 'Multiple Surahs'], correctAnswerIndex: 1, explanation: 'The story of the Elephant is told in Surah Al-Fil (Chapter 105).', difficulty: 'hard'),
      QuizQuestion(id: 'hard_14', question: 'What is the concept of "Darurah" (necessity) in Islamic law?', options: ['General emergency', 'Exception to Islamic rules when necessity demands and no alternatives exist', 'Personal preference', 'Temporary absence'], correctAnswerIndex: 1, explanation: 'Darurah is the principle that prohibitions may be lifted in cases of genuine necessity.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_15', question: 'How many Surahs are named after animals?', options: ['3', '4', '5', '6'], correctAnswerIndex: 2, explanation: 'Five Surahs are named after animals: Al-Fil (Elephant), An-Nahl (Bee), Al-Ankabut (Spider), Al-Insan (Human).', difficulty: 'hard'),
      QuizQuestion(id: 'hard_16', question: 'What is "Tawatur" in Hadith studies?', options: ['Single chain of narration', 'Mutual corroboration - narration reported by many people in different times and places', 'Weak hadith', 'Fabricated hadith'], correctAnswerIndex: 1, explanation: 'Tawatur is a hadith so widely reported that it would be impossible for all narrators to have conspired.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_17', question: 'Which Surah is known as "Surah of the Believers"?', options: ['Surah Al-Muminin', 'Surah Al-Anaam', 'Surah Al-Imaan', 'Surah At-Tawbah'], correctAnswerIndex: 0, explanation: 'Surah Al-Muminin (Chapter 23) translates to "Chapter of the Believers".', difficulty: 'hard'),
      QuizQuestion(id: 'hard_18', question: 'What is the "Tawhid Ar-Rububiyyah"?', options: ['Believing in prophets', 'Belief in the Lordship and Oneness of Allah\'s authority', 'Believing in scriptures', 'Belief in the Day of Judgment'], correctAnswerIndex: 1, explanation: 'Tawhid Ar-Rububiyyah is belief in Allah\'s sole lordship and divine control over the universe.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_19', question: 'How many times is "Paradise" (Jannah) explicitly mentioned in the Quran?', options: ['30', '50', '77', '100'], correctAnswerIndex: 2, explanation: 'The word "Jannah" (Paradise) appears approximately 77 times in the Quran.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_20', question: 'What is the "Sira Nabawiyya"?', options: ['Islamic law only', 'Biography of Prophet Muhammad covering his life and teachings', 'Quranic interpretation', 'Hadith collection'], correctAnswerIndex: 1, explanation: 'Sira Nabawiyya is the comprehensive biography of Prophet Muhammad\'s life and prophetic mission.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_21', question: 'What is "Mustalah Al-Hadith"?', options: ['Collection of hadith', 'Science of Hadith terminology and authentication', 'Hadith rules', 'Hadith studies basics'], correctAnswerIndex: 1, explanation: 'Mustalah Al-Hadith is the science of hadith terminology used to evaluate hadith authenticity.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_22', question: 'Which Surah contains the greatest number of legal rulings?', options: ['Surah Al-Baqarah', 'Surah An-Nisa', 'Surah Al-Maidah', 'Surah At-Tawbah'], correctAnswerIndex: 2, explanation: 'Surah Al-Maidah (Chapter 5) contains the most comprehensive Islamic legal rulings.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_23', question: 'What is the doctrine of "Kulliyat Al-Khams" (Five Objectives)?', options: ['Five Pillars', 'Five prayers', 'Preservation of religion, life, intellect, property, and lineage', 'Five companions'], correctAnswerIndex: 2, explanation: 'The Five Objectives of Sharia are to preserve: religion, life, intellect, property, and lineage.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_24', question: 'How many chapters of the Quran start without the Bismillah?', options: ['0', '1', '2', '5'], correctAnswerIndex: 1, explanation: 'Only Surah At-Tawbah (Chapter 9) begins without the Bismillah (In the name of Allah).', difficulty: 'hard'),
      QuizQuestion(id: 'hard_25', question: 'What is "Ayah Al-Burhan" in Islamic philosophy?', options: ['Verses of proof/evidence in the Quran', 'Religious commandments', 'Story verses', 'Scientific verses'], correctAnswerIndex: 0, explanation: 'Ayah Al-Burhan refers to verses in the Quran that serve as proofs or clear evidence.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_26', question: 'Which Surah discusses the most prophets in detail?', options: ['Surah Yusuf', 'Surah Aal-Imran', 'Surah As-Safat', 'Surah Al-Anbiya'], correctAnswerIndex: 3, explanation: 'Surah Al-Anbiya (Chapter 21) discusses numerous prophets and their stories.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_27', question: 'What is "Isnad" in hadith terminology?', options: ['The text of hadith', 'Chain of narrators reporting the hadith', 'The topic', 'The explanation'], correctAnswerIndex: 1, explanation: 'Isnad is the chain of narrators through which a hadith is transmitted.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_28', question: 'What is the "Tafsir Bil-Ijma"?', options: ['Personal interpretation', 'Interpretation based on consensus of Islamic scholars', 'Metaphorical interpretation', 'Scientific interpretation'], correctAnswerIndex: 1, explanation: 'Tafsir Bil-Ijma relies on the agreed-upon interpretations of multiple Islamic scholars.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_29', question: 'How many "Juz" (parts) is the Quran divided into?', options: ['20', '25', '30', '40'], correctAnswerIndex: 2, explanation: 'The Quran is traditionally divided into 30 equal parts called Juz for ease of recitation.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_30', question: 'What is the concept of "Tawhid Al-Uluhiyyah"?', options: ['Belief in prophets', 'Belief in worshipping Allah alone with no partners', 'Belief in scriptures', 'Belief in angels'], correctAnswerIndex: 1, explanation: 'Tawhid Al-Uluhiyyah is the belief that only Allah deserves worship and has no partners.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_31', question: 'Which scholar compiled the most authentic hadith collection known as "Sahih Al-Bukhari"?', options: ['Muslim ibn Al-Hajjaj', 'Muhammad Al-Bukhari', 'At-Tirmidhi', 'Abu Dawood'], correctAnswerIndex: 1, explanation: 'Muhammad Al-Bukhari compiled Sahih Al-Bukhari, one of the most authentic hadith collections.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_32', question: 'What is the "Meccan vs Medinan" classification in Quranic studies?', options: ['Geographic locations only', 'Classification based on where revelations occurred during Prophet\'s life', 'Type of content only', 'Random classification'], correctAnswerIndex: 1, explanation: 'Meccan and Medinan refer to Surahs revealed before and after the Hijra respectively.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_33', question: 'What is "Shari\'a" fundamentally based upon?', options: ['Cultural customs', 'Political decisions', 'Quran and Sunnah with analogical reasoning and scholarly consensus', 'Historical traditions'], correctAnswerIndex: 2, explanation: 'Sharia is based on four sources: Quran, Sunnah, Ijma (consensus), and Qiyas (analogy).', difficulty: 'hard'),
      QuizQuestion(id: 'hard_34', question: 'How many letters comprise the Arabic alphabet as traditionally counted?', options: ['26', '28', '30', '32'], correctAnswerIndex: 1, explanation: 'The Arabic alphabet has 28 letters traditionally counted in classical Arabic.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_35', question: 'What is the "Fiqh Makasid" approach?', options: ['Traditional jurisprudence', 'Jurisprudence based on the overall objectives and purposes of Sharia', 'Modern interpretation only', 'Literal interpretation'], correctAnswerIndex: 1, explanation: 'Fiqh Makasid examines rulings in light of the higher objectives of Islamic law.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_36', question: 'Which Surah mentions Dhu\'l-Qarnayn?', options: ['Surah Al-Kahf', 'Surah Yusuf', 'Surah Luqman', 'Surah As-Safat'], correctAnswerIndex: 0, explanation: 'Surah Al-Kahf (Chapter 18) contains the detailed story of Dhu\'l-Qarnayn.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_37', question: 'What is the "Usul Al-Fiqh"?', options: ['Islamic law itself', 'Sources and methodology of Islamic jurisprudence', 'Hadith collections', 'Prophetic traditions'], correctAnswerIndex: 1, explanation: 'Usul Al-Fiqh is the science of the principles and methodology of Islamic jurisprudence.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_38', question: 'How many verses discuss the prohibition of interest (Riba)?', options: ['2', '4', '6', '8'], correctAnswerIndex: 2, explanation: 'Several verses in the Quran explicitly prohibit Riba (interest/usury): 2:275, 2:276, 3:130, 4:161, 30:39.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_39', question: 'What is the "Mursal" hadith?', options: ['Authenticated hadith', 'Hadith with a broken chain missing a companion', 'Clear hadith', 'Weak hadith'], correctAnswerIndex: 1, explanation: 'Mursal is a hadith where the chain goes directly from a student of companions to Prophet.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_40', question: 'Which school of Islamic jurisprudence has the largest following today?', options: ['Hanbali', 'Maliki', 'Hanafi', 'Shafi\'i'], correctAnswerIndex: 2, explanation: 'The Hanafi school, founded by Imam Abu Hanifa, has the largest number of followers globally.', difficulty: 'hard'),
    ];
  }

  // ==========================================
  // PASTE ARABIC TRANSLATIONS HERE
  // ==========================================

  List<QuizQuestion> _getEasyQuestionsAr() {
    return[
      QuizQuestion(id: 'easy_1', question: 'كم مرة يصلي المسلمون في اليوم؟', options: ['3 مرات', '4 مرات', '5 مرات', '6 مرات'], correctAnswerIndex: 2, explanation: 'المسلمون ملزمون بالصلاة 5 مرات في اليوم: الفجر، الظهر، العصر، المغرب، والعشاء.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_2', question: 'ما هو اسم شهر الصيام في الإسلام؟', options: ['شوال', 'رمضان', 'محرم', 'ذو الحجة'], correctAnswerIndex: 1, explanation: 'رمضان هو الشهر التاسع من التقويم القمري الإسلامي والذي يصوم فيه المسلمون من الفجر حتى غروب الشمس.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_3', question: 'من هو آخر الأنبياء في الإسلام؟', options: ['إبراهيم', 'موسى', 'محمد', 'عيسى'], correctAnswerIndex: 2, explanation: 'النبي محمد (صلى الله عليه وسلم) هو الخاتم وآخر رسول بعثه الله.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_4', question: 'ماذا يسمى الحج الإسلامي؟', options: ['العمرة', 'الحج', 'الطواف', 'الصلاة'], correctAnswerIndex: 1, explanation: 'الحج هو رحلة الحج إلى مكة وهو أحد أركان الإسلام الخمسة.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_5', question: 'كم عدد أركان الإسلام؟', options: ['3', '4', '5', '6'], correctAnswerIndex: 2, explanation: 'هناك 5 أركان للإسلام: الشهادتان، الصلاة، الزكاة، الصوم، والحج.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_6', question: 'ماذا يسمى إعلان الإيمان في الإسلام؟', options: ['الصلاة', 'الشهادة', 'الزكاة', 'الحج'], correctAnswerIndex: 1, explanation: 'الشهادة هي العقيدة الإسلامية التي تقر بأنه لا إله إلا الله وأن محمداً رسول الله.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_7', question: 'في أي اتجاه يواجه المسلمون عند الصلاة؟', options: ['الشرق', 'الغرب', 'الشمال', 'تجاه مكة (القبلة)'], correctAnswerIndex: 3, explanation: 'يواجه المسلمون الكعبة في مكة أثناء الصلاة، في اتجاه يسمى القبلة.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_8', question: 'من بنى الكعبة؟', options: ['النبي موسى', 'النبي إبراهيم وإسماعيل', 'النبي محمد', 'النبي سليمان'], correctAnswerIndex: 1, explanation: 'وفقًا للتراث الإسلامي، قام النبي إبراهيم وابنه إسماعيل ببناء الكعبة.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_9', question: 'ماذا تسمى الصدقة الواجبة في الإسلام؟', options: ['الصوم', 'الزكاة', 'الحج', 'الطواف'], correctAnswerIndex: 1, explanation: 'الزكاة هي الصدقة الواجبة وهي أحد أركان الإسلام الخمسة.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_10', question: 'كم عدد سور القرآن الكريم؟', options: ['100', '110', '114', '120'], correctAnswerIndex: 2, explanation: 'يحتوي القرآن على 114 سورة، تتكون كل منها من آية واحدة أو أكثر.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_11', question: 'على ماذا يعتمد التقويم الإسلامي؟', options: ['السنة الشمسية', 'السنة القمرية', 'الشمسية والقمرية معاً', 'الفصول'], correctAnswerIndex: 1, explanation: 'يعتمد التقويم الإسلامي على السنة القمرية، ويُعرف أيضًا بالتقويم الهجري.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_12', question: 'كم عدد أيام شهر رمضان؟', options: ['25 يوماً', '28 يوماً', '29-30 يوماً', '35 يوماً'], correctAnswerIndex: 2, explanation: 'يتكون رمضان من 29 أو 30 يومًا اعتمادًا على رؤية الهلال.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_13', question: 'ماذا تعني كلمة "الإسلام"؟', options: ['السلام فقط', 'الاستسلام لله', 'الصلاة', 'الإيمان'], correctAnswerIndex: 1, explanation: 'الإسلام يعني الاستسلام لإرادة الله، وهي مشتقة من الكلمة العربية للسلام والاستسلام.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_14', question: 'من هو أول نبي في الإسلام؟', options: ['محمد', 'إبراهيم', 'آدم', 'موسى'], correctAnswerIndex: 2, explanation: 'النبي آدم هو أول إنسان وأول نبي أرسله الله.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_15', question: 'ما هي تحية الإسلام؟', options: ['مرحباً', 'السلام عليكم', 'أهلاً بك', 'تحياتي'], correctAnswerIndex: 1, explanation: 'السلام عليكم هي تحية الإسلام، والرد عليها هو "وعليكم السلام".', difficulty: 'easy'),
      QuizQuestion(id: 'easy_16', question: 'كم عدد الأنبياء المذكورين في القرآن الكريم؟', options: ['19', '25', '31', '50'], correctAnswerIndex: 1, explanation: 'تم ذكر 25 نبياً بالاسم في القرآن، بما في ذلك آدم، إبراهيم، موسى، عيسى، ومحمد.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_17', question: 'ما هي أول سورة في القرآن الكريم؟', options: ['سورة البقرة', 'سورة الفاتحة', 'سورة الناس', 'سورة الإخلاص'], correctAnswerIndex: 1, explanation: 'سورة الفاتحة هي أول سورة في القرآن وتُقرأ في كل ركعة من الصلاة.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_18', question: 'في أي مدينة وُلد النبي محمد؟', options: ['المدينة', 'مكة', 'القدس', 'بغداد'], correctAnswerIndex: 1, explanation: 'وُلد النبي محمد في مكة المكرمة عام 570 ميلادي.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_19', question: 'ما هو الطعام المحرم أكله في الإسلام؟', options: ['الخضروات', 'لحم الخنزير', 'الأسماك', 'الفواكه'], correctAnswerIndex: 1, explanation: 'يُحرم أكل لحم الخنزير وبعض اللحوم الأخرى في الإسلام كما ذُكر في القرآن.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_20', question: 'في أي عام هاجر النبي محمد إلى المدينة؟', options: ['610 م', '622 م', '632 م', '650 م'], correctAnswerIndex: 1, explanation: 'حدثت الهجرة في عام 622 ميلادي، مما يمثل بداية التقويم الإسلامي.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_21', question: 'كم مرة يطوف المسلمون حول الكعبة أثناء الحج؟', options: ['3 مرات', '5 مرات', '7 مرات', '10 مرات'], correctAnswerIndex: 2, explanation: 'يطوف المسلمون حول الكعبة 7 مرات كأحد مناسك الحج.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_22', question: 'ماذا يسمى النظام القانوني الإسلامي؟', options: ['الشريعة', 'الحديث', 'الفقه', 'الإجماع'], correctAnswerIndex: 0, explanation: 'الشريعة (القانون الإسلامي) هي الإطار القانوني المبني على القرآن والسنة.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_23', question: 'من الذي جمع أول مصحف مكتوب للقرآن الكريم؟', options: ['أبو بكر', 'عمر', 'عثمان', 'علي'], correctAnswerIndex: 2, explanation: 'قام الخليفة عثمان بن عفان بجمع القرآن وتوحيده في مصحف واحد خلال فترة حكمه.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_24', question: 'ماذا تعني كلمة "الحديث"؟', options: ['التلاوة', 'قصص الأنبياء', 'أقوال وأفعال النبي محمد', 'الفقه'], correctAnswerIndex: 2, explanation: 'يشير الحديث إلى الأقوال والأفعال والتقريرات المسجلة عن النبي محمد.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_25', question: 'كم مرة يُتلى التكبير (الله أكبر) يومياً؟', options: ['5 مرات', '10 مرات', '10 مرات على الأقل', 'مرات عديدة طوال اليوم'], correctAnswerIndex: 3, explanation: 'يُتلى التكبير عدة مرات يومياً في الصلوات والممارسات الإسلامية الأخرى.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_26', question: 'ماذا تسمى وجبة ما قبل الفجر في رمضان؟', options: ['السحور', 'الإفطار', 'التراويح', 'القيام'], correctAnswerIndex: 0, explanation: 'السحور هو الوجبة التي تؤكل قبل الفجر وبدء الصيام.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_27', question: 'ماذا يسمى كسر الصيام عند غروب الشمس؟', options: ['السحور', 'الإفطار', 'التهجد', 'الوتر'], correctAnswerIndex: 1, explanation: 'الإفطار هو الوجبة التي تؤكل عند غروب الشمس لكسر الصيام في رمضان.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_28', question: 'كم مرة يتوضأ المسلم في اليوم؟', options: ['مرة واحدة', 'مرتين', 'يختلف - قبل كل صلاة', '5 مرات فقط'], correctAnswerIndex: 2, explanation: 'يتم الوضوء قبل كل صلاة، لذلك يختلف العدد بناءً على أوقات الصلاة.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_29', question: 'ما هي صلاة الليل في رمضان؟', options: ['صلاة الليل', 'التراويح', 'قيام الليل', 'التهجد'], correctAnswerIndex: 1, explanation: 'التراويح هي صلوات خاصة تُقام في ليالي رمضان بعد صلاة العشاء.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_30', question: 'أي صلاة هي الأطول وقتًا؟', options: ['الفجر', 'الظهر', 'العصر', 'المغرب'], correctAnswerIndex: 1, explanation: 'تُعتبر صلاة الظهر عمومًا أطول صلاة في اليوم.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_31', question: 'كم عدد الركعات في صلاة الظهر؟', options: ['2', '3', '4', '5'], correctAnswerIndex: 2, explanation: 'تتكون صلاة الظهر من 4 ركعات مفروضة.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_32', question: 'ماذا تسمى شهادة الإيمان؟', options: ['التكبير', 'الشهادة', 'التسبيح', 'التهليل'], correctAnswerIndex: 1, explanation: 'الشهادة هي إعلان الإيمان الإسلامي الذي يشهد بوحدانية الله.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_33', question: 'أي شهر يُعتبر أفضل شهر للصلوات الإضافية؟', options: ['شوال', 'رمضان', 'محرم', 'رجب'], correctAnswerIndex: 1, explanation: 'رمضان هو أقدس شهر في التقويم الإسلامي حيث تُضاعف فيه الحسنات.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_34', question: 'ما هي الضريبة الواجبة أو الصدقة المفروضة؟', options: ['الزكاة', 'الخراج', 'الطواف', 'الصدقة'], correctAnswerIndex: 0, explanation: 'الزكاة هي إعطاء جزء محدد من المال للفقراء والمحتاجين.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_35', question: 'كم عدد أضلاع الكعبة؟', options: ['2', '3', '4', '6'], correctAnswerIndex: 2, explanation: 'الكعبة هي مبنى مكعب الشكل ذو 4 أضلاع، يقع في مكة.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_36', question: 'ما هي الصدقة في الإسلام؟', options: ['صدقة واجبة', 'صدقة تطوعية', 'ضريبة', 'عقوبة'], correctAnswerIndex: 1, explanation: 'الصدقة هي تبرع تطوعي يُعطى بنية مساعدة الآخرين وإرضاء الله.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_37', question: 'من هي والدة النبي محمد؟', options: ['آمنة', 'حليمة', 'خديجة', 'عائشة'], correctAnswerIndex: 0, explanation: 'آمنة بنت وهب هي الوالدة البيولوجية للنبي محمد.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_38', question: 'بماذا يُعرف التقويم الإسلامي أيضاً؟', options: ['التقويم الشمسي', 'التقويم الهجري', 'التقويم الميلادي', 'التقويم اليولياني'], correctAnswerIndex: 1, explanation: 'يُسمى التقويم الإسلامي أيضاً بالتقويم الهجري، نسبةً إلى الهجرة.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_39', question: 'كم عدد الآيات في القرآن تقريباً؟', options: ['3000', '6000', '9000', '12000'], correctAnswerIndex: 1, explanation: 'يحتوي القرآن على حوالي 6,236 آية موزعة على 114 سورة.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_40', question: 'ماذا تعني "بسم الله"؟', options: ['سبحان الله', 'باسم الله', 'الله أكبر', 'الحمد لله'], correctAnswerIndex: 1, explanation: 'تعني البسملة "باسم الله" وتُقرأ قبل البدء في أي عمل.', difficulty: 'easy'),
    ];
  }
  // --- ARABIC: MEDIUM ---
  List<QuizQuestion> _getMediumQuestionsAr() {
    return [
      QuizQuestion(id: 'mid_1', question: 'ما هي السنة؟', options: ['تعاليم الأديان الأخرى', 'ممارسات وتقاليد النبي محمد', 'طقوس الحج', 'القوانين الإسلامية'], correctAnswerIndex: 1, explanation: 'السنة تشير إلى تقاليد وممارسات النبي محمد التي تعتبر نموذجًا للمسلمين.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_2', question: 'من هو أول خليفة للمسلمين؟', options: ['عمر بن الخطاب', 'أبو بكر الصديق', 'عثمان بن عفان', 'علي بن أبي طالب'], correctAnswerIndex: 1, explanation: 'أبو بكر الصديق كان أول خليفة بعد النبي محمد، حكم من 632-634 م.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_3', question: 'ما هو الفقه في الشريعة الإسلامية؟', options: ['حفظ القرآن', 'فهم وتفسير الشريعة الإسلامية', 'تقاليد رواية القصص', 'التعبيرات الشعرية'], correctAnswerIndex: 1, explanation: 'الفقه هو فرع من المعرفة الإسلامية يتعامل مع فهم وتطبيق الشريعة.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_4', question: 'ما هو الإجماع في الشريعة الإسلامية؟', options: ['رأي شخصي', 'اتفاق علماء المسلمين', 'الآيات القرآنية', 'التقاليد فقط'], correctAnswerIndex: 1, explanation: 'الإجماع هو اتفاق علماء المسلمين على مسألة معينة وهو أحد مصادر التشريع.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_5', question: 'كم عدد الخلفاء الراشدين؟', options: ['2', '3', '4', '5'], correctAnswerIndex: 2, explanation: 'الخلفاء الراشدون الأربعة هم أبو بكر، عمر، عثمان، وعلي.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_6', question: 'ماذا تسمى الليلة التي نزل فيها القرآن؟', options: ['ليلة القدر', 'ليلة الجن', 'ليلة الإسراء', 'ليلة البراءة'], correctAnswerIndex: 0, explanation: 'ليلة القدر هي الليلة التي بدأ فيها نزول القرآن وهي أعظم الليالي.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_7', question: 'أي سورة تذكر ليلة القدر؟', options: ['سورة العلق', 'سورة القدر', 'سورة الرحمن', 'سورة العاديات'], correctAnswerIndex: 1, explanation: 'سورة القدر (السورة 97) مخصصة بالكامل لوصف ليلة القدر.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_8', question: 'ما هو القياس في الفقه الإسلامي؟', options: ['القياس المادي', 'الاستدلال التماثلي أو القياس على أمور مشابهة', 'الإبلاغ', 'طرح الأسئلة'], correctAnswerIndex: 1, explanation: 'القياس هو طريقة لاستنباط الأحكام الإسلامية عبر مقارنتها بحالات مشابهة في القرآن والسنة.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_9', question: 'كم عدد كتاب الوحي للنبي محمد؟', options: ['3', '5', '15-20', 'أكثر من 40'], correctAnswerIndex: 3, explanation: 'كان للنبي محمد أكثر من 40 كاتباً سجلوا الوحي، منهم علي وعثمان.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_10', question: 'ماذا يعني الحجاب في السياق الإسلامي؟', options: ['غطاء الرأس فقط', 'الاحتشام واللباس الساتر للرجال والنساء', 'شاشة فقط', 'منع ديني'], correctAnswerIndex: 1, explanation: 'الحجاب يمثل الاحتشام ولا يقتصر على ملابس النساء بل يشمل الجنسين.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_11', question: 'ما هو الإسراء والمعراج؟', options: ['رحلتان مختلفتان', 'رحلة النبي ليلاً من مكة للقدس وعروجه للسماء', 'سورتان في القرآن', 'اسمان للكعبة'], correctAnswerIndex: 1, explanation: 'الإسراء هو الرحلة الليلية إلى القدس، والمعراج هو الصعود إلى السماوات.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_12', question: 'أي سورة تحتوي على آية الكرسي؟', options: ['سورة البقرة', 'سورة آل عمران', 'سورة النور', 'سورة يس'], correctAnswerIndex: 0, explanation: 'توجد آية الكرسي في سورة البقرة (2:255) وهي من أعظم الآيات في القرآن.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_13', question: 'ما هي أقصر سورة في القرآن؟', options: ['سورة الإخلاص', 'سورة الناس', 'سورة الكوثر', 'سورة الفيل'], correctAnswerIndex: 2, explanation: 'سورة الكوثر (السورة 108) هي أقصر سورة وتتكون من 3 آيات فقط.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_14', question: 'كم عدد أسماء الله الحسنى الشائعة؟', options: ['50', '99', '150', '200'], correctAnswerIndex: 1, explanation: 'يتم التأكيد بشكل خاص على 99 اسماً لله في التراث الإسلامي.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_15', question: 'ما هي غزوة بدر؟', options: ['موقع في المدينة', 'أول معركة كبرى بين المسلمين وقريش', 'طريق تجاري', 'بئر ماء'], correctAnswerIndex: 1, explanation: 'غزوة بدر (2 هـ) كانت أول مواجهة عسكرية كبرى بين المسلمين وقريش.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_16', question: 'ماذا تعني كلمة "الأمة"؟', options: ['الأم', 'الأمة أو المجتمع الإسلامي', 'الجدة', 'القبيلة'], correctAnswerIndex: 1, explanation: 'تشير الأمة إلى المجتمع الإسلامي العالمي الموحد بالإيمان.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_17', question: 'ما هي أركان الإيمان الستة؟', options: ['الله، القرآن، الصلاة، الصوم، الزكاة، الحج', 'الإيمان بالله وملائكته وكتبه ورسله واليوم الآخر والقدر', 'الأركان الخمسة فقط', 'أسماء الله فقط'], correctAnswerIndex: 1, explanation: 'أركان الإيمان الستة تشكل أساس العقيدة الإسلامية.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_18', question: 'من هي الزوجة الأولى للنبي إبراهيم؟', options: ['سارة', 'هاجر', 'قطورة', 'ليئة'], correctAnswerIndex: 0, explanation: 'سارة كانت الزوجة الأولى للنبي إبراهيم وأم النبي إسحاق.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_19', question: 'بماذا يُعرف شهر محرم الإسلامي؟', options: ['شهر الصيام', 'شهر الحج', 'الشهر الحرام الذي يضم يوم عاشوراء', 'شهر المعارك'], correctAnswerIndex: 2, explanation: 'محرم هو الشهر الأول من السنة الإسلامية وهو شهر حرام.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_20', question: 'ما هي زكاة الفطر؟', options: ['ضريبة على الممتلكات', 'صدقة تُخرج في نهاية رمضان قبل صلاة العيد', 'صدقة شهرية', 'صدقة للفقراء فقط'], correctAnswerIndex: 1, explanation: 'زكاة الفطر هي شكل خاص من الصدقة تُعطى قبل عيد الفطر.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_21', question: 'كم عدد حملة عرش الرحمن؟', options: ['2', '4', '8', 'غير محدد في القرآن'], correctAnswerIndex: 2, explanation: 'وفقاً للقرآن، يحمل عرش الرحمن ثمانية من الملائكة.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_22', question: 'ما اسم الملك الذي نزل بالوحي؟', options: ['جبريل', 'ميكائيل', 'إسرافيل', 'مالك'], correctAnswerIndex: 0, explanation: 'الملك جبريل (عليه السلام) هو الملك الذي نزل بالوحي على النبي محمد.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_23', question: 'ما هو أول عمل يُحاسب عليه العبد يوم القيامة؟', options: ['الإيمان', 'الصلاة', 'الصدقة', 'اللطف'], correctAnswerIndex: 1, explanation: 'وفقًا للحديث، الصلاة هي أول عمل يُحاسب عليه العبد يوم القيامة.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_24', question: 'كم مرة وردت كلمة "يا أيها" في القرآن؟', options: ['50', '100', '165', '200'], correctAnswerIndex: 2, explanation: 'وردت عبارة "يا أيها" 165 مرة في القرآن.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_25', question: 'ما هو الدعاء المأثور عند رؤية الهلال؟', options: ['الله أكبر', 'الحمد لله', 'يختلف حسب المنطقة', 'اللهم أهله علينا بالأمن والإيمان'], correctAnswerIndex: 3, explanation: 'الدعاء المأثور هو: اللهم أهله علينا بالأمن والإيمان والسلامة والإسلام.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_26', question: 'كم مرة أدى النبي محمد فريضة الحج؟', options: ['مرة واحدة', 'مرتين', 'ثلاث مرات', 'خمس مرات'], correctAnswerIndex: 0, explanation: 'أدى النبي محمد الحج مرة واحدة فقط في 10 هـ، وتُعرف بحجة الوداع.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_27', question: 'ما هي صلاة الاستخارة؟', options: ['طقس صيام', 'صلاة لطلب الخيرة والتوجيه من الله في اتخاذ قرار', 'طقس حج', 'تحية'], correctAnswerIndex: 1, explanation: 'الاستخارة هي صلاة لطلب التوجيه الإلهي عند اتخاذ قرارات هامة.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_28', question: 'من هم الملائكة الكرام الكاتبون؟', options: ['جبريل', 'ميكائيل', 'كراماً كاتبين', 'مالك'], correctAnswerIndex: 2, explanation: 'الكرام الكاتبون هم الملائكة الذين يسجلون أفعالنا، الخير والشر.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_29', question: 'ماذا يسمى العذاب في القبر؟', options: ['عذاب القبر', 'الجحيم', 'سقر', 'لظى'], correctAnswerIndex: 0, explanation: 'يشير عذاب القبر إلى العقاب في القبر، وهو مفهوم مذكور في التعاليم الإسلامية.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_30', question: 'كم عدد آيات سورة البقرة؟', options: ['100', '200', '286', '300'], correctAnswerIndex: 2, explanation: 'تحتوي سورة البقرة (السورة 2) على 286 آية وهي أطول سورة في القرآن.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_31', question: 'ماذا تعني "الصدقة الجارية"؟', options: ['صدقة لمرة واحدة', 'صدقة مستمرة يستمر نفعها بعد الموت', 'صدقة إجبارية', 'صدقة الأعياد'], correctAnswerIndex: 1, explanation: 'الصدقة الجارية هي عمل خيري مستمر كبناء بئر أو مدرسة يفيد الناس باستمرار.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_32', question: 'من هي الصحابية المعروفة بغزارة علمها؟', options: ['عائشة', 'فاطمة', 'حفصة', 'زينب'], correctAnswerIndex: 0, explanation: 'عائشة بنت أبي بكر اشتهرت بمعرفتها الواسعة بالإسلام وتُلقب بـ "أم المؤمنين".', difficulty: 'medium'),
      QuizQuestion(id: 'mid_33', question: 'ما هو الاسم الإنجليزي لشهر الصيام؟', options: ['Ramada', 'Ramazan', 'Ramadan', 'Ramanah'], correctAnswerIndex: 2, explanation: 'Ramadan هو النقل الصوتي الإنجليزي القياسي لشهر رمضان.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_34', question: 'كم عدد الملائكة الرئيسيين المذكورين بالاسم في القرآن؟', options: ['2', '3', '4', '5'], correctAnswerIndex: 2, explanation: 'تم ذكر أربعة ملائكة كبار: جبريل، ميكائيل، إسرافيل، ومالك.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_35', question: 'ما هو مفهوم "التوكل" في الإسلام؟', options: ['الصلاة', 'الاعتماد على الله بعد بذل الجهد (عقلها وتوكل)', 'الصوم', 'الصدقة'], correctAnswerIndex: 1, explanation: 'التوكل هو المفهوم الإسلامي للثقة الكاملة والاعتماد على الله بعد اتخاذ الأسباب.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_36', question: 'كم عدد الكبائر المتفق عليها في الإسلام تقريباً؟', options: ['7', '12', 'يختلف بين العلماء', 'غير محدد'], correctAnswerIndex: 2, explanation: 'بينما لا توجد قائمة ثابتة نهائية، يتفق العلماء على الكبائر الكبرى كالشرك والقتل.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_37', question: 'ما هو مفهوم "التقوى" في الإسلام؟', options: ['الخوف فقط', 'مخافة الله والوعي به', 'الصلاة', 'الصدقة'], correctAnswerIndex: 1, explanation: 'التقوى هي مفهوم الوعي بالله والخوف منه، وهو أساسي للتطور الروحي.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_38', question: 'من كان أفضل قراء القرآن بين الصحابة بصوته؟', options: ['عمر', 'أبو موسى الأشعري', 'عثمان', 'علي'], correctAnswerIndex: 1, explanation: 'اشتهر أبو موسى الأشعري بصوته الجميل وتلاوته الاستثنائية للقرآن.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_39', question: 'ما أهمية الرقم 19 في القرآن؟', options: ['عدد الأركان', 'عدد الملائكة', 'مرتبط بخزنة جهنم وعددهم 19', 'عدد الصلوات'], correctAnswerIndex: 2, explanation: 'يظهر الرقم 19 في سورة المدثر فيما يتعلق بحراس جهنم.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_40', question: 'ما هي "شهادة الولاية"؟', options: ['شهادة الإيمان', 'شهادة الولاء لأمير المؤمنين', 'شهادة السفر', 'شهادة الثروة'], correctAnswerIndex: 0, explanation: 'تشير إلى امتداد الشهادة الإسلامية فيما يتعلق بالولاء.', difficulty: 'medium'),
    ];
  }

  // --- ARABIC: HARD ---
  List<QuizQuestion> _getHardQuestionsAr() {
    return [
      QuizQuestion(id: 'hard_1', question: 'ما هو التفسير الذي يعتمد بشكل كبير على المأثور عن السلف؟', options: ['التفسير بالمأثور', 'التفسير بالرأي', 'التفسير بالإجماع', 'التفسير بالاجتهاد'], correctAnswerIndex: 0, explanation: 'التفسير بالمأثور هو التفسير المبني على التقاليد المنقولة عن النبي والصحابة.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_2', question: 'أي إعجاز رياضي يوجد في سورة النور يتعلق بالرقم 24؟', options: ['يحدث 24 مرة', 'يحتوي على 24 آية', 'يتعلق بـ 24 ساعة', 'مذكور بأنماط رياضية محددة'], correctAnswerIndex: 3, explanation: 'تحتوي سورة النور على أنماط رياضية تتعلق بالرقم 24 اكتشفها العلماء المعاصرون.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_3', question: 'ما هو مفهوم "النسخ" في علوم القرآن؟', options: ['النسخ الحرفي', 'إلغاء حكم شرعي سابق بحكم متأخر', 'السرد', 'التخصيص'], correctAnswerIndex: 1, explanation: 'النسخ يشير إلى إلغاء أو تغيير أحكام قرآنية سابقة بوحي لاحق.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_4', question: 'كم مرة ذُكرت كلمة "قرآن" في القرآن نفسه؟', options: ['20', '50', '70', '100'], correctAnswerIndex: 2, explanation: 'تظهر كلمة "قرآن" حوالي 70 مرة بأشكال مختلفة في النص القرآني.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_5', question: 'ما هو "المتن" في مصطلح الحديث؟', options: ['سلسلة الرواة', 'نص الحديث نفسه', 'الراوي', 'الموضوع المطروح'], correctAnswerIndex: 1, explanation: 'المتن يشير إلى النص الفعلي للحديث، بخلاف السند (سلسلة الرواة).', difficulty: 'hard'),
      QuizQuestion(id: 'hard_6', question: 'أي سورة تحتوي على أطول آية في القرآن؟', options: ['سورة البقرة (آية 282)', 'سورة آل عمران', 'سورة النساء', 'سورة النور'], correctAnswerIndex: 0, explanation: 'الآية 282 من سورة البقرة (آية الدَّين) هي أطول آية في القرآن بأكمله.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_7', question: 'ما هو "الاجتهاد" في الفقه الإسلامي؟', options: ['اتباع الإجماع', 'استنباط الأحكام الشرعية من الأدلة التفصيلية', 'حفظ القرآن', 'تدريس الشريعة'], correctAnswerIndex: 1, explanation: 'الاجتهاد هو بذل الجهد من قبل العلماء المؤهلين لاستنباط الأحكام الإسلامية.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_8', question: 'كم عدد السور التي تبدأ بـ "الم"؟', options: ['3', '4', '5', '6'], correctAnswerIndex: 2, explanation: 'تبدأ خمس سور بـ (الم): البقرة، آل عمران، العنكبوت، الروم، ولقمان.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_9', question: 'ما هي "سنة الله" المذكورة في القرآن؟', options: ['ممارسات النبي محمد', 'القوانين والسنن الكونية الثابتة التي وضعها الله', 'الممارسات الدينية فقط', 'الروتين اليومي'], correctAnswerIndex: 1, explanation: 'سنة الله تشير إلى الأنماط والقوانين الثابتة التي أرساها الله في الكون.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_10', question: 'من هو النبي الأكثر ذكراً في القرآن الكريم؟', options: ['محمد', 'إبراهيم', 'موسى', 'عيسى'], correctAnswerIndex: 2, explanation: 'النبي موسى ذُكر في القرآن أكثر من أي نبي آخر.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_11', question: 'ما هو الفرق بين "الحرام" و"المكروه"؟', options: ['لا يوجد فرق', 'الحرام ممنوع والمكروه مستهجن لكنه غير محرم', 'المكروه ممنوع والحرام مستهجن', 'كلاهما يعني نفس الشيء'], correctAnswerIndex: 1, explanation: 'الحرام ممنوع تماماً بينما المكروه لا يُستحب فعله لكنه ليس محظوراً بصرامة.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_12', question: 'ما هو "الخلاف" في الفقه الإسلامي؟', options: ['الاختلاف بين العلماء', 'الخلافة', 'النزاع بين الناس', 'اختلاف أوقات الصلاة'], correctAnswerIndex: 0, explanation: 'الخلاف يشير إلى الاختلاف الفقهي بين العلماء في مسائل الشريعة.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_13', question: 'في أي سور تُروى قصة أصحاب الفيل؟', options: ['سورة الفيل', 'سورة الفيل فقط', 'سورة المسد والفيل', 'سور متعددة'], correctAnswerIndex: 1, explanation: 'تُروى قصة الفيل في سورة الفيل (السورة 105).', difficulty: 'hard'),
      QuizQuestion(id: 'hard_14', question: 'ما هو مبدأ "الضرورة" في الشريعة الإسلامية؟', options: ['الطوارئ العامة', 'إباحة المحظورات عند الضرورة القصوى (الضرورات تبيح المحظورات)', 'التفضيل الشخصي', 'الغياب المؤقت'], correctAnswerIndex: 1, explanation: 'الضرورة هي المبدأ الذي يبيح رفع الحظر في حالات الحاجة الماسة.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_15', question: 'كم عدد السور التي سميت بأسماء حيوانات؟', options: ['3', '4', '5', '6'], correctAnswerIndex: 2, explanation: 'خمس سور: البقرة، الأنعام (الماشية)، النحل، النمل، والعنكبوت.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_16', question: 'ما هو التواتر في علم الحديث؟', options: ['سلسلة رواية فردية', 'رواية جمع عن جمع يستحيل تواطؤهم على الكذب', 'حديث ضعيف', 'حديث موضوع'], correctAnswerIndex: 1, explanation: 'التواتر هو أن يروي الحديث جمع كبير يستحيل اتفاقهم على الكذب.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_17', question: 'أي سورة تُعرف بـ "سورة المؤمنين"؟', options: ['سورة المؤمنون', 'سورة الأنعام', 'سورة الإيمان', 'سورة التوبة'], correctAnswerIndex: 0, explanation: 'سورة المؤمنون (السورة 23).', difficulty: 'hard'),
      QuizQuestion(id: 'hard_18', question: 'ما هو "توحيد الربوبية"؟', options: ['الإيمان بالأنبياء', 'الإيمان بأن الله هو الخالق الرازق المدبر', 'الإيمان بالكتب', 'الإيمان بيوم القيامة'], correctAnswerIndex: 1, explanation: 'توحيد الربوبية هو الإيمان بأن الله وحده هو الخالق والمدبر للكون.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_19', question: 'كم مرة ذُكرت كلمة "الجنة" صراحة في القرآن؟', options: ['30', '50', '77', '100'], correctAnswerIndex: 2, explanation: 'وردت كلمة "الجنة" حوالي 77 مرة في القرآن.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_20', question: 'ما هي "السيرة النبوية"؟', options: ['القانون الإسلامي فقط', 'السيرة الذاتية للنبي محمد التي تغطي حياته وتعاليمه', 'التفسير القرآني', 'جمع الحديث'], correctAnswerIndex: 1, explanation: 'السيرة النبوية هي السيرة الشاملة لحياة النبي محمد ورسالته.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_21', question: 'ما هو "مصطلح الحديث"؟', options: ['مجموعة أحاديث', 'علم قواعد تقييم وتصنيف الحديث الشريف', 'قواعد الحديث', 'أساسيات دراسات الحديث'], correctAnswerIndex: 1, explanation: 'مصطلح الحديث هو العلم المستخدم لتقييم صحة الأحاديث وسندها.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_22', question: 'أي سورة تحتوي على أكبر عدد من الأحكام الشرعية؟', options: ['سورة البقرة', 'سورة النساء', 'سورة المائدة', 'سورة التوبة'], correctAnswerIndex: 2, explanation: 'سورة المائدة (السورة 5) تحتوي على أحكام شرعية شاملة وكثيرة.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_23', question: 'ما هي "الكليات الخمس" (مقاصد الشريعة)؟', options: ['الأركان الخمسة', 'الصلوات الخمس', 'حفظ الدين، النفس، العقل، النسل، والمال', 'الصحابة الخمسة'], correctAnswerIndex: 2, explanation: 'مقاصد الشريعة الخمسة هي الحفاظ على: الدين، النفس، العقل، النسل، والمال.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_24', question: 'كم عدد سور القرآن التي لا تبدأ بالبسملة؟', options: ['0', '1', '2', '5'], correctAnswerIndex: 1, explanation: 'سورة التوبة (السورة 9) هي السورة الوحيدة التي لا تبدأ بـ "بسم الله الرحمن الرحيم".', difficulty: 'hard'),
      QuizQuestion(id: 'hard_25', question: 'ما المقصود بـ "آية البرهان"؟', options: ['آيات الدليل والحجة الواضحة في القرآن', 'الوصايا الدينية', 'آيات القصص', 'الآيات العلمية'], correctAnswerIndex: 0, explanation: 'آية البرهان تشير إلى الآيات التي تعمل كأدلة أو براهين قاطعة.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_26', question: 'أي سورة تناقش أكبر عدد من الأنبياء بالتفصيل؟', options: ['سورة يوسف', 'سورة آل عمران', 'سورة الصافات', 'سورة الأنبياء'], correctAnswerIndex: 3, explanation: 'سورة الأنبياء (السورة 21) تناقش العديد من الأنبياء وقصصهم.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_27', question: 'ما هو "السند" في علم الحديث؟', options: ['نص الحديث', 'سلسلة الرواة الذين نقلوا الحديث', 'الموضوع', 'الشرح'], correctAnswerIndex: 1, explanation: 'السند هو سلسلة الرواة التي ينتقل عبرها الحديث.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_28', question: 'ما هو "التفسير بالإجماع"؟', options: ['التفسير الشخصي', 'التفسير المبني على إجماع علماء المسلمين', 'التفسير المجازي', 'التفسير العلمي'], correctAnswerIndex: 1, explanation: 'التفسير بالإجماع يعتمد على التفسيرات المتفق عليها من قبل علماء المسلمين.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_29', question: 'إلى كم "جزء" يُقسم القرآن الكريم؟', options: ['20', '25', '30', '40'], correctAnswerIndex: 2, explanation: 'يُقسم القرآن تقليدياً إلى 30 جزءاً متساوياً لتسهيل التلاوة.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_30', question: 'ما هو مفهوم "توحيد الألوهية"؟', options: ['الإيمان بالأنبياء', 'الإيمان بإفراد الله بالعبادة وحده لا شريك له', 'الإيمان بالكتب', 'الإيمان بالملائكة'], correctAnswerIndex: 1, explanation: 'توحيد الألوهية هو الإيمان بأن الله وحده هو المستحق للعبادة.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_31', question: 'من هو العالم الذي جمع أصح كتاب حديث يُعرف بـ "صحيح البخاري"؟', options: ['مسلم بن الحجاج', 'محمد بن إسماعيل البخاري', 'الترمذي', 'أبو داود'], correctAnswerIndex: 1, explanation: 'محمد البخاري هو من جمع صحيح البخاري، وهو من أصح كتب الحديث.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_32', question: 'ما هو تصنيف "المكي والمدني" في علوم القرآن؟', options: ['مواقع جغرافية فقط', 'تصنيف بناءً على مكان ووقت نزول الوحي قبل أو بعد الهجرة', 'نوع المحتوى فقط', 'تصنيف عشوائي'], correctAnswerIndex: 1, explanation: 'المكي والمدني يشير إلى السور التي نزلت قبل وبعد الهجرة إلى المدينة.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_33', question: 'على ماذا تعتمد "الشريعة" بشكل أساسي؟', options: ['العادات الثقافية', 'القرارات السياسية', 'القرآن والسنة مع القياس والإجماع', 'التقاليد التاريخية'], correctAnswerIndex: 2, explanation: 'تعتمد الشريعة على أربعة مصادر: القرآن، السنة، الإجماع، والقياس.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_34', question: 'كم عدد الحروف التي تتكون منها الأبجدية العربية تقليدياً؟', options: ['26', '28', '30', '32'], correctAnswerIndex: 1, explanation: 'تحتوي الأبجدية العربية على 28 حرفاً كما تُعد تقليدياً في العربية الفصحى.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_35', question: 'ما هو منهج "فقه المقاصد"؟', options: ['الفقه التقليدي', 'الفقه المبني على الأهداف والمقاصد الكلية للشريعة', 'التفسير الحديث فقط', 'التفسير الحرفي'], correctAnswerIndex: 1, explanation: 'فقه المقاصد يدرس الأحكام في ضوء الأهداف العليا للشريعة الإسلامية.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_36', question: 'أي سورة تذكر قصة ذي القرنين؟', options: ['سورة الكهف', 'سورة يوسف', 'سورة لقمان', 'سورة الصافات'], correctAnswerIndex: 0, explanation: 'سورة الكهف (السورة 18) تحتوي على القصة المفصلة لذي القرنين.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_37', question: 'ما هو "أصول الفقه"؟', options: ['القانون الإسلامي نفسه', 'مصادر ومنهجية استنباط الفقه الإسلامي', 'مجموعات الحديث', 'التقاليد النبوية'], correctAnswerIndex: 1, explanation: 'أصول الفقه هو علم دراسة المبادئ والمنهجية للفقه الإسلامي.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_38', question: 'كم عدد الآيات التي تناقش تحريم الربا؟', options: ['2', '4', '6', '8'], correctAnswerIndex: 2, explanation: 'تحرم عدة آيات في القرآن الربا صراحة، منها في سورة البقرة وآل عمران.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_39', question: 'ما هو الحديث "المرسل"؟', options: ['حديث موثق', 'حديث سقط من سنده الصحابي ورفعه التابعي للنبي', 'حديث واضح', 'حديث ضعيف'], correctAnswerIndex: 1, explanation: 'المرسل هو الحديث الذي يرويه التابعي عن النبي مباشرة دون ذكر الصحابي.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_40', question: 'أي مذهب فقهي إسلامي لديه أكبر عدد من الأتباع اليوم؟', options: ['الحنبلي', 'المالكي', 'الحنفي', 'الشافعي'], correctAnswerIndex: 2, explanation: 'المذهب الحنفي، الذي أسسه الإمام أبو حنيفة، يمتلك أكبر عدد من الأتباع عالمياً.', difficulty: 'hard'),
    ];
  }

  // ==========================================
  // FRENCH TRANSLATIONS (ALL 120 QUESTIONS)
  // ==========================================

  // --- FRENCH: EASY ---
  List<QuizQuestion> _getEasyQuestionsFr() {
    return [
      QuizQuestion(id: 'easy_1', question: 'Combien de fois par jour les musulmans prient-ils ?', options: ['3 fois', '4 fois', '5 fois', '6 fois'], correctAnswerIndex: 2, explanation: 'Les musulmans sont tenus de prier 5 fois par jour : Fajr, Dhohr, Asr, Maghrib et Icha.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_2', question: 'Comment s\'appelle le mois de jeûne islamique ?', options: ['Shawwal', 'Ramadan', 'Muharram', 'Dhul-Hijjah'], correctAnswerIndex: 1, explanation: 'Le Ramadan est le neuvième mois du calendrier lunaire islamique durant lequel les musulmans jeûnent de l\'aube au coucher du soleil.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_3', question: 'Qui est le dernier Prophète en Islam ?', options: ['Ibrahim', 'Moussa', 'Muhammad', 'Issa'], correctAnswerIndex: 2, explanation: 'Le Prophète Muhammad (paix et bénédictions sur lui) est le dernier messager envoyé par Allah.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_4', question: 'Comment appelle-t-on le pèlerinage islamique ?', options: ['Omra', 'Hajj', 'Tawaf', 'Salat'], correctAnswerIndex: 1, explanation: 'Le Hajj est le pèlerinage à La Mecque, qui est l\'un des cinq piliers de l\'Islam.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_5', question: 'Combien y a-t-il de piliers de l\'Islam ?', options: ['3', '4', '5', '6'], correctAnswerIndex: 2, explanation: 'Il y a 5 piliers de l\'Islam : la Chahada, la Salat, la Zakat, le Siyam (jeûne) et le Hajj.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_6', question: 'Comment s\'appelle la profession de foi en Islam ?', options: ['Salat', 'Chahada', 'Zakat', 'Hajj'], correctAnswerIndex: 1, explanation: 'La Chahada est le credo islamique déclarant qu\'il n\'y a de dieu qu\'Allah et que Muhammad est Son messager.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_7', question: 'Dans quelle direction les musulmans se tournent-ils pour prier ?', options: ['Est', 'Ouest', 'Nord', 'Vers La Mecque (Qibla)'], correctAnswerIndex: 3, explanation: 'Les musulmans font face à la Kaaba à La Mecque pendant la prière, une direction appelée Qibla.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_8', question: 'Qui a construit la Kaaba ?', options: ['Prophète Moussa', 'Prophète Ibrahim et Ismail', 'Prophète Muhammad', 'Prophète Souleymane'], correctAnswerIndex: 1, explanation: 'Selon la tradition islamique, le Prophète Ibrahim et son fils Ismail ont construit la Kaaba.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_9', question: 'Comment appelle-t-on l\'aumône obligatoire en Islam ?', options: ['Siyam', 'Zakat', 'Hajj', 'Tawaf'], correctAnswerIndex: 1, explanation: 'La Zakat est l\'aumône obligatoire qui constitue l\'un des cinq piliers de l\'Islam.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_10', question: 'Combien de chapitres compte le Coran ?', options: ['100', '110', '114', '120'], correctAnswerIndex: 2, explanation: 'Le Coran compte 114 chapitres (Sourates) contenant chacun un ou plusieurs versets (Ayats).', difficulty: 'easy'),
      QuizQuestion(id: 'easy_11', question: 'Sur quoi est basé le calendrier islamique ?', options: ['L\'année solaire', 'L\'année lunaire', 'Solaire et lunaire', 'Les saisons'], correctAnswerIndex: 1, explanation: 'Le calendrier islamique est basé sur l\'année lunaire, également connu sous le nom de calendrier Hégirien.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_12', question: 'Combien de jours compte le Ramadan ?', options: ['25 jours', '28 jours', '29-30 jours', '35 jours'], correctAnswerIndex: 2, explanation: 'Le Ramadan dure 29 ou 30 jours selon l\'observation lunaire du mois.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_13', question: 'Que signifie "Islam" ?', options: ['La paix uniquement', 'La soumission à Dieu', 'La prière', 'La croyance'], correctAnswerIndex: 1, explanation: 'Islam signifie la soumission à la volonté d\'Allah et dérive du mot arabe pour la paix et la soumission.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_14', question: 'Qui fut le premier Prophète en Islam ?', options: ['Muhammad', 'Ibrahim', 'Adam', 'Moussa'], correctAnswerIndex: 2, explanation: 'Le Prophète Adam fut le premier humain et le premier Prophète envoyé par Allah.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_15', question: 'Quelle est la salutation islamique ?', options: ['Bonjour', 'As-salamu alaikum', 'Bienvenue', 'Salut'], correctAnswerIndex: 1, explanation: 'As-salamu alaikum (Que la paix soit sur vous) est la salutation islamique, et la réponse est wa alaikum assalam.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_16', question: 'Combien de Prophètes sont explicitement mentionnés dans le Coran ?', options: ['19', '25', '31', '50'], correctAnswerIndex: 1, explanation: '25 prophètes sont nommés dans le Coran, dont Adam, Ibrahim, Moussa, Issa et Muhammad.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_17', question: 'Quelle est la première Sourate du Coran ?', options: ['Sourate Al-Baqarah', 'Sourate Al-Fatiha', 'Sourate An-Nas', 'Sourate Al-Ikhlas'], correctAnswerIndex: 1, explanation: 'La Sourate Al-Fatiha (L\'Ouverture) est le premier chapitre du Coran et est récitée à chaque prière.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_18', question: 'Dans quelle ville est né le Prophète Muhammad ?', options: ['Médine', 'La Mecque', 'Jérusalem', 'Bagdad'], correctAnswerIndex: 1, explanation: 'Le Prophète Muhammad est né à La Mecque (Makkah) en l\'an 570 È.C.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_19', question: 'Qu\'est-ce qui est interdit de manger en Islam ?', options: ['Les légumes', 'Le porc', 'Le poisson', 'Les fruits'], correctAnswerIndex: 1, explanation: 'Le porc et certaines autres viandes sont interdits (Haram) en Islam comme mentionné dans le Coran.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_20', question: 'En quelle année le Prophète Muhammad a-t-il émigré à Médine ?', options: ['610 È.C.', '622 È.C.', '632 È.C.', '650 È.C.'], correctAnswerIndex: 1, explanation: 'L\'Hégire (migration) a eu lieu en 622 È.C., marquant le début du calendrier islamique.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_21', question: 'Combien de fois les musulmans tournent-ils autour de la Kaaba pendant le Hajj ?', options: ['3 fois', '5 fois', '7 fois', '10 fois'], correctAnswerIndex: 2, explanation: 'Les musulmans accomplissent la circumambulation (Tawaf) de la Kaaba 7 fois comme rituel du Hajj.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_22', question: 'Comment appelle-t-on le système juridique islamique ?', options: ['La Charia', 'Les Hadiths', 'Le Fiqh', 'L\'Ijma'], correctAnswerIndex: 0, explanation: 'La Charia (loi islamique) est le cadre juridique basé sur le Coran et la Sunnah.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_23', question: 'Qui a compilé le premier Coran écrit ?', options: ['Abou Bakr', 'Omar', 'Othman', 'Ali'], correctAnswerIndex: 2, explanation: 'Le Calife Othman a organisé la compilation du Coran standardisé pendant son règne.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_24', question: 'Que signifie le mot Hadith ?', options: ['Récitation', 'Histoires des prophètes', 'Paroles et actions du Prophète Muhammad', 'Jurisprudence'], correctAnswerIndex: 2, explanation: 'Le Hadith fait référence aux paroles, actions et approbations enregistrées du Prophète Muhammad.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_25', question: 'Combien de fois le Takbir (Allahu Akbar) est-il récité quotidiennement ?', options: ['5 fois', '10 fois', 'Au moins 10 fois', 'Plusieurs fois par jour'], correctAnswerIndex: 3, explanation: 'Le Takbir est récité de multiples fois chaque jour dans les prières et d\'autres pratiques islamiques.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_26', question: 'Comment s\'appelle le repas pris avant l\'aube pendant le Ramadan ?', options: ['Souhour', 'Iftar', 'Tarawih', 'Qiyam'], correctAnswerIndex: 0, explanation: 'Le Souhour est le repas pris avant l\'aube avant de commencer le jeûne à l\'heure du Fajr.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_27', question: 'Comment appelle-t-on la rupture du jeûne au coucher du soleil ?', options: ['Souhour', 'Iftar', 'Tahajjud', 'Witr'], correctAnswerIndex: 1, explanation: 'L\'Iftar est le repas pris au coucher du soleil pour rompre le jeûne pendant le Ramadan.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_28', question: 'Combien de fois un musulman fait-il ses ablutions (Woudou) par jour ?', options: ['Une fois', 'Deux fois', 'Varie - avant chaque prière', '5 fois seulement'], correctAnswerIndex: 2, explanation: 'Les ablutions sont effectuées avant chaque prière, donc le nombre varie selon les horaires de prière.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_29', question: 'Comment appelle-t-on la prière nocturne pendant le Ramadan ?', options: ['Salat Al-Layl', 'Tarawih', 'Qiyam Al-Layl', 'Tahajjud'], correctAnswerIndex: 1, explanation: 'Les Tarawih sont des prières spéciales effectuées pendant les nuits de Ramadan après la prière de l\'Icha.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_30', question: 'Quelle prière est la plus longue ?', options: ['Fajr', 'Dhohr', 'Asr', 'Maghrib'], correctAnswerIndex: 1, explanation: 'Le Dhohr (prière de la mi-journée) est généralement considéré comme la prière la plus longue de la journée.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_31', question: 'Combien y a-t-il de Rakat (unités) dans la prière du Dhohr ?', options: ['2', '3', '4', '5'], correctAnswerIndex: 2, explanation: 'La prière du Dhohr se compose de 4 Rakat (unités) dans sa forme obligatoire.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_32', question: 'Comment appelle-t-on le témoignage de foi en arabe ?', options: ['Takbir', 'Chahada', 'Tasbih', 'Tahlil'], correctAnswerIndex: 1, explanation: 'La Chahada est la déclaration de foi islamique témoignant de l\'unicité d\'Allah.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_33', question: 'Quel mois est considéré comme le meilleur pour les prières supplémentaires ?', options: ['Shawwal', 'Ramadan', 'Muharram', 'Rajab'], correctAnswerIndex: 1, explanation: 'Le Ramadan est le mois le plus sacré du calendrier islamique, où les bonnes actions sont multipliées.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_34', question: 'Comment appelle-t-on la taxe obligatoire en Islam ?', options: ['Zakat', 'Kharaj', 'Tawaf', 'Sadaqah'], correctAnswerIndex: 0, explanation: 'La Zakat est l\'aumône obligatoire due sur les richesses.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_35', question: 'Combien de côtés possède la Kaaba ?', options: ['2', '3', '4', '6'], correctAnswerIndex: 2, explanation: 'La Kaaba est un bâtiment en forme de cube à 4 côtés, situé à La Mecque.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_36', question: 'Qu\'est-ce que la Sadaqah en Islam ?', options: ['Charité obligatoire', 'Charité volontaire', 'Taxe', 'Punition'], correctAnswerIndex: 1, explanation: 'La Sadaqah est une charité volontaire donnée dans l\'intention d\'aider les autres et de plaire à Allah.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_37', question: 'Qui est la mère du Prophète Muhammad ?', options: ['Aminah', 'Halimah', 'Khadijah', 'Aicha'], correctAnswerIndex: 0, explanation: 'Aminah bint Wahb était la mère biologique du Prophète Muhammad.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_38', question: 'Sous quel autre nom connaît-on le calendrier islamique ?', options: ['Calendrier Solaire', 'Calendrier Hégirien', 'Calendrier Grégorien', 'Calendrier Julien'], correctAnswerIndex: 1, explanation: 'Le calendrier islamique est aussi appelé calendrier Hégirien, d\'après l\'Hégire (migration).', difficulty: 'easy'),
      QuizQuestion(id: 'easy_39', question: 'Combien de versets le Coran contient-il environ ?', options: ['3000', '6000', '9000', '12000'], correctAnswerIndex: 1, explanation: 'Le Coran contient environ 6 236 versets répartis dans 114 chapitres.', difficulty: 'easy'),
      QuizQuestion(id: 'easy_40', question: 'Que signifie "Bismillah" ?', options: ['Gloire à Allah', 'Au nom d\'Allah', 'Allah est grand', 'Louange à Allah'], correctAnswerIndex: 1, explanation: 'Bismillah signifie "Au nom d\'Allah" et est récité avant de commencer toute action.', difficulty: 'easy'),
    ];
  }

  // --- FRENCH: MEDIUM ---
  List<QuizQuestion> _getMediumQuestionsFr() {
    return [
      QuizQuestion(id: 'mid_1', question: 'Qu\'est-ce que la Sunnah ?', options: ['Les enseignements d\'autres religions', 'Les pratiques et traditions du Prophète Muhammad', 'Rituels de pèlerinage', 'Codes juridiques islamiques'], correctAnswerIndex: 1, explanation: 'La Sunnah désigne les traditions et pratiques du Prophète Muhammad qui servent de modèle.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_2', question: 'Qui fut le premier Calife musulman ?', options: ['Omar ibn Al-Khattab', 'Abou Bakr', 'Othman ibn Affan', 'Ali ibn Abi Talib'], correctAnswerIndex: 1, explanation: 'Abou Bakr (As-Siddiq) fut le premier Calife après le Prophète Muhammad (632-634 È.C.).', difficulty: 'medium'),
      QuizQuestion(id: 'mid_3', question: 'Qu\'est-ce que le Fiqh dans la jurisprudence islamique ?', options: ['La mémorisation du Coran', 'La compréhension et l\'interprétation de la loi islamique', 'Les traditions narratives', 'Les expressions poétiques'], correctAnswerIndex: 1, explanation: 'Le Fiqh est la branche de la connaissance islamique traitant de la compréhension et de l\'application de la Charia.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_4', question: 'Qu\'est-ce que l\'Ijma en droit islamique ?', options: ['L\'opinion personnelle', 'Le consensus des savants islamiques', 'Les versets coraniques', 'Les traditions uniquement'], correctAnswerIndex: 1, explanation: 'L\'Ijma est le consensus des savants islamiques sur une question particulière et est une source de droit.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_5', question: 'Combien de compagnons sont connus sous le nom de "Califes Bien Guidés" ?', options: ['2', '3', '4', '5'], correctAnswerIndex: 2, explanation: 'Les quatre Califes Bien Guidés sont Abou Bakr, Omar, Othman et Ali, ayant régné de 632 à 661 È.C.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_6', question: 'Comment appelle-t-on la Nuit du Destin en arabe ?', options: ['Laylat Al-Qadr', 'Laylat Al-Jinn', 'Laylat Al-Isra', 'Laylat Al-Baraa'], correctAnswerIndex: 0, explanation: 'Laylat Al-Qadr (La Nuit du Destin) est la nuit où le Coran fut révélé pour la première fois.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_7', question: 'Quelle Sourate mentionne la Nuit du Destin ?', options: ['Sourate Al-Alaq', 'Sourate Al-Qadr', 'Sourate Ar-Rahman', 'Sourate Al-Adiyat'], correctAnswerIndex: 1, explanation: 'La Sourate Al-Qadr (Chapitre 97) est entièrement consacrée à la description de la Nuit du Destin.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_8', question: 'Qu\'est-ce que le Qiyyas dans la jurisprudence islamique ?', options: ['La mesure', 'Le raisonnement par analogie', 'Le rapport', 'Le questionnement'], correctAnswerIndex: 1, explanation: 'Le Qiyyas est la méthode pour déduire des règles islamiques en faisant des analogies avec des cas similaires.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_9', question: 'Combien de scribes de la révélation le Prophète Muhammad avait-il ?', options: ['3', '5', '15-20', 'Plus de 40'], correctAnswerIndex: 3, explanation: 'Le Prophète Muhammad avait plus de 40 scribes qui ont enregistré les révélations coraniques.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_10', question: 'Que signifie le Hijab dans le contexte islamique ?', options: ['Seulement un foulard', 'La pudeur et un vêtement modeste couvrant pour hommes et femmes', 'Uniquement un paravent', 'Une interdiction religieuse'], correctAnswerIndex: 1, explanation: 'Le Hijab représente la pudeur et ne se limite pas aux vêtements féminins, mais s\'applique aux deux sexes.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_11', question: 'Qu\'est-ce que l\'Isra et le Mi\'raj ?', options: ['Deux voyages différents', 'Le voyage nocturne du Prophète vers Jérusalem et son ascension au ciel', 'Deux Sourates du Coran', 'Deux noms de la Kaaba'], correctAnswerIndex: 1, explanation: 'L\'Isra est le voyage nocturne vers Jérusalem, et le Mi\'raj est l\'ascension vers les cieux.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_12', question: 'Quelle Sourate contient le Verset du Trône (Ayat Al-Kursi) ?', options: ['Sourate Al-Baqarah', 'Sourate Aal-Imran', 'Sourate An-Noor', 'Sourate Ya-Seen'], correctAnswerIndex: 0, explanation: 'L\'Ayat Al-Kursi se trouve dans la Sourate Al-Baqarah (2:255) et est l\'un des versets les plus importants.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_13', question: 'Quelle est la Sourate la plus courte du Coran ?', options: ['Sourate Al-Ikhlas', 'Sourate An-Nas', 'Sourate Al-Kawthar', 'Sourate Al-Fil'], correctAnswerIndex: 2, explanation: 'La Sourate Al-Kawthar (Chapitre 108) est la plus courte avec seulement 3 versets.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_14', question: 'Combien de noms différents (Asma) d\'Allah sont mentionnés dans le Coran ?', options: ['50', '99', '150', '200'], correctAnswerIndex: 1, explanation: 'Bien que de nombreux noms d\'Allah apparaissent, 99 sont particulièrement soulignés dans la tradition.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_15', question: 'Qu\'est-ce que la Bataille de Badr ?', options: ['Un lieu à Médine', 'La première bataille majeure entre les Musulmans et les Qurayshites', 'Une route commerciale', 'Un puits d\'eau'], correctAnswerIndex: 1, explanation: 'La Bataille de Badr (2 AH/624 È.C.) fut le premier affrontement militaire majeur.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_16', question: 'Que signifie "Oumma" ?', options: ['Mère', 'Nation ou communauté', 'Grand-mère', 'Tribu'], correctAnswerIndex: 1, explanation: 'L\'Oumma désigne la communauté musulmane mondiale unie par la foi en l\'Islam.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_17', question: 'Quels sont les six articles de la croyance islamique ?', options: ['Allah, Coran, Prière, Jeûne, Zakat, Hajj', 'Croyance en Allah, aux Anges, aux Livres, aux Prophètes, au Jour du Jugement et au Décret Divin', 'Uniquement les Cinq Piliers', 'Uniquement les noms d\'Allah'], correctAnswerIndex: 1, explanation: 'Les Six Articles de Foi forment le fondement de la croyance islamique.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_18', question: 'Qui était la première femme du Prophète Ibrahim ?', options: ['Sarah', 'Hagar', 'Keturah', 'Léa'], correctAnswerIndex: 0, explanation: 'Sarah (Sara) était la première femme du Prophète Ibrahim et la mère du Prophète Ishaq.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_19', question: 'Pour quoi le mois islamique de Muharram est-il connu ?', options: ['Mois de jeûne', 'Mois de pèlerinage', 'Mois sacré contenant Achoura', 'Mois de batailles'], correctAnswerIndex: 2, explanation: 'Muharram est le premier mois de l\'année islamique et est sacré. Le 10ème jour est Achoura.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_20', question: 'Qu\'est-ce que la Zakat Al-Fitr ?', options: ['Taxe foncière', 'Charité donnée à la fin du Ramadan avant la prière de l\'Aïd', 'Charité mensuelle', 'Charité pour les pauvres uniquement'], correctAnswerIndex: 1, explanation: 'La Zakat Al-Fitr est une charité spécifique donnée avant l\'Aïd Al-Fitr.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_21', question: 'Combien de piliers possède le Trône d\'Allah ?', options: ['2', '4', '8', 'Non spécifié dans le Coran'], correctAnswerIndex: 2, explanation: 'Selon la tradition islamique (et le Coran), huit anges portent le Trône d\'Allah.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_22', question: 'Quel est le nom de l\'ange qui a transmis la révélation du Coran ?', options: ['Gabriel (Jibril)', 'Michaël (Mikhaïl)', 'Israfil', 'Malik'], correctAnswerIndex: 0, explanation: 'L\'Ange Gabriel (Jibril) est l\'ange qui a apporté la révélation coranique au Prophète Muhammad.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_23', question: 'Quelle est la première action jugée le Jour du Jugement ?', options: ['La croyance', 'La prière', 'La charité', 'La gentillesse'], correctAnswerIndex: 1, explanation: 'Selon le hadith, la prière est la première action à être jugée le Jour du Jugement.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_24', question: 'Combien de fois l\'expression "Ya Ayouha" (Ô vous) apparaît-elle dans le Coran ?', options: ['50', '100', '165', '200'], correctAnswerIndex: 2, explanation: 'L\'expression "Ya Ayouha" apparaît 165 fois dans le Coran, s\'adressant souvent aux croyants.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_25', question: 'Quelle est la salutation islamique à la vue du croissant de lune ?', options: ['Allahu Akbar', 'Alhamdulillah', 'L\'invocation varie selon les régions', 'Pas de salutation spécifique'], correctAnswerIndex: 2, explanation: 'Bien que "Alhamdulillah" soit courant, il existe des invocations spécifiques qui varient culturellement.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_26', question: 'Combien de fois le Prophète Muhammad a-t-il accompli le Hajj ?', options: ['Une fois', 'Deux fois', 'Trois fois', 'Cinq fois'], correctAnswerIndex: 0, explanation: 'Le Prophète Muhammad n\'a accompli le Hajj qu\'une seule fois en 10 AH/632 È.C. (Pèlerinage d\'Adieu).', difficulty: 'medium'),
      QuizQuestion(id: 'mid_27', question: 'Qu\'est-ce que l\'Istikhara ?', options: ['Rituel de jeûne', 'Prière de consultation pour chercher l\'aide d\'Allah lors d\'une décision', 'Rituel de pèlerinage', 'Salutation'], correctAnswerIndex: 1, explanation: 'L\'Istikhara est une prière pour chercher la guidance divine lors de décisions importantes de la vie.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_28', question: 'Qui sont les anges gardiens de chaque personne ?', options: ['Gabriel', 'Michaël', 'Kiraman Katibin', 'Malik'], correctAnswerIndex: 2, explanation: 'Les Kiraman Katibin sont les nobles anges qui enregistrent toutes nos actions, bonnes et mauvaises.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_29', question: 'Comment appelle-t-on le châtiment dans la tombe ?', options: ['Adhab Al-Qabr', 'Jahim', 'Saqar', 'Laza'], correctAnswerIndex: 0, explanation: 'Adhab Al-Qabr fait référence au châtiment dans la tombe, un concept mentionné dans l\'Islam.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_30', question: 'Combien de versets compte la Sourate Al-Baqarah ?', options: ['100', '200', '286', '300'], correctAnswerIndex: 2, explanation: 'La Sourate Al-Baqarah (Chapitre 2) compte 286 versets et est le chapitre le plus long du Coran.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_31', question: 'Que signifie "Sadaqah Jariyah" ?', options: ['Charité ponctuelle', 'Charité continue dont les bienfaits se poursuivent après la mort', 'Charité forcée', 'Charité de fête'], correctAnswerIndex: 1, explanation: 'La Sadaqah Jariyah est une charité continue, comme la construction d\'un puits ou d\'une école.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_32', question: 'Quelle femme compagnon du Prophète était connue pour son vaste savoir ?', options: ['Aicha', 'Fatima', 'Hafsa', 'Zaynab'], correctAnswerIndex: 0, explanation: 'Aicha bint Abou Bakr était connue pour sa vaste connaissance de l\'Islam.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_33', question: 'Comment le mois islamique du jeûne est-il orthographié en français ?', options: ['Ramada', 'Ramazan', 'Ramadan', 'Ramanah'], correctAnswerIndex: 2, explanation: 'Ramadan est l\'orthographe standard en français pour le neuvième mois islamique.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_34', question: 'Combien d\'archanges sont mentionnés par leur nom dans le Coran ?', options: ['2', '3', '4', '5'], correctAnswerIndex: 2, explanation: 'Quatre archanges sont nommés : Gabriel (Jibril), Michaël (Mikhaïl), Israfil et Malik.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_35', question: 'Quel est le concept du "Tawakkoul" en Islam ?', options: ['Prière', 'La confiance en Allah après avoir fait de son mieux', 'Jeûne', 'Charité'], correctAnswerIndex: 1, explanation: 'Le Tawakkoul est le concept islamique de confiance totale en Allah après avoir pris les mesures nécessaires.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_36', question: 'Combien de péchés majeurs y a-t-il en Islam ?', options: ['7', '12', 'Varie selon les savants', 'Indéfini'], correctAnswerIndex: 2, explanation: 'Bien qu\'il n\'y ait pas de liste fixe, les savants s\'accordent sur les grands péchés comme le Shirk ou le meurtre.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_37', question: 'Quel est le concept islamique de "Taqwa" ?', options: ['La peur uniquement', 'La piété et la conscience de Dieu', 'La prière', 'La charité'], correctAnswerIndex: 1, explanation: 'La Taqwa est le concept de conscience de Dieu et de piété, central dans le développement spirituel.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_38', question: 'Qui était le meilleur récitateur du Coran parmi les compagnons ?', options: ['Omar', 'Abou Moussa Al-Achari', 'Othman', 'Ali'], correctAnswerIndex: 1, explanation: 'Abou Moussa Al-Achari était connu pour sa belle voix et sa récitation exceptionnelle du Coran.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_39', question: 'Quelle est la signification du nombre 19 dans le Coran ?', options: ['Nombre de piliers', 'Nombre d\'archanges', 'Associé aux 19 gardiens de l\'Enfer', 'Nombre de prières'], correctAnswerIndex: 2, explanation: 'Le nombre 19 apparaît dans la Sourate Al-Mouddaththir concernant les gardiens de l\'Enfer.', difficulty: 'medium'),
      QuizQuestion(id: 'mid_40', question: 'Qu\'est-ce que la "Chahada Toul-Wilaya" ?', options: ['Témoignage de foi', 'Témoignage d\'allégeance à l\'Emir des Croyants', 'Témoignage de voyage', 'Témoignage de richesse'], correctAnswerIndex: 0, explanation: 'Bien que moins courant, ce terme fait référence à une extension du témoignage islamique concernant la loyauté.', difficulty: 'medium'),
    ];
  }

  // --- FRENCH: HARD ---
  List<QuizQuestion> _getHardQuestionsFr() {
    return [
      QuizQuestion(id: 'hard_1', question: 'Comment appelle-t-on l\'approche du Tafsir qui s\'appuie fortement sur les savants islamiques classiques ?', options: ['Tafsir Bil-Ma\'thour', 'Tafsir Bil-Ra\'y', 'Tafsir Bil-Ijma', 'Tafsir Bil-Ijtihad'], correctAnswerIndex: 0, explanation: 'Le Tafsir Bil-Ma\'thour est l\'exégèse basée sur les traditions transmises par le Prophète et ses compagnons.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_2', question: 'Quel miracle mathématique se trouve dans la Sourate An-Noor concernant le nombre 24 ?', options: ['Apparaît 24 fois', 'Contient 24 versets', 'Lié aux 24 heures de la journée', 'Mentionné avec des modèles mathématiques spécifiques'], correctAnswerIndex: 3, explanation: 'La Sourate An-Noor contient des modèles mathématiques liés au nombre 24 découverts par des savants modernes.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_3', question: 'Qu\'est-ce que le concept de "Naskh" dans la jurisprudence coranique ?', options: ['Copie', 'L\'abrogation des révélations antérieures par des révélations ultérieures', 'Narration', 'Spécification'], correctAnswerIndex: 1, explanation: 'Le Naskh fait référence à l\'abrogation des règles coraniques antérieures par des révélations plus tardives.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_4', question: 'Combien de fois le mot "Coran" est-il mentionné dans le Coran lui-même ?', options: ['20', '50', '70', '100'], correctAnswerIndex: 2, explanation: 'Le mot "Coran" apparaît environ 70 fois sous diverses formes tout au long du texte.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_5', question: 'Qu\'est-ce que le "Matn" dans la terminologie du Hadith ?', options: ['La chaîne de transmission', 'Le texte/corps du hadith', 'Le narrateur', 'Le sujet discuté'], correctAnswerIndex: 1, explanation: 'Le Matn fait référence au texte réel d\'un hadith, par opposition à l\'Isnad (chaîne de transmission).', difficulty: 'hard'),
      QuizQuestion(id: 'hard_6', question: 'Quelle Sourate contient le plus long verset du Coran ?', options: ['Sourate Al-Baqarah (Verset 282)', 'Sourate Aal-Imran', 'Sourate An-Nisa', 'Sourate An-Noor'], correctAnswerIndex: 0, explanation: 'Le verset 282 de la Sourate Al-Baqarah (le verset de la dette) est le plus long verset du Coran.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_7', question: 'Qu\'est-ce que l\'"Ijtihad" dans la jurisprudence islamique ?', options: ['Le suivi du consensus', 'Le raisonnement indépendant pour déduire des règles du Coran et de la Sunnah', 'La mémorisation du Coran', 'L\'enseignement du droit islamique'], correctAnswerIndex: 1, explanation: 'L\'Ijtihad est l\'effort de réflexion indépendant mené par des savants qualifiés pour déduire des règles.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_8', question: 'Combien de Sourates commencent par Alif-Lam-Mim ?', options: ['3', '4', '5', '6'], correctAnswerIndex: 2, explanation: 'Cinq Sourates commencent par Alif-Lam-Mim : Al-Baqarah, Aal-Imran, Al-Ankabut, Ar-Rum, et Luqman.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_9', question: 'Qu\'est-ce que la "Sunna d\'Allah" mentionnée dans le Coran ?', options: ['Les pratiques du Prophète Muhammad', 'Les lois et modèles immuables établis par Allah dans l\'univers', 'Les pratiques religieuses uniquement', 'Les routines quotidiennes'], correctAnswerIndex: 1, explanation: 'La Sunna d\'Allah fait référence aux modèles et lois immuables établis par Allah dans la création.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_10', question: 'Quel Prophète est le plus fréquemment mentionné dans le Coran ?', options: ['Muhammad', 'Ibrahim', 'Moussa', 'Issa'], correctAnswerIndex: 2, explanation: 'Le Prophète Moussa (Moïse) est mentionné plus fréquemment que tout autre prophète dans le Coran.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_11', question: 'Quelle est la différence entre "Haram" et "Makrouh" ?', options: ['Aucune différence', 'Haram est interdit, Makrouh est déconseillé mais permis', 'Makrouh est interdit, Haram est déconseillé', 'Les deux signifient la même chose'], correctAnswerIndex: 1, explanation: 'Haram est absolument interdit, tandis que Makrouh est déconseillé sans être strictement prohibé.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_12', question: 'Qu\'est-ce que le "Khilaf" dans la jurisprudence islamique ?', options: ['Le désaccord entre les savants', 'Le Califat', 'Le conflit entre les gens', 'La différence d\'horaires de prière'], correctAnswerIndex: 0, explanation: 'Le Khilaf désigne le désaccord académique (ikhtilaf) entre les savants sur des questions de droit.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_13', question: 'Quels versets du Coran racontent l\'histoire de l\'Éléphant (Fil) ?', options: ['Sourate Al-Fil', 'Sourate Al-Fil uniquement', 'Sourate Al-Lahab et Al-Fil', 'Plusieurs Sourates'], correctAnswerIndex: 1, explanation: 'L\'histoire de l\'Éléphant est racontée dans la Sourate Al-Fil (Chapitre 105).', difficulty: 'hard'),
      QuizQuestion(id: 'hard_14', question: 'Qu\'est-ce que le concept de "Darourah" (nécessité) en droit islamique ?', options: ['L\'urgence générale', 'L\'exception aux règles islamiques lorsque la nécessité l\'exige et sans autre alternative', 'La préférence personnelle', 'L\'absence temporaire'], correctAnswerIndex: 1, explanation: 'La Darourah est le principe selon lequel les interdictions peuvent être levées en cas de véritable nécessité.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_15', question: 'Combien de Sourates portent le nom d\'animaux ?', options: ['3', '4', '5', '6'], correctAnswerIndex: 2, explanation: 'Cinq Sourates : Al-Baqarah (Vache), Al-An\'am (Bestiaux), An-Nahl (Abeille), An-Naml (Fourmi), Al-Ankabut (Araignée). L\'Éléphant fait six avec Al-Fil, mais classiquement 5 grandes sourates de nom d\'animal sont citées selon l\'auteur.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_16', question: 'Qu\'est-ce que le "Tawatour" dans l\'étude du Hadith ?', options: ['Chaîne de narration unique', 'Corroboration mutuelle - narration rapportée par beaucoup de gens à différentes époques et lieux', 'Hadith faible', 'Hadith inventé'], correctAnswerIndex: 1, explanation: 'Le Tawatour est un hadith si largement rapporté qu\'il est impossible que tous les narrateurs aient comploté.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_17', question: 'Quelle Sourate est connue sous le nom de "Sourate des Croyants" ?', options: ['Sourate Al-Mou\'minoun', 'Sourate Al-An\'am', 'Sourate Al-Imaan', 'Sourate At-Tawbah'], correctAnswerIndex: 0, explanation: 'La Sourate Al-Mou\'minoun (Chapitre 23) se traduit par "Chapitre des Croyants".', difficulty: 'hard'),
      QuizQuestion(id: 'hard_18', question: 'Qu\'est-ce que le "Tawhid Ar-Rouboubiyyah" ?', options: ['Croyance aux prophètes', 'La croyance en la Seigneurie et l\'autorité Unique d\'Allah', 'Croyance aux écritures', 'Croyance au Jour du Jugement'], correctAnswerIndex: 1, explanation: 'Le Tawhid Ar-Rouboubiyyah est la croyance qu\'Allah est le seul créateur et maître de l\'univers.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_19', question: 'Combien de fois le mot "Paradis" (Jannah) est-il explicitement mentionné dans le Coran ?', options: ['30', '50', '77', '100'], correctAnswerIndex: 2, explanation: 'Le mot "Jannah" (Paradis) apparaît environ 77 fois dans le Coran.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_20', question: 'Qu\'est-ce que la "Sira Nabawiyya" ?', options: ['Le droit islamique uniquement', 'La biographie du Prophète Muhammad couvrant sa vie et ses enseignements', 'L\'interprétation coranique', 'Une collection de hadiths'], correctAnswerIndex: 1, explanation: 'La Sira Nabawiyya est la biographie complète de la vie du Prophète Muhammad.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_21', question: 'Qu\'est-ce que le "Moustalah Al-Hadith" ?', options: ['Une collection de hadiths', 'La science de la terminologie et de l\'authentification du Hadith', 'Les règles du Hadith', 'Les bases de l\'étude du Hadith'], correctAnswerIndex: 1, explanation: 'Le Moustalah Al-Hadith est la science utilisée pour évaluer l\'authenticité des hadiths.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_22', question: 'Quelle Sourate contient le plus grand nombre de règles juridiques ?', options: ['Sourate Al-Baqarah', 'Sourate An-Nisa', 'Sourate Al-Ma\'idah', 'Sourate At-Tawbah'], correctAnswerIndex: 2, explanation: 'La Sourate Al-Ma\'idah (Chapitre 5) contient les règles juridiques islamiques les plus complètes.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_23', question: 'Qu\'est-ce que la doctrine des "Koulliyat Al-Khams" (Les Cinq Objectifs) ?', options: ['Les Cinq Piliers', 'Les cinq prières', 'La préservation de la religion, la vie, l\'intellect, la propriété et la lignée', 'Les cinq compagnons'], correctAnswerIndex: 2, explanation: 'Les cinq objectifs de la Charia (Maqasid) sont de préserver : la religion, la vie, l\'intellect, les biens et la lignée.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_24', question: 'Combien de chapitres du Coran commencent sans le Bismillah ?', options: ['0', '1', '2', '5'], correctAnswerIndex: 1, explanation: 'Seule la Sourate At-Tawbah (Chapitre 9) commence sans la formule Bismillah.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_25', question: 'Qu\'est-ce que l\'"Ayah Al-Bourhan" dans la philosophie islamique ?', options: ['Les versets de preuve/d\'évidence dans le Coran', 'Les commandements religieux', 'Les versets d\'histoire', 'Les versets scientifiques'], correctAnswerIndex: 0, explanation: 'L\'Ayah Al-Bourhan désigne les versets qui servent de preuves ou d\'évidences claires.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_26', question: 'Quelle Sourate parle du plus grand nombre de prophètes en détail ?', options: ['Sourate Youssouf', 'Sourate Aal-Imran', 'Sourate As-Saffat', 'Sourate Al-Anbiya'], correctAnswerIndex: 3, explanation: 'La Sourate Al-Anbiya (Chapitre 21, "Les Prophètes") raconte l\'histoire de nombreux prophètes.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_27', question: 'Qu\'est-ce que l\'"Isnad" dans la terminologie du hadith ?', options: ['Le texte du hadith', 'La chaîne des narrateurs rapportant le hadith', 'Le sujet', 'L\'explication'], correctAnswerIndex: 1, explanation: 'L\'Isnad est la chaîne des narrateurs par laquelle un hadith est transmis.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_28', question: 'Qu\'est-ce que le "Tafsir Bil-Ijma" ?', options: ['L\'interprétation personnelle', 'L\'interprétation basée sur le consensus des savants islamiques', 'L\'interprétation métaphorique', 'L\'interprétation scientifique'], correctAnswerIndex: 1, explanation: 'Le Tafsir Bil-Ijma s\'appuie sur les interprétations convenues par de multiples savants.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_29', question: 'En combien de "Jouz" (parties) le Coran est-il divisé ?', options: ['20', '25', '30', '40'], correctAnswerIndex: 2, explanation: 'Le Coran est traditionnellement divisé en 30 parties égales appelées Jouz pour faciliter la récitation.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_30', question: 'Quel est le concept du "Tawhid Al-Oulouhiyyah" ?', options: ['Croyance aux prophètes', 'La croyance d\'adorer Allah seul, sans associés', 'Croyance aux écritures', 'Croyance aux anges'], correctAnswerIndex: 1, explanation: 'Le Tawhid Al-Oulouhiyyah est la croyance que seul Allah mérite l\'adoration.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_31', question: 'Quel savant a compilé le recueil de hadiths le plus authentique, connu sous le nom de "Sahih Al-Boukhari" ?', options: ['Mouslim ibn Al-Hajjaj', 'Muhammad Al-Boukhari', 'At-Tirmidhi', 'Abou Daoud'], correctAnswerIndex: 1, explanation: 'Muhammad Al-Boukhari a compilé le Sahih Al-Boukhari, le recueil de hadiths le plus authentique.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_32', question: 'Qu\'est-ce que la classification "Mecquoise vs Médinoise" dans les études coraniques ?', options: ['Des lieux géographiques uniquement', 'Une classification basée sur le moment de la révélation (avant/après l\'Hégire)', 'Un type de contenu', 'Une classification aléatoire'], correctAnswerIndex: 1, explanation: 'Les Sourates Mecquoises et Médinoises font référence aux révélations antérieures et postérieures à l\'Hégire.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_33', question: 'Sur quoi la "Charia" est-elle fondamentalement basée ?', options: ['Les coutumes culturelles', 'Les décisions politiques', 'Le Coran, la Sunnah, le raisonnement analogique (Qiyas) et le consensus (Ijma)', 'Les traditions historiques'], correctAnswerIndex: 2, explanation: 'La Charia repose sur quatre sources : le Coran, la Sunnah, l\'Ijma (consensus) et le Qiyas (analogie).', difficulty: 'hard'),
      QuizQuestion(id: 'hard_34', question: 'Combien de lettres l\'alphabet arabe compte-t-il traditionnellement ?', options: ['26', '28', '30', '32'], correctAnswerIndex: 1, explanation: 'L\'alphabet arabe compte traditionnellement 28 lettres dans l\'arabe classique.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_35', question: 'Qu\'est-ce que l\'approche "Fiqh Maqasid" ?', options: ['La jurisprudence traditionnelle', 'La jurisprudence basée sur les objectifs et desseins globaux de la Charia', 'L\'interprétation moderne', 'L\'interprétation littérale'], correctAnswerIndex: 1, explanation: 'Le Fiqh Maqasid examine les règles à la lumière des objectifs supérieurs (Maqasid) de la loi islamique.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_36', question: 'Quelle Sourate mentionne Dhou\'l-Qarnayn ?', options: ['Sourate Al-Kahf', 'Sourate Youssouf', 'Sourate Luqman', 'Sourate As-Saffat'], correctAnswerIndex: 0, explanation: 'La Sourate Al-Kahf (Chapitre 18) contient l\'histoire détaillée de Dhou\'l-Qarnayn.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_37', question: 'Qu\'est-ce que les "Ousoul Al-Fiqh" ?', options: ['La loi islamique elle-même', 'Les sources et la méthodologie de la jurisprudence islamique', 'Les recueils de hadiths', 'Les traditions prophétiques'], correctAnswerIndex: 1, explanation: 'Les Ousoul Al-Fiqh désignent la science des principes et de la méthodologie de la jurisprudence islamique.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_38', question: 'Combien de versets discutent de l\'interdiction de l\'intérêt (Riba) ?', options: ['2', '4', '6', '8'], correctAnswerIndex: 2, explanation: 'Plusieurs versets du Coran (environ 6) interdisent explicitement le Riba (l\'usure/l\'intérêt).', difficulty: 'hard'),
      QuizQuestion(id: 'hard_39', question: 'Qu\'est-ce qu\'un hadith "Moursal" ?', options: ['Un hadith authentifié', 'Un hadith dont la chaîne est brisée par l\'absence d\'un compagnon', 'Un hadith clair', 'Un hadith faible'], correctAnswerIndex: 1, explanation: 'Un hadith Moursal est celui dont la chaîne va directement d\'un Tabi\'i (successeur) au Prophète.', difficulty: 'hard'),
      QuizQuestion(id: 'hard_40', question: 'Quelle école de jurisprudence islamique compte le plus grand nombre de fidèles aujourd\'hui ?', options: ['Hanbalite', 'Malikite', 'Hanafite', 'Chaféite'], correctAnswerIndex: 2, explanation: 'L\'école Hanafite, fondée par l\'Imam Abou Hanifa, compte le plus grand nombre de fidèles au monde.', difficulty: 'hard'),
    ];
  }
}