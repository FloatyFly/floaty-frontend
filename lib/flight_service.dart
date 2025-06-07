import 'dart:convert';
import 'package:floaty_client/api.dart' as api;
import 'package:http/http.dart' as http;

import 'CookieAuth.dart';
import 'constants.dart';
import 'model.dart' as model;

Future<List<model.Flight>> fetchFlights(
  int userId,
  CookieAuth cookieAuth,
) async {
  final apiClient = api.ApiClient(
    basePath: backendUrl,
    authentication: cookieAuth,
  );
  final flightsApi = api.FlightsApi(apiClient);

  try {
    final List<api.Flight>? response = await flightsApi.getFlights();

    if (response != null && response.isNotEmpty) {
      // Map the fetched flights to your model and return
      return response
          .map((flight) => model.Flight.fromJson(flight.toJson()))
          .toList();
    } else {
      // Return an empty list when no flights are found
      return [];
    }
  } catch (e) {
    // Handle any errors that occur during the fetch operation
    // Log the error and return an empty list for consistency
    print('Error fetching flights: $e');
    return [];
  }
}

Future<api.Flight?> addFlight(
  model.Flight flight,
  CookieAuth cookieAuth,
) async {
  final apiClient = api.ApiClient(
    basePath: backendUrl,
    authentication: cookieAuth,
  );
  final flightsApi = api.FlightsApi(apiClient);

  api.Flight? flightDto = api.Flight.fromJson(flight.toJson());
  if (flightDto == null) {
    throw Exception('Failed to convert flight to DTO.');
  }

  try {
    final response = await flightsApi.createFlightWithHttpInfo(flightDto);
    if (response.statusCode == 201) {
      return await flightsApi.createFlight(flightDto);
    } else {
      throw Exception('Failed to add flight: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to add flight: $e');
  }
}

Future<void> deleteFlight(int flightId, CookieAuth cookieAuth) async {
  final apiClient = api.ApiClient(
    basePath: backendUrl,
    authentication: cookieAuth,
  );
  final flightsApi = api.FlightsApi(apiClient);

  try {
    await flightsApi.deleteFlightById(flightId);
  } catch (e) {
    throw Exception('Failed to delete flight: $e');
  }
}

Future<void> updateFlight(model.Flight flight, CookieAuth cookieAuth) async {
  final apiClient = api.ApiClient(
    basePath: backendUrl,
    authentication: cookieAuth,
  );
  final flightsApi = api.FlightsApi(apiClient);

  // Create FlightUpdate object with all required fields
  final flightUpdate = api.FlightUpdate(
    dateTime: DateTime.parse(flight.dateTime),
    launchSpotId: flight.launchSpotId,
    landingSpotId: flight.landingSpotId,
    duration: flight.duration,
    description: flight.description,
    gliderId: flight.gliderId,
  );

  try {
    await flightsApi.updateFlightById(flight.flightId, flightUpdate);
  } catch (e) {
    throw Exception('Failed to update flight: $e');
  }
}
