import 'package:equatable/equatable.dart';

class HotelEntity extends Equatable {
  final int id;
  final String hotelName;
  final String hotelAddressEn;
  final String hotelAddressAr;
  final String hotelPhone;
  final String hotelReceptionContact;
  final String emergencyContact;
  final String checkInDate;
  final String checkOutDate;
  final String roomNumber;
  final String roomCategory;
  final String confirmationReference;
  final String wifiInstructions;
  final String operationalNotes;

  const HotelEntity({
    this.id = 0,
    this.hotelName = 'The St. Regis Cairo',
    this.hotelAddressEn = 'Corniche El Nile, Cairo, Egypt',
    this.hotelAddressAr = 'كورنيش النيل، القاهرة، مصر',
    this.hotelPhone = '+20 2 2597 9000',
    this.hotelReceptionContact = 'Dial 0 from room',
    this.emergencyContact = '+20 100 000 9999',
    this.checkInDate = '2 Nov 2026, 14:00',
    this.checkOutDate = '5 Nov 2026, 12:00',
    this.roomNumber = 'Assigned upon arrival',
    this.roomCategory = 'Deluxe Nile View',
    this.confirmationReference = 'HTL-ORG-7788',
    this.wifiInstructions = 'Network: StRegis_Guest | Pass: OrangeCairo2026',
    this.operationalNotes = 'Keycards available at Orange Welcome Desk in lobby.',
  });

  @override
  List<Object?> get props => [
        id,
        hotelName,
        hotelAddressEn,
        hotelAddressAr,
        hotelPhone,
        hotelReceptionContact,
        emergencyContact,
        checkInDate,
        checkOutDate,
        roomNumber,
        roomCategory,
        confirmationReference,
        wifiInstructions,
        operationalNotes,
      ];
}
