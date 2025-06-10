//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class GlidersApi {
  GlidersApi([ApiClient? apiClient])
      : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Create a new glider.
  ///
  /// Add a new glider to the database for the authenticated user.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [GliderCreate] gliderCreate (required):
  ///   Glider details
  Future<Response> createGliderWithHttpInfo(
    GliderCreate gliderCreate,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/gliders';

    // ignore: prefer_final_locals
    Object? postBody = gliderCreate;

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

  /// Create a new glider.
  ///
  /// Add a new glider to the database for the authenticated user.
  ///
  /// Parameters:
  ///
  /// * [GliderCreate] gliderCreate (required):
  ///   Glider details
  Future<Glider?> createGlider(
    GliderCreate gliderCreate,
  ) async {
    final response = await createGliderWithHttpInfo(
      gliderCreate,
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
        'Glider',
      ) as Glider;
    }
    return null;
  }

  /// Delete a glider by ID.
  ///
  /// Deletes a single glider by its ID.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] gliderId (required):
  ///   ID of the glider to delete
  Future<Response> deleteGliderByIdWithHttpInfo(
    int gliderId,
  ) async {
    // ignore: prefer_const_declarations
    final path =
        r'/gliders/{gliderId}'.replaceAll('{gliderId}', gliderId.toString());

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

  /// Delete a glider by ID.
  ///
  /// Deletes a single glider by its ID.
  ///
  /// Parameters:
  ///
  /// * [int] gliderId (required):
  ///   ID of the glider to delete
  Future<void> deleteGliderById(
    int gliderId,
  ) async {
    final response = await deleteGliderByIdWithHttpInfo(
      gliderId,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Get all gliders.
  ///
  /// Returns a list of all gliders for the authenticated user.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> getAllGlidersWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/gliders';

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

  /// Get all gliders.
  ///
  /// Returns a list of all gliders for the authenticated user.
  Future<List<Glider>?> getAllGliders() async {
    final response = await getAllGlidersWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<Glider>')
              as List)
          .cast<Glider>()
          .toList(growable: false);
    }
    return null;
  }

  /// Get a glider by ID.
  ///
  /// Returns a single glider by its ID.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] gliderId (required):
  ///   ID of the glider to retrieve
  Future<Response> getGliderByIdWithHttpInfo(
    int gliderId,
  ) async {
    // ignore: prefer_const_declarations
    final path =
        r'/gliders/{gliderId}'.replaceAll('{gliderId}', gliderId.toString());

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

  /// Get a glider by ID.
  ///
  /// Returns a single glider by its ID.
  ///
  /// Parameters:
  ///
  /// * [int] gliderId (required):
  ///   ID of the glider to retrieve
  Future<Glider?> getGliderById(
    int gliderId,
  ) async {
    final response = await getGliderByIdWithHttpInfo(
      gliderId,
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
        'Glider',
      ) as Glider;
    }
    return null;
  }

  /// Update a glider by ID.
  ///
  /// Updates a single glider with the provided data.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] gliderId (required):
  ///   ID of the glider to update
  ///
  /// * [GliderUpdate] gliderUpdate (required):
  ///   Updated glider information
  Future<Response> updateGliderByIdWithHttpInfo(
    int gliderId,
    GliderUpdate gliderUpdate,
  ) async {
    // ignore: prefer_const_declarations
    final path =
        r'/gliders/{gliderId}'.replaceAll('{gliderId}', gliderId.toString());

    // ignore: prefer_final_locals
    Object? postBody = gliderUpdate;

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

  /// Update a glider by ID.
  ///
  /// Updates a single glider with the provided data.
  ///
  /// Parameters:
  ///
  /// * [int] gliderId (required):
  ///   ID of the glider to update
  ///
  /// * [GliderUpdate] gliderUpdate (required):
  ///   Updated glider information
  Future<Glider?> updateGliderById(
    int gliderId,
    GliderUpdate gliderUpdate,
  ) async {
    final response = await updateGliderByIdWithHttpInfo(
      gliderId,
      gliderUpdate,
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
        'Glider',
      ) as Glider;
    }
    return null;
  }
}
