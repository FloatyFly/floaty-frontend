import 'package:flutter/material.dart';
import 'package:floaty_client/api.dart' as api;
import 'package:floaty/config/constants.dart';
import 'package:floaty/pages/add_glider_page.dart';
import 'package:floaty/widgets/ui_components.dart';
import 'package:provider/provider.dart';
import '../config/CookieAuth.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../config/theme.dart';
import '../widgets/glider_format.dart';

class EditGliderPage extends AddGliderPage {
  final api.Glider glider;

  EditGliderPage({required this.glider});

  @override
  EditGliderPageState createState() => EditGliderPageState();
}

class EditGliderPageState extends AddGliderPageState {
  late api.Glider glider;
  bool _isDeleting = false;

  // Deliberately no local formKey / controllers here: shadowing the parent's meant the Form
  // widget and the validate() call used different keys, so validators never fired on save.

  @override
  void initState() {
    super.initState();
    glider = (widget as EditGliderPage).glider;
    manufacturerController.text = glider.manufacturer;
    modelController.text = glider.model;
    sizeController.text = glider.size ?? '';
    certificationClass = glider.certificationClass;
    gradation = glider.gradation;
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

  // Not an override: _submitForm is private to the parent's library, so this is a separate
  // method that the edit page's own Save button calls.
  Future<void> _submitForm() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        // PUT replaces the glider server-side, and the generated toJson() always writes every
        // key, nulls included. Any field omitted here is therefore actively cleared, so all of
        // them must be sent.
        final size = sizeController.text.trim();
        final gliderUpdate = api.GliderUpdate(
          manufacturer: manufacturerController.text,
          model: modelController.text,
          size: size.isEmpty ? null : size,
          certificationClass: toUpdateCertificationClass(certificationClass),
          gradation: toUpdateGradation(gradation),
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
            isLoading = false;
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
          // Scrollable: the form is now tall enough to overflow shorter viewports.
          SingleChildScrollView(
            child: Column(
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
                  key: formKey,
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
                          controller: manufacturerController,
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
                          controller: modelController,
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
                        SizedBox(height: 20),
                        ...buildCertificationFields(() {}),
                        SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FloatyButton(
                              onPressed: () => Navigator.pop(context),
                              text: 'Cancel',
                              backgroundColor: Colors.grey.shade100,
                              foregroundColor: Colors.black,
                              enabled: !isLoading,
                            ),
                            SizedBox(width: 16),
                            FloatyButton(
                              onPressed: _deleteGlider,
                              text: 'Delete',
                              backgroundColor: Colors.red,
                              enabled: !isLoading,
                            ),
                            SizedBox(width: 16),
                            isLoading
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
          ),
        ],
      ),
    );
  }
}
