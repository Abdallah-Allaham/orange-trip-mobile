import 'package:equatable/equatable.dart';

class AnnouncementEntity extends Equatable {
  final int id;
  final String titleEn;
  final String titleAr;
  final String contentEn;
  final String contentAr;
  final String type;
  final bool requiresAcknowledgment;
  final String targetAudience;
  final String createdAt;
  final bool isAcknowledged;

  const AnnouncementEntity({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.contentEn,
    required this.contentAr,
    this.type = 'General',
    this.requiresAcknowledgment = false,
    this.targetAudience = 'All',
    required this.createdAt,
    this.isAcknowledged = false,
  });

  AnnouncementEntity copyWith({
    int? id,
    String? titleEn,
    String? titleAr,
    String? contentEn,
    String? contentAr,
    String? type,
    bool? requiresAcknowledgment,
    String? targetAudience,
    String? createdAt,
    bool? isAcknowledged,
  }) {
    return AnnouncementEntity(
      id: id ?? this.id,
      titleEn: titleEn ?? this.titleEn,
      titleAr: titleAr ?? this.titleAr,
      contentEn: contentEn ?? this.contentEn,
      contentAr: contentAr ?? this.contentAr,
      type: type ?? this.type,
      requiresAcknowledgment: requiresAcknowledgment ?? this.requiresAcknowledgment,
      targetAudience: targetAudience ?? this.targetAudience,
      createdAt: createdAt ?? this.createdAt,
      isAcknowledged: isAcknowledged ?? this.isAcknowledged,
    );
  }

  @override
  List<Object?> get props => [
        id,
        titleEn,
        titleAr,
        contentEn,
        contentAr,
        type,
        requiresAcknowledgment,
        targetAudience,
        createdAt,
        isAcknowledged,
      ];
}
