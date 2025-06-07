import 'package:cookie_jar/cookie_jar.dart';
import 'package:floaty/flight_service.dart';
import 'package:floaty/gliders_service.dart';
import 'package:floaty/spots_service.dart';
import 'package:floaty/ui_components.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'CookieAuth.dart';
import 'model.dart';
import 'package:floaty_client/api.dart' as api;
import 'constants.dart';

class AddFlightPage extends StatefulWidget {
  const AddFlightPage({Key? key}) : super(key: key);

  @override
  _AddFlightPageState createState() => _AddFlightPageState();
}

class _AddFlightPageState extends State<AddFlightPage> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _focusDate = FocusNode();
  final _focusDescription = FocusNode();

  bool isProcessing = false;
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

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat("dd.MM.yyyy").format(DateTime.now());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusDate);
    });

    // Initialize futures for spots and gliders
    futureSpots = fetchAllSpots(_getCookieAuth());
    futureGliders = fetchGliders(_getCookieAuth());
  }

  @override
  void dispose() {
    _dateController.dispose();
    _descriptionController.dispose();
    _focusDate.dispose();
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
        flightId: 0,
        dateTime: formattedDate,
        launchSpotId: selectedLaunchSpotId!,
        landingSpotId: selectedLandingSpotId!,
        gliderId: selectedGliderId!,
        duration: duration,
        description: _descriptionController.text,
      );

      final result = await addFlight(flight, _getCookieAuth());
      if (result != null) {
        if (mounted) {
          Navigator.pop(context, true);
        }
      } else {
        setState(() {
          errorMessage = "Failed to save flight. Please try again.";
          isProcessing = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Failed to save flight: ${e.toString()}";
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
                            (_) => FocusScope.of(context).unfocus(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14.0),

                  // Launch Spot Dropdown
                  FutureBuilder<List<api.Spot>>(
                    future: futureSpots,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }

                      final spots = snapshot.data!;
                      final launchSpots =
                          spots
                              .where(
                                (spot) =>
                                    spot.type == api.SpotTypeEnum.LAUNCH_SITE ||
                                    spot.type ==
                                        api
                                            .SpotTypeEnum
                                            .LAUNCH_AND_LANDING_SITE,
                              )
                              .toList();

                      return DropdownButtonFormField<int>(
                        value: selectedLaunchSpotId,
                        decoration: InputDecoration(
                          hintText: "Launch Site",
                          prefixIcon: Icon(
                            Icons.flight_takeoff,
                            color: Colors.orange,
                          ),
                          border: OutlineInputBorder(),
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
                  const SizedBox(height: 14.0),

                  // Landing Spot Dropdown
                  FutureBuilder<List<api.Spot>>(
                    future: futureSpots,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }

                      final spots = snapshot.data!;
                      final landingSpots =
                          spots
                              .where(
                                (spot) =>
                                    spot.type ==
                                        api.SpotTypeEnum.LANDING_SITE ||
                                    spot.type ==
                                        api
                                            .SpotTypeEnum
                                            .LAUNCH_AND_LANDING_SITE,
                              )
                              .toList();

                      return DropdownButtonFormField<int>(
                        value: selectedLandingSpotId,
                        decoration: InputDecoration(
                          hintText: "Landing Site",
                          prefixIcon: Icon(
                            Icons.flight_land,
                            color: Colors.orange,
                          ),
                          border: OutlineInputBorder(),
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
                  const SizedBox(height: 14.0),

                  // Glider Dropdown
                  FutureBuilder<List<api.Glider>>(
                    future: futureGliders,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }

                      final gliders = snapshot.data!;
                      return DropdownButtonFormField<int>(
                        value: selectedGliderId,
                        decoration: InputDecoration(
                          hintText: "Glider",
                          prefixIcon: Icon(
                            Icons.airplanemode_active,
                            color: Colors.orange,
                          ),
                          border: OutlineInputBorder(),
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
                                  "${glider.manufacturer} ${glider.model}",
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
