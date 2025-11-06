import 'package:floaty/services/gliders_service.dart';
import 'package:floaty/services/spots_service.dart';
import 'package:floaty/widgets/ui_components.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'dart:io';
import '../config/CookieAuth.dart';
import '../config/theme.dart';
import '../models/model.dart';
import '../services/flight_service.dart';
import 'package:floaty_client/api.dart' as api;

class AddFlightPage extends StatefulWidget {
  final Flight? latestFlight;

  const AddFlightPage({super.key, this.latestFlight});

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

  // IGC file upload fields
  File? _selectedIgcFile;
  String? _igcFileName;
  List<int>? _selectedIgcBytes;

  late Future<List<api.Spot>> futureSpots;
  late Future<List<api.Glider>> futureGliders;

  final DateFormat formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss");

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat("dd.MM.yyyy").format(DateTime.now());

    // Pre-select values from latest flight if available
    if (widget.latestFlight != null) {
      selectedLaunchSpotId = widget.latestFlight!.launchSpotId;
      selectedLandingSpotId = widget.latestFlight!.landingSpotId;
      selectedGliderId = widget.latestFlight!.gliderId;
    }

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
    return CookieAuth();
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

      // Use the new service function that handles IGC upload
      await addFlightWithIgc(
        flight,
        _selectedIgcFile,
        _igcFileName,
        _getCookieAuth(),
        igcBytes: _selectedIgcBytes,
      );

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

  // Pick IGC file
  Future<void> _pickIgcFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['igc'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        // Check if we're on web (bytes available) or mobile/desktop (path available)
        if (result.files.first.bytes != null) {
          // Web platform - use bytes
          setState(() {
            _selectedIgcFile = null; // We'll store bytes separately for web
            _igcFileName = result.files.first.name;
            _selectedIgcBytes = result.files.first.bytes; // Store bytes for web
          });
        } else {
          // Mobile/desktop platform - use path
          final path = result.files.first.path;
          if (path != null) {
            final file = File(path);
            setState(() {
              _selectedIgcFile = file;
              _igcFileName = result.files.first.name;
            });
          } else {
            setState(() {
              errorMessage = "Unable to access file path";
            });
            return;
          }
        }
      } else {
        // Handle case where no file is selected
      }
    } catch (e) {
      setState(() {
        errorMessage = "Failed to pick IGC file: ${e.toString()}";
      });
    }
  }

  // Remove selected IGC file
  void _removeIgcFile() {
    setState(() {
      _selectedIgcFile = null;
      _igcFileName = null;
      _selectedIgcBytes = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 700;
    final containerWidth = isMobile ? screenWidth : screenWidth * 2 / 3;
    final shadColors = getShadThemeData().colorScheme;

    return Scaffold(
      backgroundColor: shadColors.background,
      body: Stack(
        children: [
          if (!isMobile) const FloatyBackgroundWidget(),
          if (isMobile) Container(color: shadColors.background),
          Column(
            children: [
              Header(),
              SizedBox(height: 20),
              Container(
                width: containerWidth,
                padding: EdgeInsets.all(isMobile ? 16 : 24),
                decoration: BoxDecoration(
                  color: shadColors.card,
                  borderRadius: isMobile
                      ? BorderRadius.zero
                      : BorderRadius.vertical(top: Radius.circular(12)),
                  border: isMobile
                      ? null
                      : Border.all(color: shadColors.border, width: 1),
                  boxShadow: isMobile
                      ? []
                      : [
                          BoxShadow(
                            color: shadColors.foreground.withValues(alpha: 0.05),
                            spreadRadius: 0,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                ),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add New Flight',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: shadColors.foreground,
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
                                labelText: "Launch Site",
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
                                labelText: "Landing Site",
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
                                labelText: "Glider",
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
                        if (flightTimeErrorMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 8.0,
                              left: 16.0,
                            ),
                            child: Text(
                              flightTimeErrorMessage!,
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Theme.of(context).colorScheme.error,
                                height: 16.0 / 12.0,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.4,
                              ),
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
                          ),
                          maxLines: 3,
                        ),
                        SizedBox(height: 16),
                        // IGC File Upload
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          child:
                              (_selectedIgcFile == null &&
                                      _selectedIgcBytes == null)
                                  ? InkWell(
                                    onTap: _pickIgcFile,
                                    borderRadius: BorderRadius.circular(6),
                                    child: Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 16,
                                        horizontal: 16,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey.shade400,
                                          width: 2,
                                          style: BorderStyle.none,
                                        ),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: CustomPaint(
                                        painter: DashedBorderPainter(),
                                        child: Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.symmetric(
                                            vertical: 16,
                                            horizontal: 16,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.cloud_upload_outlined,
                                                size: 24,
                                                color: Colors.grey.shade600,
                                              ),
                                              SizedBox(width: 12),
                                              Text(
                                                MediaQuery.of(
                                                          context,
                                                        ).size.width <
                                                        600
                                                    ? 'Click to upload IGC file (optional).'
                                                    : 'Drag & drop IGC file here or click to browse (optional)...',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey.shade700,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  : Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 16,
                                      horizontal: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey.shade400,
                                        width: 2,
                                        style: BorderStyle.none,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: CustomPaint(
                                      painter: DashedBorderPainter(),
                                      child: Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.symmetric(
                                          vertical: 16,
                                          horizontal: 16,
                                        ),
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              'assets/images/track.png',
                                              width: 24,
                                              height: 24,
                                            ),
                                            SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                _igcFileName!,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey.shade700,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: _removeIgcFile,
                                              icon: Icon(
                                                Icons.close,
                                                color: Colors.red,
                                                size: 20,
                                              ),
                                              padding: EdgeInsets.zero,
                                              constraints: BoxConstraints(
                                                minWidth: 24,
                                                minHeight: 24,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                        ),
                        SizedBox(height: 24),
                        // Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FloatyButton(
                              onPressed: () => Navigator.pop(context),
                              text: 'Cancel',
                              backgroundColor: Colors.grey.shade100,
                              foregroundColor: Colors.black,
                              enabled: !_isLoading,
                              padding: EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                            SizedBox(width: 16),
                            _isLoading
                                ? Container(
                                    width: 120,
                                    height: 48,
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Color(0xFF2B7DE9),
                                              ),
                                      ),
                                    ),
                                  )
                                : FloatyButton(
                                    onPressed: _saveNewFlight,
                                    text: 'Save',
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
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

class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.grey.shade400
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke;

    const dashWidth = 5;
    const dashSpace = 5;
    const margin = 2.0; // Equal distance from outer border
    final path = Path();
    final rect = Rect.fromLTWH(
      margin,
      margin,
      size.width - 2 * margin,
      size.height - 2 * margin,
    );
    final radius = Radius.circular(4);

    path.addRRect(RRect.fromRectAndRadius(rect, radius));

    final pathMetrics = path.computeMetrics().first;
    final dashLength = dashWidth.toDouble();
    final spaceLength = dashSpace.toDouble();

    double distance = 0;
    while (distance < pathMetrics.length) {
      final start = pathMetrics.getTangentForOffset(distance);
      final end = pathMetrics.getTangentForOffset(distance + dashLength);
      if (start != null && end != null) {
        canvas.drawLine(start.position, end.position, paint);
      }
      distance += dashLength + spaceLength;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
