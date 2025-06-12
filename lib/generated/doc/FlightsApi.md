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
[**getFlightIgc**](FlightsApi.md#getflightigc) | **GET** /flights/{flightId}/igc | Get IGC file data for a flight
[**getFlightTrack**](FlightsApi.md#getflighttrack) | **GET** /flights/{flightId}/track | Get the processed track data for a flight
[**getFlights**](FlightsApi.md#getflights) | **GET** /flights | Find all flights.
[**updateFlightById**](FlightsApi.md#updateflightbyid) | **PUT** /flights/{flightId} | Update a Flight by ID.


# **createFlight**
> Flight createFlight(flightCreate)

Create a flight.

Register a new flight for the authenticated user.

### Example
```dart
import 'package:floaty_client/api.dart';

final api_instance = FlightsApi();
final flightCreate = FlightCreate(); // FlightCreate | Flight details including required glider and spots references

try {
    final result = api_instance.createFlight(flightCreate);
    print(result);
} catch (e) {
    print('Exception when calling FlightsApi->createFlight: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **flightCreate** | [**FlightCreate**](FlightCreate.md)| Flight details including required glider and spots references | 

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

# **getFlightIgc**
> IgcData getFlightIgc(flightId)

Get IGC file data for a flight

Returns the complete IGC file data including metadata and binary content for a specific flight. Returns 404 if the flight exists but has no IGC file.

### Example
```dart
import 'package:floaty_client/api.dart';

final api_instance = FlightsApi();
final flightId = 789; // int | ID of the flight to retrieve IGC data for

try {
    final result = api_instance.getFlightIgc(flightId);
    print(result);
} catch (e) {
    print('Exception when calling FlightsApi->getFlightIgc: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **flightId** | **int**| ID of the flight to retrieve IGC data for | 

### Return type

[**IgcData**](IgcData.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getFlightTrack**
> FlightTrack getFlightTrack(flightId)

Get the processed track data for a flight

Returns processed track data including timestamped coordinates, altitude, speed,  and vertical rates calculated from the IGC file. Optimized for map display and  compatible with flutter_map package. Returns 404 if flight exists but has no IGC data. 

### Example
```dart
import 'package:floaty_client/api.dart';

final api_instance = FlightsApi();
final flightId = 789; // int | ID of the flight to retrieve track data for

try {
    final result = api_instance.getFlightTrack(flightId);
    print(result);
} catch (e) {
    print('Exception when calling FlightsApi->getFlightTrack: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **flightId** | **int**| ID of the flight to retrieve track data for | 

### Return type

[**FlightTrack**](FlightTrack.md)

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

