//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

import 'package:floaty_client/api.dart';
import 'package:test/test.dart';


/// tests for FlightsApi
void main() {
  // final instance = FlightsApi();

  group('tests for FlightsApi', () {
    // Create a flight.
    //
    // Register a new flight for the authenticated user.
    //
    //Future<Flight> createFlight(FlightCreate flightCreate) async
    test('test createFlight', () async {
      // TODO
    });

    // Delete a Flight by ID.
    //
    // Deletes a single flight by its ID.
    //
    //Future deleteFlightById(int flightId) async
    test('test deleteFlightById', () async {
      // TODO
    });

    // Get a Flight by ID.
    //
    // Returns a single flight by its ID.
    //
    //Future<Flight> getFlightById(int flightId) async
    test('test getFlightById', () async {
      // TODO
    });

    // Get IGC file data for a flight
    //
    // Returns the complete IGC file data including metadata and binary content for a specific flight. Returns 404 if the flight exists but has no IGC file.
    //
    //Future<IgcData> getFlightIgc(int flightId) async
    test('test getFlightIgc', () async {
      // TODO
    });

    // Get the processed track data for a flight
    //
    // Returns processed track data including timestamped coordinates, altitude, speed,  and vertical rates calculated from the IGC file. Optimized for map display and  compatible with flutter_map package. Returns 404 if flight exists but has no IGC data. 
    //
    //Future<FlightTrack> getFlightTrack(int flightId) async
    test('test getFlightTrack', () async {
      // TODO
    });

    // Find all flights.
    //
    // Returns a list of all flights for the authenticated user.
    //
    //Future<List<Flight>> getFlights() async
    test('test getFlights', () async {
      // TODO
    });

    // Update a Flight by ID.
    //
    // Updates a single flight with the provided data.
    //
    //Future<Flight> updateFlightById(int flightId, FlightUpdate flightUpdate) async
    test('test updateFlightById', () async {
      // TODO
    });

  });
}
