import 'package:floaty/user_service.dart';

class Flight {
  final String flightId;
  final User user;
  final String date;
  final String takeoff;
  final int duration;

  Flight({
    required this.flightId,
    required this.user,
    required this.date,
    required this.takeoff,
    required this.duration,
  });

  factory Flight.fromJson(Map<String, dynamic> json, User user) {
    return Flight(
      flightId: json['flightId'],
      user: user,
      date: json['date'],
      takeoff: json['takeoff'],
      duration: json['duration'],
    );
  }

  Map<String, dynamic> toJson() => {
    if (flightId != null) 'flightId': flightId,
    'userId': user.id, // Extract only the userId when converting back to JSON
    'date': date,
    'takeoff': takeoff,
    if (duration != null) 'duration': duration,
  };
}

class User {
  int id;
  String name;

  User({required this.id, required this.name});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: int.parse(json['id']),
      name: json['name'],
    );
  }
}
