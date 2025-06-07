import 'dart:convert';
import 'dart:typed_data';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:csv/csv.dart';
import 'package:file_saver/file_saver.dart';
import 'package:floaty/flight_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'CookieAuth.dart';
import 'main.dart';
import 'model.dart';
import 'add_flight_page.dart';
import 'ui_components.dart';
import 'edit_flight_page.dart';
import 'package:floaty_client/api.dart' as api;
import 'spots_service.dart';
import 'gliders_service.dart';

class FlightsPage extends StatefulWidget {
  final FloatyUser? user;

  const FlightsPage({required this.user});

  @override
  _FlightsPageState createState() => _FlightsPageState();
}

class _FlightsPageState extends State<FlightsPage> {
  late Future<List<Flight>> futureFlights;
  late FloatyUser _currentUser;

  @override
  void initState() {
    super.initState();

    // ONLY FOR DEBUGGING TO PREVENT NEED FOR LOGIN DUE TO STATE RESET ON HOT RELOAD.
    bool isDebug = false;
    if (isDebug) {
      _currentUser = FloatyUser(
        id: 1,
        name: "Floater",
        email: "floater@test.com",
        emailVerified: true,
      );
      Provider.of<AppState>(context, listen: false).setUser(_currentUser);
    } else {
      _currentUser = Provider.of<AppState>(context, listen: false).currentUser!;
    }

    futureFlights = _fetchFlights();
  }

  CookieAuth _getCookieAuth() {
    CookieJar cookieJar = Provider.of<CookieJar>(context, listen: false);
    return CookieAuth(cookieJar);
  }

  Future<List<Flight>> _fetchFlights() {
    return fetchFlights(_currentUser.id, _getCookieAuth());
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
    // For mobile, use full width; for desktop use 2/3 of width
    final containerWidth = isMobile ? screenWidth : screenWidth * 2 / 3;

    return Scaffold(
      body: Stack(
        children: [
          // Only show background if not on mobile
          if (!isMobile) const FloatyBackgroundWidget(),
          // For mobile, use a white background
          if (isMobile) Container(color: Colors.white),
          Column(
            children: [
              Header(),
              SizedBox(height: 20), // Space below the header
              Expanded(
                child: Center(
                  child: Container(
                    width: containerWidth,
                    padding: EdgeInsets.all(isMobile ? 8 : 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          isMobile
                              ? BorderRadius
                                  .zero // No rounded corners on mobile
                              : BorderRadius.vertical(top: Radius.circular(6)),
                      boxShadow:
                          isMobile
                              ? [] // No shadow on mobile
                              : [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Make buttons stack vertically on small screens
                        isMobile
                            ? Row(
                              children: [
                                // Add Flight button
                                Expanded(
                                  flex: 1,
                                  child: ElevatedButton.icon(
                                    onPressed: () async {
                                      // Navigate to AddFlightPage and wait for the result
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AddFlightPage(),
                                        ),
                                      );

                                      // If the result is true, fetch new flights to reflect the added one
                                      if (result == true) {
                                        setState(() {
                                          futureFlights = _fetchFlights();
                                        });
                                      }
                                    },
                                    icon: Icon(
                                      Icons.add,
                                      size: 18,
                                    ), // Plus sign icon
                                    label: Text(
                                      "Add Flight",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF0078D7),
                                      foregroundColor:
                                          Colors
                                              .white, // White text color for good contrast
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          20.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                // Export button
                                Expanded(
                                  flex: 1,
                                  child: ElevatedButton.icon(
                                    onPressed:
                                        _exportFlightsToCSV, // Calls the CSV export function
                                    icon: Icon(
                                      Icons.file_download,
                                      size: 16,
                                    ), // Export icon
                                    label: Text(
                                      "Export",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor:
                                          Colors.blueGrey, // Text color
                                    ),
                                  ),
                                ),
                              ],
                            )
                            : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    // Navigate to AddFlightPage and wait for the result
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddFlightPage(),
                                      ),
                                    );

                                    // If the result is true, fetch new flights to reflect the added one
                                    if (result == true) {
                                      setState(() {
                                        futureFlights = _fetchFlights();
                                      });
                                    }
                                  },
                                  icon: Icon(
                                    Icons.add,
                                    size: 18,
                                  ), // Plus sign icon
                                  label: Text(
                                    "Add Flight",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF0078D7),
                                    foregroundColor:
                                        Colors
                                            .white, // White text color for good contrast
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                ),

                                ElevatedButton.icon(
                                  onPressed:
                                      _exportFlightsToCSV, // Calls the CSV export function
                                  icon: Icon(
                                    Icons.file_download,
                                    size: 16,
                                  ), // Export icon
                                  label: Text(
                                    "Export",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor:
                                        Colors.blueGrey, // Text color
                                  ),
                                ),
                              ],
                            ),
                        SizedBox(height: 16),
                        FlightListView(
                          futureFlights: futureFlights,
                          onDeleteFlight: (flight) async {
                            await _deleteFlight(flight.flightId);
                            setState(() {
                              futureFlights = _fetchFlights();
                            });
                          },
                          onFlightUpdated: () {
                            setState(() {
                              futureFlights = _fetchFlights();
                            });
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
  final Function(Flight) onDeleteFlight;
  final Function() onFlightUpdated;
  final bool isMobile;

  FlightListView({
    required this.futureFlights,
    required this.onDeleteFlight,
    required this.onFlightUpdated,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<List<Flight>>(
        future: futureFlights,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading flights"));
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
                      color: Color(0xFF0078D7),
                    ),
                    SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        "Start your Floaty journey by adding your first flight!",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
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
            future: fetchAllSpots(_getCookieAuth(context)),
            builder: (context, spotsSnapshot) {
              if (!spotsSnapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              return FutureBuilder<List<api.Glider>>(
                future: fetchGliders(_getCookieAuth(context)),
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
                              vertical: 8,
                              horizontal: 8,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Flight number and date
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
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      Text(
                                        DateFormat('dd.MM.yyyy').format(
                                          DateTime.parse(flight.dateTime),
                                        ),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 16),
                                // Title and description
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${getSpotName(flight.launchSpotId)} - ${getSpotName(flight.landingSpotId)}",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF0078D7),
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        flight.description,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: true,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 8),
                                // Glider name
                                SizedBox(
                                  width: 120,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        getGliderName(flight.gliderId),
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                      SizedBox(height: 4),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.access_time,
                                            size: 15,
                                            color: Colors.black54,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            "${flight.duration ~/ 60}:${(flight.duration % 60).toString().padLeft(2, '0')}",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
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
                              vertical: 8,
                              horizontal: 16,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Flight number + date
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
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      Text(
                                        DateFormat('dd.MM.yyyy').format(
                                          DateTime.parse(flight.dateTime),
                                        ),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Title and description
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 24.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${getSpotName(flight.launchSpotId)} - ${getSpotName(flight.landingSpotId)}",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF0078D7),
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          flight.description,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                          softWrap: true,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Glider name and duration
                                SizedBox(
                                  width: 120,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        getGliderName(flight.gliderId),
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                      SizedBox(height: 4),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.access_time,
                                            size: 15,
                                            color: Colors.black54,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            "${flight.duration ~/ 60}:${(flight.duration % 60).toString().padLeft(2, '0')}",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
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
                        color: Colors.grey.withOpacity(0.3),
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
    CookieJar cookieJar = Provider.of<CookieJar>(context, listen: false);
    return CookieAuth(cookieJar);
  }
}
