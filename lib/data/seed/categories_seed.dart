// lib/data/seed/categories_seed.dart
class CategoriesSeedData {
  static List<Map<String, dynamic>> getCategories() {
    return [
      {
        'name': 'Lipstick',
        'arabicName': 'أحمر شفاه',
        'description': 'All types of lipsticks including matte, glossy, and liquid formulas for every occasion and skin type',
        'arabicDescription': 'جميع أنواع أحمر الشفاه بما في ذلك المطفي واللامع والسائل لكل مناسبة ونوع بشرة',
        'image': 'https://images.unsplash.com/photo-1586495777744-4413f21062fa?w=300',
        'displayOrder': 1,
        'isActive': true
      },
      {
        'name': 'Mascara',
        'arabicName': 'مسكرة',
        'description': 'Mascara products for volume, length, and definition to enhance your natural lashes',
        'arabicDescription': 'منتجات المسكرة للحجم والطول والتحديد لتعزيز رموشك الطبيعية',
        'image': 'https://images.unsplash.com/photo-1631214540242-3b0a9e61fa5c?w=300',
        'displayOrder': 2,
        'isActive': true
      },
      {
        'name': 'Lip Balm',
        'arabicName': 'بلسم شفاه',
        'description': 'Nourishing and protective lip balms with natural ingredients for healthy lips',
        'arabicDescription': 'بلسم شفاه مغذي وواقي بمكونات طبيعية لشفاه صحية',
        'image': 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=300',
        'displayOrder': 3,
        'isActive': true
      }
    ];
  }
}
