import 'package:cookie_jar/cookie_jar.dart';
import 'package:floaty/flight_service.dart';
import 'package:floaty/ui_components.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'CookieAuth.dart';
import 'model.dart';

class AddFlightPage extends StatefulWidget {
  const AddFlightPage();

  @override
  _AddFlightPageState createState() => _AddFlightPageState();
}

class _AddFlightPageState extends State<AddFlightPage> {
  final _formKey = GlobalKey<FormState>();
  bool isFormValid = false;

  final TextEditingController dateController = TextEditingController();
  final TextEditingController takeoffController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final DateFormat formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss");

  CookieAuth _getCookieAuth() {
    CookieJar cookieJar = Provider.of<CookieJar>(context, listen: false);
    return CookieAuth(cookieJar);
  }

  Future<void> _saveNewFlight() async {
    try {
      final formattedDate = formatter.format(DateTime.parse(dateController.text));

      Flight flight = Flight(
        flightId: "",
        dateTime: formattedDate,
        takeOff: takeoffController.text,
        duration: int.parse(durationController.text),
        description: descriptionController.text,
      );

      await addFlight(flight, _getCookieAuth());
      Navigator.pop(context); // Return to FlightsPage after saving the flight
    } catch (e) {
      print("Failed to save flight, error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const FloatyBackgroundWidget(), // The background remains in the stack
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Header(), // Header is at the top
          ),
          Positioned(
            top: 120.0, // Adjust for header space
            left: 0,
            right: 0,
            bottom: 0, // Ensure the form takes up the remaining space
            child: AddFlightContainer(
              headerText: "Add New Flight",
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: () {
                  setState(() {
                    isFormValid = _formKey.currentState?.validate() ?? false;
                  });
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: dateController,
                      decoration: InputDecoration(labelText: "Date (YYYY-MM-DD)"),
                      validator: (value) {
                        if (value == null || value.isEmpty || DateTime.tryParse(value) == null || DateTime.parse(value).isAfter(DateTime.now())) {
                          return "Please enter a valid date.";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: takeoffController,
                      decoration: InputDecoration(labelText: "Takeoff Location"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a takeoff location.";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: durationController,
                      decoration: InputDecoration(labelText: "Flight Duration (minutes)"),
                      validator: (value) {
                        if (value == null || value.isEmpty || int.tryParse(value) == null) {
                          return "Please enter a valid duration in minutes.";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: descriptionController,
                      decoration: InputDecoration(labelText: "Description"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Save Button
                          ElevatedButton(
                            onPressed: isFormValid ? _saveNewFlight : null,
                            child: Text("Save Flight"),
                          ),
                          SizedBox(width: 16),
                          // Cancel Button
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context); // Navigate back to the Flights page
                            },
                            child: Text("Cancel"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class AddFlightContainer extends StatelessWidget {
  final String headerText;
  final Widget child;

  const AddFlightContainer({
    Key? key,
    required this.headerText,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 400,
        height: 550,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Column(
          children: [
            // Header Box
            Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12.0),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                headerText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Child widget (the form input logic)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

