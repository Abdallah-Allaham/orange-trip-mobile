import '../../domain/entities/hotel_entity.dart';

class HotelModel extends HotelEntity {
  const HotelModel({
    super.id,
    super.hotelName,
    super.hotelPhone,
    super.hotelReceptionContact,
    super.emergencyContact,
    super.checkInDate,
    super.checkOutDate,
    super.roomNumber,
    super.roomCategory,
    super.wifiNetwork = '',
    super.wifiPassword = '',
    super.wifiInstructions = 'Network: StRegis_Guest',
    super.operationalNotes = 'Keycards available at Orange Welcome Desk in lobby.',
    super.mapUrl = 'https://maps.google.com/?q=The+St.+Regis+Cairo',
  });

  factory HotelModel.fromJson(Map<String, dynamic> json) {
    final wifiNet = json['wifiNetwork'] ?? json['WifiNetwork'] ?? '';
    final wifiPass = json['wifiPassword'] ?? json['WifiPassword'] ?? '';
    final rawInstructions = json['wifiInstructions'] ?? json['WifiInstructions'];
    final mapUrl = json['mapUrl'] ?? json['MapUrl'] ?? '';

    return HotelModel(
      id: json['id'] ?? json['Id'] ?? 0,
      hotelName: json['hotelName'] ?? json['HotelName'] ?? '',
      hotelPhone: json['hotelPhone'] ?? json['HotelPhone'] ?? '',
      hotelReceptionContact: json['hotelReceptionContact'] ?? json['HotelReceptionContact'] ?? 'Dial 0 from room',
      emergencyContact: json['emergencyContact'] ?? json['EmergencyContact'] ?? '',
      checkInDate: json['checkInDate'] ?? json['CheckInDate'] ?? '',
      checkOutDate: json['checkOutDate'] ?? json['CheckOutDate'] ?? '',
      roomNumber: json['roomNumber'] ?? json['RoomNumber'] ?? 'Assigned upon arrival',
      roomCategory: json['roomCategory'] ?? json['RoomCategory'] ?? '',
      wifiNetwork: wifiNet.toString(),
      wifiPassword: wifiPass.toString(),
      wifiInstructions: rawInstructions != null && rawInstructions.toString().isNotEmpty
          ? rawInstructions.toString()
          : 'Network: $wifiNet | Pass: $wifiPass',
      operationalNotes: json['operationalNotes'] ?? json['OperationalNotes'] ?? 'Keycards available at Orange Welcome Desk in lobby.',
      mapUrl: mapUrl.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hotelName': hotelName,
      'hotelPhone': hotelPhone,
      'hotelReceptionContact': hotelReceptionContact,
      'emergencyContact': emergencyContact,
      'checkInDate': checkInDate,
      'checkOutDate': checkOutDate,
      'roomNumber': roomNumber,
      'roomCategory': roomCategory,
      'wifiNetwork': wifiNetwork,
      'wifiPassword': wifiPassword,
      'wifiInstructions': wifiInstructions,
      'operationalNotes': operationalNotes,
      'mapUrl': mapUrl,
    };
  }
}
