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
    bool isDebug = true;
    if (isDebug) {
      _currentUser = FloatyUser(id: 1, name: "Floater", email: "floater@test.com", emailVerified: true);
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
      flights.sort((a, b) => b.dateTime.compareTo(a.dateTime));  // Sort descending by dateTime (newest first)

      // Prepare CSV data
      List<List<dynamic>> rows = [];
      rows.add(['Flight', 'Date', 'Takeoff Location', 'Duration (minutes)', 'Description']); // Header row

      // Assign flight number starting from 1 based on the sorted order
      for (int i = 0; i < flights.length; i++) {
        final flight = flights[i];
        String formattedDate = DateFormat('dd.MM.yyyy').format(DateTime.parse(flight.dateTime));
        rows.add([
          (i + 1),  // Flight Number (starts from 1)
          formattedDate,  // Date
          flight.takeOff,   // Takeoff Location
          flight.duration,  // Duration
          flight.description, // Description
        ]);
      }

      // Convert rows to CSV string
      String csv = const ListToCsvConverter().convert(rows);

      // Convert the CSV string to a Uint8List for downloading
      Uint8List csvBytes = Uint8List.fromList(utf8.encode(csv));

      // Download the file on the device
      await FileSaver.instance.saveFile(
        name: 'flights',  // Name the file
        ext: 'csv',           // File extension
        bytes: csvBytes,      // CSV bytes
        mimeType: MimeType.csv, // Mime type for CSV
      );

      // Notify the user that the file has been saved
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('CSV created. Download ready!')),
      );

    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to export CSV: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double containerWidth = MediaQuery.of(context).size.width * 2 / 3;

    return Scaffold(
      body: Stack(
        children: [
          const FloatyBackgroundWidget(),
          Column(
            children: [
              Header(),
              SizedBox(height: 20), // Space below the header
              Expanded(
                child: Center(
                  child: Container(
                    width: containerWidth,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(6)),
                      boxShadow: [
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
                        Row(
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
                              icon: Icon(Icons.add, size: 18), // Plus sign icon
                              label: Text(
                                "Add Flight",
                                style: TextStyle(fontSize: 16),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF00B5B8),  // Use blue or any color that stands out
                                foregroundColor: Colors.white,  // White text color for good contrast
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            ),

                            ElevatedButton.icon(
                              onPressed: _exportFlightsToCSV, // Calls the CSV export function
                              icon: Icon(Icons.file_download, size: 16), // Export icon
                              label: Text(
                                "Export",
                                style: TextStyle(fontSize: 14),
                              ),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.blueGrey, // Text color
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

  Future<void> _deleteFlight(String flightId) async {
    await deleteFlight(flightId, _getCookieAuth());
  }
}

class FlightListView extends StatelessWidget {
  final Future<List<Flight>> futureFlights;
  final Function(Flight) onDeleteFlight;

  FlightListView({
    required this.futureFlights,
    required this.onDeleteFlight,
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
            return Center(child: Text("No flights available"));
          }

          // Sort flights by date, assuming Flight has a DateTime property called `dateTime`
          final flights = snapshot.data!;
          flights.sort((a, b) => b.dateTime.compareTo(a.dateTime));  // Newest first

          return ListView.separated(
            itemCount: flights.length,
            itemBuilder: (context, index) {
              final flight = flights[index];

              // Generate the flight number based on the index such that the newest flight gets the highest number
              final flightNumber = "${flights.length - index}";  // Reverse the order of numbering

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Row(
                  children: [
                    // Flight number + date (Fixed Width)
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1, // 10% of screen width
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            flightNumber,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                          Text(
                            flight.dateTime.toString().substring(0, 10).split("-").reversed.join("."),
                            style: TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: 10), // Small spacing

                    // Takeoff & Description (At 1/5th of Row Width)
                    Expanded(
                      flex: 5, // 1/5th of total space
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            flight.takeOff,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey[900]),
                          ),
                          SizedBox(height: 1),
                          Padding(
                            padding: const EdgeInsets.only(right: 16.0), // Add padding to the right side
                            child: Text(
                              flight.description,
                              style: TextStyle(fontSize: 14, color: Colors.black87),
                              softWrap: true, // Enables wrapping
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Flight Duration (At 4/5th of Row Width)
                    Expanded(
                      flex: 1, // 4/5th of total space
                      child: Align(
                        alignment: Alignment.centerLeft, // Ensures left alignment
                        child: Row(
                          mainAxisSize: MainAxisSize.min, // Ensures row size is as small as needed
                          children: [
                            Icon(
                              Icons.access_time,  // Clock icon
                              size: 15,  // Icon size
                              color: Colors.black54,  // Icon color
                            ),
                            SizedBox(width: 4),  // Small spacing between icon and text
                            Text(
                              // Convert the duration (in minutes) such that it is displayed in the format 1:30
                              "${flight.duration ~/ 60}:${(flight.duration % 60).toString().padLeft(2, '0')}",
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),


                    // Delete Button (Fixed Size)
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.blueGrey, size: 17,),
                      onPressed: () async {
                        await onDeleteFlight(flight);
                      },
                    ),
                  ],
                ),
              );

            },
            separatorBuilder: (context, index) {
              return Divider(
                color: Colors.grey.withOpacity(0.3), // Thin divider line with light color
                height: 1, // Set height to make it thin
                thickness: 1, // Set thickness to make the line thin
              );
            },
          );
        },
      ),
    );
  }
}





