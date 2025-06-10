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

class EditFlightPage extends StatefulWidget {
  final Flight flight;

  const EditFlightPage({super.key, required this.flight});

  @override
  _EditFlightPageState createState() => _EditFlightPageState();
}

class _EditFlightPageState extends State<EditFlightPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _dateController;
  late TextEditingController _descriptionController;
  final _focusDate = FocusNode();
  final _focusDescription = FocusNode();

  bool _isLoading = false;
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

    // Initialize controllers with existing flight data
    final date = DateTime.parse(widget.flight.dateTime);
    _dateController = TextEditingController(
      text: DateFormat("dd.MM.yyyy").format(date),
    );
    _descriptionController = TextEditingController(
      text: widget.flight.description,
    );

    // Set initial values for dropdowns
    selectedLaunchSpotId = widget.flight.launchSpotId;
    selectedLandingSpotId = widget.flight.landingSpotId;
    selectedGliderId = widget.flight.gliderId;

    // Set initial duration values
    selectedHours = widget.flight.duration ~/ 60;
    selectedMinutes = widget.flight.duration % 60;

    // Adjust selectedMinutes to match dropdown values (multiples of 5)
    if (selectedMinutes != null && selectedMinutes! % 5 != 0) {
      selectedMinutes = (selectedMinutes! / 5).round() * 5;
      if (selectedMinutes == 60) {
        selectedMinutes = 0;
        selectedHours = (selectedHours ?? 0) + 1;
      }
    }

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

  Future<void> _updateFlight() async {
    if (!_formKey.currentState!.validate()) return;

    // Check if both hours and minutes are zero
    if ((selectedHours ?? 0) == 0 && (selectedMinutes ?? 0) == 0) {
      setState(() {
        flightTimeErrorMessage = "Flight time can not be 0 minutes.";
      });
      return;
    }

    setState(() {
      _isLoading = true;
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

      Flight updatedFlight = Flight(
        flightId: widget.flight.flightId,
        dateTime: formattedDate,
        launchSpotId: selectedLaunchSpotId!,
        landingSpotId: selectedLandingSpotId!,
        gliderId: selectedGliderId!,
        duration: duration,
        description: _descriptionController.text,
      );

      await updateFlight(updatedFlight, _getCookieAuth());

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      setState(() {
        errorMessage = "Failed to update flight. Please try again.";
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteFlight() async {
    // Show confirmation dialog before deleting
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Delete Flight'),
            content: Text('Are you sure you want to delete this flight?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: Text('Delete'),
              ),
            ],
          ),
    );

    if (shouldDelete == true) {
      setState(() {
        _isLoading = true;
        errorMessage = null;
      });

      try {
        await deleteFlight(widget.flight.flightId, _getCookieAuth());

        if (mounted) {
          Navigator.pop(context, true);
        }
      } catch (e) {
        setState(() {
          errorMessage = "Failed to delete flight. Please try again.";
          _isLoading = false;
        });
      }
    }
  }

  // Show the date picker dialog
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(widget.flight.dateTime),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
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
                          'Edit Flight',
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
                                labelText: 'Launch Site',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
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
                                labelText: 'Landing Site',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
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
                                labelText: 'Glider',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
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
                                items: [
                                  DropdownMenuItem<int>(
                                    value: 0,
                                    child: Text('0 Hours'),
                                  ),
                                  ...List.generate(12, (index) {
                                    return DropdownMenuItem<int>(
                                      value: index + 1,
                                      child: Text('${index + 1} Hours'),
                                    );
                                  }),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    selectedHours = value;
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
                                items: [
                                  DropdownMenuItem<int>(
                                    value: 0,
                                    child: Text('0 Minutes'),
                                  ),
                                  ...List.generate(12, (index) {
                                    return DropdownMenuItem<int>(
                                      value: (index + 1) * 5,
                                      child: Text('${(index + 1) * 5} Minutes'),
                                    );
                                  }),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    selectedMinutes = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        if (flightTimeErrorMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              flightTimeErrorMessage!,
                              style: TextStyle(color: Colors.red, fontSize: 14),
                            ),
                          ),
                        SizedBox(height: 16),
                        // Description Field
                        TextFormField(
                          controller: _descriptionController,
                          decoration: InputDecoration(
                            labelText: 'Description',
                            border: OutlineInputBorder(),
                            alignLabelWithHint: true,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          maxLines: 3,
                        ),
                        if (errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              errorMessage!,
                              style: TextStyle(color: Colors.red, fontSize: 14),
                            ),
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
                              onPressed: _isLoading ? null : _updateFlight,
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
                            SizedBox(width: 16),
                            ElevatedButton(
                              onPressed: _isLoading ? null : _deleteFlight,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                              ),
                              child: Text('Delete'),
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
