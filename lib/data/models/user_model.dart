// lib/data/models/user_model.dart
class UserModel {
  final String objectId;
  final String fullName;
  final String email;
  final String phone;
  final String skinType;
  final bool profileCompleted;
  final bool isActive;
  final Map<String, dynamic> preferences;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.objectId,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.skinType,
    required this.profileCompleted,
    required this.isActive,
    required this.preferences,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      objectId: json['objectId'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      skinType: json['skinType'] ?? '',
      profileCompleted: json['profileCompleted'] ?? false,
      isActive: json['isActive'] ?? true,
      preferences: Map<String, dynamic>.from(json['preferences'] ?? {}),
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'objectId': objectId,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'skinType': skinType,
      'profileCompleted': profileCompleted,
      'isActive': isActive,
      'preferences': preferences,
    };
  }

  UserModel copyWith({
    String? objectId,
    String? fullName,
    String? email,
    String? phone,
    String? skinType,
    bool? profileCompleted,
    bool? isActive,
    Map<String, dynamic>? preferences,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      objectId: objectId ?? this.objectId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      skinType: skinType ?? this.skinType,
      profileCompleted: profileCompleted ?? this.profileCompleted,
      isActive: isActive ?? this.isActive,
      preferences: preferences ?? this.preferences,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Helper getters
  String get displayName {
    if (fullName.isNotEmpty) return fullName;
    if (email.isNotEmpty) return email.split('@').first;
    return 'مستخدم';
  }

  String get initials {
    if (fullName.isNotEmpty) {
      final names = fullName.split(' ');
      if (names.length >= 2) {
        return '${names.first[0]}${names.last[0]}'.toUpperCase();
      }
      return fullName[0].toUpperCase();
    }
    return 'م';
  }

  bool get hasPhone => phone.isNotEmpty;
  bool get hasSkinType => skinType.isNotEmpty;
  bool get needsProfileCompletion => !profileCompleted;
}