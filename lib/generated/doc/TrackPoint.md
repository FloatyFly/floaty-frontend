# floaty_client.model.TrackPoint

## Load the model package
```dart
import 'package:floaty_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**timestamp** | [**DateTime**](DateTime.md) | UTC timestamp of the track point | 
**latitude** | **double** | Latitude in decimal degrees (WGS84) | 
**longitude** | **double** | Longitude in decimal degrees (WGS84) | 
**altitude** | **int** | Altitude in meters above sea level (GPS altitude) | 
**speed** | **double** | Ground speed in km/h (calculated from GPS coordinates) | 
**verticalRate** | **double** | Vertical rate in m/s (positive = climbing, negative = sinking) | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


