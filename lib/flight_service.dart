import 'package:floaty/user_service.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'dart:math';

import 'constants.dart';
import 'model.dart';


Future<List<Flight>> fetchFlights() async {

  final response = await http.get(Uri.parse('$BASE_URL/flights'));

  if (response.statusCode == 200) {
    List<dynamic> list = json.decode(response.body);

    Iterable<Future<Flight>> flightsFutures = list.map((flight) => createFlightFromJson(flight));

    return await Future.wait(flightsFutures);
  } else {
    throw Exception('Failed to load flights');
  }
}

Future<Flight> createFlightFromJson(Map<String, dynamic> json) async {
  User user = await fetchUserById(json['userId'].toString());
  return Flight.fromJson(json, user);
}

Future<void> addRandomFlight() async {
  var flightJson = generateFlightJson();
  print(flightJson);
  final response = await http.post(
    Uri.parse('$BASE_URL/flights'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: flightJson,
  );

  if (response.statusCode != 201 && response.statusCode != 200) {
    print(response.body);

    throw Exception('Failed to add flight');
  }
}

Future<void> deleteFlight(String flightId) async {
  final response = await http.delete(
    Uri.parse('$BASE_URL/flights/$flightId'),
  );

  if (response.statusCode != 200 && response.statusCode != 204) {
    // Note: HTTP status code 204 means No Content, which is typically returned
    // for successful DELETE requests without returning any content.
    throw Exception('Failed to delete flight');
  }
}

String generateFlightJson() {
  final random = Random();

  // List of city names
  final cities = ["New York", "Los Angeles", "Chicago", "Houston", "Phoenix", "Philadelphia", "San Antonio"];

  // Generate random city
  final takeoff = cities[random.nextInt(cities.length)];

  // Generate random date within a range (e.g., within 2023)
  final day = random.nextInt(28) + 1;  // for simplicity, assuming all months have 28 days
  final month = random.nextInt(12) + 1;
  final date = "$day.$month.2023";  // for simplicity, fixing day to 01

  // Other random data
  final userId = (random.nextInt(3) + 1).toString();
  final flightId = Uuid().v4();  // using uuid package for generating UUID
  final duration = random.nextInt(91) + 10;  // Random number between 10 and 100

  var flight = {
    "userId": userId,
    "date": date,
    "takeoff": takeoff,
    "duration": duration.toString(),
  };

  return jsonEncode(flight);
}