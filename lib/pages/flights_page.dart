import 'dart:convert';
import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:file_saver/file_saver.dart';
import 'package:floaty/services/flight_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../config/CookieAuth.dart';
import '../../../main.dart';
import '../../models/model.dart';
import 'add_flight_page.dart';
import '../../widgets/ui_components.dart';
import 'edit_flight_page.dart';
import 'package:floaty_client/api.dart' as api;
import '../../../services/spots_service.dart';
import '../../../services/gliders_service.dart';
import '../../config/theme.dart';

class FlightsPage extends StatefulWidget {
  const FlightsPage({Key? key}) : super(key: key);

  @override
  _FlightsPageState createState() => _FlightsPageState();
}

class _FlightsPageState extends State<FlightsPage> {
  Future<List<Flight>>? futureFlights;
  Future<List<api.Spot>>? futureSpots;
  Future<List<api.Glider>>? futureGliders;
  FloatyUser? _currentUser;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();

    // Use addPostFrameCallback to access Provider after the widget tree is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _initialized) {
        return;
      }
      _initialized = true;

      // ONLY FOR DEBUGGING TO PREVENT NEED FOR LOGIN DUE TO STATE RESET ON HOT RELOAD.
      bool isDebug = false;
      if (isDebug) {
        _currentUser = FloatyUser(
          id: 1,
          name: "Floater",
          email: "floater@test.com",
          emailVerified: true,
        );
        Provider.of<AppState>(context, listen: false).setUser(_currentUser!);
      } else {
        _currentUser = Provider.of<AppState>(context, listen: false).currentUser!;
      }

      // Initialize all futures once to prevent redundant API calls
      setState(() {
        futureFlights = _fetchFlights();
        futureSpots = fetchAllSpots(_getCookieAuth());
        futureGliders = fetchGliders(_getCookieAuth());
      });
    });
  }

  CookieAuth _getCookieAuth() {
    return CookieAuth();
  }

  Future<List<Flight>> _fetchFlights() {
    return fetchFlights(_currentUser!.id, _getCookieAuth());
  }

  // Helper method to refresh all data (flights, spots, gliders)
  void _refreshAllData() {
    setState(() {
      futureFlights = _fetchFlights();
      futureSpots = fetchAllSpots(_getCookieAuth());
      futureGliders = fetchGliders(_getCookieAuth());
    });
  }

  Future<void> _exportFlightsToCSV() async {
    try {
      List<Flight> flights = await _fetchFlights(); // Fetch the flights

      // Sort flights by date (newest on top)
      flights.sort(
        (a, b) => b.dateTime.compareTo(a.dateTime),
      ); // Sort descending by dateTime (newest first)

      // Prepare CSV data
      List<List<dynamic>> rows = [];
      rows.add([
        'Flight',
        'Date',
        'Launch Spot',
        'Landing Spot',
        'Glider',
        'Duration (minutes)',
        'Description',
      ]); // Header row

      // Assign flight number starting from 1 based on the sorted order
      for (int i = 0; i < flights.length; i++) {
        final flight = flights[i];
        String formattedDate = DateFormat(
          'dd.MM.yyyy',
        ).format(DateTime.parse(flight.dateTime));
        rows.add([
          (i + 1), // Flight Number (starts from 1)
          formattedDate, // Date
          flight.launchSpotId, // Launch Spot
          flight.landingSpotId, // Landing Spot
          flight.gliderId, // Glider
          flight.duration, // Duration
          flight.description, // Description
        ]);
      }

      // Convert rows to CSV string
      String csv = const ListToCsvConverter().convert(rows);

      // Convert the CSV string to a Uint8List for downloading
      Uint8List csvBytes = Uint8List.fromList(utf8.encode(csv));

      // Download the file on the device
      await FileSaver.instance.saveFile(
        name: 'flights', // Name the file
        ext: 'csv', // File extension
        bytes: csvBytes, // CSV bytes
        mimeType: MimeType.csv, // Mime type for CSV
      );

      // Notify the user that the file has been saved
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('CSV created. Download ready!')));
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to export CSV: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 700;
    final containerWidth = isMobile ? screenWidth : screenWidth * 2 / 3;
    final shadColors = getShadThemeData().colorScheme;
    final linkColor = Color(0xFF2B7DE9); // Brighter blue (Add Flight button color)

    // Show loading screen if futures are not initialized yet
    if (futureFlights == null || futureSpots == null || futureGliders == null) {
      return Scaffold(
        backgroundColor: shadColors.background,
        body: Center(
          child: CircularProgressIndicator(color: shadColors.primary),
        ),
      );
    }

    return Scaffold(
      backgroundColor: shadColors.background,
      body: Stack(
        children: [
          if (!isMobile) const FloatyBackgroundWidget(),
          if (isMobile) Container(color: shadColors.background),
          Column(
            children: [
              Header(),
              SizedBox(height: 20),
              Expanded(
                child: Center(
                  child: Container(
                    width: containerWidth,
                    padding: EdgeInsets.all(isMobile ? 16 : 24),
                    decoration: BoxDecoration(
                      color: shadColors.card,
                      borderRadius: isMobile
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Make buttons stack vertically on small screens
                        isMobile
                            ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Add Flight button
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black,
                                        offset: Offset(-4, 4), // Bottom-right shadow
                                        blurRadius: 0,
                                        spreadRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton.icon(
                                    onPressed: () async {
                                      Flight? latestFlight;
                                      try {
                                        final flights = await _fetchFlights();
                                        if (flights.isNotEmpty) {
                                          flights.sort(
                                            (a, b) => b.dateTime.compareTo(a.dateTime),
                                          );
                                          latestFlight = flights.first;
                                        }
                                      } catch (e) {
                                        print("Could not fetch latest flight: $e");
                                      }

                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AddFlightPage(
                                            latestFlight: latestFlight,
                                          ),
                                        ),
                                      );

                                      if (result == true) {
                                        _refreshAllData();
                                      }
                                    },
                                    icon: Icon(Icons.add, size: 18),
                                    label: Text("Add Flight"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: linkColor,
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                ),
                                // Export link
                                MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: _exportFlightsToCSV,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.file_download,
                                          size: 16,
                                          color: shadColors.foreground,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          "Export",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: shadColors.foreground,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                            : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black,
                                        offset: Offset(-4, 4), // Bottom-right shadow
                                        blurRadius: 0,
                                        spreadRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton.icon(
                                    onPressed: () async {
                                      Flight? latestFlight;
                                      try {
                                        final flights = await _fetchFlights();
                                        if (flights.isNotEmpty) {
                                          flights.sort(
                                            (a, b) => b.dateTime.compareTo(a.dateTime),
                                          );
                                          latestFlight = flights.first;
                                        }
                                      } catch (e) {
                                        print("Could not fetch latest flight: $e");
                                      }

                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AddFlightPage(
                                            latestFlight: latestFlight,
                                          ),
                                        ),
                                      );

                                      if (result == true) {
                                        _refreshAllData();
                                      }
                                    },
                                    icon: Icon(Icons.add, size: 18),
                                    label: Text("Add Flight"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: linkColor,
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                ),
                                // Export link
                                MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: _exportFlightsToCSV,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.file_download,
                                          size: 16,
                                          color: shadColors.foreground,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          "Export",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: shadColors.foreground,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        SizedBox(height: 16),
                        FlightListView(
                          futureFlights: futureFlights!,
                          futureSpots: futureSpots!,
                          futureGliders: futureGliders!,
                          onDeleteFlight: (flight) async {
                            await _deleteFlight(flight.flightId);
                            _refreshAllData();
                          },
                          onFlightUpdated: () {
                            _refreshAllData();
                          },
                          isMobile: isMobile,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _deleteFlight(int flightId) async {
    await deleteFlight(flightId, _getCookieAuth());
  }
}

class FlightListView extends StatelessWidget {
  final Future<List<Flight>> futureFlights;
  final Future<List<api.Spot>> futureSpots;
  final Future<List<api.Glider>> futureGliders;
  final Function(Flight) onDeleteFlight;
  final Function() onFlightUpdated;
  final bool isMobile;

  FlightListView({
    required this.futureFlights,
    required this.futureSpots,
    required this.futureGliders,
    required this.onDeleteFlight,
    required this.onFlightUpdated,
    required this.isMobile,
  });

  // Format duration as "1h15min", "30min", or "4h"
  String _formatDuration(int durationInMinutes) {
    final hours = durationInMinutes ~/ 60;
    final minutes = durationInMinutes % 60;

    if (hours > 0 && minutes > 0) {
      return '${hours}h${minutes}min';
    } else if (hours > 0) {
      return '${hours}h';
    } else {
      return '${minutes}min';
    }
  }

  @override
  Widget build(BuildContext context) {
    final shadColors = getShadThemeData().colorScheme;
    // Link color for clickable items
    final linkColor = Color(0xFF0969DA); // GitHub-style blue link color

    return Expanded(
      child: FutureBuilder<List<Flight>>(
        future: futureFlights,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: shadColors.primary,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error loading flights",
                style: TextStyle(color: shadColors.destructive),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.33,
                  left: 16,
                  right: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.rocket_launch,
                      size: 24,
                      color: shadColors.primary,
                    ),
                    SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        "Start your Floaty journey by adding your first flight!",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: shadColors.foreground,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // Sort flights by date, assuming Flight has a DateTime property called `dateTime`
          final flights = snapshot.data!;
          flights.sort(
            (a, b) => b.dateTime.compareTo(a.dateTime),
          ); // Newest first

          return FutureBuilder<List<api.Spot>>(
            future: futureSpots, // Use cached future
            builder: (context, spotsSnapshot) {
              if (!spotsSnapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              return FutureBuilder<List<api.Glider>>(
                future: futureGliders, // Use cached future
                builder: (context, glidersSnapshot) {
                  if (!glidersSnapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final spots = spotsSnapshot.data!;
                  final gliders = glidersSnapshot.data!;

                  String getSpotName(int spotId) {
                    final spot = spots.firstWhere(
                      (spot) => spot.spotId == spotId,
                      orElse:
                          () => api.Spot(
                            spotId: spotId,
                            name: 'Unknown Spot',
                            type: api.SpotTypeEnum.LAUNCH_SITE,
                            latitude: 0,
                            longitude: 0,
                            altitude: 0,
                          ),
                    );
                    return spot.name;
                  }

                  String getGliderName(int gliderId) {
                    final glider = gliders.firstWhere(
                      (glider) => glider.id == gliderId,
                      orElse:
                          () => api.Glider(
                            id: gliderId,
                            manufacturer: 'Unknown',
                            model: 'Unknown',
                          ),
                    );
                    return '${glider.manufacturer} ${glider.model}';
                  }

                  return ListView.separated(
                    itemCount: flights.length,
                    itemBuilder: (context, index) {
                      final flight = flights[index];
                      final flightNumber = "${flights.length - index}";

                      if (isMobile) {
                        return GestureDetector(
                          onTap: () => _navigateToEditFlight(context, flight),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 12,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Flight number, date, and duration
                                SizedBox(
                                  width: 90,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        flightNumber,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: shadColors.foreground,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        DateFormat('dd.MM.yyyy').format(
                                          DateTime.parse(flight.dateTime),
                                        ),
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: shadColors.mutedForeground,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Row(
                                        children: [
                                          Text(
                                            _formatDuration(flight.duration),
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: shadColors.mutedForeground,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          if (flight.igcMetadata != null)
                                            Padding(
                                              padding: const EdgeInsets.only(left: 4.0),
                                              child: Image.asset(
                                                'assets/images/track.png',
                                                width: 16,
                                                height: 16,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 16),
                                // Content area with title, description, and glider/duration
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Flight title
                                      MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: Text(
                                          "${getSpotName(flight.launchSpotId)} - ${getSpotName(flight.landingSpotId)}",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: linkColor,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      // Glider name
                                      Text(
                                        getGliderName(flight.gliderId),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: shadColors.foreground,
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      Text(
                                        flight.description,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: shadColors.mutedForeground,
                                        ),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: true,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return GestureDetector(
                          onTap: () => _navigateToEditFlight(context, flight),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 20,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Flight number, date, and duration
                                SizedBox(
                                  width: 90,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        flightNumber,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: shadColors.foreground,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        DateFormat('dd.MM.yyyy').format(
                                          DateTime.parse(flight.dateTime),
                                        ),
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: shadColors.mutedForeground,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Row(
                                        children: [
                                          Text(
                                            _formatDuration(flight.duration),
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: shadColors.mutedForeground,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          if (flight.igcMetadata != null)
                                            Padding(
                                              padding: const EdgeInsets.only(left: 4.0),
                                              child: Image.asset(
                                                'assets/images/track.png',
                                                width: 16,
                                                height: 16,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // Content area with title, description, and glider/duration
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 24.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Title row with glider on the right
                                        Row(
                                          children: [
                                            Expanded(
                                              child: MouseRegion(
                                                cursor: SystemMouseCursors.click,
                                                child: Text(
                                                  "${getSpotName(flight.launchSpotId)} - ${getSpotName(flight.landingSpotId)}",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: linkColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 12),
                                            Text(
                                              getGliderName(flight.gliderId),
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: shadColors.foreground,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 6),
                                        Text(
                                          flight.description,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: shadColors.mutedForeground,
                                          ),
                                          softWrap: true,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        color: shadColors.border,
                        height: 1,
                        thickness: 1,
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  void _navigateToEditFlight(BuildContext context, Flight flight) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditFlightPage(flight: flight)),
    );

    if (result == true) {
      onFlightUpdated();
    }
  }

  CookieAuth _getCookieAuth(BuildContext context) {
    return CookieAuth();
  }
}
