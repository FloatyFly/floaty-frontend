class Flight {
  int id;
  User user;
  String takeoff;
  int duration;
  String flightDate;

  Flight({
    required this.id,
    required this.user,
    required this.takeoff,
    required this.duration,
    required this.flightDate
  });

  factory Flight.fromJson(Map<String, dynamic> json) {
    return Flight(
      id: json['id'],
      user: User.fromJson(json['user']),
      takeoff: json['takeoff'],
      duration: json['duration'],
      flightDate: json['flightdate']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.id,
      'takeoff': takeoff,
      'duration': duration,
      // ... any other fields ...
    };
  }
}

class User {
  int id;
  String name;

  User({required this.id, required this.name});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
    );
  }
}
