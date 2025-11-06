import 'package:flutter/material.dart';
import 'package:floaty_client/api.dart' as api;
import 'package:floaty/config/constants.dart';
import 'package:floaty/pages/add_glider_page.dart';
import 'package:floaty/widgets/ui_components.dart';
import 'package:provider/provider.dart';
import '../config/CookieAuth.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../config/theme.dart';

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
    return CookieAuth();
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
                  borderRadius:
                      isMobile
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
                          'Edit Glider',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: shadColors.foreground,
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
                            FloatyButton(
                              onPressed: () => Navigator.pop(context),
                              text: 'Cancel',
                              backgroundColor: Colors.grey.shade100,
                              foregroundColor: Colors.black,
                              enabled: !_isLoading,
                            ),
                            SizedBox(width: 16),
                            FloatyButton(
                              onPressed: _deleteGlider,
                              text: 'Delete',
                              backgroundColor: Colors.red,
                              enabled: !_isLoading,
                            ),
                            SizedBox(width: 16),
                            _isLoading
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor:
                                          AlwaysStoppedAnimation<Color>(
                                            Color(0xFF2B7DE9),
                                          ),
                                    ),
                                  )
                                : FloatyButton(
                                    onPressed: _submitForm,
                                    text: 'Save',
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
