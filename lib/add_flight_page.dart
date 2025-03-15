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
  final _takeoffController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _focusDate = FocusNode();
  final _focusTakeoff = FocusNode();
  final _focusDescription = FocusNode();

  bool isProcessing = false;
  String? errorMessage;
  String? flightTimeErrorMessage; // Error message for flight time

  // Duration selection variables
  int? selectedHours;
  int? selectedMinutes;

  final DateFormat formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss");

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat("dd.MM.yyyy").format(DateTime.now());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusTakeoff); // Focus on the Takeoff Location field
    });
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
      flightTimeErrorMessage = null; // Clear any previous flight time error
    });

    try {
      DateFormat dateFormat = DateFormat('dd.MM.yyyy');
      final formattedDate = formatter.format(dateFormat.parseStrict(_dateController.text));

      // Calculate total duration in minutes
      final duration = (selectedHours ?? 0) * 60 + (selectedMinutes ?? 0);

      Flight flight = Flight(
        flightId: "",
        dateTime: formattedDate,
        takeOff: _takeoffController.text,
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
        _dateController.text = DateFormat("dd.MM.yyy").format(picked);
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
                            icon: Icon(Icons.calendar_today, color: Colors.orange),
                            onPressed: () => _selectDate(context),
                            padding: EdgeInsets.only(left: 7), // Set padding of the icon to zero
                          ),
                          prefixIconConstraints: BoxConstraints(
                            maxWidth: 32, // Icon size width
                          ),
                          contentPadding: EdgeInsets.only(left: 60), // Add padding to the left side of the text (after the icon)
                          isDense: false, // Tighter vertical spacing
                          border: OutlineInputBorder(), // Optional: To make it look more consistent
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter a valid date.";
                          }

                          try {
                            // Try to parse the date using the custom format
                            DateFormat dateFormat = DateFormat('dd.MM.yyyy');
                            dateFormat.parseStrict(value); // This will throw if the date is invalid
                            return null; // Date is valid
                          } catch (e) {
                            // If parsing fails, return an error message
                            return "Enter a valid date.";
                          }
                        },
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_focusTakeoff),
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
                        borderRadius: BorderRadius.circular(3.0), // Rounded corners
                      ),
                    ),
                    validator: (value) => value == null || value.isEmpty ? "Enter a takeoff location." : null,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_focusDescription),
                  ),
                  const SizedBox(height: 14.0),

                  // Duration (Hours and Minutes) - Initial Text
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
                          items: List.generate(12, (index) {
                            return DropdownMenuItem<int>(
                              value: index + 1,
                              child: Text("${index + 1} Hours"),
                            );
                          }).toList(),
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
                          items: List.generate(12, (index) {
                            return DropdownMenuItem<int>(
                              value: (index + 1) * 5,
                              child: Text("${(index + 1) * 5} Minutes"),
                            );
                          }).toList(),
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
                    maxLines: null, // Allow unlimited lines
                    minLines: 3, // Initial size
                    decoration: InputDecoration(
                      hintText: "Description",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
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
                      : SizedBox(
                    width: double.infinity,
                    child: Row(
                      children: [
                        // Save Button (Black)
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
                        const SizedBox(width: 16), // Add some space between buttons
                        // Cancel Button (Grey)
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context); // Navigate back to the Flights Page
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey, // Set background color to grey
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
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Footer(),
          ),
        ],
      ),
    );
  }
}
