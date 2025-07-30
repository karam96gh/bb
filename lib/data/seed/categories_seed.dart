// lib/data/seed/categories_seed.dart - محدث
class CategoriesSeedData {
  static List<Map<String, dynamic>> getCategories() {
    return [
      {
        'name': 'Lipstick',
        'arabicName': 'أحمر شفاه',
        'description': 'All types of lipsticks including matte, glossy, liquid formulas, and lip pencils for every occasion and skin type',
        'arabicDescription': 'جميع أنواع أحمر الشفاه بما في ذلك المطفي واللامع والسائل وأقلام الشفاه لكل مناسبة ونوع بشرة',
        'image': 'https://images.unsplash.com/photo-1586495777744-4413f21062fa?w=300',
        'displayOrder': 1,
        'isActive': true
      },
      {
        'name': 'Mascara',
        'arabicName': 'مسكرة',
        'description': 'Mascara products for volume, length, and definition to enhance your natural lashes with various formulas and brushes',
        'arabicDescription': 'منتجات المسكرة للحجم والطول والتحديد لتعزيز رموشك الطبيعية بتركيبات وفراشي متنوعة',
        'image': 'https://images.unsplash.com/photo-1631214540242-3b0a9e61fa5c?w=300',
        'displayOrder': 2,
        'isActive': true
      },
      {
        'name': 'Lip Balm',
        'arabicName': 'بلسم شفاه',
        'description': 'Nourishing and protective lip balms with natural ingredients for healthy, moisturized lips in various formulations',
        'arabicDescription': 'بلسم شفاه مغذي وواقي بمكونات طبيعية لشفاه صحية ومرطبة بتركيبات متنوعة',
        'image': 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=300',
        'displayOrder': 3,
        'isActive': true
      },
      {
        'name': 'Makeup Setting',
        'arabicName': 'مثبت المكياج',
        'description': 'Setting sprays and products that lock in your makeup for all-day wear and protection against environmental factors',
        'arabicDescription': 'رذاذ ومنتجات التثبيت التي تحافظ على مكياجك طوال اليوم وتحميه من العوامل البيئية',
        'image': 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?w=300',
        'displayOrder': 4,
        'isActive': true
      }
    ];
  }
}