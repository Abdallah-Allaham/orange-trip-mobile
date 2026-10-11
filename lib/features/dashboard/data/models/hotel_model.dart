import '../../domain/entities/hotel_entity.dart';

class HotelModel extends HotelEntity {
  const HotelModel({
    super.id,
    super.hotelName,
    super.hotelAddressEn,
    super.hotelAddressAr,
    super.hotelPhone,
    super.hotelReceptionContact,
    super.emergencyContact,
    super.checkInDate,
    super.checkOutDate,
    super.roomNumber,
    super.roomCategory,
    super.confirmationReference,
    super.wifiNetwork = 'StRegis_Guest',
    super.wifiPassword = 'OrangeCairo2026',
    super.wifiInstructions = 'Network: StRegis_Guest | Pass: OrangeCairo2026',
    super.operationalNotes = 'Keycards available at Orange Welcome Desk in lobby.',
  });

  factory HotelModel.fromJson(Map<String, dynamic> json) {
    final wifiNet = json['wifiNetwork'] ?? json['WifiNetwork'] ?? 'StRegis_Guest';
    final wifiPass = json['wifiPassword'] ?? json['WifiPassword'] ?? 'OrangeCairo2026';
    final rawInstructions = json['wifiInstructions'] ?? json['WifiInstructions'];

    return HotelModel(
      id: json['id'] ?? json['Id'] ?? 0,
      hotelName: json['hotelName'] ?? json['HotelName'] ?? 'The St. Regis Cairo',
      hotelAddressEn: json['hotelAddressEn'] ?? json['HotelAddressEn'] ?? 'Corniche El Nile, Cairo, Egypt',
      hotelAddressAr: json['hotelAddressAr'] ?? json['HotelAddressAr'] ?? 'كورنيش النيل، القاهرة، مصر',
      hotelPhone: json['hotelPhone'] ?? json['HotelPhone'] ?? '+20 2 2597 9000',
      hotelReceptionContact: json['hotelReceptionContact'] ?? json['HotelReceptionContact'] ?? 'Dial 0 from room',
      emergencyContact: json['emergencyContact'] ?? json['EmergencyContact'] ?? '+20 100 000 9999',
      checkInDate: json['checkInDate'] ?? json['CheckInDate'] ?? '2 Nov 2026, 14:00',
      checkOutDate: json['checkOutDate'] ?? json['CheckOutDate'] ?? '5 Nov 2026, 12:00',
      roomNumber: json['roomNumber'] ?? json['RoomNumber'] ?? 'Assigned upon arrival',
      roomCategory: json['roomCategory'] ?? json['RoomCategory'] ?? 'Deluxe Nile View',
      confirmationReference: json['confirmationReference'] ?? json['ConfirmationReference'] ?? 'HTL-ORG-7788',
      wifiNetwork: wifiNet.toString(),
      wifiPassword: wifiPass.toString(),
      wifiInstructions: rawInstructions != null && rawInstructions.toString().isNotEmpty
          ? rawInstructions.toString()
          : 'Network: $wifiNet | Pass: $wifiPass',
      operationalNotes: json['operationalNotes'] ?? json['OperationalNotes'] ?? 'Keycards available at Orange Welcome Desk in lobby.',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hotelName': hotelName,
      'hotelAddressEn': hotelAddressEn,
      'hotelAddressAr': hotelAddressAr,
      'hotelPhone': hotelPhone,
      'hotelReceptionContact': hotelReceptionContact,
      'emergencyContact': emergencyContact,
      'checkInDate': checkInDate,
      'checkOutDate': checkOutDate,
      'roomNumber': roomNumber,
      'roomCategory': roomCategory,
      'confirmationReference': confirmationReference,
      'wifiNetwork': wifiNetwork,
      'wifiPassword': wifiPassword,
      'wifiInstructions': wifiInstructions,
      'operationalNotes': operationalNotes,
    };
  }
}
