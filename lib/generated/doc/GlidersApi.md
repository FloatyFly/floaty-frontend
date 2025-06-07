# floaty_client.api.GlidersApi

## Load the API package
```dart
import 'package:floaty_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createGlider**](GlidersApi.md#createglider) | **POST** /gliders | Create a new glider.
[**deleteGliderById**](GlidersApi.md#deletegliderbyid) | **DELETE** /gliders/{gliderId} | Delete a glider by ID.
[**getAllGliders**](GlidersApi.md#getallgliders) | **GET** /gliders | Get all gliders.
[**getGliderById**](GlidersApi.md#getgliderbyid) | **GET** /gliders/{gliderId} | Get a glider by ID.
[**updateGliderById**](GlidersApi.md#updategliderbyid) | **PUT** /gliders/{gliderId} | Update a glider by ID.


# **createGlider**
> Glider createGlider(gliderCreate)

Create a new glider.

Add a new glider to the database for the authenticated user.

### Example
```dart
import 'package:floaty_client/api.dart';

final api_instance = GlidersApi();
final gliderCreate = GliderCreate(); // GliderCreate | Glider details

try {
    final result = api_instance.createGlider(gliderCreate);
    print(result);
} catch (e) {
    print('Exception when calling GlidersApi->createGlider: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **gliderCreate** | [**GliderCreate**](GliderCreate.md)| Glider details | 

### Return type

[**Glider**](Glider.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteGliderById**
> deleteGliderById(gliderId)

Delete a glider by ID.

Deletes a single glider by its ID.

### Example
```dart
import 'package:floaty_client/api.dart';

final api_instance = GlidersApi();
final gliderId = 789; // int | ID of the glider to delete

try {
    api_instance.deleteGliderById(gliderId);
} catch (e) {
    print('Exception when calling GlidersApi->deleteGliderById: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **gliderId** | **int**| ID of the glider to delete | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAllGliders**
> List<Glider> getAllGliders()

Get all gliders.

Returns a list of all gliders for the authenticated user.

### Example
```dart
import 'package:floaty_client/api.dart';

final api_instance = GlidersApi();

try {
    final result = api_instance.getAllGliders();
    print(result);
} catch (e) {
    print('Exception when calling GlidersApi->getAllGliders: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<Glider>**](Glider.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getGliderById**
> Glider getGliderById(gliderId)

Get a glider by ID.

Returns a single glider by its ID.

### Example
```dart
import 'package:floaty_client/api.dart';

final api_instance = GlidersApi();
final gliderId = 789; // int | ID of the glider to retrieve

try {
    final result = api_instance.getGliderById(gliderId);
    print(result);
} catch (e) {
    print('Exception when calling GlidersApi->getGliderById: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **gliderId** | **int**| ID of the glider to retrieve | 

### Return type

[**Glider**](Glider.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateGliderById**
> Glider updateGliderById(gliderId, gliderUpdate)

Update a glider by ID.

Updates a single glider with the provided data.

### Example
```dart
import 'package:floaty_client/api.dart';

final api_instance = GlidersApi();
final gliderId = 789; // int | ID of the glider to update
final gliderUpdate = GliderUpdate(); // GliderUpdate | Updated glider information

try {
    final result = api_instance.updateGliderById(gliderId, gliderUpdate);
    print(result);
} catch (e) {
    print('Exception when calling GlidersApi->updateGliderById: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **gliderId** | **int**| ID of the glider to update | 
 **gliderUpdate** | [**GliderUpdate**](GliderUpdate.md)| Updated glider information | 

### Return type

[**Glider**](Glider.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

