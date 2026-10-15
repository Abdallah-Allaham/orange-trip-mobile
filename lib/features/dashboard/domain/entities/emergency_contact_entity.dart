import 'package:equatable/equatable.dart';

class EmergencyContactEntity extends Equatable {
  final int id;
  final String name;
  final String roleEn;
  final String roleAr;
  final String phone;
  final String? whatsapp;
  final String? descriptionEn;
  final String? descriptionAr;
  final int displayOrder;

  const EmergencyContactEntity({
    required this.id,
    required this.name,
    required this.roleEn,
    required this.roleAr,
    required this.phone,
    this.whatsapp,
    this.descriptionEn,
    this.descriptionAr,
    this.displayOrder = 0,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        roleEn,
        roleAr,
        phone,
        whatsapp,
        descriptionEn,
        descriptionAr,
        displayOrder,
      ];
}
