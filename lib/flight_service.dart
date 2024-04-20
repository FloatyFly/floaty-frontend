import 'package:floaty/user_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'constants.dart';
import 'model.dart';

Future<List<Flight>> fetchFlights() async {
  final response = await http.get(Uri.parse('$BASE_URL/flights'));

  if (response.statusCode == 200) {
    List<dynamic> list = json.decode(response.body);

    Iterable<Future<Flight>> flightsFutures =
        list.map((flight) => createFlightFromJson(flight));

    return await Future.wait(flightsFutures);
  } else {
    throw Exception('Failed to load flights');
  }
}

Future<void> addFlight(String flightJson) async {
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

Future<Flight> createFlightFromJson(Map<String, dynamic> json) async {
  FloatyUser user = await fetchUserById(json['userId'].toString());
  return Flight.fromJson(json, user);
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
