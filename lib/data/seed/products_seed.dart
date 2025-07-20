// lib/data/seed/products_seed.dart
class ProductsSeedData {
  static List<Map<String, dynamic>> getProducts() {
    return [
      // أحمر الشفاه المطفي من لوريال
      {
        'name': "L'Oréal Color Riche Matte Lipstick",
        'arabicName': "أحمر شفاه لوريال كولور ريتش مات",
        'description': "Creamy matte lipstick enriched with colors and hydration. Covers lips with a smooth layer that lasts for hours, provides saturated color without drying the lips. Contains Vitamin E and Jojoba oil for moisturizing and protecting lips.",
        'arabicDescription': "حمرة شفاه كريمية بتركيبة مطفية غنية بالألوان والترطيب. تغطي الشفاه بطبقة ناعمة تدوم لساعات، تمنح لونًا مشبعًا دون تجفيف الشفاه. تحتوي على فيتامين E وزيت الجوجوبا لترطيب وحماية الشفاه.",
        'category': 'lipstick',
        'brand': "L'Oréal",
        'price': 75.0,
        'images': [
          'https://images.unsplash.com/photo-1586495777744-4413f21062fa?w=400',
          'https://images.unsplash.com/photo-1631214540242-3b0a9e61fa5c?w=400'
        ],
        'colors': [
          {
            'name': 'Nude Beige',
            'arabicName': 'بيج',
            'hexCode': '#D2B48C',
            'isAvailable': true
          },
          {
            'name': 'Soft Pink',
            'arabicName': 'وردي كاشف',
            'hexCode': '#FFB6C1',
            'isAvailable': true
          },
          {
            'name': 'Deep Rose',
            'arabicName': 'وردي غامق',
            'hexCode': '#C71585',
            'isAvailable': true
          }
        ],
        'skinTypes': ['oily', 'combination', 'normal'],
        'suitableFor': {
          'oily': 90,
          'dry': 80,
          'combination': 95,
          'sensitive': 85,
          'normal': 90
        },
        'features': ['long_lasting', 'moisturizing', 'vitamin_e', 'jojoba_oil'],
        'ingredients': 'فيتامين E، زيت الجوجوبا، أصباغ طبيعية، شمع طبيعي',
        'usage': 'يطبق مباشرة على الشفاه النظيفة. للثبات الأطول، استخدمي مرطب شفاه قبل التطبيق بـ 5 دقائق.',
        'benefits': ['ترطيب طويل الأمد', 'لون مشبع', 'حماية من التشقق', 'ملمس ناعم'],
        'problems_solved': ['dry_lips', 'color_fading', 'cracking'],
        'occasion': ['daily', 'professional', 'casual'],
        'finish': 'matte',
        'isActive': true,
        'stockStatus': 'in_stock',
        'rating': 4.5,
        'reviewsCount': 127
      },

      // أحمر الشفاه السائل المطفي
      {
        'name': "L'Oréal Infallible Pro-Matte Liquid Lipstick",
        'arabicName': "أحمر شفاه لوريال إنفاليبل برو مات السائل",
        'description': "Long-lasting liquid lipstick with completely matte formula. Adheres well to lips and provides rich, stable color that lasts for hours with smudge resistance.",
        'arabicDescription': "حمرة شفاه سائلة طويلة الثبات بتركيبة مطفية تماما. تلتصق جيدًا بالشفاه وتمنح لونًا غنيًا وثابتًا يدوم لساعات مع مقاومة التلطخ.",
        'category': 'lipstick',
        'brand': "L'Oréal",
        'price': 85.0,
        'images': [
          'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?w=400',
          'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=400'
        ],
        'colors': [
          {
            'name': 'Classic Beige',
            'arabicName': 'بيج كلاسيكي',
            'hexCode': '#D2B48C',
            'isAvailable': true
          },
          {
            'name': 'Rose Pink',
            'arabicName': 'وردي كاشف',
            'hexCode': '#FFB6C1',
            'isAvailable': true
          },
          {
            'name': 'Bold Rose',
            'arabicName': 'وردي غامق',
            'hexCode': '#C71585',
            'isAvailable': true
          }
        ],
        'skinTypes': ['oily', 'combination'],
        'suitableFor': {
          'oily': 95,
          'dry': 65,
          'combination': 90,
          'sensitive': 70,
          'normal': 85
        },
        'features': ['ultra_long_lasting', 'smudge_proof', 'transfer_resistant'],
        'ingredients': 'بوليمرات طويلة الثبات، أصباغ مقاومة للماء، مواد مثبتة',
        'usage': 'يطبق بطبقة رقيقة على الشفاه النظيفة. تجنبي فرك الشفاه بعد التطبيق لمدة دقيقتين.',
        'benefits': ['ثبات 8+ ساعات', 'مقاومة التلطخ', 'لون غني', 'مقاوم للماء'],
        'problems_solved': ['smudging', 'transfer', 'color_fading'],
        'occasion': ['evening', 'professional', 'special_events'],
        'finish': 'ultra_matte',
        'isActive': true,
        'stockStatus': 'in_stock',
        'rating': 4.3,
        'reviewsCount': 89
      },

      // أحمر الشفاه اللامع
      {
        'name': "L'Oréal Color Riche Shine Lipstick",
        'arabicName': "أحمر شفاه لوريال كولور ريتش شاين",
        'description': "Glossy lipstick with moisturizing and smooth formula, gives lips a sparkling touch with transparent and radiant color. Suitable for daily use with light texture.",
        'arabicDescription': "حمرة شفاه لامعة بتركيبة مرطبة وناعمة، تمنح شفاهك لمسة براقة مع لون شفاف ومتوهج. مناسبة للاستعمال اليومي مع ملمس خفيف.",
        'category': 'lipstick',
        'brand': "L'Oréal",
        'price': 70.0,
        'images': [
          'https://images.unsplash.com/photo-1631214540242-3b0a9e61fa5c?w=400',
          'https://images.unsplash.com/photo-1586495777744-4413f21062fa?w=400'
        ],
        'colors': [
          {
            'name': 'Natural Beige',
            'arabicName': 'بيج طبيعي',
            'hexCode': '#D2B48C',
            'isAvailable': true
          },
          {
            'name': 'Sheer Pink',
            'arabicName': 'وردي شفاف',
            'hexCode': '#FFB6C1',
            'isAvailable': true
          },
          {
            'name': 'Coral Pink',
            'arabicName': 'وردي مرجاني',
            'hexCode': '#FF7F7F',
            'isAvailable': true
          }
        ],
        'skinTypes': ['dry', 'normal', 'sensitive'],
        'suitableFor': {
          'oily': 70,
          'dry': 90,
          'combination': 80,
          'sensitive': 85,
          'normal': 90
        },
        'features': ['moisturizing', 'glossy_finish', 'lightweight', 'nourishing'],
        'ingredients': 'زيوت طبيعية، مرطبات، أصباغ شفافة، فيتامين E',
        'usage': 'يطبق مباشرة على الشفاه أو فوق مرطب شفاه للمعان إضافي.',
        'benefits': ['ترطيب فوري', 'لمعان طبيعي', 'ملمس خفيف', 'لون شفاف جميل'],
        'problems_solved': ['dry_lips', 'dull_color'],
        'occasion': ['daily', 'casual', 'daytime'],
        'finish': 'glossy',
        'isActive': true,
        'stockStatus': 'in_stock',
        'rating': 4.2,
        'reviewsCount': 156
      },

      // بلسم الشفاه المتوهج
      {
        'name': "L'Oréal Glow Paradise Balm-in-Lipstick",
        'arabicName': "بلسم الشفاه المتوهج من لوريال",
        'description': "Balm-in-lipstick provides instant and intensive hydration with 92% natural ingredients formula, pomegranate extract works to nourish and soothe lips.",
        'arabicDescription': "بلسم شفاه يوفر ترطيب فوري ومكثّف بفضل تركيبة 92% مكوّنات طبيعية، مستخلص الرمان يعمل على تغذية الشفاه وتلطيفها.",
        'category': 'lip_balm',
        'brand': "L'Oréal",
        'price': 65.0,
        'images': [
          'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=400',
          'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?w=400'
        ],
        'colors': [
          {
            'name': 'Natural Clear',
            'arabicName': 'شفاف طبيعي',
            'hexCode': '#FFE4E1',
            'isAvailable': true
          },
          {
            'name': 'Tinted Pink',
            'arabicName': 'وردي ملون',
            'hexCode': '#FFB6C1',
            'isAvailable': true
          },
          {
            'name': 'Berry Tint',
            'arabicName': 'توتي فاتح',
            'hexCode': '#FF69B4',
            'isAvailable': true
          }
        ],
        'skinTypes': ['dry', 'sensitive', 'normal', 'combination'],
        'suitableFor': {
          'oily': 75,
          'dry': 95,
          'combination': 85,
          'sensitive': 98,
          'normal': 95
        },
        'features': ['natural_ingredients', 'pomegranate_extract', 'intensive_moisturizing', 'dermatologically_tested'],
        'ingredients': '92% مكونات طبيعية، مستخلص الرمان، زبدة الشيا، زيت جوز الهند',
        'usage': 'يطبق عدة مرات يومياً حسب الحاجة. يمكن استخدامه كقاعدة قبل أحمر الشفاه.',
        'benefits': ['ترطيب مكثف', 'تغذية عميقة', 'حماية من التشقق', 'ملمس ناعم حريري'],
        'problems_solved': ['dry_lips', 'cracking', 'irritation'],
        'occasion': ['daily', 'night_care', 'treatment'],
        'finish': 'natural',
        'isActive': true,
        'stockStatus': 'in_stock',
        'rating': 4.7,
        'reviewsCount': 203
      },

      // مسكرة لاش بارادايس
      {
        'name': "L'Oréal Voluminous Lash Paradise Mascara",
        'arabicName': "مسكرة لوريال فوليومينوس لاش بارادايس",
        'description': "Mascara gives thick and long lashes with rich coverage in deep black color. Smooth formula allows smooth application without clumping, with dense brush to lift and thicken lashes clearly.",
        'arabicDescription': "مسكرة تعطي رموش كثيفة وطويلة مع تغطية غنية باللون الأسود العميق. تركيبة ناعمة تسمح بالتطبيق السلس بدون تكتل، مع فرشاة كثيفة لرفع وتكثيف الرموش بشكل واضح.",
        'category': 'mascara',
        'brand': "L'Oréal",
        'price': 80.0,
        'images': [
          'https://images.unsplash.com/photo-1631214540242-3b0a9e61fa5c?w=400',
          'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=400'
        ],
        'colors': [
          {
            'name': 'Deep Black',
            'arabicName': 'أسود عميق',
            'hexCode': '#000000',
            'isAvailable': true
          },
          {
            'name': 'Brown Black',
            'arabicName': 'أسود بني',
            'hexCode': '#2F2F2F',
            'isAvailable': true
          }
        ],
        'skinTypes': ['all'],
        'suitableFor': {
          'oily': 85,
          'dry': 85,
          'combination': 85,
          'sensitive': 80,
          'normal': 90
        },
        'features': ['volumizing', 'lengthening', 'no_clumping', 'smooth_application'],
        'ingredients': 'أصباغ مقاومة للماء، شموع طبيعية، بوليمرات مرنة',
        'usage': 'يطبق من جذور الرموش إلى الأطراف بحركة متعرجة. يمكن تطبيق طبقات متعددة.',
        'benefits': ['كثافة واضحة', 'طول طبيعي', 'لون أسود غني', 'ثبات طويل'],
        'problems_solved': ['thin_lashes', 'short_lashes', 'lack_of_definition'],
        'occasion': ['daily', 'professional', 'evening'],
        'finish': 'matte',
        'isActive': true,
        'stockStatus': 'in_stock',
        'rating': 4.4,
        'reviewsCount': 178
      },

      // مسكرة تلسكوبيك
      {
        'name': "L'Oréal Telescopic Mascara",
        'arabicName': "مسكرة لوريال تلسكوبيك",
        'description': "Mascara focuses on clearly lengthening lashes with precise brush that allows covering each lash individually, gives separated and long lashes without clumping.",
        'arabicDescription': "مسكرة تركز على إطالة الرموش بشكل واضح مع فرشاة دقيقة تسمح بتغطية كل رمش على حدة، تمنح رموشًا منفصلة وطويلة بدون تكتل.",
        'category': 'mascara',
        'brand': "L'Oréal",
        'price': 75.0,
        'images': [
          'https://images.unsplash.com/photo-1586495777744-4413f21062fa?w=400',
          'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?w=400'
        ],
        'colors': [
          {
            'name': 'Jet Black',
            'arabicName': 'أسود فاحم',
            'hexCode': '#000000',
            'isAvailable': true
          },
          {
            'name': 'Dark Brown',
            'arabicName': 'بني غامق',
            'hexCode': '#654321',
            'isAvailable': true
          }
        ],
        'skinTypes': ['all'],
        'suitableFor': {
          'oily': 90,
          'dry': 80,
          'combination': 85,
          'sensitive': 85,
          'normal': 95
        },
        'features': ['lengthening', 'separating', 'precise_application', 'natural_look'],
        'ingredients': 'أصباغ طبيعية، شموع مرنة، مكونات مطولة للرموش',
        'usage': 'يطبق بحركة مستقيمة من الجذور للأطراف. الفرشاة الدقيقة تصل لكل رمش.',
        'benefits': ['إطالة واضحة', 'رموش منفصلة', 'مظهر طبيعي', 'دقة في التطبيق'],
        'problems_solved': ['short_lashes', 'clumping', 'uneven_application'],
        'occasion': ['daily', 'professional', 'natural_look'],
        'finish': 'natural',
        'isActive': true,
        'stockStatus': 'in_stock',
        'rating': 4.1,
        'reviewsCount': 142
      },

      // مسكرة كاربون بلاك
      {
        'name': "L'Oréal Voluminous Carbon Black Mascara",
        'arabicName': "مسكرة لوريال فوليومينوس كاربون بلاك",
        'description': "Ultra-black mascara with dense formula that greatly increases lash volume, gives dramatic look with excellent coverage.",
        'arabicDescription': "مسكرة فائقة السواد مع تركيبة كثيفة تزيد من حجم الرموش بشكل كبير، تعطي مظهر درامي مع تغطية ممتازة.",
        'category': 'mascara',
        'brand': "L'Oréal",
        'price': 85.0,
        'images': [
          'https://images.unsplash.com/photo-1631214540242-3b0a9e61fa5c?w=400',
          'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=400'
        ],
        'colors': [
          {
            'name': 'Carbon Black',
            'arabicName': 'أسود كربوني',
            'hexCode': '#000000',
            'isAvailable': true
          }
        ],
        'skinTypes': ['all'],
        'suitableFor': {
          'oily': 85,
          'dry': 75,
          'combination': 80,
          'sensitive': 75,
          'normal': 85
        },
        'features': ['ultra_black', 'dramatic_volume', 'dense_formula', 'evening_wear'],
        'ingredients': 'أصباغ كربونية فائقة، شموع مكثفة، بوليمرات حجم',
        'usage': 'يطبق بطبقات متعددة للحصول على الحجم المطلوب. مثالية للسهرات.',
        'benefits': ['حجم درامي', 'أسود فائق', 'تأثير مذهل', 'مثالية للمناسبات'],
        'problems_solved': ['thin_lashes', 'lack_of_drama', 'special_occasions'],
        'occasion': ['evening', 'special_events', 'dramatic_look'],
        'finish': 'dramatic',
        'isActive': true,
        'stockStatus': 'in_stock',
        'rating': 4.6,
        'reviewsCount': 95
      }
    ];
  }
}



