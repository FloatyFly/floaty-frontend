//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class AuthApi {
  AuthApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Verify an Email.
  ///
  /// Verifies a user's email using the provided token.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] emailVerificationToken (required):
  ///   Token for email verification
  Future<Response> authVerifyEmailEmailVerificationTokenPostWithHttpInfo(String emailVerificationToken,) async {
    // ignore: prefer_const_declarations
    final path = r'/auth/verify-email/{emailVerificationToken}'
      .replaceAll('{emailVerificationToken}', emailVerificationToken);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


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

  /// Verify an Email.
  ///
  /// Verifies a user's email using the provided token.
  ///
  /// Parameters:
  ///
  /// * [String] emailVerificationToken (required):
  ///   Token for email verification
  Future<String?> authVerifyEmailEmailVerificationTokenPost(String emailVerificationToken,) async {
    final response = await authVerifyEmailEmailVerificationTokenPostWithHttpInfo(emailVerificationToken,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'String',) as String;
    
    }
    return null;
  }

  /// Request a password reset initiation mail.
  ///
  /// Hitting this endpoint will send a mail to the given email (if exists) with the possibility to reset a password.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] body (required):
  ///   The email adress attached to a user to reset the password for.
  Future<Response> initiatePasswordResetWithHttpInfo(String body,) async {
    // ignore: prefer_const_declarations
    final path = r'/auth/initiate-password-reset';

    // ignore: prefer_final_locals
    Object? postBody = body;

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

  /// Request a password reset initiation mail.
  ///
  /// Hitting this endpoint will send a mail to the given email (if exists) with the possibility to reset a password.
  ///
  /// Parameters:
  ///
  /// * [String] body (required):
  ///   The email adress attached to a user to reset the password for.
  Future<void> initiatePasswordReset(String body,) async {
    final response = await initiatePasswordResetWithHttpInfo(body,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Login a user.
  ///
  /// Authenticates a user and returns a session cookie or token.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [LoginRequest] loginRequest (required):
  ///   User login credentials.
  Future<Response> loginUserWithHttpInfo(LoginRequest loginRequest,) async {
    // ignore: prefer_const_declarations
    final path = r'/auth/login';

    // ignore: prefer_final_locals
    Object? postBody = loginRequest;

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

  /// Login a user.
  ///
  /// Authenticates a user and returns a session cookie or token.
  ///
  /// Parameters:
  ///
  /// * [LoginRequest] loginRequest (required):
  ///   User login credentials.
  Future<User?> loginUser(LoginRequest loginRequest,) async {
    final response = await loginUserWithHttpInfo(loginRequest,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'User',) as User;
    
    }
    return null;
  }

  /// Logout the user.
  ///
  /// Logs out the authenticated user and invalidates the session.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] userId (required):
  ///   ID of user
  Future<Response> logoutUserWithHttpInfo(int userId,) async {
    // ignore: prefer_const_declarations
    final path = r'/auth/logout/{userId}'
      .replaceAll('{userId}', userId.toString());

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


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

  /// Logout the user.
  ///
  /// Logs out the authenticated user and invalidates the session.
  ///
  /// Parameters:
  ///
  /// * [int] userId (required):
  ///   ID of user
  Future<void> logoutUser(int userId,) async {
    final response = await logoutUserWithHttpInfo(userId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Register a new user.
  ///
  /// Creates a new user with a username and password.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [RegisterRequest] registerRequest (required):
  ///   User registration details.
  Future<Response> registerUserWithHttpInfo(RegisterRequest registerRequest,) async {
    // ignore: prefer_const_declarations
    final path = r'/auth/register';

    // ignore: prefer_final_locals
    Object? postBody = registerRequest;

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

  /// Register a new user.
  ///
  /// Creates a new user with a username and password.
  ///
  /// Parameters:
  ///
  /// * [RegisterRequest] registerRequest (required):
  ///   User registration details.
  Future<User?> registerUser(RegisterRequest registerRequest,) async {
    final response = await registerUserWithHttpInfo(registerRequest,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'User',) as User;
    
    }
    return null;
  }

  /// Reset a password.
  ///
  /// Reset a password for a user with a given reset password token.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [ResetPasswordRequest] resetPasswordRequest (required):
  ///   The password request item.
  Future<Response> resetPasswordWithHttpInfo(ResetPasswordRequest resetPasswordRequest,) async {
    // ignore: prefer_const_declarations
    final path = r'/auth/reset-password';

    // ignore: prefer_final_locals
    Object? postBody = resetPasswordRequest;

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

  /// Reset a password.
  ///
  /// Reset a password for a user with a given reset password token.
  ///
  /// Parameters:
  ///
  /// * [ResetPasswordRequest] resetPasswordRequest (required):
  ///   The password request item.
  Future<void> resetPassword(ResetPasswordRequest resetPasswordRequest,) async {
    final response = await resetPasswordWithHttpInfo(resetPasswordRequest,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }
}
