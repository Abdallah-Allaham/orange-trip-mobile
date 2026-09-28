import '../../domain/entities/announcement_entity.dart';

class AnnouncementModel extends AnnouncementEntity {
  const AnnouncementModel({
    required super.id,
    required super.titleEn,
    required super.titleAr,
    required super.contentEn,
    required super.contentAr,
    super.type,
    super.requiresAcknowledgment,
    super.targetAudience,
    required super.createdAt,
    super.isAcknowledged,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['id'] ?? json['Id'] ?? 0,
      titleEn: json['titleEn'] ?? json['TitleEn'] ?? '',
      titleAr: json['titleAr'] ?? json['TitleAr'] ?? '',
      contentEn: json['contentEn'] ?? json['ContentEn'] ?? '',
      contentAr: json['contentAr'] ?? json['ContentAr'] ?? '',
      type: json['type'] ?? json['Type'] ?? 'General',
      requiresAcknowledgment: json['requiresAcknowledgment'] ?? json['RequiresAcknowledgment'] ?? false,
      targetAudience: json['targetAudience'] ?? json['TargetAudience'] ?? 'All',
      createdAt: json['createdAt'] ?? json['CreatedAt'] ?? '',
      isAcknowledged: json['isAcknowledged'] ?? json['IsAcknowledged'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titleEn': titleEn,
      'titleAr': titleAr,
      'contentEn': contentEn,
      'contentAr': contentAr,
      'type': type,
      'requiresAcknowledgment': requiresAcknowledgment,
      'targetAudience': targetAudience,
      'createdAt': createdAt,
      'isAcknowledged': isAcknowledged,
    };
  }
}
