import 'package:floaty/user_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:floaty_client/api.dart' as api;

import 'CookieAuth.dart';
import 'constants.dart';
import 'model.dart' as model;
import 'model.dart';

Future<List<model.Flight>> fetchFlights(int userId, CookieAuth cookieAuth) async {
  final apiClient = api.ApiClient(basePath: BASE_URL, authentication: cookieAuth);
  final flightsApi = api.FlightsApi(apiClient);

  try {
    final List<api.Flight>? response = await flightsApi.getFlights(userId);

    if (response != null && response.isNotEmpty) {
      return response.map((flight) => model.Flight.fromJson(flight.toJson())).toList();
    } else {
      throw Exception('No flights found');
    }
  } catch (e) {
    // Handle any errors that occur during the fetch operation
    throw Exception('Failed to load flights: $e');
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

Future<model.Flight> createFlightFromJson(Map<String, dynamic> json) async {
  FloatyUser user = await fetchUserById(json['userId'].toString());
  return Flight.fromJson(json);
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
