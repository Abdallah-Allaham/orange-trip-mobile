import '../../domain/entities/itinerary_item_entity.dart';

class ItineraryItemModel extends ItineraryItemEntity {
  const ItineraryItemModel({
    required super.id,
    required super.date,
    required super.startTime,
    super.endTime,
    required super.titleEn,
    required super.titleAr,
    super.descriptionEn,
    super.descriptionAr,
    super.locationEn,
    super.locationAr,
    super.gatheringPointEn,
    super.gatheringPointAr,
    super.dressCodeEn,
    super.dressCodeAr,
    super.targetGroup,
    super.attachmentName,
    super.attachmentUrl,
    super.orderIndex,
    super.isPublished,
  });

  factory ItineraryItemModel.fromJson(Map<String, dynamic> json) {
    return ItineraryItemModel(
      id: json['id'] ?? json['Id'] ?? 0,
      date: json['date'] ?? json['Date'] ?? '',
      startTime: json['startTime'] ?? json['StartTime'] ?? '',
      endTime: json['endTime'] ?? json['EndTime'] ?? '',
      titleEn: json['titleEn'] ?? json['TitleEn'] ?? '',
      titleAr: json['titleAr'] ?? json['TitleAr'] ?? '',
      descriptionEn: json['descriptionEn'] ?? json['DescriptionEn'] ?? '',
      descriptionAr: json['descriptionAr'] ?? json['DescriptionAr'] ?? '',
      locationEn: json['locationEn'] ?? json['LocationEn'] ?? '',
      locationAr: json['locationAr'] ?? json['LocationAr'] ?? '',
      gatheringPointEn: json['gatheringPointEn'] ?? json['GatheringPointEn'] ?? '',
      gatheringPointAr: json['gatheringPointAr'] ?? json['GatheringPointAr'] ?? '',
      dressCodeEn: json['dressCodeEn'] ?? json['DressCodeEn'] ?? '',
      dressCodeAr: json['dressCodeAr'] ?? json['DressCodeAr'] ?? '',
      targetGroup: json['targetGroup'] ?? json['TargetGroup'] ?? 'All',
      attachmentName: json['attachmentName'] ?? json['AttachmentName'],
      attachmentUrl: json['attachmentUrl'] ?? json['AttachmentUrl'],
      orderIndex: json['orderIndex'] ?? json['OrderIndex'] ?? 0,
      isPublished: json['isPublished'] ?? json['IsPublished'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'titleEn': titleEn,
      'titleAr': titleAr,
      'descriptionEn': descriptionEn,
      'descriptionAr': descriptionAr,
      'locationEn': locationEn,
      'locationAr': locationAr,
      'gatheringPointEn': gatheringPointEn,
      'gatheringPointAr': gatheringPointAr,
      'dressCodeEn': dressCodeEn,
      'dressCodeAr': dressCodeAr,
      'targetGroup': targetGroup,
      'attachmentName': attachmentName,
      'attachmentUrl': attachmentUrl,
      'orderIndex': orderIndex,
      'isPublished': isPublished,
    };
  }
}
