# floaty_client.api.AuthApi

## Load the API package
```dart
import 'package:floaty_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**authVerifyEmailEmailVerificationTokenPost**](AuthApi.md#authverifyemailemailverificationtokenpost) | **POST** /auth/verify-email/{emailVerificationToken} | Verify an Email.
[**getCurrentUser**](AuthApi.md#getcurrentuser) | **GET** /auth/me | Get current authenticated user.
[**initiatePasswordReset**](AuthApi.md#initiatepasswordreset) | **POST** /auth/initiate-password-reset | Request a password reset initiation mail.
[**loginUser**](AuthApi.md#loginuser) | **POST** /auth/login | Login a user.
[**logoutUser**](AuthApi.md#logoutuser) | **POST** /auth/logout | Logout the user.
[**registerUser**](AuthApi.md#registeruser) | **POST** /auth/register | Register a new user.
[**resetPassword**](AuthApi.md#resetpassword) | **POST** /auth/reset-password | Reset a password.


# **authVerifyEmailEmailVerificationTokenPost**
> String authVerifyEmailEmailVerificationTokenPost(emailVerificationToken)

Verify an Email.

Verifies a user's email using the provided token.

### Example
```dart
import 'package:floaty_client/api.dart';

final api_instance = AuthApi();
final emailVerificationToken = some-generated-uuid-from-mailbox; // String | Token for email verification

try {
    final result = api_instance.authVerifyEmailEmailVerificationTokenPost(emailVerificationToken);
    print(result);
} catch (e) {
    print('Exception when calling AuthApi->authVerifyEmailEmailVerificationTokenPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **emailVerificationToken** | **String**| Token for email verification | 

### Return type

**String**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getCurrentUser**
> User getCurrentUser()

Get current authenticated user.

Returns the current user's information based on the session cookie. Used for session validation and restoration.

### Example
```dart
import 'package:floaty_client/api.dart';

final api_instance = AuthApi();

try {
    final result = api_instance.getCurrentUser();
    print(result);
} catch (e) {
    print('Exception when calling AuthApi->getCurrentUser: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**User**](User.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **initiatePasswordReset**
> initiatePasswordReset(body)

Request a password reset initiation mail.

Hitting this endpoint will send a mail to the given email (if exists) with the possibility to reset a password.

### Example
```dart
import 'package:floaty_client/api.dart';

final api_instance = AuthApi();
final body = String(); // String | The email adress attached to a user to reset the password for.

try {
    api_instance.initiatePasswordReset(body);
} catch (e) {
    print('Exception when calling AuthApi->initiatePasswordReset: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | **String**| The email adress attached to a user to reset the password for. | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **loginUser**
> User loginUser(loginRequest)

Login a user.

Authenticates a user and returns a session cookie or token.

### Example
```dart
import 'package:floaty_client/api.dart';

final api_instance = AuthApi();
final loginRequest = LoginRequest(); // LoginRequest | User login credentials.

try {
    final result = api_instance.loginUser(loginRequest);
    print(result);
} catch (e) {
    print('Exception when calling AuthApi->loginUser: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **loginRequest** | [**LoginRequest**](LoginRequest.md)| User login credentials. | 

### Return type

[**User**](User.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **logoutUser**
> logoutUser()

Logout the user.

Logs out the authenticated user and invalidates the session.

### Example
```dart
import 'package:floaty_client/api.dart';

final api_instance = AuthApi();

try {
    api_instance.logoutUser();
} catch (e) {
    print('Exception when calling AuthApi->logoutUser: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **registerUser**
> User registerUser(registerRequest)

Register a new user.

Creates a new user with a username and password.

### Example
```dart
import 'package:floaty_client/api.dart';

final api_instance = AuthApi();
final registerRequest = RegisterRequest(); // RegisterRequest | User registration details.

try {
    final result = api_instance.registerUser(registerRequest);
    print(result);
} catch (e) {
    print('Exception when calling AuthApi->registerUser: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **registerRequest** | [**RegisterRequest**](RegisterRequest.md)| User registration details. | 

### Return type

[**User**](User.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **resetPassword**
> resetPassword(resetPasswordRequest)

Reset a password.

Reset a password for a user with a given reset password token.

### Example
```dart
import 'package:floaty_client/api.dart';

final api_instance = AuthApi();
final resetPasswordRequest = ResetPasswordRequest(); // ResetPasswordRequest | The password request item.

try {
    api_instance.resetPassword(resetPasswordRequest);
} catch (e) {
    print('Exception when calling AuthApi->resetPassword: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **resetPasswordRequest** | [**ResetPasswordRequest**](ResetPasswordRequest.md)| The password request item. | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

