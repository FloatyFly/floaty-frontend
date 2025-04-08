import 'package:cookie_jar/cookie_jar.dart';
import 'package:floaty/flight_service.dart';
import 'package:floaty/ui_components.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'CookieAuth.dart';
import 'model.dart';

class EditFlightPage extends StatefulWidget {
  final Flight flight;

  const EditFlightPage({Key? key, required this.flight}) : super(key: key);

  @override
  _EditFlightPageState createState() => _EditFlightPageState();
}

class _EditFlightPageState extends State<EditFlightPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _dateController;
  late TextEditingController _takeoffController;
  late TextEditingController _descriptionController;
  final _focusDate = FocusNode();
  final _focusTakeoff = FocusNode();
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

    // Initialize controllers with existing flight data
    final date = DateTime.parse(widget.flight.dateTime);
    _dateController = TextEditingController(
      text: DateFormat("dd.MM.yyyy").format(date),
    );
    _takeoffController = TextEditingController(text: widget.flight.takeOff);
    _descriptionController = TextEditingController(
      text: widget.flight.description,
    );

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
  }

  @override
  void dispose() {
    _dateController.dispose();
    _takeoffController.dispose();
    _descriptionController.dispose();
    _focusDate.dispose();
    _focusTakeoff.dispose();
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

      Flight updatedFlight = Flight(
        flightId: widget.flight.flightId,
        dateTime: formattedDate,
        takeOff: _takeoffController.text,
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
        isProcessing = false;
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
        isProcessing = true;
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
          isProcessing = false;
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
    return Scaffold(
      body: Stack(
        children: [
          const FloatyBackgroundWidget(),
          Header(),
          AuthContainer(
            headerText: "Edit Flight",
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
                            ).requestFocus(_focusTakeoff),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14.0),

                  // Takeoff Location Field
                  TextFormField(
                    controller: _takeoffController,
                    focusNode: _focusTakeoff,
                    decoration: InputDecoration(
                      hintText: "Takeoff Location",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(3.0),
                      ),
                    ),
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? "Enter a takeoff location."
                                : null,
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

                  // Buttons (Save, Delete, and Cancel)
                  isProcessing
                      ? const CircularProgressIndicator()
                      : SizedBox(
                        width: double.infinity,
                        child: Row(
                          children: [
                            // Save Button
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    FocusScope.of(context).unfocus();
                                    _updateFlight();
                                  }
                                },
                                child: const Text(
                                  'Save',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),

                            // Delete Button
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _deleteFlight,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),

                            const SizedBox(width: 8),

                            // Cancel Button
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                ),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.white),
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
          Positioned(left: 0, right: 0, bottom: 0, child: Footer()),
        ],
      ),
    );
  }
}
