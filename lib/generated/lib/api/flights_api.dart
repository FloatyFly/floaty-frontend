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
  FlightsApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Create a flight for a given user.
  ///
  /// Register a new flight
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [Flight] flight (required):
  ///   Optional description in *Markdown*
  Future<Response> createFlightWithHttpInfo(Flight flight,) async {
    // ignore: prefer_const_declarations
    final path = r'/flights';

    // ignore: prefer_final_locals
    Object? postBody = flight;

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

  /// Create a flight for a given user.
  ///
  /// Register a new flight
  ///
  /// Parameters:
  ///
  /// * [Flight] flight (required):
  ///   Optional description in *Markdown*
  Future<Flight?> createFlight(Flight flight,) async {
    final response = await createFlightWithHttpInfo(flight,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'Flight',) as Flight;
    
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
  /// * [String] flightId (required):
  ///   ID of the flight to delete
  Future<Response> deleteFlightByIdWithHttpInfo(String flightId,) async {
    // ignore: prefer_const_declarations
    final path = r'/flights/{flightId}'
      .replaceAll('{flightId}', flightId);

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
  /// * [String] flightId (required):
  ///   ID of the flight to delete
  Future<void> deleteFlightById(String flightId,) async {
    final response = await deleteFlightByIdWithHttpInfo(flightId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Find all flights.
  ///
  /// Returns a list of all Flights for all users.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> findAllFlightsWithHttpInfo() async {
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
  /// Returns a list of all Flights for all users.
  Future<List<Flight>?> findAllFlights() async {
    final response = await findAllFlightsWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<Flight>') as List)
        .cast<Flight>()
        .toList(growable: false);

    }
    return null;
  }

  /// Find all flights for a given User.
  ///
  /// Returns a list of Flights for a User.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] userId (required):
  ///   ID of user
  Future<Response> getFlightsWithHttpInfo(int userId,) async {
    // ignore: prefer_const_declarations
    final path = r'/flights/{userId}'
      .replaceAll('{userId}', userId.toString());

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

  /// Find all flights for a given User.
  ///
  /// Returns a list of Flights for a User.
  ///
  /// Parameters:
  ///
  /// * [int] userId (required):
  ///   ID of user
  Future<List<Flight>?> getFlights(int userId,) async {
    final response = await getFlightsWithHttpInfo(userId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<Flight>') as List)
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
  /// * [String] flightId (required):
  ///   ID of the flight to update
  ///
  /// * [FlightUpdate] flightUpdate (required):
  ///   Updated flight information
  Future<Response> updateFlightByIdWithHttpInfo(String flightId, FlightUpdate flightUpdate,) async {
    // ignore: prefer_const_declarations
    final path = r'/flights/{flightId}'
      .replaceAll('{flightId}', flightId);

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
  /// * [String] flightId (required):
  ///   ID of the flight to update
  ///
  /// * [FlightUpdate] flightUpdate (required):
  ///   Updated flight information
  Future<Flight?> updateFlightById(String flightId, FlightUpdate flightUpdate,) async {
    final response = await updateFlightByIdWithHttpInfo(flightId, flightUpdate,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'Flight',) as Flight;
    
    }
    return null;
  }
}
