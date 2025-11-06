import 'package:flutter/material.dart';
import 'package:floaty_client/api.dart' as api;
import 'package:floaty/config/constants.dart';
import 'package:floaty/config/CookieAuth.dart';
import 'package:floaty/widgets/ui_components.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../config/theme.dart';

class AddSpotPage extends StatefulWidget {
  const AddSpotPage({super.key});

  @override
  State<AddSpotPage> createState() => _AddSpotPageState();
}

class _AddSpotPageState extends State<AddSpotPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  final _altitudeController = TextEditingController();
  api.SpotCreateTypeEnum _selectedType = api.SpotCreateTypeEnum.LAUNCH_SITE;
  bool _isLoading = false;
  LatLng? _selectedLocation;
  final MapController _mapController = MapController();
  bool _useCancellableProvider = true;

  @override
  void dispose() {
    _nameController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _altitudeController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    print('Initializing AddSpotPage');
    // Set initial location to center of Switzerland
    _selectedLocation = LatLng(46.8182, 8.2275);
    _latitudeController.text = _selectedLocation!.latitude.toStringAsFixed(3);
    _longitudeController.text = _selectedLocation!.longitude.toStringAsFixed(3);

    // Get initial elevation
    print('Getting initial elevation');
    _getElevation(_selectedLocation!)
        .then((elevation) {
          print('Got initial elevation: $elevation');
          if (mounted) {
            setState(() {
              _altitudeController.text = elevation.round().toString();
            });
          }
        })
        .catchError((error) {
          print('Error getting initial elevation: $error');
          if (mounted) {
            setState(() {
              _altitudeController.text = '0';
            });
          }
        });
  }

  CookieAuth _getCookieAuth() {
    return CookieAuth();
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

  Future<void> _saveNewSpot() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final spotCreate = api.SpotCreate(
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
        await spotsApi.createSpot(spotCreate);

        if (mounted) {
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to save spot. Please try again.'),
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
  }

  Widget _buildTypeButton(
    api.SpotCreateTypeEnum type,
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
    final shadColors = getShadThemeData().colorScheme;

    return Scaffold(
      backgroundColor: shadColors.background,
      body: Stack(
        children: [
          if (!isMobile) const FloatyBackgroundWidget(),
          if (isMobile) Container(color: shadColors.background),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Header(),
                  SizedBox(height: 20),
                  Container(
                    width: containerWidth,
                    padding: EdgeInsets.all(isMobile ? 16 : 24),
                    decoration: BoxDecoration(
                      color: shadColors.card,
                      borderRadius:
                          isMobile
                              ? BorderRadius.zero
                              : BorderRadius.vertical(top: Radius.circular(12)),
                      border: isMobile
                          ? null
                          : Border.all(color: shadColors.border, width: 1),
                      boxShadow: isMobile
                          ? []
                          : [
                              BoxShadow(
                                color: shadColors.foreground.withValues(alpha: 0.05),
                                spreadRadius: 0,
                                blurRadius: 10,
                                offset: Offset(0, 4),
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
                              'Add New Spot',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: shadColors.foreground,
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
                                  return 'Please enter a spot name';
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
                                        api.SpotCreateTypeEnum.LAUNCH_SITE,
                                        'Launch',
                                        true,
                                        false,
                                      ),
                                      _buildTypeButton(
                                        api.SpotCreateTypeEnum.LANDING_SITE,
                                        'Landing',
                                        false,
                                        false,
                                      ),
                                      _buildTypeButton(
                                        api
                                            .SpotCreateTypeEnum
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
                            // Map Widget
                            Container(
                              height: 400,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: MapWithZoomControls(
                                  mapController: _mapController,
                                  options: MapOptions(
                                    initialCenter: LatLng(46.8182, 8.2275),
                                    initialZoom: 8,
                                    onTap: _onMapTap,
                                  ),
                                  children: [
                                    TileLayer(
                                      urlTemplate: mapTileUrl,
                                      maxZoom: mapMaxZoom,
                                      minZoom: mapMinZoom,
                                      tileSize: mapTileSize,
                                      keepBuffer: mapKeepBuffer,
                                      panBuffer: mapPanBuffer,
                                      maxNativeZoom: mapMaxNativeZoom,
                                      retinaMode: mapRetinaMode,
                                      tileDisplay: mapTileDisplay,
                                      errorTileCallback: mapErrorTileCallback,
                                      tileProvider: CancellableNetworkTileProvider(),
                                    ),
                                    if (_selectedLocation != null)
                                      MarkerLayer(
                                        markers: [
                                          Marker(
                                            point: _selectedLocation!,
                                            width: 40,
                                            height: 40,
                                            child: Icon(
                                              Icons.location_on,
                                              color: Colors.red,
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
                                FloatyButton(
                                  onPressed: () => Navigator.pop(context),
                                  text: 'Cancel',
                                  backgroundColor: Colors.grey.shade100,
                                  foregroundColor: Colors.black,
                                  enabled: !_isLoading,
                                ),
                                SizedBox(width: 16),
                                _isLoading
                                    ? SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Color(0xFF2B7DE9),
                                              ),
                                        ),
                                      )
                                    : FloatyButton(
                                        onPressed: _saveNewSpot,
                                        text: 'Save',
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
