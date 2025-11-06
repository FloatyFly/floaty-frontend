import 'package:floaty/services/flight_service.dart';
import 'package:floaty/services/gliders_service.dart';
import 'package:floaty/services/spots_service.dart';
import 'package:floaty/widgets/ui_components.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../config/CookieAuth.dart';
import '../models/model.dart';
import 'package:floaty_client/api.dart' as api;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../config/constants.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../config/theme.dart';

class EditFlightPage extends StatefulWidget {
  final Flight flight;

  const EditFlightPage({super.key, required this.flight});

  @override
  _EditFlightPageState createState() => _EditFlightPageState();
}

class _EditFlightPageState extends State<EditFlightPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _dateController;
  late TextEditingController _descriptionController;
  final _focusDate = FocusNode();
  final _focusDescription = FocusNode();

  bool _isLoading = false;
  String? errorMessage;
  String? flightTimeErrorMessage;

  int? selectedHours;
  int? selectedMinutes;
  int? selectedLaunchSpotId;
  int? selectedLandingSpotId;
  int? selectedGliderId;

  late Future<List<api.Spot>> futureSpots;
  late Future<List<api.Glider>> futureGliders;

  final DateFormat formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss");

  api.FlightTrack? _flightTrack;
  bool _isLoadingTrack = false;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();

    // Initialize controllers with existing flight data
    final date = DateTime.parse(widget.flight.dateTime);
    _dateController = TextEditingController(
      text: DateFormat("dd.MM.yyyy").format(date),
    );
    _descriptionController = TextEditingController(
      text: widget.flight.description,
    );

    // Set initial values for dropdowns
    selectedLaunchSpotId = widget.flight.launchSpotId;
    selectedLandingSpotId = widget.flight.landingSpotId;
    selectedGliderId = widget.flight.gliderId;

    // Set initial duration values
    selectedHours = widget.flight.duration ~/ 60;
    selectedMinutes = widget.flight.duration % 60;

    // Adjust selectedMinutes to match dropdown values (multiples of 5)
    if (selectedMinutes != null && selectedMinutes! % 5 != 0) {
      selectedMinutes = (selectedMinutes! / 5).round() * 5;
      if (selectedMinutes == 60) {
        selectedMinutes = 0;
        selectedHours = (selectedHours ?? 0) + 1;
      }
    }

    // Initialize futures for spots and gliders
    futureSpots = fetchAllSpots(_getCookieAuth());
    futureGliders = fetchGliders(_getCookieAuth());
    if (widget.flight.igcMetadata != null) {
      _fetchTrack();
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _descriptionController.dispose();
    _focusDate.dispose();
    _focusDescription.dispose();
    _mapController.dispose();
    super.dispose();
  }

  CookieAuth _getCookieAuth() {
    return CookieAuth();
  }

  Future<void> _updateFlight() async {
    if (!_formKey.currentState!.validate()) return;

    // Check if both hours and minutes are zero
    if ((selectedHours ?? 0) == 0 && (selectedMinutes ?? 0) == 0) {
      setState(() {
        flightTimeErrorMessage = "Flight time can not be 0 minutes.";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      errorMessage = null;
      flightTimeErrorMessage = null;
    });

    try {
      DateFormat dateFormat = DateFormat('dd.MM.yyyy');
      final formattedDate = formatter.format(
        dateFormat.parseStrict(_dateController.text),
      );

      // Calculate total duration in minutes
      final duration = (selectedHours ?? 0) * 60 + (selectedMinutes ?? 0);

      Flight updatedFlight = Flight(
        flightId: widget.flight.flightId,
        dateTime: formattedDate,
        launchSpotId: selectedLaunchSpotId!,
        landingSpotId: selectedLandingSpotId!,
        gliderId: selectedGliderId!,
        duration: duration,
        description: _descriptionController.text,
        igcMetadata: widget.flight.igcMetadata,
      );

      await updateFlight(updatedFlight, _getCookieAuth());

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      setState(() {
        errorMessage = "Failed to update flight. Please try again.";
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteFlight() async {
    // Show confirmation dialog before deleting
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Delete Flight'),
            content: Text('Are you sure you want to delete this flight?'),
            actions: [
              FloatyButton(
                onPressed: () => Navigator.pop(context, false),
                text: 'Cancel',
                backgroundColor: Colors.grey.shade100,
                foregroundColor: Colors.black,
              ),
              FloatyButton(
                onPressed: () => Navigator.pop(context, true),
                text: 'Delete',
                backgroundColor: Colors.red,
              ),
            ],
          ),
    );

    if (shouldDelete == true) {
      setState(() {
        _isLoading = true;
        errorMessage = null;
      });

      try {
        await deleteFlight(widget.flight.flightId, _getCookieAuth());

        if (mounted) {
          Navigator.pop(context, true);
        }
      } catch (e) {
        setState(() {
          errorMessage = "Failed to delete flight. Please try again.";
          _isLoading = false;
        });
      }
    }
  }

  // Show the date picker dialog
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(widget.flight.dateTime),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat("dd.MM.yyyy").format(picked);
      });
    }
  }

  Future<void> _fetchTrack() async {
    setState(() => _isLoadingTrack = true);
    try {
      final track = await fetchFlightTrack(
        widget.flight.flightId,
        _getCookieAuth(),
      );
      setState(() {
        _flightTrack = track;
      });
    } finally {
      setState(() => _isLoadingTrack = false);
    }
  }

  Widget _buildTrackMap() {
    if (_isLoadingTrack) {
      return Center(child: CircularProgressIndicator());
    }
    if (_flightTrack == null || _flightTrack!.points.isEmpty) {
      return Center(child: Text('No track data available'));
    }
    final points =
        _flightTrack!.points
            .map((p) => LatLng(p.latitude, p.longitude))
            .toList();
    final altitudes = _flightTrack!.points.map((p) => p.altitude).toList();
    final minAltitude = altitudes.reduce((a, b) => a < b ? a : b);
    final maxAltitude = altitudes.reduce((a, b) => a > b ? a : b);

    // Calculate bounds
    final minLat = points
        .map((p) => p.latitude)
        .reduce((a, b) => a < b ? a : b);
    final maxLat = points
        .map((p) => p.latitude)
        .reduce((a, b) => a > b ? a : b);
    final minLng = points
        .map((p) => p.longitude)
        .reduce((a, b) => a < b ? a : b);
    final maxLng = points
        .map((p) => p.longitude)
        .reduce((a, b) => a > b ? a : b);

    // Create LatLngBounds for the track
    final bounds = LatLngBounds(
      LatLng(minLat, minLng), // southwest
      LatLng(maxLat, maxLng), // northeast
    );

    return Column(
      children: [
        Container(
          height: 450,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: MapWithZoomControls(
              mapController: _mapController,
              options: MapOptions(
                initialCameraFit: CameraFit.bounds(
                  bounds: bounds,
                  padding: EdgeInsets.all(20.0),
                ),
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
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: points,
                      color: Colors.orange,
                      strokeWidth: 3.0,
                    ),
                  ],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: points.first,
                      width: 40,
                      height: 40,
                      child: Icon(
                        Icons.location_on,
                        color: Colors.blue,
                        size: 40,
                      ),
                    ),
                    Marker(
                      point: points.last,
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
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildStatColumn(
                      'Distance',
                      '${_flightTrack!.statistics.distance.toStringAsFixed(2)} km',
                    ),
                  ),
                  Expanded(
                    child: _buildStatColumn(
                      'Max Altitude',
                      '${_flightTrack!.statistics.maxAltitude.toStringAsFixed(0)} m',
                    ),
                  ),
                  Expanded(
                    child: _buildStatColumn(
                      'Min Altitude',
                      '${_flightTrack!.statistics.minAltitude.toStringAsFixed(0)} m',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildStatColumn(
                      'Max Speed',
                      '${_flightTrack!.statistics.maxSpeed.toStringAsFixed(1)} km/h',
                    ),
                  ),
                  Expanded(
                    child: _buildStatColumn(
                      'Max Climbrate',
                      '${_flightTrack!.statistics.maxClimbRate.toStringAsFixed(1)} m/s',
                    ),
                  ),
                  Expanded(
                    child: _buildStatColumn(
                      'Max Sinkrate',
                      '${_flightTrack!.statistics.maxSinkRate.toStringAsFixed(1)} m/s',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey)),
        Text(
          value,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
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
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Edit Flight',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: shadColors.foreground,
                              ),
                            ),
                            SizedBox(height: 20),
                            // Date Field
                            TextFormField(
                              controller: _dateController,
                              decoration: InputDecoration(
                                labelText: 'Date',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.calendar_today),
                                  onPressed: () => _selectDate(context),
                                ),
                              ),
                              readOnly: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a date';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16),
                            // Launch Spot Dropdown
                            FutureBuilder<List<api.Spot>>(
                              future: futureSpots,
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                final spots = snapshot.data!;
                                final launchSpots =
                                    spots
                                        .where(
                                          (spot) =>
                                              spot.type ==
                                                  api
                                                      .SpotTypeEnum
                                                      .LAUNCH_SITE ||
                                              spot.type ==
                                                  api
                                                      .SpotTypeEnum
                                                      .LAUNCH_AND_LANDING_SITE,
                                        )
                                        .toList();
                                final selectedLaunchSpot =
                                    spots
                                            .where(
                                              (spot) =>
                                                  spot.spotId ==
                                                  selectedLaunchSpotId,
                                            )
                                            .isNotEmpty
                                        ? spots.firstWhere(
                                          (spot) =>
                                              spot.spotId ==
                                              selectedLaunchSpotId,
                                        )
                                        : null;
                                if (selectedLaunchSpot != null &&
                                    !launchSpots.any(
                                      (spot) =>
                                          spot.spotId == selectedLaunchSpotId,
                                    )) {
                                  launchSpots.add(selectedLaunchSpot);
                                }

                                return DropdownButtonFormField<int>(
                                  value: selectedLaunchSpotId,
                                  decoration: InputDecoration(
                                    labelText: 'Launch Site',
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Please select a launch site';
                                    }
                                    return null;
                                  },
                                  items:
                                      launchSpots.map((spot) {
                                        return DropdownMenuItem<int>(
                                          value: spot.spotId,
                                          child: Text(spot.name),
                                        );
                                      }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedLaunchSpotId = value;
                                    });
                                  },
                                );
                              },
                            ),
                            SizedBox(height: 16),
                            // Landing Spot Dropdown
                            FutureBuilder<List<api.Spot>>(
                              future: futureSpots,
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                final spots = snapshot.data!;
                                final landingSpots =
                                    spots
                                        .where(
                                          (spot) =>
                                              spot.type ==
                                                  api
                                                      .SpotTypeEnum
                                                      .LANDING_SITE ||
                                              spot.type ==
                                                  api
                                                      .SpotTypeEnum
                                                      .LAUNCH_AND_LANDING_SITE,
                                        )
                                        .toList();
                                final selectedLandingSpot =
                                    spots
                                            .where(
                                              (spot) =>
                                                  spot.spotId ==
                                                  selectedLandingSpotId,
                                            )
                                            .isNotEmpty
                                        ? spots.firstWhere(
                                          (spot) =>
                                              spot.spotId ==
                                              selectedLandingSpotId,
                                        )
                                        : null;
                                if (selectedLandingSpot != null &&
                                    !landingSpots.any(
                                      (spot) =>
                                          spot.spotId == selectedLandingSpotId,
                                    )) {
                                  landingSpots.add(selectedLandingSpot);
                                }

                                return DropdownButtonFormField<int>(
                                  value: selectedLandingSpotId,
                                  decoration: InputDecoration(
                                    labelText: 'Landing Site',
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Please select a landing site';
                                    }
                                    return null;
                                  },
                                  items:
                                      landingSpots.map((spot) {
                                        return DropdownMenuItem<int>(
                                          value: spot.spotId,
                                          child: Text(spot.name),
                                        );
                                      }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedLandingSpotId = value;
                                    });
                                  },
                                );
                              },
                            ),
                            SizedBox(height: 16),
                            // Glider Dropdown
                            FutureBuilder<List<api.Glider>>(
                              future: futureGliders,
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                final gliders = snapshot.data!;
                                return DropdownButtonFormField<int>(
                                  value: selectedGliderId,
                                  decoration: InputDecoration(
                                    labelText: 'Glider',
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Please select a glider';
                                    }
                                    return null;
                                  },
                                  items:
                                      gliders.map((glider) {
                                        return DropdownMenuItem<int>(
                                          value: glider.id,
                                          child: Text(
                                            '${glider.manufacturer} ${glider.model}',
                                          ),
                                        );
                                      }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedGliderId = value;
                                    });
                                  },
                                );
                              },
                            ),
                            SizedBox(height: 16),
                            // Duration Fields
                            Row(
                              children: [
                                Expanded(
                                  child: DropdownButtonFormField<int>(
                                    value: selectedHours,
                                    decoration: InputDecoration(
                                      labelText: 'Hours',
                                      border: OutlineInputBorder(),
                                    ),
                                    items: [
                                      DropdownMenuItem<int>(
                                        value: 0,
                                        child: Text('0 Hours'),
                                      ),
                                      ...List.generate(12, (index) {
                                        return DropdownMenuItem<int>(
                                          value: index + 1,
                                          child: Text('${index + 1} Hours'),
                                        );
                                      }),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        selectedHours = value;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: DropdownButtonFormField<int>(
                                    value: selectedMinutes,
                                    decoration: InputDecoration(
                                      labelText: 'Minutes',
                                      border: OutlineInputBorder(),
                                    ),
                                    items: [
                                      DropdownMenuItem<int>(
                                        value: 0,
                                        child: Text('0 Minutes'),
                                      ),
                                      ...List.generate(12, (index) {
                                        return DropdownMenuItem<int>(
                                          value: (index + 1) * 5,
                                          child: Text(
                                            '${(index + 1) * 5} Minutes',
                                          ),
                                        );
                                      }),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        selectedMinutes = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            if (flightTimeErrorMessage != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  flightTimeErrorMessage!,
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: Theme.of(context).colorScheme.error,
                                    height: 16.0 / 12.0,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.4,
                                  ),
                                ),
                              ),
                            SizedBox(height: 16),
                            // Description Field
                            TextFormField(
                              controller: _descriptionController,
                              decoration: InputDecoration(
                                labelText: 'Description',
                                border: OutlineInputBorder(),
                                alignLabelWithHint: true,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                              maxLines: 3,
                            ),
                            if (errorMessage != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  errorMessage!,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            SizedBox(height: 8),
                            if (widget.flight.igcMetadata != null) ...[
                              SizedBox(height: 16),
                              _buildTrackMap(),
                              SizedBox(height: 24),
                            ],
                            // Buttons
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
                                        onPressed: _updateFlight,
                                        text: 'Save',
                                      ),
                                SizedBox(width: 16),
                                FloatyButton(
                                  onPressed: _deleteFlight,
                                  text: 'Delete',
                                  backgroundColor: Colors.red,
                                  enabled: !_isLoading,
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
