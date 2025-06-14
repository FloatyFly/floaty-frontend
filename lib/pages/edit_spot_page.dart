import 'package:flutter/material.dart';
import 'package:floaty_client/api.dart' as api;
import 'package:floaty/config/constants.dart';
import 'package:floaty/config/CookieAuth.dart';
import 'package:floaty/widgets/ui_components.dart';
import 'package:provider/provider.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';

class EditSpotPage extends StatefulWidget {
  final api.Spot spot;

  const EditSpotPage({required this.spot, super.key});

  @override
  State<EditSpotPage> createState() => _EditSpotPageState();
}

class _EditSpotPageState extends State<EditSpotPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  final _altitudeController = TextEditingController();
  late api.SpotUpdateTypeEnum _selectedType;
  bool _isLoading = false;
  bool _isDeleting = false;
  LatLng? _selectedLocation;
  final MapController _mapController = MapController();
  bool _useCancellableProvider = true;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.spot.name;
    _descriptionController.text = widget.spot.description ?? '';
    _selectedType = api.SpotUpdateTypeEnum.values.firstWhere(
      (e) => e.toString() == widget.spot.type.toString(),
    );
    _selectedLocation = LatLng(widget.spot.latitude, widget.spot.longitude);
    _latitudeController.text = widget.spot.latitude.toStringAsFixed(3);
    _longitudeController.text = widget.spot.longitude.toStringAsFixed(3);
    _altitudeController.text = widget.spot.altitude.toString();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _altitudeController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  CookieAuth _getCookieAuth() {
    CookieJar cookieJar = Provider.of<CookieJar>(context, listen: false);
    return CookieAuth(cookieJar);
  }

  Future<double> _getElevation(LatLng location) async {
    try {
      print(
        'Fetching elevation for: ${location.latitude}, ${location.longitude}',
      );
      final response = await http.get(
        Uri.parse(
          'https://api.open-meteo.com/v1/elevation?latitude=${location.latitude}&longitude=${location.longitude}&timezone=auto',
        ),
      );

      print('Elevation API response: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Parsed elevation data: $data');
        if (data['elevation'] != null &&
            data['elevation'] is List &&
            data['elevation'].isNotEmpty) {
          final elevation = (data['elevation'][0] as num).toDouble();
          print('Got elevation: $elevation');
          return elevation;
        }
      }
      print('Error getting elevation: ${response.body}');
      return 0.0;
    } catch (e) {
      print('Error getting elevation: $e');
      return 0.0;
    }
  }

  void _onMapTap(TapPosition tapPosition, LatLng location) async {
    print('Map tapped at: ${location.latitude}, ${location.longitude}');

    // First update the location and coordinates
    setState(() {
      _selectedLocation = location;
      _latitudeController.text = location.latitude.toStringAsFixed(3);
      _longitudeController.text = location.longitude.toStringAsFixed(3);
    });

    // Then get and update the elevation
    try {
      final elevation = await _getElevation(location);
      print('Setting elevation to: $elevation');
      if (mounted) {
        setState(() {
          _altitudeController.text = elevation.round().toString();
        });
      }
    } catch (e) {
      print('Error updating elevation: $e');
      if (mounted) {
        setState(() {
          _altitudeController.text = '0';
        });
      }
    }
  }

  Future<void> _deleteSpot() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Delete Spot'),
            content: Text('Are you sure you want to delete this spot?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: Text('Delete'),
              ),
            ],
          ),
    );

    if (confirmed != true) return;

    setState(() {
      _isDeleting = true;
    });

    try {
      final apiClient = api.ApiClient(
        basePath: backendUrl,
        authentication: _getCookieAuth(),
      );
      final spotsApi = api.SpotsApi(apiClient);
      await spotsApi.deleteSpotById(widget.spot.spotId);

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete spot. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDeleting = false;
        });
      }
    }
  }

  Future<void> _saveSpot() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final spotUpdate = api.SpotUpdate(
        name: _nameController.text,
        type: _selectedType,
        latitude: double.parse(_latitudeController.text),
        longitude: double.parse(_longitudeController.text),
        altitude: int.parse(_altitudeController.text),
        description:
            _descriptionController.text.isEmpty
                ? null
                : _descriptionController.text,
      );

      final apiClient = api.ApiClient(
        basePath: backendUrl,
        authentication: _getCookieAuth(),
      );
      final spotsApi = api.SpotsApi(apiClient);
      await spotsApi.updateSpotById(widget.spot.spotId, spotUpdate);

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update spot. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildTypeButton(
    api.SpotUpdateTypeEnum type,
    String label,
    bool isFirst,
    bool isLast,
  ) {
    final isSelected = _selectedType == type;
    return Expanded(
      flex: label == 'Launch & Landing' ? 2 : 1,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _selectedType = type;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isSelected ? const Color(0xFF0078D7) : Colors.grey[200],
          foregroundColor: isSelected ? Colors.white : Colors.black87,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          minimumSize: Size(0, 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.horizontal(
              left: Radius.circular(isFirst ? 4 : 0),
              right: Radius.circular(isLast ? 4 : 0),
            ),
          ),
        ),
        child: Text(label, style: TextStyle(fontSize: 14)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 700;
    final containerWidth = isMobile ? screenWidth : screenWidth * 2 / 3;

    return Scaffold(
      body: Stack(
        children: [
          if (!isMobile) const FloatyBackgroundWidget(),
          if (isMobile) Container(color: Colors.white),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Header(),
                  SizedBox(height: 20),
                  Container(
                    width: containerWidth,
                    padding: EdgeInsets.all(isMobile ? 8 : 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          isMobile
                              ? BorderRadius.zero
                              : BorderRadius.circular(6),
                      boxShadow:
                          isMobile
                              ? []
                              : [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Edit Spot',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: 'Spot Name',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a name';
                                }
                                return null;
                              },
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 5, bottom: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      _buildTypeButton(
                                        api.SpotUpdateTypeEnum.LAUNCH_SITE,
                                        'Launch',
                                        true,
                                        false,
                                      ),
                                      _buildTypeButton(
                                        api.SpotUpdateTypeEnum.LANDING_SITE,
                                        'Landing',
                                        false,
                                        false,
                                      ),
                                      _buildTypeButton(
                                        api
                                            .SpotUpdateTypeEnum
                                            .LAUNCH_AND_LANDING_SITE,
                                        'Launch & Landing',
                                        false,
                                        true,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16),
                            Container(
                              height: 400,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.3),
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: FlutterMap(
                                  mapController: _mapController,
                                  options: MapOptions(
                                    initialCenter: _selectedLocation!,
                                    initialZoom: 13,
                                    onTap: _onMapTap,
                                    interactionOptions:
                                        const InteractionOptions(
                                          enableScrollWheel: true,
                                          enableMultiFingerGestureRace: false,
                                          flags:
                                              InteractiveFlag.all &
                                              ~InteractiveFlag.rotate,
                                        ),
                                  ),
                                  children: [
                                    TileLayer(
                                      urlTemplate: mapTileUrl,
                                      maxZoom: mapTileOptions.maxZoom,
                                      minZoom: mapTileOptions.minZoom,
                                      tileSize: mapTileOptions.tileSize,
                                      keepBuffer: mapTileOptions.keepBuffer,
                                      tileProvider:
                                          _useCancellableProvider
                                              ? CancellableNetworkTileProvider()
                                              : null,
                                    ),
                                    MarkerLayer(
                                      markers: [
                                        if (_selectedLocation != null)
                                          Marker(
                                            point: _selectedLocation!,
                                            width: 40,
                                            height: 40,
                                            child: Icon(
                                              Icons.location_on,
                                              color: Color(0xFF0078D7),
                                              size: 40,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Latitude',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          _latitudeController.text,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Longitude',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          _longitudeController.text,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Altitude',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          '${_altitudeController.text} m',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 24),
                            TextFormField(
                              controller: _descriptionController,
                              decoration: InputDecoration(
                                labelText: 'Description',
                                border: OutlineInputBorder(),
                                alignLabelWithHint: true,
                              ),
                              maxLines: 3,
                            ),
                            SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed:
                                      _isLoading
                                          ? null
                                          : () => Navigator.pop(context),
                                  child: Text('Cancel'),
                                ),
                                SizedBox(width: 16),
                                TextButton(
                                  onPressed: _isLoading ? null : _deleteSpot,
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.red,
                                  ),
                                  child: Text('Delete'),
                                ),
                                SizedBox(width: 16),
                                ElevatedButton(
                                  onPressed: _isLoading ? null : _saveSpot,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF0078D7),
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                  ),
                                  child:
                                      _isLoading
                                          ? SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    Colors.white,
                                                  ),
                                            ),
                                          )
                                          : Text('Save'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
