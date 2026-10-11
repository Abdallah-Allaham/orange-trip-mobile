import 'package:flutter_test/flutter_test.dart';
import 'package:orange_trip_mobile/features/dashboard/data/models/hotel_model.dart';
import 'package:orange_trip_mobile/features/dashboard/domain/entities/hotel_entity.dart';

void main() {
  const tHotelModel = HotelModel(
    id: 1,
    hotelName: 'The St. Regis Cairo',
    hotelPhone: '+20 2 2597 9000',
    hotelReceptionContact: 'Dial 0 from room',
    emergencyContact: '+20 100 000 9999',
    checkInDate: '2 Nov 2026, 14:00',
    checkOutDate: '5 Nov 2026, 12:00',
    roomNumber: 'Assigned upon arrival',
    roomCategory: 'Deluxe Nile View',
    confirmationReference: 'HTL-ORG-7788',
    wifiInstructions: 'Network: StRegis_Guest | Pass: OrangeCairo2026',
    operationalNotes: 'Keycards available at Orange Welcome Desk in lobby.',
  );

  test('HotelModel should be a subclass of HotelEntity', () {
    expect(tHotelModel, isA<HotelEntity>());
  });

  test('fromJson should parse server JSON correctly', () {
    final Map<String, dynamic> jsonMap = {
      'id': 1,
      'hotelName': 'The St. Regis Cairo',
      'roomNumber': 'Assigned upon arrival',
      'roomCategory': 'Deluxe Nile View',
      'wifiInstructions': 'Network: StRegis_Guest | Pass: OrangeCairo2026',
    };

    final result = HotelModel.fromJson(jsonMap);
    expect(result.hotelName, 'The St. Regis Cairo');
    expect(result.wifiInstructions, contains('OrangeCairo2026'));
  });
}
