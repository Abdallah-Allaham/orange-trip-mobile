import 'package:equatable/equatable.dart';

class FlightEntity extends Equatable {
  final int id;
  final String airline;
  final String flightNumberOutbound;
  final String outboundRoute;
  final String outboundDepartureTime;
  final String outboundArrivalTime;
  final String outboundAirport;
  final String flightNumberReturn;
  final String returnRoute;
  final String returnDepartureTime;
  final String returnArrivalTime;
  final String returnAirport;

  const FlightEntity({
    this.id = 0,
    this.airline = 'Royal Jordanian',
    this.flightNumberOutbound = '',
    this.outboundRoute = 'Amman (AMM) → Cairo (CAI)',
    this.outboundDepartureTime = '2026-11-02 09:30',
    this.outboundArrivalTime = '2026-11-02 10:55',
    this.outboundAirport = 'Queen Alia International Airport',
    this.flightNumberReturn = 'RJ 506',
    this.returnRoute = 'Cairo (CAI) → Amman (AMM)',
    this.returnDepartureTime = '2026-11-05 19:00',
    this.returnArrivalTime = '2026-11-05 21:15',
    this.returnAirport = 'Cairo International Airport',
  });

  @override
  List<Object?> get props => [
        id,
        airline,
        flightNumberOutbound,
        outboundRoute,
        outboundDepartureTime,
        outboundArrivalTime,
        outboundAirport,
        flightNumberReturn,
        returnRoute,
        returnDepartureTime,
        returnArrivalTime,
        returnAirport,
      ];
}
