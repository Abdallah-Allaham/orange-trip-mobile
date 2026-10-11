import 'package:equatable/equatable.dart';

class HotelEntity extends Equatable {
  final int id;
  final String hotelName;
  final String hotelPhone;
  final String hotelReceptionContact;
  final String emergencyContact;
  final String checkInDate;
  final String checkOutDate;
  final String roomNumber;
  final String roomCategory;
  final String confirmationReference;
  final String wifiNetwork;
  final String wifiPassword;
  final String wifiInstructions;
  final String operationalNotes;
  final String mapUrl;

  const HotelEntity({
    this.id = 0,
    this.hotelName = 'The St. Regis Cairo',
    this.hotelPhone = '+20 2 2597 9000',
    this.hotelReceptionContact = 'Dial 0 from room',
    this.emergencyContact = '+20 100 000 9999',
    this.checkInDate = '2 Nov 2026, 14:00',
    this.checkOutDate = '5 Nov 2026, 12:00',
    this.roomNumber = 'Assigned upon arrival',
    this.roomCategory = 'Deluxe Nile View',
    this.confirmationReference = 'HTL-ORG-7788',
    this.wifiNetwork = 'StRegis_Guest',
    this.wifiPassword = 'OrangeCairo2026',
    this.wifiInstructions = 'Network: StRegis_Guest | Pass: OrangeCairo2026',
    this.operationalNotes = 'Keycards available at Orange Welcome Desk in lobby.',
    this.mapUrl = 'https://maps.google.com/?q=The+St.+Regis+Cairo',
  });

  @override
  List<Object?> get props => [
        id,
        hotelName,
        hotelPhone,
        hotelReceptionContact,
        emergencyContact,
        checkInDate,
        checkOutDate,
        roomNumber,
        roomCategory,
        confirmationReference,
        wifiNetwork,
        wifiPassword,
        wifiInstructions,
        operationalNotes,
        mapUrl,
      ];
}
