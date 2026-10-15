import '../../domain/entities/flight_entity.dart';

class FlightModel extends FlightEntity {
  const FlightModel({
    super.id,
    super.airline,
    super.flightNumberOutbound,
    super.outboundRoute,
    super.outboundDepartureTime,
    super.outboundArrivalTime,
    super.outboundAirport,
    super.flightNumberReturn,
    super.returnRoute,
    super.returnDepartureTime,
    super.returnArrivalTime,
    super.returnAirport,
  });

  factory FlightModel.fromJson(Map<String, dynamic> json) {
    return FlightModel(
      id: json['id'] ?? json['Id'] ?? 0,
      airline: json['airline'] ?? json['Airline'] ?? 'Royal Jordanian',
      flightNumberOutbound: json['flightNumberOutbound'] ?? json['FlightNumberOutbound'] ?? 'RJ 501',
      outboundRoute: json['outboundRoute'] ?? json['OutboundRoute'] ?? 'Amman (AMM) → Cairo (CAI)',
      outboundDepartureTime: json['outboundDepartureTime'] ?? json['OutboundDepartureTime'] ?? '2026-11-02 09:30',
      outboundArrivalTime: json['outboundArrivalTime'] ?? json['OutboundArrivalTime'] ?? '2026-11-02 10:55',
      outboundAirport: json['outboundAirport'] ?? json['OutboundAirport'] ?? 'Queen Alia International Airport',
      flightNumberReturn: json['flightNumberReturn'] ?? json['FlightNumberReturn'] ?? 'RJ 506',
      returnRoute: json['returnRoute'] ?? json['ReturnRoute'] ?? 'Cairo (CAI) → Amman (AMM)',
      returnDepartureTime: json['returnDepartureTime'] ?? json['ReturnDepartureTime'] ?? '2026-11-05 19:00',
      returnArrivalTime: json['returnArrivalTime'] ?? json['ReturnArrivalTime'] ?? '2026-11-05 21:15',
      returnAirport: json['returnAirport'] ?? json['ReturnAirport'] ?? 'Cairo International Airport',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'airline': airline,
      'flightNumberOutbound': flightNumberOutbound,
      'outboundRoute': outboundRoute,
      'outboundDepartureTime': outboundDepartureTime,
      'outboundArrivalTime': outboundArrivalTime,
      'outboundAirport': outboundAirport,
      'flightNumberReturn': flightNumberReturn,
      'returnRoute': returnRoute,
      'returnDepartureTime': returnDepartureTime,
      'returnArrivalTime': returnArrivalTime,
      'returnAirport': returnAirport,
    };
  }
}
