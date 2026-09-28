import 'package:equatable/equatable.dart';

class ItineraryItemEntity extends Equatable {
  final int id;
  final String date;
  final String startTime;
  final String endTime;
  final String titleEn;
  final String titleAr;
  final String descriptionEn;
  final String descriptionAr;
  final String locationEn;
  final String locationAr;
  final String gatheringPointEn;
  final String gatheringPointAr;
  final String dressCodeEn;
  final String dressCodeAr;
  final String targetGroup;
  final String? attachmentName;
  final String? attachmentUrl;
  final int orderIndex;
  final bool isPublished;

  const ItineraryItemEntity({
    required this.id,
    required this.date,
    required this.startTime,
    this.endTime = '',
    required this.titleEn,
    required this.titleAr,
    this.descriptionEn = '',
    this.descriptionAr = '',
    this.locationEn = '',
    this.locationAr = '',
    this.gatheringPointEn = '',
    this.gatheringPointAr = '',
    this.dressCodeEn = '',
    this.dressCodeAr = '',
    this.targetGroup = 'All',
    this.attachmentName,
    this.attachmentUrl,
    this.orderIndex = 0,
    this.isPublished = true,
  });

  @override
  List<Object?> get props => [
        id,
        date,
        startTime,
        endTime,
        titleEn,
        titleAr,
        descriptionEn,
        descriptionAr,
        locationEn,
        locationAr,
        gatheringPointEn,
        gatheringPointAr,
        dressCodeEn,
        dressCodeAr,
        targetGroup,
        attachmentName,
        attachmentUrl,
        orderIndex,
        isPublished,
      ];
}
