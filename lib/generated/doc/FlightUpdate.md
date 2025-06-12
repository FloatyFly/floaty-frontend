# floaty_client.model.FlightUpdate

## Load the model package
```dart
import 'package:floaty_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**dateTime** | [**DateTime**](DateTime.md) | Datetime of the flight in UTC (ISO-8601 format with Z suffix) | [optional] 
**launchSpotId** | **int** | Reference to the launch spot used for this flight. | [optional] 
**landingSpotId** | **int** | Reference to the landing spot used for this flight. | [optional] 
**duration** | **int** | Duration in minutes | [optional] 
**description** | **String** | Some textual description of the flight experience. | [optional] 
**gliderId** | **int** | Reference to the glider used for this flight. | [optional] 
**igcDataCreate** | [**IgcDataCreate**](IgcDataCreate.md) | Full metadata with data, null if no IGC file exists | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


