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
  const AddFlightPage({super.key});

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

  bool _isLoading = false;

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
      if (mounted) {
        Navigator.pop(context, true);
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 700;
    final containerWidth = isMobile ? screenWidth : screenWidth * 2 / 3;

    return Scaffold(
      body: Stack(
        children: [
          if (!isMobile) const FloatyBackgroundWidget(),
          if (isMobile) Container(color: Colors.white),
          Column(
            children: [
              Header(),
              SizedBox(height: 20),
              Container(
                width: containerWidth,
                padding: EdgeInsets.all(isMobile ? 8 : 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      isMobile ? BorderRadius.zero : BorderRadius.circular(6),
                  boxShadow:
                      isMobile
                          ? []
                          : [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                ),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add New Flight',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        // Date Field
                        TextFormField(
                          controller: _dateController,
                          decoration: InputDecoration(
                            labelText: 'Date',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.calendar_today),
                              onPressed: () => _selectDate(context),
                            ),
                          ),
                          readOnly: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a date';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
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
                                          spot.type ==
                                              api.SpotTypeEnum.LAUNCH_SITE ||
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
                        SizedBox(height: 16),
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
                        SizedBox(height: 16),
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
                                  Icons.paragliding,
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
                                        '${glider.manufacturer} ${glider.model}',
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
                        SizedBox(height: 16),
                        // Duration Fields
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<int>(
                                value: selectedHours,
                                decoration: InputDecoration(
                                  labelText: 'Hours',
                                  border: OutlineInputBorder(),
                                ),
                                items: List.generate(13, (index) {
                                  return DropdownMenuItem<int>(
                                    value: index,
                                    child: Text('$index'),
                                  );
                                }),
                                onChanged: (value) {
                                  setState(() {
                                    selectedHours = value!;
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: DropdownButtonFormField<int>(
                                value: selectedMinutes,
                                decoration: InputDecoration(
                                  labelText: 'Minutes',
                                  border: OutlineInputBorder(),
                                ),
                                items: List.generate(60, (index) {
                                  return DropdownMenuItem<int>(
                                    value: index,
                                    child: Text('$index'),
                                  );
                                }),
                                onChanged: (value) {
                                  setState(() {
                                    selectedMinutes = value!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        // Description Field
                        TextFormField(
                          controller: _descriptionController,
                          decoration: InputDecoration(
                            labelText: 'Description',
                            border: OutlineInputBorder(),
                            alignLabelWithHint: true,
                          ),
                          maxLines: 3,
                        ),
                        SizedBox(height: 24),
                        // Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed:
                                  _isLoading
                                      ? null
                                      : () => Navigator.pop(context),
                              child: Text('Cancel'),
                            ),
                            SizedBox(width: 16),
                            ElevatedButton(
                              onPressed: _isLoading ? null : _saveNewFlight,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF0078D7),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                              ),
                              child:
                                  _isLoading
                                      ? SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      )
                                      : Text('Save'),
                            ),
                          ],
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
}
