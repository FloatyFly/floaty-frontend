import 'package:cookie_jar/cookie_jar.dart';
import 'package:floaty/flight_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'CookieAuth.dart';
import 'model.dart';
import 'add_flight_page.dart';
import 'ui_components.dart'; // Import your UI components here like FloatyBackgroundWidget and Header

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

  Future<void> _deleteFlight(String flightId) async {
    await deleteFlight(flightId, _getCookieAuth());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          const FloatyBackgroundWidget(),
          // Header
          Header(),
          // Main Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0).copyWith(top: 120.0),
            child: FutureBuilder<List<Flight>>(
              future: futureFlights,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No flights added yet.'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    Flight flight = snapshot.data![index];
                    return ListTile(
                      title: Text(flight.takeOff),
                      subtitle: Text(flight.dateTime),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          await _deleteFlight(flight.flightId);
                          setState(() {
                            futureFlights = _fetchFlights();
                          });
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to AddFlightPage
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddFlightPage(),
            ),
          ).then((_) {
            setState(() {
              futureFlights = _fetchFlights(); // Refresh the flight list after adding a new flight
            });
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
