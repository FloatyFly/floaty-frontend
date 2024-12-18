import 'package:floaty_client/api.dart';

class Flight {
  final String flightId;
  final String dateTime;
  final String takeOff;
  final int duration;
  final String description;

  Flight({
    required this.flightId,
    required this.dateTime,
    required this.takeOff,
    required this.duration,
    this.description = ''
  });

  factory Flight.fromJson(Map<String, dynamic> json) {
    return Flight(
      flightId: json['flightId'],
      dateTime: json['dateTime'],
      takeOff: json['takeOff'],
      duration: json['duration'],
      description: json['description']
    );
  }

  Flight empty() {
    return Flight(
      flightId: "",
      dateTime: "",
      takeOff: "",
      duration: 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "flightId": flightId,
        "dateTime": dateTime,
        "takeOff": takeOff,
        "duration": duration,
      };
}

class FloatyUser {
  int id;
  String name;
  bool emailVerified;

  FloatyUser({required this.id, required this.name, required this.emailVerified});

  factory FloatyUser.fromUserDto(User userDto) {
    return FloatyUser(
      id: int.parse(userDto.id),
      name: userDto.name,
      emailVerified: userDto.emailVerified
    );
  }

  factory FloatyUser.fromJson(Map<String, dynamic> json) {
    return FloatyUser(
      id: int.parse(json['id']),
      name: json['name'],
      emailVerified: bool.parse(json['emailVerified'])
    );
  }
}
