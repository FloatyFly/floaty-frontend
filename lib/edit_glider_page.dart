import 'package:flutter/material.dart';
import 'package:floaty_client/api.dart' as api;
import 'package:floaty/constants.dart';
import 'package:floaty/add_glider_page.dart';
import 'package:floaty/ui_components.dart';
import 'package:provider/provider.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'CookieAuth.dart';

class EditGliderPage extends AddGliderPage {
  final api.Glider glider;

  EditGliderPage({required this.glider});

  @override
  EditGliderPageState createState() => EditGliderPageState();
}

class EditGliderPageState extends AddGliderPageState {
  final _formKey = GlobalKey<FormState>();
  final _manufacturerController = TextEditingController();
  final _modelController = TextEditingController();
  bool _isLoading = false;
  late api.Glider glider;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    glider = (widget as EditGliderPage).glider;
    _manufacturerController.text = glider.manufacturer;
    _modelController.text = glider.model;
  }

  @override
  void dispose() {
    _manufacturerController.dispose();
    _modelController.dispose();
    super.dispose();
  }

  CookieAuth _getCookieAuth() {
    CookieJar cookieJar = Provider.of<CookieJar>(context, listen: false);
    return CookieAuth(cookieJar);
  }

  Future<void> _deleteGlider() async {
    setState(() {
      _isDeleting = true;
    });

    try {
      final apiClient = api.ApiClient(
        basePath: backendUrl,
        authentication: _getCookieAuth(),
      );
      final glidersApi = api.GlidersApi(apiClient);
      await glidersApi.deleteGliderById(glider.id);

      if (mounted) {
        Navigator.pop(context, true); // Return true to indicate success
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error deleting glider: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDeleting = false;
        });
      }
    }
  }

  @override
  Future<void> _submitForm() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final gliderUpdate = api.GliderUpdate(
          manufacturer: _manufacturerController.text,
          model: _modelController.text,
        );

        final apiClient = api.ApiClient(
          basePath: backendUrl,
          authentication: _getCookieAuth(),
        );
        apiClient.addDefaultHeader('Accept', 'application/json');
        final glidersApi = api.GlidersApi(apiClient);
        await glidersApi.updateGliderById(glider.id, gliderUpdate);

        if (mounted) {
          Navigator.pop(context, true); // Return true to indicate success
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error updating glider: $e')));
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
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Edit Glider',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _manufacturerController,
                          decoration: InputDecoration(
                            labelText: 'Manufacturer',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a manufacturer';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _modelController,
                          decoration: InputDecoration(
                            labelText: 'Model',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a model';
                            }
                            return null;
                          },
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
                            TextButton(
                              onPressed: _isLoading ? null : _deleteGlider,
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                              child: Text('Delete'),
                            ),
                            SizedBox(width: 16),
                            ElevatedButton(
                              onPressed: _isLoading ? null : _submitForm,
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
