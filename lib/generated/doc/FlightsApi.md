# floaty_client.api.FlightsApi

## Load the API package
```dart
import 'package:floaty_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createFlight**](FlightsApi.md#createflight) | **POST** /flights | Create a flight.
[**deleteFlightById**](FlightsApi.md#deleteflightbyid) | **DELETE** /flights/{flightId} | Delete a Flight by ID.
[**getFlightById**](FlightsApi.md#getflightbyid) | **GET** /flights/{flightId} | Get a Flight by ID.
[**getFlights**](FlightsApi.md#getflights) | **GET** /flights | Find all flights.
[**updateFlightById**](FlightsApi.md#updateflightbyid) | **PUT** /flights/{flightId} | Update a Flight by ID.


# **createFlight**
> Flight createFlight(flight)

Create a flight.

Register a new flight for the authenticated user.

### Example
```dart
import 'package:floaty_client/api.dart';

final api_instance = FlightsApi();
final flight = Flight(); // Flight | Flight details including required glider and spots references

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
 **flight** | [**Flight**](Flight.md)| Flight details including required glider and spots references | 

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
final flightId = 789; // int | ID of the flight to delete

try {
    api_instance.deleteFlightById(flightId);
} catch (e) {
    print('Exception when calling FlightsApi->deleteFlightById: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **flightId** | **int**| ID of the flight to delete | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getFlightById**
> Flight getFlightById(flightId)

Get a Flight by ID.

Returns a single flight by its ID.

### Example
```dart
import 'package:floaty_client/api.dart';

final api_instance = FlightsApi();
final flightId = 789; // int | ID of the flight to retrieve

try {
    final result = api_instance.getFlightById(flightId);
    print(result);
} catch (e) {
    print('Exception when calling FlightsApi->getFlightById: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **flightId** | **int**| ID of the flight to retrieve | 

### Return type

[**Flight**](Flight.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getFlights**
> List<Flight> getFlights()

Find all flights.

Returns a list of all flights for the authenticated user.

### Example
```dart
import 'package:floaty_client/api.dart';

final api_instance = FlightsApi();

try {
    final result = api_instance.getFlights();
    print(result);
} catch (e) {
    print('Exception when calling FlightsApi->getFlights: $e\n');
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

# **updateFlightById**
> Flight updateFlightById(flightId, flightUpdate)

Update a Flight by ID.

Updates a single flight with the provided data.

### Example
```dart
import 'package:floaty_client/api.dart';

final api_instance = FlightsApi();
final flightId = 789; // int | ID of the flight to update
final flightUpdate = FlightUpdate(); // FlightUpdate | Updated flight information

try {
    final result = api_instance.updateFlightById(flightId, flightUpdate);
    print(result);
} catch (e) {
    print('Exception when calling FlightsApi->updateFlightById: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **flightId** | **int**| ID of the flight to update | 
 **flightUpdate** | [**FlightUpdate**](FlightUpdate.md)| Updated flight information | 

### Return type

[**Flight**](Flight.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

