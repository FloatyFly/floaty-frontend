# floaty_client.api.UsersApi

## Load the API package
```dart
import 'package:floaty_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**findUserById**](UsersApi.md#finduserbyid) | **GET** /users/{userId} | Find user by ID.
[**getUsers**](UsersApi.md#getusers) | **GET** /users | Find all users.


# **findUserById**
> User findUserById(userId)

Find user by ID.

Returns a single user.

### Example
```dart
import 'package:floaty_client/api.dart';

final api_instance = UsersApi();
final userId = 789; // int | ID of user to return

try {
    final result = api_instance.findUserById(userId);
    print(result);
} catch (e) {
    print('Exception when calling UsersApi->findUserById: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **int**| ID of user to return | 

### Return type

[**User**](User.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getUsers**
> User getUsers()

Find all users.

Returns a list of users.

### Example
```dart
import 'package:floaty_client/api.dart';

final api_instance = UsersApi();

try {
    final result = api_instance.getUsers();
    print(result);
} catch (e) {
    print('Exception when calling UsersApi->getUsers: $e\n');
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

