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

Future<api.Flight?> addFlight(model.Flight flight, CookieAuth cookieAuth) async {
  final apiClient = api.ApiClient(basePath: BASE_URL, authentication: cookieAuth);
  final flightsApi = api.FlightsApi(apiClient);

  api.Flight? flightDto = api.Flight.fromJson(flight.toJson());
  if (flightDto == null) {
    throw Exception('Failed to convert flight to DTO.');
  }

  try {
    return flightsApi.createFlight(flightDto);
  } catch (e) {
    throw Exception('Failed to add flight: $e');
  }
}
