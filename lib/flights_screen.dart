import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:floaty/flight_service.dart';

import 'model.dart';
import 'landing_page.dart';

class FlightsScreen extends StatefulWidget {
  final User? user;

  const FlightsScreen({required this.user});

  @override
  FlightsScreenState createState() => FlightsScreenState();
}

class FlightsScreenState extends State<FlightsScreen> {
  // List of flights to display
  late Future<List<Flight>> futureFlights;

  // Currently logged in user
  late User _currentUser;

  // Data containers for newly entered flight data
  String? date;
  String? takeoff;
  int? duration;

  // Overlay for new flight entry
  late OverlayEntry overlayEntry;

  // Input validation utilities
  final _formKey = GlobalKey<FormState>();
  bool isFormValid = false;
  final DateFormat formatter = DateFormat('dd.MM.yyyy');

  TextEditingController dateController = TextEditingController();
  TextEditingController takeoffController = TextEditingController();
  TextEditingController durationController = TextEditingController();

  // Button style
  final ButtonStyle style = ElevatedButton.styleFrom(
    textStyle: const TextStyle(
      fontSize: 12.0,
    ),
    padding: EdgeInsets.all(10.0),
  );

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user!;
    futureFlights = fetchFlights();
  }

  void showOverlay(BuildContext context) {
    overlayEntry = createOverlayEntry(context);
    Overlay.of(context).insert(overlayEntry);
  }

  Future<void> saveFlight() async {
    final formattedDate = formatter.format(DateTime.parse(dateController.text));
    String flightJson = jsonEncode({
      "userId": _currentUser.displayName,
      "date": formattedDate,
      "takeoff": takeoffController.text,
      "duration": durationController.text,
    });
    print("JSON: $flightJson");
    await addFlight(flightJson);
  }

  OverlayEntry createOverlayEntry(BuildContext context) {
    return OverlayEntry(
      builder: (context) => Positioned(
        top: 200,
        left: 100,
        right: 100,
        child: Material(
          elevation: 4.0,
          child: Container(
            padding: EdgeInsets.all(20.0),
            color: Colors.white,
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: () {
                    setState(() {
                      isFormValid = _formKey.currentState?.validate() ?? false;
                    });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: dateController,
                        decoration: InputDecoration(
                          hintText: "Date of Flight (yyyy-mm-dd)",
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              DateTime.tryParse(value) == null ||
                              DateTime.parse(value).isAfter(DateTime.now())) {
                            return "Please enter a valid date in the format yyyy-mm-dd";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: takeoffController,
                        decoration: InputDecoration(
                          hintText: "Takeoff Location",
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter a takeoff location";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: durationController,
                        decoration: InputDecoration(
                          hintText: "Flight Duration (minutes)",
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              int.tryParse(value) == null) {
                            return "Please enter a valid duration in minutes";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(
                          child: Text('Cancel'),
                          onPressed: () => overlayEntry.remove(),
                        ),
                      ),
                      Visibility(
                        visible: isFormValid,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () async {
                              try {
                                await saveFlight();
                              } catch (e) {
                                print("Failed to save flight, error: $e");
                              }

                              setState(() {
                                futureFlights = fetchFlights();
                              });

                              overlayEntry.remove(); // Close the dialog
                            },
                            style: style,
                            child: Text('Save'),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/background.jpg"),
                fit: BoxFit.cover,
                opacity: 0.3),
          ),
        ),
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.grey.withOpacity(0.5),
        ),
        // Dot Grid Overlay
        Positioned.fill(
          child: CustomPaint(
            painter: DotGridPainter(),
          ),
        ),
        Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.white,
                      Colors.white,
                      Colors.transparent
                    ],
                    stops: [
                      0.01,
                      0.05,
                      0.95,
                      1.0
                    ], // Adjust the stops to determine the fade area
                  ).createShader(bounds);
                },
                blendMode: BlendMode.dstIn,
                child: FutureBuilder<List<Flight>>(
                  future: futureFlights,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          Flight flight = snapshot.data![index];
                          return Stack(
                            children: [
                              Card(
                                margin: EdgeInsets.all(10.0),
                                child: Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: [
                                          Icon(Icons.person_outline,
                                              color: Colors.blue),
                                          SizedBox(width: 8.0),
                                          Text(
                                            flight.user.name,
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8.0),
                                      Row(
                                        children: [
                                          Icon(Icons.date_range,
                                              color: Colors.lightBlueAccent),
                                          SizedBox(width: 8.0),
                                          Text(
                                            flight.date.toString(),
                                            style: TextStyle(fontSize: 16.0),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8.0),
                                      Row(
                                        children: [
                                          Icon(Icons.flight_takeoff,
                                              color: Colors.lightGreen),
                                          SizedBox(width: 8.0),
                                          Text(
                                            'Takeoff: ${flight.takeoff}',
                                            style: TextStyle(fontSize: 16.0),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8.0),
                                      Row(
                                        children: [
                                          Icon(Icons.timer,
                                              color: Colors.redAccent),
                                          SizedBox(width: 8.0),
                                          Text(
                                            '${flight.duration.toString()} minutes',
                                            style: TextStyle(fontSize: 16.0),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 10.0,
                                right: 10.0,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.grey[400], // muted color
                                  ),
                                  onPressed: () async {
                                    await deleteFlight(flight.flightId);
                                    setState(() {
                                      futureFlights = fetchFlights();
                                    });
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text('${snapshot.error}'));
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding:
                    const EdgeInsets.only(right: 30.0, bottom: 30.0, top: 5),
                child: SizedBox(
                  width: 80, // provide a custom width
                  height: 80, // provide a custom height
                  child: FloatingActionButton(
                    backgroundColor: Color(0xFF8BC34A),
                    onPressed: () => showOverlay(context),
                    child: Icon(Icons.add, size: 40),
                  ),
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
