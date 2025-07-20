// lib/core/constants/app_constants.dart
class AppConstants {
  // Back4App Table Names
  static const String usersTable = '_User';
  static const String categoriesTable = 'Categories';
  static const String productsTable = 'Products';
  static const String surveyQuestionsTable = 'Survey_Questions';
  static const String surveysTable = 'Surveys';
  static const String cartTable = 'Cart';
  static const String ordersTable = 'Orders';
  static const String reviewsTable = 'Product_Reviews';

  // Skin Types
  static const String oilySkin = 'oily';
  static const String drySkin = 'dry';
  static const String combinationSkin = 'combination';
  static const String sensitiveSkin = 'sensitive';
  static const String normalSkin = 'normal';

  // Product Categories
  static const String lipstickCategory = 'lipstick';
  static const String mascaraCategory = 'mascara';
  static const String lipBalmCategory = 'lip_balm';

  // Product Finishes
  static const String matteFinish = 'matte';
  static const String glossyFinish = 'glossy';
  static const String naturalFinish = 'natural';
  static const String ultraMatteFinish = 'ultra_matte';

  // Order Status
  static const String pendingStatus = 'pending';
  static const String confirmedStatus = 'confirmed';
  static const String processingStatus = 'processing';
  static const String shippedStatus = 'shipped';
  static const String deliveredStatus = 'delivered';
  static const String cancelledStatus = 'cancelled';

  // Survey Sections
  static const String skinAnalysisSection = 'skin_analysis';
  static const String problemsSection = 'problems';
  static const String preferencesSection = 'preferences';

  // App Settings
  static const int maxCartItems = 50;
  static const int questionsPerPage = 1;
  static const int productsPerPage = 20;
  static const double minConfidenceScore = 0.7;

  // SharedPreferences Keys
  static const String userSkinTypeKey = 'user_skin_type';
  static const String lastSurveyDateKey = 'last_survey_date';
  static const String appFirstRunKey = 'app_first_run';
  static const String userPreferencesKey = 'user_preferences';

  // Default Values
  static const String defaultSkinType = normalSkin;
  static const String defaultProductImage = 'assets/images/default_product.png';
  static const String defaultCategoryImage = 'assets/images/default_category.png';
}