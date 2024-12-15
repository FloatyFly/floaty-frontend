import 'package:floaty_client/api.dart';

class Flight {
  final String flightId;
  final FloatyUser user;
  final String date;
  final String takeoff;
  final int duration;
  final String description;

  Flight({
    required this.flightId,
    required this.user,
    required this.date,
    required this.takeoff,
    required this.duration,
    this.description = ''
  });

  factory Flight.fromJson(Map<String, dynamic> json, FloatyUser user) {
    return Flight(
      flightId: json['flightId'],
      user: user,
      date: json['date'],
      takeoff: json['takeoff'],
      duration: json['duration'],
      description: json['description']
    );
  }

  Flight empty() {
    return Flight(
      flightId: "",
      user: FloatyUser(id: 0, name: "", emailVerified: false),
      date: "",
      takeoff: "",
      duration: 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "flightId": flightId,
        "userId":
            user.id, // Extract only the userId when converting back to JSON
        "date": date,
        "takeoff": takeoff,
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
