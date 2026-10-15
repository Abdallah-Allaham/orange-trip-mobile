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
    flightNumberReturn: 'RJ 506',
    returnRoute: 'Cairo (CAI) → Amman (AMM)',
    returnDepartureTime: '2026-11-05 19:00',
    returnArrivalTime: '2026-11-05 21:15',
    returnAirport: 'Cairo International Airport',
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
      'flightNumberReturn': 'RJ 506',
      'returnRoute': 'Cairo (CAI) → Amman (AMM)',
      'returnDepartureTime': '2026-11-05 19:00',
      'returnArrivalTime': '2026-11-05 21:15',
      'returnAirport': 'Cairo International Airport',
    };

    final result = FlightModel.fromJson(jsonMap);
    expect(result.flightNumberOutbound, 'RJ 501');
    expect(result.flightNumberReturn, 'RJ 506');
    expect(result.airline, 'Royal Jordanian');
    expect(result.outboundAirport, 'Queen Alia International Airport');
  });

  test('toJson should output correct map representation', () {
    final json = tFlightModel.toJson();
    expect(json['flightNumberOutbound'], 'RJ 501');
    expect(json['airline'], 'Royal Jordanian');
    expect(json['outboundRoute'], 'Amman (AMM) → Cairo (CAI)');
  });
}
