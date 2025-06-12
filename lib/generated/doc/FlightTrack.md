# floaty_client.model.FlightTrack

## Load the model package
```dart
import 'package:floaty_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**flightId** | **int** | ID of the flight this track belongs to | 
**points** | [**List<TrackPoint>**](TrackPoint.md) | Array of track points ordered chronologically | [default to const []]
**statistics** | [**TrackStatistics**](TrackStatistics.md) |  | 
**boundingBox** | [**BoundingBox**](BoundingBox.md) |  | 
**processedAt** | [**DateTime**](DateTime.md) | When the track data was last processed/calculated (UTC) | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


