import 'dart:convert';
import 'dart:io';
import 'package:floaty_client/api.dart' as api;

import '../config/CookieAuth.dart';
import '../config/constants.dart';
import '../models/model.dart' as model;

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
    final response = await flightsApi.getFlightsWithHttpInfo();
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => model.Flight.fromJson(json)).toList();
    } else {
      return [];
    }
  } catch (e) {
    print('Error fetching flights: $e');
    return [];
  }
}

Future<api.Flight> addFlight(model.Flight flight, CookieAuth cookieAuth) async {
  final apiClient = api.ApiClient(
    basePath: backendUrl,
    authentication: cookieAuth,
  );
  final flightsApi = api.FlightsApi(apiClient);

  // Create FlightCreate object with all required fields
  final flightCreate = api.FlightCreate(
    dateTime: DateTime.parse(flight.dateTime).toUtc(),
    launchSpotId: flight.launchSpotId,
    landingSpotId: flight.landingSpotId,
    duration: flight.duration,
    description: flight.description,
    gliderId: flight.gliderId,
  );

  try {
    final response = await flightsApi.createFlight(flightCreate);
    if (response == null) {
      throw Exception('Failed to create flight: No response from server');
    }
    return response;
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
    dateTime: DateTime.parse(flight.dateTime).toUtc(),
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

Future<api.FlightTrack?> fetchFlightTrack(
  int flightId,
  CookieAuth cookieAuth,
) async {
  final apiClient = api.ApiClient(
    basePath: backendUrl,
    authentication: cookieAuth,
  );
  final flightsApi = api.FlightsApi(apiClient);
  try {
    return await flightsApi.getFlightTrack(flightId);
  } catch (e) {
    print('Error fetching flight track: $e');
    return null;
  }
}

Future<api.Flight> addFlightWithIgc(
  model.Flight flight,
  File? igcFile,
  String? igcFileName,
  CookieAuth cookieAuth, {
  List<int>? igcBytes,
}) async {
  final apiClient = api.ApiClient(
    basePath: backendUrl,
    authentication: cookieAuth,
  );
  final flightsApi = api.FlightsApi(apiClient);

  // Create FlightCreate object with all required fields
  final flightCreate = api.FlightCreate(
    dateTime: DateTime.parse(flight.dateTime).toUtc(),
    launchSpotId: flight.launchSpotId,
    landingSpotId: flight.landingSpotId,
    duration: flight.duration,
    description: flight.description,
    gliderId: flight.gliderId,
  );

  // Add IGC data if file is provided
  if (igcFileName != null) {
    try {
      String igcContent;
      if (igcFile != null) {
        // Mobile/desktop platform - read from file
        igcContent = await igcFile.readAsString();
      } else if (igcBytes != null) {
        // Web platform - convert bytes to string
        igcContent = String.fromCharCodes(igcBytes);
      } else {
        throw Exception('No IGC file data provided');
      }

      // Encode the IGC content to base64
      final base64Content = base64Encode(utf8.encode(igcContent));

      flightCreate.igcDataCreate = api.IgcDataCreate(
        fileName: igcFileName,
        file: base64Content,
      );
    } catch (e) {
      throw Exception('Failed to read IGC file: $e');
    }
  }

  try {
    final response = await flightsApi.createFlight(flightCreate);
    if (response == null) {
      throw Exception('Failed to create flight: No response from server');
    }
    return response;
  } catch (e) {
    throw Exception('Failed to add flight: $e');
  }
}
