//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class SpotsApi {
  SpotsApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Create a new spot.
  ///
  /// Add a new paragliding spot to the database for the authenticated user.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [SpotCreate] spotCreate (required):
  ///   Spot details
  Future<Response> createSpotWithHttpInfo(
    SpotCreate spotCreate,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/spots';

    // ignore: prefer_final_locals
    Object? postBody = spotCreate;

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

  /// Create a new spot.
  ///
  /// Add a new paragliding spot to the database for the authenticated user.
  ///
  /// Parameters:
  ///
  /// * [SpotCreate] spotCreate (required):
  ///   Spot details
  Future<Spot?> createSpot(
    SpotCreate spotCreate,
  ) async {
    final response = await createSpotWithHttpInfo(
      spotCreate,
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
        'Spot',
      ) as Spot;
    }
    return null;
  }

  /// Delete a spot by ID.
  ///
  /// Deletes a single paragliding spot by its ID.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] spotId (required):
  ///   ID of the spot to delete
  Future<Response> deleteSpotByIdWithHttpInfo(
    int spotId,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/spots/{spotId}'.replaceAll('{spotId}', spotId.toString());

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

  /// Delete a spot by ID.
  ///
  /// Deletes a single paragliding spot by its ID.
  ///
  /// Parameters:
  ///
  /// * [int] spotId (required):
  ///   ID of the spot to delete
  Future<void> deleteSpotById(
    int spotId,
  ) async {
    final response = await deleteSpotByIdWithHttpInfo(
      spotId,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Get a spot by ID.
  ///
  /// Returns a single paragliding spot by its ID.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] spotId (required):
  ///   ID of the spot to retrieve
  Future<Response> getSpotByIdWithHttpInfo(
    int spotId,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/spots/{spotId}'.replaceAll('{spotId}', spotId.toString());

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

  /// Get a spot by ID.
  ///
  /// Returns a single paragliding spot by its ID.
  ///
  /// Parameters:
  ///
  /// * [int] spotId (required):
  ///   ID of the spot to retrieve
  Future<Spot?> getSpotById(
    int spotId,
  ) async {
    final response = await getSpotByIdWithHttpInfo(
      spotId,
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
        'Spot',
      ) as Spot;
    }
    return null;
  }

  /// Get all spots.
  ///
  /// Returns a list of all paragliding spots (launch and landing sites) for the authenticated user.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> getSpotsWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/spots';

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

  /// Get all spots.
  ///
  /// Returns a list of all paragliding spots (launch and landing sites) for the authenticated user.
  Future<List<Spot>?> getSpots() async {
    final response = await getSpotsWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<Spot>')
              as List)
          .cast<Spot>()
          .toList(growable: false);
    }
    return null;
  }

  /// Update a spot by ID.
  ///
  /// Updates a single paragliding spot with the provided data.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] spotId (required):
  ///   ID of the spot to update
  ///
  /// * [SpotUpdate] spotUpdate (required):
  ///   Updated spot information
  Future<Response> updateSpotByIdWithHttpInfo(
    int spotId,
    SpotUpdate spotUpdate,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/spots/{spotId}'.replaceAll('{spotId}', spotId.toString());

    // ignore: prefer_final_locals
    Object? postBody = spotUpdate;

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

  /// Update a spot by ID.
  ///
  /// Updates a single paragliding spot with the provided data.
  ///
  /// Parameters:
  ///
  /// * [int] spotId (required):
  ///   ID of the spot to update
  ///
  /// * [SpotUpdate] spotUpdate (required):
  ///   Updated spot information
  Future<Spot?> updateSpotById(
    int spotId,
    SpotUpdate spotUpdate,
  ) async {
    final response = await updateSpotByIdWithHttpInfo(
      spotId,
      spotUpdate,
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
        'Spot',
      ) as Spot;
    }
    return null;
  }
}
