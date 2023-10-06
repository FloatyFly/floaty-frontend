import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'dart:math';

import 'model.dart';

Future<List<Flight>> fetchFlights() async {
  final response = await http.get(Uri.parse('https://floaty-backend-floaty-backend.azuremicroservices.io/flights'));

  if (response.statusCode == 200) {
    Iterable list = json.decode(response.body);
    print(list);
    var flights = list.map((model) => Flight.fromJson(model)).toList();
    return flights;
  } else {
    throw Exception('Failed to load flights');
  }
}

Future<void> addRandomFlight() async {
  var flightJson = generateFlightJson();

  final response = await http.post(
    Uri.parse('https://floaty-backend-floaty-backend.azuremicroservices.io/flights'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: flightJson,
  );
  print(response.body);
  if (response.statusCode != 201 && response.statusCode != 200) {
    // Note: HTTP status code 201 means Created, which is typically returned
    // for successful POST requests that result in creation.
    throw Exception('Failed to add flight');
  }
}

Future<void> deleteFlight(int flightId) async {
  print("deleting flight $flightId");
  final response = await http.delete(
    Uri.parse('https://floaty-backend-floaty-backend.azuremicroservices.io/flights/$flightId'),
  );
  print(response.body);

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
  final date = "01.$month.2023";  // for simplicity, fixing day to 01

  // Other random data
  final userId = (random.nextInt(3) + 1).toString();
  final flightId = Uuid().v4();  // using uuid package for generating UUID
  final duration = random.nextInt(91) + 10;  // Random number between 10 and 100

  var flight = {
    "userid": userId,
    "date": date,
    "takeoff": takeoff,
    "duration": duration.toString(),
  };

  return jsonEncode(flight);
}