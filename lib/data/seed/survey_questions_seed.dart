// lib/data/seed/survey_questions_seed.dart
class SurveyQuestionsSeedData {
  static List<Map<String, dynamic>> getQuestions() {
    return [
      // الأسئلة الخاصة بتحليل البشرة (1-6)
      {
        'questionNumber': 1,
        'section': 'skin_analysis',
        'questionText': 'In the middle of the day, place a tissue on your face for 10 seconds, what do you notice?',
        'arabicQuestionText': 'في منتصف اليوم، ضعي منديل ورقي على وجهك لمدة 10 ثوانٍ، ماذا تلاحظين؟',
        'questionType': 'single_choice',
        'options': [
          {
            'key': 'أ',
            'text': 'Tissue saturated with oils from entire face',
            'arabicText': 'المنديل مشبع بالزيوت من كامل الوجه',
            'weights': {'oily': 25, 'dry': 0, 'combination': 0, 'sensitive': 0, 'normal': 0}
          },
          {
            'key': 'ب',
            'text': 'Clear oils only on forehead and nose',
            'arabicText': 'زيوت واضحة فقط على الجبين والأنف',
            'weights': {'oily': 0, 'dry': 0, 'combination': 25, 'sensitive': 0, 'normal': 0}
          },
          {
            'key': 'ج',
            'text': 'Almost no oils present',
            'arabicText': 'لا توجد زيوت تقريباً',
            'weights': {'oily': 0, 'dry': 25, 'combination': 0, 'sensitive': 0, 'normal': 0}
          },
          {
            'key': 'د',
            'text': 'Very few oils in a balanced way',
            'arabicText': 'زيوت قليلة جداً بشكل متوازن',
            'weights': {'oily': 0, 'dry': 0, 'combination': 0, 'sensitive': 0, 'normal': 20}
          }
        ],
        'weights': {'skin_type_importance': 0.4, 'section_weight': 0.6},
        'isActive': true,
        'displayOrder': 1
      },

      {
        'questionNumber': 2,
        'section': 'skin_analysis',
        'questionText': 'In the morning when you wake up, how does your skin feel before washing it?',
        'arabicQuestionText': 'صباحاً عند الاستيقاظ، كيف تشعرين ببشرتك قبل غسلها؟',
        'questionType': 'single_choice',
        'options': [
          {
            'key': 'أ',
            'text': 'Tight and dry, needs immediate moisturizing',
            'arabicText': 'مشدودة وجافة تحتاج ترطيب فوري',
            'weights': {'oily': 0, 'dry': 20, 'combination': 0, 'sensitive': 0, 'normal': 0}
          },
          {
            'key': 'ب',
            'text': 'Sticky and oily with visible shine',
            'arabicText': 'لزجة ودهنية مع لمعان واضح',
            'weights': {'oily': 20, 'dry': 0, 'combination': 0, 'sensitive': 0, 'normal': 0}
          },
          {
            'key': 'ج',
            'text': 'Tight on cheeks, oily in the middle',
            'arabicText': 'مشدودة على الخدين، دهنية في المنتصف',
            'weights': {'oily': 0, 'dry': 0, 'combination': 20, 'sensitive': 0, 'normal': 0}
          },
          {
            'key': 'د',
            'text': 'Comfortable and balanced',
            'arabicText': 'مريحة ومتوازنة',
            'weights': {'oily': 0, 'dry': 0, 'combination': 0, 'sensitive': 0, 'normal': 15}
          },
          {
            'key': 'هـ',
            'text': 'Sensitive or reddish',
            'arabicText': 'حساسة أو محمرة',
            'weights': {'oily': 0, 'dry': 0, 'combination': 0, 'sensitive': 25, 'normal': 0}
          }
        ],
        'weights': {'skin_type_importance': 0.35, 'section_weight': 0.6},
        'isActive': true,
        'displayOrder': 2
      },

      {
        'questionNumber': 3,
        'section': 'skin_analysis',
        'questionText': 'Under good lighting, how do your facial pores appear?',
        'arabicQuestionText': 'تحت إضاءة قوية، كيف تبدو مسام بشرتك؟',
        'questionType': 'single_choice',
        'options': [
          {
            'key': 'أ',
            'text': 'Large and visible across entire face',
            'arabicText': 'كبيرة وواضحة على كامل الوجه',
            'weights': {'oily': 15, 'dry': 0, 'combination': 0, 'sensitive': 0, 'normal': 0}
          },
          {
            'key': 'ب',
            'text': 'Medium-sized only in T-zone',
            'arabicText': 'متوسطة الحجم في منطقة T فقط',
            'weights': {'oily': 0, 'dry': 0, 'combination': 15, 'sensitive': 0, 'normal': 0}
          },
          {
            'key': 'ج',
            'text': 'Small or barely visible',
            'arabicText': 'صغيرة أو غير مرئية تقريباً',
            'weights': {'oily': 0, 'dry': 15, 'combination': 0, 'sensitive': 0, 'normal': 0}
          },
          {
            'key': 'د',
            'text': 'Medium-sized evenly distributed',
            'arabicText': 'متوسطة الحجم ومتساوية التوزيع',
            'weights': {'oily': 0, 'dry': 0, 'combination': 0, 'sensitive': 0, 'normal': 10}
          },
          {
            'key': 'هـ',
            'text': 'Irregular with redness around them',
            'arabicText': 'غير منتظمة مع احمرار حولها',
            'weights': {'oily': 0, 'dry': 0, 'combination': 0, 'sensitive': 20, 'normal': 0}
          }
        ],
        'weights': {'skin_type_importance': 0.3, 'section_weight': 0.5},
        'isActive': true,
        'displayOrder': 3
      },

      {
        'questionNumber': 4,
        'section': 'skin_analysis',
        'questionText': 'When trying a new beauty product, what is your skin\'s usual reaction?',
        'arabicQuestionText': 'عند تجربة منتج تجميل جديد، ما رد فعل بشرتك عادة؟',
        'questionType': 'single_choice',
        'options': [
          {
            'key': 'أ',
            'text': 'Never reacts negatively, accepts everything',
            'arabicText': 'لا تتفاعل سلبياً أبداً، تتقبل كل شيء',
            'weights': {'oily': 0, 'dry': 0, 'combination': 0, 'sensitive': 0, 'normal': 10}
          },
          {
            'key': 'ب',
            'text': 'Sometimes develops pimples or blackheads',
            'arabicText': 'أحياناً تظهر حبوب أو رؤوس سوداء',
            'weights': {'oily': 15, 'dry': 0, 'combination': 0, 'sensitive': 0, 'normal': 0}
          },
          {
            'key': 'ج',
            'text': 'Gets irritated quickly with itching or redness',
            'arabicText': 'تتهيج بسرعة مع حكة أو احمرار',
            'weights': {'oily': 0, 'dry': 0, 'combination': 0, 'sensitive': 25, 'normal': 0}
          },
          {
            'key': 'د',
            'text': 'Needs time to adapt but without major issues',
            'arabicText': 'تحتاج وقت للتأقلم لكن بدون مشاكل كبيرة',
            'weights': {'oily': 0, 'dry': 0, 'combination': 0, 'sensitive': 0, 'normal': 5}
          },
          {
            'key': 'هـ',
            'text': 'Becomes flaky or more dry',
            'arabicText': 'تتقشر أو تجف أكثر',
            'weights': {'oily': 0, 'dry': 15, 'combination': 0, 'sensitive': 0, 'normal': 0}
          }
        ],
        'weights': {'skin_type_importance': 0.4, 'section_weight': 0.7},
        'isActive': true,
        'displayOrder': 4
      },

      {
        'questionNumber': 5,
        'section': 'skin_analysis',
        'questionText': 'How does your skin react to weather changes?',
        'arabicQuestionText': 'كيف تتأثر بشرتك بتغيرات الطقس؟',
        'questionType': 'single_choice',
        'options': [
          {
            'key': 'أ',
            'text': 'Becomes more oily and shiny in heat',
            'arabicText': 'تزداد دهنية ولمعاناً في الحر',
            'weights': {'oily': 20, 'dry': 0, 'combination': 0, 'sensitive': 0, 'normal': 0}
          },
          {
            'key': 'ب',
            'text': 'Becomes dry and flaky in cold',
            'arabicText': 'تجف وتتقشر في البرد',
            'weights': {'oily': 0, 'dry': 20, 'combination': 0, 'sensitive': 0, 'normal': 0}
          },
          {
            'key': 'ج',
            'text': 'Gets irritated by sun and wind with redness',
            'arabicText': 'تتهيج من الشمس والرياح مع احمرار',
            'weights': {'oily': 0, 'dry': 0, 'combination': 0, 'sensitive': 20, 'normal': 0}
          },
          {
            'key': 'د',
            'text': 'Remains relatively stable most of the time',
            'arabicText': 'مستقرة نسبياً في معظم الأوقات',
            'weights': {'oily': 0, 'dry': 0, 'combination': 0, 'sensitive': 0, 'normal': 15}
          },
          {
            'key': 'هـ',
            'text': 'Oily in summer, dry in winter',
            'arabicText': 'دهنية صيفاً، جافة شتاءً',
            'weights': {'oily': 0, 'dry': 0, 'combination': 20, 'sensitive': 0, 'normal': 0}
          }
        ],
        'weights': {'skin_type_importance': 0.3, 'section_weight': 0.5},
        'isActive': true,
        'displayOrder': 5
      },

      {
        'questionNumber': 6,
        'section': 'skin_analysis',
        'questionText': 'When touching your cheek gently, what is the feeling?',
        'arabicQuestionText': 'عند لمس خدك برفق، ما الإحساس؟',
        'questionType': 'single_choice',
        'options': [
          {
            'key': 'أ',
            'text': 'Naturally smooth and silky',
            'arabicText': 'ناعم ونعومة حريرية طبيعية',
            'weights': {'oily': 0, 'dry': 0, 'combination': 0, 'sensitive': 0, 'normal': 15}
          },
          {
            'key': 'ب',
            'text': 'Slightly rough with small bumps',
            'arabicText': 'خشن قليلاً مع نتوءات صغيرة',
            'weights': {'oily': 10, 'dry': 0, 'combination': 0, 'sensitive': 0, 'normal': 0}
          },
          {
            'key': 'ج',
            'text': 'Sticky or oily to touch',
            'arabicText': 'لزج أو زيتي الملمس',
            'weights': {'oily': 20, 'dry': 0, 'combination': 0, 'sensitive': 0, 'normal': 0}
          },
          {
            'key': 'د',
            'text': 'Dry and flaky',
            'arabicText': 'جاف ومتقشر',
            'weights': {'oily': 0, 'dry': 20, 'combination': 0, 'sensitive': 0, 'normal': 0}
          },
          {
            'key': 'هـ',
            'text': 'Smooth but thin and sensitive',
            'arabicText': 'ناعم لكن رقيق وحساس',
            'weights': {'oily': 0, 'dry': 0, 'combination': 0, 'sensitive': 15, 'normal': 0}
          }
        ],
        'weights': {'skin_type_importance': 0.25, 'section_weight': 0.4},
        'isActive': true,
        'displayOrder': 6
      },

      // الأسئلة الخاصة بالمشاكل (7-10)
      {
        'questionNumber': 7,
        'section': 'problems',
        'questionText': 'What is the most annoying problem you face with lipstick?',
        'arabicQuestionText': 'ما أكثر مشكلة تواجهينها مع أحمر الشفاه؟',
        'questionType': 'single_choice',
        'options': [
          {
            'key': 'أ',
            'text': 'Dries my lips and causes flaking',
            'arabicText': 'يجف شفتاي ويتقشر',
            'weights': {'drying': 3, 'smudging': 0, 'fading': 0, 'environmental': 0}
          },
          {
            'key': 'ب',
            'text': 'Smudges quickly on cup/food',
            'arabicText': 'يتلطخ بسرعة على الكوب/الطعام',
            'weights': {'drying': 0, 'smudging': 3, 'fading': 0, 'environmental': 0}
          },
          {
            'key': 'ج',
            'text': 'Color fades within hours',
            'arabicText': 'يبهت لونه خلال ساعات',
            'weights': {'drying': 0, 'smudging': 0, 'fading': 3, 'environmental': 0}
          },
          {
            'key': 'د',
            'text': 'Color doesn\'t show clearly',
            'arabicText': 'لا يظهر لونه واضحاً',
            'weights': {'drying': 0, 'smudging': 0, 'fading': 1, 'environmental': 0}
          },
          {
            'key': 'هـ',
            'text': 'No major problems',
            'arabicText': 'لا مشاكل كبيرة',
            'weights': {'drying': 0, 'smudging': 0, 'fading': 0, 'environmental': 0}
          }
        ],
        'weights': {'problem_importance': 0.8},
        'isActive': true,
        'displayOrder': 7
      },

      {
        'questionNumber': 8,
        'section': 'problems',
        'questionText': 'What is your main goal with mascara?',
        'arabicQuestionText': 'ما هدفك الأساسي من المسكرة؟',
        'questionType': 'single_choice',
        'options': [
          {
            'key': 'أ',
            'text': 'Thicken thin lashes',
            'arabicText': 'تكثيف الرموش الخفيفة',
            'weights': {'volume_needed': 3, 'length_needed': 0, 'drama_needed': 0}
          },
          {
            'key': 'ب',
            'text': 'Lengthen short lashes',
            'arabicText': 'إطالة الرموش القصيرة',
            'weights': {'volume_needed': 0, 'length_needed': 3, 'drama_needed': 0}
          },
          {
            'key': 'ج',
            'text': 'Dramatic volume for occasions',
            'arabicText': 'حجم درامي للمناسبات',
            'weights': {'volume_needed': 1, 'length_needed': 0, 'drama_needed': 3}
          },
          {
            'key': 'د',
            'text': 'Natural daily look',
            'arabicText': 'مظهر طبيعي يومي',
            'weights': {'volume_needed': 1, 'length_needed': 1, 'drama_needed': 0}
          },
          {
            'key': 'هـ',
            'text': 'I don\'t use mascara',
            'arabicText': 'لا أستخدم المسكرة',
            'weights': {'volume_needed': 0, 'length_needed': 0, 'drama_needed': 0}
          }
        ],
        'weights': {'mascara_preference': 0.7},
        'isActive': true,
        'displayOrder': 8
      },

      {
        'questionNumber': 9,
        'section': 'problems',
        'questionText': 'In which environment do you spend most of your day?',
        'arabicQuestionText': 'في أي بيئة تقضين معظم يومك؟',
        'questionType': 'single_choice',
        'options': [
          {
            'key': 'أ',
            'text': 'Air-conditioned office (dry environment)',
            'arabicText': 'مكتب مكيف (جو جاف)',
            'weights': {'environmental': 1, 'drying': 2, 'smudging': 0}
          },
          {
            'key': 'ب',
            'text': 'Outdoors frequently (sun/wind)',
            'arabicText': 'خارج المنزل كثيراً (شمس/رياح)',
            'weights': {'environmental': 3, 'drying': 1, 'smudging': 1}
          },
          {
            'key': 'ج',
            'text': 'Hot places (kitchen/workshops)',
            'arabicText': 'أماكن حارة (مطبخ/ورش)',
            'weights': {'environmental': 2, 'drying': 0, 'smudging': 2}
          },
          {
            'key': 'د',
            'text': 'Humid environment',
            'arabicText': 'بيئة رطبة',
            'weights': {'environmental': 1, 'drying': 0, 'smudging': 2}
          },
          {
            'key': 'هـ',
            'text': 'Varied environment',
            'arabicText': 'بيئة متنوعة',
            'weights': {'environmental': 1, 'drying': 1, 'smudging': 1}
          }
        ],
        'weights': {'environmental_factor': 0.6},
        'isActive': true,
        'displayOrder': 9
      },

      {
        'questionNumber': 10,
        'section': 'problems',
        'questionText': 'Which of these affects your skin condition?',
        'arabicQuestionText': 'أي من هذه يؤثر على حالة بشرتك؟',
        'questionType': 'single_choice',
        'options': [
          {
            'key': 'أ',
            'text': 'Lack of sleep and staying up late',
            'arabicText': 'قلة النوم والسهر',
            'weights': {'lifestyle': 2, 'stress': 1}
          },
          {
            'key': 'ب',
            'text': 'Stress and psychological pressure',
            'arabicText': 'التوتر والضغط النفسي',
            'weights': {'lifestyle': 1, 'stress': 3}
          },
          {
            'key': 'ج',
            'text': 'Menstrual cycle',
            'arabicText': 'الدورة الشهرية',
            'weights': {'hormonal': 3, 'sensitivity': 1}
          },
          {
            'key': 'د',
            'text': 'Diet',
            'arabicText': 'النظام الغذائي',
            'weights': {'lifestyle': 2, 'health': 1}
          },
          {
            'key': 'هـ',
            'text': 'No noticeable effect',
            'arabicText': 'لا تأثير واضح',
            'weights': {'stable': 1}
          }
        ],
        'weights': {'lifestyle_impact': 0.5},
        'isActive': true,
        'displayOrder': 10
      },

      // الأسئلة الخاصة بالتفضيلات (11-14)
      {
        'questionNumber': 11,
        'section': 'preferences',
        'questionText': 'What type of product do you need most today?',
        'arabicQuestionText': 'ما نوع المنتج الذي تحتاجينه أكثر اليوم؟',
        'questionType': 'single_choice',
        'options': [
          {
            'key': 'أ',
            'text': 'Lipstick for daily professional use',
            'arabicText': 'أحمر شفاه للاستخدام المهني اليومي',
            'weights': {'product_type': 'daily_lipstick', 'occasion': 'professional'}
          },
          {
            'key': 'ب',
            'text': 'Lipstick for evenings and parties',
            'arabicText': 'أحمر شفاه للسهرات والحفلات',
            'weights': {'product_type': 'evening_lipstick', 'occasion': 'evening'}
          },
          {
            'key': 'ج',
            'text': 'Mascara for natural thickening',
            'arabicText': 'مسكرة لتكثيف طبيعي',
            'weights': {'product_type': 'volume_mascara', 'effect': 'natural'}
          },
          {
            'key': 'د',
            'text': 'Dramatic mascara',
            'arabicText': 'مسكرة دراماتيكية',
            'weights': {'product_type': 'dramatic_mascara', 'effect': 'dramatic'}
          },

          {
            'key': 'ز',
            'text': 'Foundation for daily coverage',
            'arabicText': 'كريم أساس للتغطية اليومية',
            'weights': {'product_type': 'daily_foundation', 'coverage': 'natural'}
          },
          {
            'key': 'ح',
            'text': 'Matte foundation for oily skin',
            'arabicText': 'كريم أساس مطفي للبشرة الدهنية',
            'weights': {'product_type': 'matte_foundation', 'skin_concern': 'oily'}
          },
          {
            'key': 'ط',
            'text': 'Blush for natural glow',
            'arabicText': 'أحمر خدود للإشراقة الطبيعية',
            'weights': {'product_type': 'natural_blush', 'effect': 'glow'}
          },
          {
            'key': 'هـ',
            'text': 'Therapeutic lip balm',
            'arabicText': 'بلسم علاجي للشفاه',
            'weights': {'product_type': 'lip_balm', 'purpose': 'treatment'}
          },
          {
            'key': 'و',
            'text': 'Complete set',
            'arabicText': 'مجموعة متكاملة',
            'weights': {'product_type': 'all_products', 'variety': 'complete'}
          },
          {
            'key': 'ي',
            'text': 'Bronzer for contouring',
            'arabicText': 'برونزر للكونتور',
            'weights': {'product_type': 'contouring_bronzer', 'technique': 'contouring'}
          },
        ],
        'weights': {'product_preference': 0.9},
        'isActive': true,
        'displayOrder': 11
      },

      {
        'questionNumber': 12,
        'section': 'preferences',
        'questionText': 'What type of colors suits your personality?',
        'arabicQuestionText': 'ما نوع الألوان التي تناسب شخصيتك؟',
        'questionType': 'single_choice',
        'options': [
          {
            'key': 'أ',
            'text': 'Natural and neutral (nude, beige, light pink)',
            'arabicText': 'طبيعية ومحايدة (بيج، وردي فاتح)',
            'weights': {'color_preference': 'natural', 'intensity': 'low'}
          },
          {
            'key': 'ب',
            'text': 'Bold and strong (deep pink, red)',
            'arabicText': 'جريئة وقوية (وردي غامق، أحمر)',
            'weights': {'color_preference': 'bold', 'intensity': 'high'}
          },
          {
            'key': 'ج',
            'text': 'Varied according to mood',
            'arabicText': 'متنوعة حسب المزاج',
            'weights': {'color_preference': 'varied', 'flexibility': 'high'}
          },
          {
            'key': 'د',
            'text': 'Classic and timeless',
            'arabicText': 'كلاسيكية وخالدة',
            'weights': {'color_preference': 'classic', 'style': 'timeless'}
          }
        ],
        'weights': {'color_importance': 0.7},
        'isActive': true,
        'displayOrder': 12
      },

      {
        'questionNumber': 13,
        'section': 'preferences',
        'questionText': 'What is most important to you in lipstick?',
        'arabicQuestionText': 'ما الأهم بالنسبة لك في أحمر الشفاه؟',
        'questionType': 'single_choice',
        'options': [
          {
            'key': 'أ',
            'text': 'Very long lasting even if slightly dry (8+ hours)',
            'arabicText': 'ثبات طويل جداً حتى لو كان جافاً قليلاً (8+ ساعات)',
            'weights': {'priority': 'long_lasting', 'durability': 'high'}
          },
          {
            'key': 'ب',
            'text': 'High hydration and comfortable creamy texture',
            'arabicText': 'ترطيب عالي وملمس كريمي مريح',
            'weights': {'priority': 'moisturizing', 'comfort': 'high'}
          },
          {
            'key': 'ج',
            'text': 'Shine and attractive gloss for the look',
            'arabicText': 'لمعان وبريق جذاب للإطلالة',
            'weights': {'priority': 'glossy', 'finish': 'shiny'}
          },
          {
            'key': 'د',
            'text': 'Balance between durability and comfort',
            'arabicText': 'توازن بين الثبات والراحة',
            'weights': {'priority': 'balanced', 'approach': 'moderate'}
          },
          {
            'key': 'هـ',
            'text': 'Easy application and removal',
            'arabicText': 'سهولة التطبيق والإزالة',
            'weights': {'priority': 'easy_application', 'convenience': 'high'}
          }
        ],
        'weights': {'texture_importance': 0.8},
        'isActive': true,
        'displayOrder': 13
      },

      {
        'questionNumber': 14,
        'section': 'preferences',
        'questionText': 'When will you use this product most?',
        'arabicQuestionText': 'متى ستستخدمين هذا المنتج أكثر؟',
        'questionType': 'single_choice',
        'options': [
          {
            'key': 'أ',
            'text': 'Work and formal occasions daily',
            'arabicText': 'العمل والمناسبات الرسمية يومياً',
            'weights': {'occasion': 'professional', 'frequency': 'daily'}
          },
          {
            'key': 'ب',
            'text': 'Outings and evenings with friends',
            'arabicText': 'الخروجات والسهرات مع الأصدقاء',
            'weights': {'occasion': 'social', 'frequency': 'weekly'}
          },
          {
            'key': 'ج',
            'text': 'Special occasions and weddings',
            'arabicText': 'المناسبات الخاصة والأعراس',
            'weights': {'occasion': 'special_events', 'frequency': 'occasional'}
          },
          {
            'key': 'د',
            'text': 'Simple daily use',
            'arabicText': 'الاستخدام اليومي البسيط',
            'weights': {'occasion': 'daily', 'frequency': 'daily'}
          },
          {
            'key': 'هـ',
            'text': 'Night care and moisturizing',
            'arabicText': 'العناية الليلية والترطيب',
            'weights': {'occasion': 'night_care', 'purpose': 'treatment'}
          }
        ],
        'weights': {'occasion_importance': 0.6},
        'isActive': true,
        'displayOrder': 14
      }
    ];
  }
}
