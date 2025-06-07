import 'package:floaty_client/api.dart';

class Flight {
  final int flightId;
  final String dateTime;
  final int launchSpotId;
  final int landingSpotId;
  final int duration;
  final String description;
  final int gliderId;

  Flight({
    required this.flightId,
    required this.dateTime,
    required this.launchSpotId,
    required this.landingSpotId,
    required this.duration,
    required this.gliderId,
    this.description = '',
  });

  factory Flight.fromJson(Map<String, dynamic> json) {
    return Flight(
      flightId: json['flightId'],
      dateTime: json['dateTime'],
      launchSpotId: json['launchSpotId'],
      landingSpotId: json['landingSpotId'],
      duration: json['duration'],
      gliderId: json['gliderId'],
      description: json['description'] ?? '',
    );
  }

  Flight empty() {
    return Flight(
      flightId: 0,
      dateTime: "",
      launchSpotId: 0,
      landingSpotId: 0,
      duration: 0,
      gliderId: 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "flightId": flightId,
    "dateTime": dateTime,
    "launchSpotId": launchSpotId,
    "landingSpotId": landingSpotId,
    "duration": duration,
    "gliderId": gliderId,
    "description": description,
  };
}

class FloatyUser {
  int id;
  String name;
  String email;
  bool emailVerified;

  FloatyUser({
    required this.id,
    required this.name,
    required this.email,
    required this.emailVerified,
  });

  factory FloatyUser.fromUserDto(User userDto) {
    return FloatyUser(
      id: int.parse(userDto.id),
      name: userDto.name,
      email: userDto.email,
      emailVerified: userDto.emailVerified,
    );
  }

  factory FloatyUser.fromJson(Map<String, dynamic> json) {
    return FloatyUser(
      id: int.parse(json['id']),
      name: json['name'],
      email: json['email'],
      emailVerified: bool.parse(json['emailVerified']),
    );
  }
}
