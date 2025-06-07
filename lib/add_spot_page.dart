import 'package:flutter/material.dart';
import 'package:floaty_client/api.dart' as api;
import 'package:floaty/ui_components.dart';
import 'package:floaty/model.dart';
import 'package:floaty/spots_service.dart';
import 'package:floaty/constants.dart';
import 'package:provider/provider.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'CookieAuth.dart';

class AddSpotPage extends StatefulWidget {
  final FloatyUser? user;

  const AddSpotPage({Key? key, this.user}) : super(key: key);

  @override
  _AddSpotPageState createState() => _AddSpotPageState();
}

class _AddSpotPageState extends State<AddSpotPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  final _altitudeController = TextEditingController();
  final _descriptionController = TextEditingController();
  api.SpotCreateTypeEnum _selectedType = api.SpotCreateTypeEnum.LAUNCH_SITE;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _altitudeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  CookieAuth _getCookieAuth() {
    CookieJar cookieJar = Provider.of<CookieJar>(context, listen: false);
    return CookieAuth(cookieJar);
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final spotCreate = api.SpotCreate(
          name: _nameController.text,
          type: _selectedType,
          latitude: double.parse(_latitudeController.text),
          longitude: double.parse(_longitudeController.text),
          altitude: int.parse(_altitudeController.text),
          description:
              _descriptionController.text.isEmpty
                  ? null
                  : _descriptionController.text,
        );

        final apiClient = api.ApiClient(
          basePath: backendUrl,
          authentication: _getCookieAuth(),
        );
        apiClient.addDefaultHeader('Accept', 'application/json');
        final spotsApi = api.SpotsApi(apiClient);
        await spotsApi.createSpot(spotCreate);

        if (mounted) {
          Navigator.pop(context, true); // Return true to indicate success
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error creating spot: $e')));
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
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
              Expanded(
                child: Center(
                  child: Container(
                    width: containerWidth,
                    padding: EdgeInsets.all(isMobile ? 8 : 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          isMobile
                              ? BorderRadius.zero
                              : BorderRadius.vertical(top: Radius.circular(6)),
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
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Add New Spot',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: 'Name',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a name';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16),
                            DropdownButtonFormField<api.SpotCreateTypeEnum>(
                              value: _selectedType,
                              decoration: InputDecoration(
                                labelText: 'Type',
                                border: OutlineInputBorder(),
                              ),
                              items:
                                  api.SpotCreateTypeEnum.values.map((type) {
                                    return DropdownMenuItem(
                                      value: type,
                                      child: Text(
                                        type.toString().split('.').last,
                                      ),
                                    );
                                  }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    _selectedType = value;
                                  });
                                }
                              },
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              controller: _latitudeController,
                              decoration: InputDecoration(
                                labelText: 'Latitude',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter latitude';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Please enter a valid number';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              controller: _longitudeController,
                              decoration: InputDecoration(
                                labelText: 'Longitude',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter longitude';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Please enter a valid number';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              controller: _altitudeController,
                              decoration: InputDecoration(
                                labelText: 'Altitude (meters)',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter altitude';
                                }
                                if (int.tryParse(value) == null) {
                                  return 'Please enter a valid number';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              controller: _descriptionController,
                              decoration: InputDecoration(
                                labelText: 'Description (optional)',
                                border: OutlineInputBorder(),
                              ),
                              maxLines: 3,
                            ),
                            SizedBox(height: 24),
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
                                  onPressed: _isLoading ? null : _submitForm,
                                  child:
                                      _isLoading
                                          ? SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          )
                                          : Text('Create Spot'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF0078D7),
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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
