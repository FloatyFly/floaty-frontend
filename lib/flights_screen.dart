import 'package:flutter/material.dart';
import 'package:floaty/flight_service.dart';

import 'model.dart';

class FlightsScreen extends StatefulWidget {
  @override
  _FlightsScreenState createState() => _FlightsScreenState();
}

class _FlightsScreenState extends State<FlightsScreen> {
  late Future<List<Flight>> futureFlights;

  @override
  void initState() {
    super.initState();
    futureFlights = fetchFlights();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flights')),
      body: Column(
        children: [
          Expanded(
            child:
              FutureBuilder<List<Flight>>(
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: [
                                        Icon(Icons.person_outline, color: Colors.blue),
                                        SizedBox(width: 8.0),
                                        Text(
                                          '${flight.user.name}',
                                          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8.0),
                                    Row(
                                      children: [
                                        Icon(Icons.date_range, color: Colors.lightBlueAccent),
                                        SizedBox(width: 8.0),
                                        Text(
                                          '${flight.date.toString()}',
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
                                          'Takeoff: ${flight.takeoff}',
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
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 30.0, bottom: 30.0),
              child: SizedBox(
                width: 80,  // provide a custom width
                height: 80, // provide a custom height
                child: FloatingActionButton(
                  backgroundColor: Color(0xFF8BC34A),
                  onPressed: () async {
                    await addRandomFlight();
                    setState(() {
                      futureFlights = fetchFlights();
                    });
                  },
                  child: Icon(Icons.add, size: 40),  // increase the icon size accordingly
                  mini: false,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}