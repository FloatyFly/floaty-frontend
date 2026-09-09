import 'package:flutter/material.dart';
import 'package:floaty/widgets/ui_components.dart';
import 'package:floaty/config/constants.dart';
import 'package:floaty_client/api.dart' as api;
import 'package:provider/provider.dart';
import '../config/CookieAuth.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../config/theme.dart';
import '../widgets/certification_selector.dart';
import '../widgets/glider_format.dart';

class AddGliderPage extends StatefulWidget {
  @override
  AddGliderPageState createState() => AddGliderPageState();
}

class AddGliderPageState extends State<AddGliderPage> {
  final _formKey = GlobalKey<FormState>();
  final _manufacturerController = TextEditingController();
  final _modelController = TextEditingController();
  final _sizeController = TextEditingController();
  api.GliderCertificationClassEnum? _certificationClass;
  api.GliderGradationEnum? _gradation;
  bool _isLoading = false;

  @protected
  GlobalKey<FormState> get formKey => _formKey;

  @protected
  TextEditingController get manufacturerController => _manufacturerController;

  @protected
  TextEditingController get modelController => _modelController;

  @protected
  TextEditingController get sizeController => _sizeController;

  @protected
  api.GliderCertificationClassEnum? get certificationClass => _certificationClass;

  @protected
  set certificationClass(api.GliderCertificationClassEnum? value) =>
      _certificationClass = value;

  @protected
  api.GliderGradationEnum? get gradation => _gradation;

  @protected
  set gradation(api.GliderGradationEnum? value) => _gradation = value;

  @protected
  bool get isLoading => _isLoading;

  @protected
  set isLoading(bool value) => _isLoading = value;

  @protected
  CookieAuth _getCookieAuth() {
    return CookieAuth();
  }

  /// The size / certification fields, shared with the edit page so both forms stay identical.
  ///
  /// Gradation is disabled until a certification class is picked: the backend rejects a
  /// gradation with no class, since "High" on its own means nothing.
  @protected
  List<Widget> buildCertificationFields(VoidCallback onChanged) {
    final classSelected = _certificationClass != null;
    return [
      TextFormField(
        controller: _sizeController,
        decoration: InputDecoration(
          labelText: 'Size (optional)',
          hintText: 'e.g. 95 or 24',
          helperText: 'As printed by the manufacturer.',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
      SizedBox(height: 20),
      SegmentedOptionSelector<api.GliderCertificationClassEnum>(
        label: 'Certification (optional)',
        options: const [
          api.GliderCertificationClassEnum.A,
          api.GliderCertificationClassEnum.B,
          api.GliderCertificationClassEnum.C,
          api.GliderCertificationClassEnum.D,
          api.GliderCertificationClassEnum.NONE,
          api.GliderCertificationClassEnum.CCC,
        ],
        labelBuilder: (option) => switch (option.value) {
          'NONE' => 'None',
          'CCC' => 'None (CCC)',
          final value => value,
        },
        selected: _certificationClass,
        helperText: 'Tap again to clear. None means uncertified; CCC is the competition class.',
        onChanged: (value) {
          setState(() {
            _certificationClass = value;
            // A gradation with no class is rejected by the API, so drop it.
            if (value == null) {
              _gradation = null;
            }
          });
          onChanged();
        },
      ),
      SizedBox(height: 20),
      SegmentedOptionSelector<api.GliderGradationEnum>(
        label: 'Gradation (optional)',
        options: const [
          api.GliderGradationEnum.LOW,
          api.GliderGradationEnum.MID,
          api.GliderGradationEnum.HIGH,
        ],
        labelBuilder: (option) => switch (option.value) {
          'LOW' => 'Low',
          'MID' => 'Mid',
          'HIGH' => 'High',
          final value => value,
        },
        selected: _gradation,
        enabled: classSelected,
        helperText: classSelected
            ? 'Informal refinement, e.g. Low B.'
            : 'Pick a certification class first.',
        onChanged: (value) {
          setState(() => _gradation = value);
          onChanged();
        },
      ),
    ];
  }

  @override
  void dispose() {
    _sizeController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final size = _sizeController.text.trim();
        final gliderCreate = api.GliderCreate(
          manufacturer: _manufacturerController.text,
          model: _modelController.text,
          size: size.isEmpty ? null : size,
          certificationClass: toCreateCertificationClass(_certificationClass),
          gradation: toCreateGradation(_gradation),
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
          ),
        ],
      ),
    );
  }
}
