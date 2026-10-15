import '../../domain/entities/emergency_contact_entity.dart';

class EmergencyContactModel extends EmergencyContactEntity {
  const EmergencyContactModel({
    required super.id,
    required super.name,
    required super.roleEn,
    required super.roleAr,
    required super.phone,
    super.whatsapp,
    super.descriptionEn,
    super.descriptionAr,
    super.displayOrder,
  });

  factory EmergencyContactModel.fromJson(Map<String, dynamic> json) {
    return EmergencyContactModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? json['Name']?.toString() ?? '',
      roleEn: json['roleEn']?.toString() ?? json['RoleEn']?.toString() ?? '',
      roleAr: json['roleAr']?.toString() ?? json['RoleAr']?.toString() ?? '',
      phone: json['phone']?.toString() ?? json['Phone']?.toString() ?? '',
      whatsapp: json['whatsapp']?.toString() ?? json['Whatsapp']?.toString(),
      descriptionEn: json['descriptionEn']?.toString() ?? json['DescriptionEn']?.toString(),
      descriptionAr: json['descriptionAr']?.toString() ?? json['DescriptionAr']?.toString(),
      displayOrder: json['displayOrder'] is int
          ? json['displayOrder']
          : int.tryParse(json['displayOrder']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'roleEn': roleEn,
      'roleAr': roleAr,
      'phone': phone,
      'whatsapp': whatsapp,
      'descriptionEn': descriptionEn,
      'descriptionAr': descriptionAr,
      'displayOrder': displayOrder,
    };
  }
}
