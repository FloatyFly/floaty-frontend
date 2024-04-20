class Flight {
  final String flightId;
  final FloatyUser user;
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

  factory Flight.fromJson(Map<String, dynamic> json, FloatyUser user) {
    return Flight(
      flightId: json['flightId'],
      user: user,
      date: json['date'],
      takeoff: json['takeoff'],
      duration: json['duration'],
    );
  }

  Flight empty() {
    return Flight(
      flightId: "",
      user: FloatyUser(id: 0, name: ""),
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

  FloatyUser({required this.id, required this.name});

  factory FloatyUser.fromJson(Map<String, dynamic> json) {
    return FloatyUser(
      id: int.parse(json['id']),
      name: json['name'],
    );
  }
}
