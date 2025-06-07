import 'package:flutter/material.dart';
import 'package:floaty_client/api.dart' as api;
import 'package:floaty/ui_components.dart';
import 'package:floaty/model.dart';
import 'package:floaty/constants.dart';
import 'package:provider/provider.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'CookieAuth.dart';

class AddGliderPage extends StatefulWidget {
  final FloatyUser? user;

  const AddGliderPage({Key? key, this.user}) : super(key: key);

  @override
  _AddGliderPageState createState() => _AddGliderPageState();
}

class _AddGliderPageState extends State<AddGliderPage> {
  final _formKey = GlobalKey<FormState>();
  final _manufacturerController = TextEditingController();
  final _modelController = TextEditingController();
  bool _isLoading = false;

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

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final gliderCreate = api.GliderCreate(
          manufacturer: _manufacturerController.text,
          model: _modelController.text,
        );

        final apiClient = api.ApiClient(
          basePath: backendUrl,
          authentication: _getCookieAuth(),
        );
        apiClient.addDefaultHeader('Accept', 'application/json');
        final glidersApi = api.GlidersApi(apiClient);
        await glidersApi.createGlider(gliderCreate);

        if (mounted) {
          Navigator.pop(context, true); // Return true to indicate success
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error creating glider: $e')));
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
                              'Add New Glider',
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
                                          : Text('Create Glider'),
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
