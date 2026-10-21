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
      airline: json['airline'] ?? json['Airline'] ?? '',
      flightNumberOutbound: json['flightNumberOutbound'] ?? json['FlightNumberOutbound'] ?? '',
      outboundRoute: json['outboundRoute'] ?? json['OutboundRoute'] ?? '',
      outboundDepartureTime: json['outboundDepartureTime'] ?? json['OutboundDepartureTime'] ?? '',
      outboundArrivalTime: json['outboundArrivalTime'] ?? json['OutboundArrivalTime'] ?? '',
      outboundAirport: json['outboundAirport'] ?? json['OutboundAirport'] ?? '',
      flightNumberReturn: json['flightNumberReturn'] ?? json['FlightNumberReturn'] ?? '',
      returnRoute: json['returnRoute'] ?? json['ReturnRoute'] ?? '',
      returnDepartureTime: json['returnDepartureTime'] ?? json['ReturnDepartureTime'] ?? '',
      returnArrivalTime: json['returnArrivalTime'] ?? json['ReturnArrivalTime'] ?? '',
      returnAirport: json['returnAirport'] ?? json['ReturnAirport'] ?? '',
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
