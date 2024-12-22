import 'package:cookie_jar/cookie_jar.dart';
import 'package:floaty/ui_components.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:floaty/flight_service.dart';
import 'package:provider/provider.dart';

import 'CookieAuth.dart';
import 'model.dart';

class FlightsPage extends StatefulWidget {
  final FloatyUser? user;

  const FlightsPage({required this.user});

  @override
  FlightsPageState createState() => FlightsPageState();
}

class FlightsPageState extends State<FlightsPage> {
  late Future<List<Flight>> futureFlights;
  late FloatyUser _currentUser;

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
  TextEditingController descriptionController = TextEditingController();

  // Button style
  final ButtonStyle style = ElevatedButton.styleFrom(
    textStyle: const TextStyle(
      fontSize: 12.0,
    ),
  );

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user!;
    futureFlights = _fetchFlights();
  }

  CookieAuth _getCookieAuth() {
    CookieJar cookieJar = Provider.of<CookieJar>(context, listen: false);
    return CookieAuth(cookieJar);
  }

  Future<List<Flight>> _fetchFlights() {
    return fetchFlights(_currentUser.id, _getCookieAuth());
  }

  Future<void> _saveNewFlight() async {
    final DateFormat formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
    final formattedDate = formatter.format(DateTime.parse(dateController.text));

    Flight flight = Flight(
      flightId: "",
      dateTime: formattedDate,
      takeOff: takeoffController.text,
      duration: int.parse(durationController.text),
      description: descriptionController.text,
    );
    await addFlight(flight, _getCookieAuth());
  }

  Future<void> _deleteFlight(String flightId) async {
    await deleteFlight(flightId, _getCookieAuth());
  }

  void showOverlay(BuildContext context) {
    overlayEntry = createAddFlightOverlay(context);
    Overlay.of(context).insert(overlayEntry);
  }

  OverlayEntry createAddFlightOverlay(BuildContext context) {
    return OverlayEntry(
      builder: (context) => Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.black54, // Adds semi-transparent overlay
        child: Center(
          child: Material(
            elevation: 10.0,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.7,
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Form(
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
                        hintText: "Date YYYY-MM-DD",
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                        ),
                        icon: Icon(Icons.date_range),
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
                          icon: Icon(Icons.location_pin)
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
                          icon: Icon(Icons.timer)
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
                    TextFormField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                          hintText: "Description",
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                          ),
                          icon: Icon(Icons.description)
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Cancel Button
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextButton(
                              onPressed: () {
                                overlayEntry.remove(); // Close overlay
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.deepOrange, backgroundColor: Colors.white, // Button background
                                side: BorderSide(color: Colors.deepOrange), // Border color
                                textStyle: TextStyle(fontSize: 14.0), // Text size
                              ),
                              child: Text('Cancel'),
                            ),
                          ),
                          // Save Button (only visible if form is valid)
                          Visibility(
                            visible: isFormValid,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                onPressed: () async {
                                  try {
                                    await _saveNewFlight();
                                    setState(() {
                                      futureFlights = _fetchFlights();
                                    });
                                    overlayEntry.remove(); // Close the overlay
                                  } catch (e) {
                                    print("Failed to save flight, error: $e");
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black, backgroundColor: Colors.deepOrange, // Text color
                                  textStyle: TextStyle(fontSize: 14.0), // Text size
                                ),
                                child: Text('Save'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
        const FloatyBackgroundWidget(),
        Header(),
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
                      if (snapshot.data!.isEmpty) {
                        // Show a custom message when no flights are logged
                        return Center(
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 5,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(width: 10),
                                Text(
                                  'You have no flights logged yet. Go fly! 🚀',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

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
                                  child: Row(  // Main horizontal layout
                                    crossAxisAlignment: CrossAxisAlignment.start,  // Align items at the start vertically
                                    children: <Widget>[
                                      // Container for icons and labels to ensure they are tightly packed
                                      Container(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              children: [
                                                Icon(Icons.date_range, color: Colors.lightBlueAccent),
                                                SizedBox(width: 8.0),
                                                Text(
                                                  flight.dateTime.toString(),
                                                  style: TextStyle(fontSize: 16.0),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 8.0),
                                            Row(
                                              children: [
                                                Icon(Icons.flight_takeoff, color: Colors.lightGreen),
                                                SizedBox(width: 8.0),
                                                Text(
                                                  'Takeoff: ${flight.takeOff}',
                                                  style: TextStyle(fontSize: 16.0),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 8.0),
                                            Row(
                                              children: [
                                                Icon(Icons.timer, color: Colors.redAccent),
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
                                      // Expanded widget for the description to ensure it fills the remaining space
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(top: 20.0, left: 120.0, right: 40),  // Top margin to avoid overlapping with delete button
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10), // Rounded corners
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),  // Internal padding
                                            child: Text(
                                              flight.description != null ? flight.description : "",
                                              style: TextStyle(fontSize: 16.0),
                                              textAlign: TextAlign.justify,
                                            ),
                                          ),
                                        ),
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
                                    await _deleteFlight(flight.flightId);
                                    setState(() {
                                      futureFlights = _fetchFlights();
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
                    backgroundColor: Colors.deepOrangeAccent,
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
