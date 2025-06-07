# floaty_client.api.SpotsApi

## Load the API package
```dart
import 'package:floaty_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createSpot**](SpotsApi.md#createspot) | **POST** /spots | Create a new spot.
[**deleteSpotById**](SpotsApi.md#deletespotbyid) | **DELETE** /spots/{spotId} | Delete a spot by ID.
[**getSpotById**](SpotsApi.md#getspotbyid) | **GET** /spots/{spotId} | Get a spot by ID.
[**getSpots**](SpotsApi.md#getspots) | **GET** /spots | Get all spots.
[**updateSpotById**](SpotsApi.md#updatespotbyid) | **PUT** /spots/{spotId} | Update a spot by ID.


# **createSpot**
> Spot createSpot(spotCreate)

Create a new spot.

Add a new paragliding spot to the database for the authenticated user.

### Example
```dart
import 'package:floaty_client/api.dart';

final api_instance = SpotsApi();
final spotCreate = SpotCreate(); // SpotCreate | Spot details

try {
    final result = api_instance.createSpot(spotCreate);
    print(result);
} catch (e) {
    print('Exception when calling SpotsApi->createSpot: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **spotCreate** | [**SpotCreate**](SpotCreate.md)| Spot details | 

### Return type

[**Spot**](Spot.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteSpotById**
> deleteSpotById(spotId)

Delete a spot by ID.

Deletes a single paragliding spot by its ID.

### Example
```dart
import 'package:floaty_client/api.dart';

final api_instance = SpotsApi();
final spotId = 789; // int | ID of the spot to delete

try {
    api_instance.deleteSpotById(spotId);
} catch (e) {
    print('Exception when calling SpotsApi->deleteSpotById: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **spotId** | **int**| ID of the spot to delete | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getSpotById**
> Spot getSpotById(spotId)

Get a spot by ID.

Returns a single paragliding spot by its ID.

### Example
```dart
import 'package:floaty_client/api.dart';

final api_instance = SpotsApi();
final spotId = 789; // int | ID of the spot to retrieve

try {
    final result = api_instance.getSpotById(spotId);
    print(result);
} catch (e) {
    print('Exception when calling SpotsApi->getSpotById: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **spotId** | **int**| ID of the spot to retrieve | 

### Return type

[**Spot**](Spot.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getSpots**
> List<Spot> getSpots()

Get all spots.

Returns a list of all paragliding spots (launch and landing sites) for the authenticated user.

### Example
```dart
import 'package:floaty_client/api.dart';

final api_instance = SpotsApi();

try {
    final result = api_instance.getSpots();
    print(result);
} catch (e) {
    print('Exception when calling SpotsApi->getSpots: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<Spot>**](Spot.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateSpotById**
> Spot updateSpotById(spotId, spotUpdate)

Update a spot by ID.

Updates a single paragliding spot with the provided data.

### Example
```dart
import 'package:floaty_client/api.dart';

final api_instance = SpotsApi();
final spotId = 789; // int | ID of the spot to update
final spotUpdate = SpotUpdate(); // SpotUpdate | Updated spot information

try {
    final result = api_instance.updateSpotById(spotId, spotUpdate);
    print(result);
} catch (e) {
    print('Exception when calling SpotsApi->updateSpotById: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **spotId** | **int**| ID of the spot to update | 
 **spotUpdate** | [**SpotUpdate**](SpotUpdate.md)| Updated spot information | 

### Return type

[**Spot**](Spot.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

