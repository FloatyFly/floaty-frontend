import 'package:floaty_client/api.dart';

class Flight {
  final int flightId;
  final String dateTime;
  final int launchSpotId;
  final int landingSpotId;
  final int duration;
  final String description;
  final int gliderId;
  final IgcMetadata? igcMetadata;

  Flight({
    required this.flightId,
    required this.dateTime,
    required this.launchSpotId,
    required this.landingSpotId,
    required this.duration,
    required this.gliderId,
    required this.description,
    this.igcMetadata,
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
      igcMetadata:
          json['igcMetadata'] != null
              ? IgcMetadata.fromJson(json['igcMetadata'])
              : null,
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
      description: '',
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
    "igcMetadata": igcMetadata?.toJson(),
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
      id: userDto.id,
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
