//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class FlightsApi {
  FlightsApi([ApiClient? apiClient])
      : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Create a flight.
  ///
  /// Register a new flight for the authenticated user.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [FlightCreate] flightCreate (required):
  ///   Flight details including required glider and spots references
  Future<Response> createFlightWithHttpInfo(
    FlightCreate flightCreate,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/flights';

    // ignore: prefer_final_locals
    Object? postBody = flightCreate;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];

    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Create a flight.
  ///
  /// Register a new flight for the authenticated user.
  ///
  /// Parameters:
  ///
  /// * [FlightCreate] flightCreate (required):
  ///   Flight details including required glider and spots references
  Future<Flight?> createFlight(
    FlightCreate flightCreate,
  ) async {
    final response = await createFlightWithHttpInfo(
      flightCreate,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'Flight',
      ) as Flight;
    }
    return null;
  }

  /// Delete a Flight by ID.
  ///
  /// Deletes a single flight by its ID.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] flightId (required):
  ///   ID of the flight to delete
  Future<Response> deleteFlightByIdWithHttpInfo(
    int flightId,
  ) async {
    // ignore: prefer_const_declarations
    final path =
        r'/flights/{flightId}'.replaceAll('{flightId}', flightId.toString());

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];

    return apiClient.invokeAPI(
      path,
      'DELETE',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Delete a Flight by ID.
  ///
  /// Deletes a single flight by its ID.
  ///
  /// Parameters:
  ///
  /// * [int] flightId (required):
  ///   ID of the flight to delete
  Future<void> deleteFlightById(
    int flightId,
  ) async {
    final response = await deleteFlightByIdWithHttpInfo(
      flightId,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Get a Flight by ID.
  ///
  /// Returns a single flight by its ID.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] flightId (required):
  ///   ID of the flight to retrieve
  Future<Response> getFlightByIdWithHttpInfo(
    int flightId,
  ) async {
    // ignore: prefer_const_declarations
    final path =
        r'/flights/{flightId}'.replaceAll('{flightId}', flightId.toString());

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];

    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get a Flight by ID.
  ///
  /// Returns a single flight by its ID.
  ///
  /// Parameters:
  ///
  /// * [int] flightId (required):
  ///   ID of the flight to retrieve
  Future<Flight?> getFlightById(
    int flightId,
  ) async {
    final response = await getFlightByIdWithHttpInfo(
      flightId,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'Flight',
      ) as Flight;
    }
    return null;
  }

  /// Get IGC file data for a flight
  ///
  /// Returns the complete IGC file data including metadata and binary content for a specific flight. Returns 404 if the flight exists but has no IGC file.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] flightId (required):
  ///   ID of the flight to retrieve IGC data for
  Future<Response> getFlightIgcWithHttpInfo(
    int flightId,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/flights/{flightId}/igc'
        .replaceAll('{flightId}', flightId.toString());

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];

    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get IGC file data for a flight
  ///
  /// Returns the complete IGC file data including metadata and binary content for a specific flight. Returns 404 if the flight exists but has no IGC file.
  ///
  /// Parameters:
  ///
  /// * [int] flightId (required):
  ///   ID of the flight to retrieve IGC data for
  Future<IgcData?> getFlightIgc(
    int flightId,
  ) async {
    final response = await getFlightIgcWithHttpInfo(
      flightId,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'IgcData',
      ) as IgcData;
    }
    return null;
  }

  /// Get the processed track data for a flight
  ///
  /// Returns processed track data including timestamped coordinates, altitude, speed,  and vertical rates calculated from the IGC file. Optimized for map display and  compatible with flutter_map package. Returns 404 if flight exists but has no IGC data.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] flightId (required):
  ///   ID of the flight to retrieve track data for
  Future<Response> getFlightTrackWithHttpInfo(
    int flightId,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/flights/{flightId}/track'
        .replaceAll('{flightId}', flightId.toString());

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];

    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get the processed track data for a flight
  ///
  /// Returns processed track data including timestamped coordinates, altitude, speed,  and vertical rates calculated from the IGC file. Optimized for map display and  compatible with flutter_map package. Returns 404 if flight exists but has no IGC data.
  ///
  /// Parameters:
  ///
  /// * [int] flightId (required):
  ///   ID of the flight to retrieve track data for
  Future<FlightTrack?> getFlightTrack(
    int flightId,
  ) async {
    final response = await getFlightTrackWithHttpInfo(
      flightId,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'FlightTrack',
      ) as FlightTrack;
    }
    return null;
  }

  /// Find all flights.
  ///
  /// Returns a list of all flights for the authenticated user.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> getFlightsWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/flights';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];

    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Find all flights.
  ///
  /// Returns a list of all flights for the authenticated user.
  Future<List<Flight>?> getFlights() async {
    final response = await getFlightsWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      // print the response body
      print(responseBody);
      return (await apiClient.deserializeAsync(responseBody, 'List<Flight>')
              as List)
          .cast<Flight>()
          .toList(growable: false);
    }
    return null;
  }

  /// Update a Flight by ID.
  ///
  /// Updates a single flight with the provided data.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] flightId (required):
  ///   ID of the flight to update
  ///
  /// * [FlightUpdate] flightUpdate (required):
  ///   Updated flight information
  Future<Response> updateFlightByIdWithHttpInfo(
    int flightId,
    FlightUpdate flightUpdate,
  ) async {
    // ignore: prefer_const_declarations
    final path =
        r'/flights/{flightId}'.replaceAll('{flightId}', flightId.toString());

    // ignore: prefer_final_locals
    Object? postBody = flightUpdate;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];

    return apiClient.invokeAPI(
      path,
      'PUT',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Update a Flight by ID.
  ///
  /// Updates a single flight with the provided data.
  ///
  /// Parameters:
  ///
  /// * [int] flightId (required):
  ///   ID of the flight to update
  ///
  /// * [FlightUpdate] flightUpdate (required):
  ///   Updated flight information
  Future<Flight?> updateFlightById(
    int flightId,
    FlightUpdate flightUpdate,
  ) async {
    final response = await updateFlightByIdWithHttpInfo(
      flightId,
      flightUpdate,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'Flight',
      ) as Flight;
    }
    return null;
  }
}
