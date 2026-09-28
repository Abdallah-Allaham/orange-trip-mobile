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
    super.outboundTerminal,
    super.outboundBaggage,
    super.flightNumberReturn,
    super.returnRoute,
    super.returnDepartureTime,
    super.returnArrivalTime,
    super.returnAirport,
    super.returnTerminal,
    super.returnBaggage,
    super.bookingReference,
    super.ticketStatus,
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
      outboundTerminal: json['outboundTerminal'] ?? json['OutboundTerminal'] ?? 'Terminal 1',
      outboundBaggage: json['outboundBaggage'] ?? json['OutboundBaggage'] ?? '1 x 23kg checked + 7kg cabin',
      flightNumberReturn: json['flightNumberReturn'] ?? json['FlightNumberReturn'] ?? 'RJ 506',
      returnRoute: json['returnRoute'] ?? json['ReturnRoute'] ?? 'Cairo (CAI) → Amman (AMM)',
      returnDepartureTime: json['returnDepartureTime'] ?? json['ReturnDepartureTime'] ?? '2026-11-05 19:00',
      returnArrivalTime: json['returnArrivalTime'] ?? json['ReturnArrivalTime'] ?? '2026-11-05 21:15',
      returnAirport: json['returnAirport'] ?? json['ReturnAirport'] ?? 'Cairo International Airport',
      returnTerminal: json['returnTerminal'] ?? json['ReturnTerminal'] ?? 'Terminal 2',
      returnBaggage: json['returnBaggage'] ?? json['ReturnBaggage'] ?? '1 x 23kg checked + 7kg cabin',
      bookingReference: json['bookingReference'] ?? json['BookingReference'] ?? 'RJ-ORG-7788',
      ticketStatus: json['ticketStatus'] ?? json['TicketStatus'] ?? 'Ticketed',
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
      'outboundTerminal': outboundTerminal,
      'outboundBaggage': outboundBaggage,
      'flightNumberReturn': flightNumberReturn,
      'returnRoute': returnRoute,
      'returnDepartureTime': returnDepartureTime,
      'returnArrivalTime': returnArrivalTime,
      'returnAirport': returnAirport,
      'returnTerminal': returnTerminal,
      'returnBaggage': returnBaggage,
      'bookingReference': bookingReference,
      'ticketStatus': ticketStatus,
    };
  }
}
