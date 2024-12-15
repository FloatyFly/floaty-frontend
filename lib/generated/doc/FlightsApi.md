# floaty_client.api.FlightsApi

## Load the API package
```dart
import 'package:floaty_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createFlight**](FlightsApi.md#createflight) | **POST** /flights | Create a flight for a given user.
[**deleteFlightById**](FlightsApi.md#deleteflightbyid) | **DELETE** /flights/{flightId} | Delete a Flight by ID.
[**findAllFlights**](FlightsApi.md#findallflights) | **GET** /flights | Find all flights.
[**getFlights**](FlightsApi.md#getflights) | **GET** /flights/{userId} | Find all flights for a given User.


# **createFlight**
> Flight createFlight(flight)

Create a flight for a given user.

Register a new flight

### Example
```dart
import 'package:floaty_client/api.dart';

final api_instance = FlightsApi();
final flight = Flight(); // Flight | Optional description in *Markdown*

try {
    final result = api_instance.createFlight(flight);
    print(result);
} catch (e) {
    print('Exception when calling FlightsApi->createFlight: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **flight** | [**Flight**](Flight.md)| Optional description in *Markdown* | 

### Return type

[**Flight**](Flight.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteFlightById**
> deleteFlightById(flightId)

Delete a Flight by ID.

Deletes a single flight by its ID.

### Example
```dart
import 'package:floaty_client/api.dart';

final api_instance = FlightsApi();
final flightId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | ID of the flight to delete

try {
    api_instance.deleteFlightById(flightId);
} catch (e) {
    print('Exception when calling FlightsApi->deleteFlightById: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **flightId** | **String**| ID of the flight to delete | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **findAllFlights**
> List<Flight> findAllFlights()

Find all flights.

Returns a list of all Flights for all users.

### Example
```dart
import 'package:floaty_client/api.dart';

final api_instance = FlightsApi();

try {
    final result = api_instance.findAllFlights();
    print(result);
} catch (e) {
    print('Exception when calling FlightsApi->findAllFlights: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<Flight>**](Flight.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getFlights**
> Flight getFlights(userId)

Find all flights for a given User.

Returns a list of Flights for a User.

### Example
```dart
import 'package:floaty_client/api.dart';

final api_instance = FlightsApi();
final userId = 789; // int | ID of user

try {
    final result = api_instance.getFlights(userId);
    print(result);
} catch (e) {
    print('Exception when calling FlightsApi->getFlights: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **int**| ID of user | 

### Return type

[**Flight**](Flight.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

