import 'package:flutter_test/flutter_test.dart';
import 'package:orange_trip_mobile/features/dashboard/data/models/flight_model.dart';
import 'package:orange_trip_mobile/features/dashboard/domain/entities/flight_entity.dart';

void main() {
  const tFlightModel = FlightModel(
    id: 1,
    airline: 'Royal Jordanian',
    flightNumberOutbound: 'RJ 501',
    outboundRoute: 'Amman (AMM) → Cairo (CAI)',
    outboundDepartureTime: '2026-11-02 09:30',
    outboundArrivalTime: '2026-11-02 10:55',
    outboundAirport: 'Queen Alia International Airport',
    outboundTerminal: 'Terminal 1',
    outboundBaggage: '1 x 23kg checked + 7kg cabin',
    flightNumberReturn: 'RJ 506',
    returnRoute: 'Cairo (CAI) → Amman (AMM)',
    returnDepartureTime: '2026-11-05 19:00',
    returnArrivalTime: '2026-11-05 21:15',
    returnAirport: 'Cairo International Airport',
    returnTerminal: 'Terminal 2',
    returnBaggage: '1 x 23kg checked + 7kg cabin',
    bookingReference: 'RJ-ORG-7788',
    ticketStatus: 'Ticketed',
  );

  test('FlightModel should be a subclass of FlightEntity', () {
    expect(tFlightModel, isA<FlightEntity>());
  });

  test('fromJson should parse camelCase server JSON correctly', () {
    final Map<String, dynamic> jsonMap = {
      'id': 1,
      'airline': 'Royal Jordanian',
      'flightNumberOutbound': 'RJ 501',
      'outboundRoute': 'Amman (AMM) → Cairo (CAI)',
      'outboundDepartureTime': '2026-11-02 09:30',
      'outboundArrivalTime': '2026-11-02 10:55',
      'outboundAirport': 'Queen Alia International Airport',
      'outboundTerminal': 'Terminal 1',
      'outboundBaggage': '1 x 23kg checked + 7kg cabin',
      'flightNumberReturn': 'RJ 506',
      'returnRoute': 'Cairo (CAI) → Amman (AMM)',
      'returnDepartureTime': '2026-11-05 19:00',
      'returnArrivalTime': '2026-11-05 21:15',
      'returnAirport': 'Cairo International Airport',
      'returnTerminal': 'Terminal 2',
      'returnBaggage': '1 x 23kg checked + 7kg cabin',
      'bookingReference': 'RJ-ORG-7788',
      'ticketStatus': 'Ticketed',
    };

    final result = FlightModel.fromJson(jsonMap);
    expect(result.flightNumberOutbound, 'RJ 501');
    expect(result.flightNumberReturn, 'RJ 506');
    expect(result.airline, 'Royal Jordanian');
    expect(result.ticketStatus, 'Ticketed');
    expect(result.bookingReference, 'RJ-ORG-7788');
  });

  test('toJson should output correct map representation', () {
    final json = tFlightModel.toJson();
    expect(json['flightNumberOutbound'], 'RJ 501');
    expect(json['airline'], 'Royal Jordanian');
    expect(json['ticketStatus'], 'Ticketed');
  });
}
