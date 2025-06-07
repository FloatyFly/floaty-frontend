import 'package:cookie_jar/cookie_jar.dart';
import 'package:floaty/flight_service.dart';
import 'package:floaty/ui_components.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'CookieAuth.dart';
import 'model.dart';

class AddFlightPage extends StatefulWidget {
  const AddFlightPage({Key? key}) : super(key: key);

  @override
  _AddFlightPageState createState() => _AddFlightPageState();
}

class _AddFlightPageState extends State<AddFlightPage> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _launchSpotController = TextEditingController();
  final _landingSpotController = TextEditingController();
  final _gliderController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _focusDate = FocusNode();
  final _focusLaunchSpot = FocusNode();
  final _focusLandingSpot = FocusNode();
  final _focusGlider = FocusNode();
  final _focusDescription = FocusNode();

  bool isProcessing = false;
  String? errorMessage;
  String? flightTimeErrorMessage;

  int? selectedHours;
  int? selectedMinutes;

  final DateFormat formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss");

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat("dd.MM.yyyy").format(DateTime.now());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusLaunchSpot);
    });
  }

  @override
  void dispose() {
    _dateController.dispose();
    _launchSpotController.dispose();
    _landingSpotController.dispose();
    _gliderController.dispose();
    _descriptionController.dispose();
    _focusDate.dispose();
    _focusLaunchSpot.dispose();
    _focusLandingSpot.dispose();
    _focusGlider.dispose();
    _focusDescription.dispose();
    super.dispose();
  }

  CookieAuth _getCookieAuth() {
    CookieJar cookieJar = Provider.of<CookieJar>(context, listen: false);
    return CookieAuth(cookieJar);
  }

  Future<void> _saveNewFlight() async {
    if (!_formKey.currentState!.validate()) return;

    // Check if both hours and minutes are zero
    if ((selectedHours ?? 0) == 0 && (selectedMinutes ?? 0) == 0) {
      setState(() {
        flightTimeErrorMessage = "Flight time can not be 0 minutes.";
      });
      return;
    }

    setState(() {
      isProcessing = true;
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

      Flight flight = Flight(
        flightId: "",
        dateTime: formattedDate,
        launchSpotId: _launchSpotController.text,
        landingSpotId: _landingSpotController.text,
        gliderId: _gliderController.text,
        duration: duration,
        description: _descriptionController.text,
      );

      await addFlight(flight, _getCookieAuth());

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      setState(() {
        errorMessage = "Failed to save flight. Please try again.";
        isProcessing = false;
      });
    }
  }

  // Show the date picker dialog
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _dateController.text = DateFormat("dd.MM.yyyy").format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const FloatyBackgroundWidget(),
          Header(),
          AuthContainer(
            headerText: "Add New Flight",
            isFlightPage: true,
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Date Picker Field with Button
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _dateController,
                        focusNode: _focusDate,
                        decoration: InputDecoration(
                          hintText: "dd.MM.yyyy",
                          prefixIcon: IconButton(
                            icon: Icon(
                              Icons.calendar_today,
                              color: Colors.orange,
                            ),
                            onPressed: () => _selectDate(context),
                            padding: EdgeInsets.only(left: 7),
                          ),
                          prefixIconConstraints: BoxConstraints(maxWidth: 32),
                          contentPadding: EdgeInsets.only(left: 60),
                          isDense: false,
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter a valid date.";
                          }

                          try {
                            DateFormat dateFormat = DateFormat('dd.MM.yyyy');
                            dateFormat.parseStrict(value);
                            return null;
                          } catch (e) {
                            return "Enter a valid date.";
                          }
                        },
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted:
                            (_) => FocusScope.of(
                              context,
                            ).requestFocus(_focusLaunchSpot),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14.0),

                  // Launch Spot Field
                  TextFormField(
                    controller: _launchSpotController,
                    focusNode: _focusLaunchSpot,
                    decoration: InputDecoration(
                      hintText: "Launch Spot ID",
                      prefixIcon: Icon(
                        Icons.flight_takeoff,
                        color: Colors.orange,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter a launch spot ID.";
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted:
                        (_) => FocusScope.of(
                          context,
                        ).requestFocus(_focusLandingSpot),
                  ),
                  const SizedBox(height: 14.0),

                  // Landing Spot Field
                  TextFormField(
                    controller: _landingSpotController,
                    focusNode: _focusLandingSpot,
                    decoration: InputDecoration(
                      hintText: "Landing Spot ID",
                      prefixIcon: Icon(Icons.flight_land, color: Colors.orange),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter a landing spot ID.";
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted:
                        (_) =>
                            FocusScope.of(context).requestFocus(_focusGlider),
                  ),
                  const SizedBox(height: 14.0),

                  // Glider Field
                  TextFormField(
                    controller: _gliderController,
                    focusNode: _focusGlider,
                    decoration: InputDecoration(
                      hintText: "Glider ID",
                      prefixIcon: Icon(
                        Icons.airplanemode_active,
                        color: Colors.orange,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter a glider ID.";
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted:
                        (_) => FocusScope.of(
                          context,
                        ).requestFocus(_focusDescription),
                  ),
                  const SizedBox(height: 14.0),

                  // Duration (Hours and Minutes)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Hours Dropdown
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          value: selectedHours,
                          onChanged: (value) {
                            setState(() {
                              selectedHours = value;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: "Hours",
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            DropdownMenuItem<int>(
                              value: 0,
                              child: Text("0 Hours"),
                            ),
                            ...List.generate(12, (index) {
                              return DropdownMenuItem<int>(
                                value: index + 1,
                                child: Text("${index + 1} Hours"),
                              );
                            }),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Minutes Dropdown
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          value: selectedMinutes,
                          onChanged: (value) {
                            setState(() {
                              selectedMinutes = value;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: "Minutes",
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            DropdownMenuItem<int>(
                              value: 0,
                              child: Text("0 Minutes"),
                            ),
                            ...List.generate(12, (index) {
                              return DropdownMenuItem<int>(
                                value: (index + 1) * 5,
                                child: Text("${(index + 1) * 5} Minutes"),
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14.0),

                  // Show flight time error message if both hours and minutes are zero
                  if (flightTimeErrorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 0.0),
                      child: Text(
                        flightTimeErrorMessage!,
                        style: const TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ),

                  const SizedBox(height: 14.0),

                  // Description Field
                  TextField(
                    controller: _descriptionController,
                    focusNode: _focusDescription,
                    maxLines: null,
                    minLines: 3,
                    decoration: InputDecoration(
                      hintText: "Description",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 10.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  // Error Message
                  if (errorMessage != null)
                    Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  const SizedBox(height: 32.0),

                  // Buttons (Save and Cancel)
                  isProcessing
                      ? const CircularProgressIndicator()
                      : Row(
                        children: [
                          // Save Button
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  FocusScope.of(context).unfocus();
                                  _saveNewFlight();
                                }
                              },
                              child: const Text(
                                'Save',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Cancel Button
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey.shade300,
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ],
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
