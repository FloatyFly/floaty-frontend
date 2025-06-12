# floaty_client.model.IgcData

## Load the model package
```dart
import 'package:floaty_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**uploadedAt** | [**DateTime**](DateTime.md) | When the IGC file was uploaded (UTC) | 
**fileSize** | **int** | Size of the IGC file in bytes | 
**fileName** | **String** | Original filename of the uploaded IGC file | [optional] 
**checksum** | **String** | File checksum for integrity verification | [optional] 
**file** | **String** | Full metadata with data, null if no IGC file exists. | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


