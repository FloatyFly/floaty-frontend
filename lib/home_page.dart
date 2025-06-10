import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:floaty/main.dart';
import 'package:floaty/ui_components.dart';
import 'package:floaty/flights_page.dart';
import 'package:floaty/login_page.dart';
import 'package:floaty/register_page.dart';
import 'package:floaty/constants.dart';
import 'package:floaty/model.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:floaty/CookieAuth.dart';
import 'package:visibility_detector/visibility_detector.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _imageKey = GlobalKey();
  final GlobalKey _statsImageKey = GlobalKey();
  final GlobalKey _textKey = GlobalKey();
  double _imageSlidePosition = 1.0;
  double _statsSlidePosition = 1.0;
  double _textOpacity = 0.0;
  bool _imageAnimationCompleted = false;
  bool _statsAnimationCompleted = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    _updateImagePosition(_imageKey, true, (progress) {
      _imageSlidePosition = progress;
    });
    _updateImagePosition(_statsImageKey, false, (progress) {
      _statsSlidePosition = progress;
    });
    _updateTextOpacity();
  }

  void _updateImagePosition(
    GlobalKey key,
    bool fromRight,
    Function(double) updatePosition,
  ) {
    final RenderBox? imageBox =
        key.currentContext?.findRenderObject() as RenderBox?;
    if (imageBox == null) return;

    // Check if this is for the first or second image
    bool isFirstImage = key == _imageKey;
    if ((isFirstImage && _imageAnimationCompleted) ||
        (!isFirstImage && _statsAnimationCompleted)) {
      updatePosition(0.0); // Keep the image in its final position
      return;
    }

    final imagePosition = imageBox.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;

    final startPosition = screenHeight + imageBox.size.height;
    final endPosition = screenHeight - imageBox.size.height;

    double progress = ((imagePosition.dy - endPosition) /
            (startPosition - endPosition))
        .clamp(0.0, 1.0);

    if (mounted) {
      setState(() {
        updatePosition(progress);
        // If the animation has completed (progress is 0), mark it as done
        if (progress == 0.0) {
          if (isFirstImage) {
            _imageAnimationCompleted = true;
          } else {
            _statsAnimationCompleted = true;
          }
        }
      });
    }
  }

  void _updateTextOpacity() {
    final RenderBox? textBox =
        _textKey.currentContext?.findRenderObject() as RenderBox?;
    if (textBox == null) return;

    final textPosition = textBox.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;

    // Start fading in as soon as text enters view
    final startPosition = screenHeight + textBox.size.height;
    final endPosition = screenHeight - textBox.size.height;

    // Calculate opacity (0 = invisible, 1 = fully visible)
    double opacity =
        1.0 -
        ((textPosition.dy - endPosition) / (startPosition - endPosition)).clamp(
          0.0,
          1.0,
        );

    if (mounted) {
      setState(() {
        _textOpacity = opacity;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return Scaffold(
          body: Stack(
            children: [
              const FloatyBackgroundWidget(),
              // Content
              SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    // Custom header with Register button for non-logged in users
                    if (!appState.isLoggedIn)
                      Container(
                        height: 75.0,
                        color: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Logo
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, HOME_ROUTE);
                              },
                              child: Image.asset(
                                "assets/logo.png",
                                height: 55.0,
                                fit: BoxFit.contain,
                              ),
                            ),
                            // Register button
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, REGISTER_ROUTE);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade900,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                textStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Text('Register'),
                            ),
                          ],
                        ),
                      )
                    else
                      Header(),

                    // Show login form in the background section when not logged in
                    if (!appState.isLoggedIn)
                      Container(
                        height: 500,
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: AuthContainer(
                            headerText: "Login",
                            child: LoginForm(
                              onSubmit: (username, password) async {
                                final cookieJar = Provider.of<CookieJar>(
                                  context,
                                  listen: false,
                                );
                                try {
                                  final user =
                                      await loginAndExtractSessionCookie(
                                        username,
                                        password,
                                        cookieJar,
                                      );

                                  if (user != null) {
                                    var floatyUser = FloatyUser.fromUserDto(
                                      user,
                                    );
                                    Provider.of<AppState>(
                                      context,
                                      listen: false,
                                    ).login(floatyUser);
                                    Navigator.pushNamed(context, FLIGHTS_ROUTE);
                                  }
                                } on EmailNotVerifiedException {
                                  Navigator.pushNamed(
                                    context,
                                    EMAIL_VERIFICATION_ROUTE,
                                    arguments: username,
                                  );
                                } catch (e) {
                                  // Show error in a snackbar
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Login failed. Please try again.',
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      )
                    else
                      SizedBox(
                        height: 500,
                        width: double.infinity,
                        child: Center(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, FLIGHTS_ROUTE);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF0078D7),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              textStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 5,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.arrow_forward, size: 24),
                                SizedBox(width: 10),
                                Text('Go to Flights'),
                              ],
                            ),
                          ),
                        ),
                      ),

                    // App Screenshots Section
                    Container(
                      width: double.infinity,
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(
                        vertical: 60,
                        horizontal: 20,
                      ),
                      child: Column(
                        children: [
                          // Title
                          Text(
                            'Floaty - The simple paragliding flight log',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 40),
                          // Description
                          Container(
                            constraints: BoxConstraints(maxWidth: 800),
                            child: Text(
                              'Floaty is a simple and intuitive flight log that puts ease of use first. You can access your flights from any device and analyze your data with in-depth statistics. Your flying history stays private and secure.',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black87,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 60),
                          // First screenshot with scroll-based animation
                          Container(
                            key: _imageKey,
                            constraints: BoxConstraints(maxWidth: 1200),
                            transform: Matrix4.translationValues(
                              MediaQuery.of(context).size.width *
                                  _imageSlidePosition,
                              0,
                              0,
                            ),
                            child: Image.asset(
                              'assets/images/floaty_laptop_phone.png',
                              width: double.infinity,
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(height: 40),
                          // Divider between devices and analysis
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 40),
                            child: Divider(
                              color: Colors.grey.shade300,
                              thickness: 1,
                            ),
                          ),
                          SizedBox(height: 40),
                          // Animated text section
                          Container(
                            key: _textKey,
                            constraints: BoxConstraints(maxWidth: 800),
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Opacity(
                              opacity: _textOpacity,
                              child: Column(
                                children: [
                                  Text(
                                    'Track your progress with meaningful insights',
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    'Get detailed statistics about your flights and airtime. Monthly and yearly summaries help you understand your flying patterns. Make informed decisions about your training based on actual flight data.',
                                    style: TextStyle(
                                      fontSize: 20,
                                      height: 1.5,
                                      color: Colors.black87,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 40),
                          // Statistics screenshot with scroll-based animation
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final isMobile = constraints.maxWidth < 700;
                              return Container(
                                key: _statsImageKey,
                                constraints: BoxConstraints(
                                  maxWidth: isMobile ? double.infinity : 650,
                                ),
                                transform: Matrix4.translationValues(
                                  -MediaQuery.of(context).size.width *
                                      _statsSlidePosition,
                                  0,
                                  0,
                                ),
                                child: Image.asset(
                                  'assets/images/floaty_statistics.png',
                                  width: double.infinity,
                                  fit: BoxFit.contain,
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 40),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 40),
                            child: Divider(
                              color: Colors.grey.shade300,
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Buy me a coffee Section
                    Container(
                      width: double.infinity,
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 40),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final isMobile = constraints.maxWidth < 700;

                                final textWidget = RichText(
                                  textAlign:
                                      isMobile
                                          ? TextAlign.center
                                          : TextAlign.center,
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black87,
                                      height: 1.5,
                                    ),
                                    children: [
                                      TextSpan(
                                        text:
                                            'Do you enjoy using Floaty? It is entirely ',
                                      ),
                                      TextSpan(
                                        text: 'free',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(text: ' of use.\n'),
                                      TextSpan(text: 'Support me and...'),
                                    ],
                                  ),
                                );

                                final buttonWidget = ElevatedButton(
                                  onPressed: () {
                                    // Add your buy me a coffee link here
                                    // Launch URL for buy me a coffee
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    padding: EdgeInsets.all(12),
                                    minimumSize: Size(200, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: Image.asset(
                                    'assets/images/coffee-cup.png',
                                    height: 35,
                                    fit: BoxFit.contain,
                                  ),
                                );

                                if (isMobile) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        constraints: BoxConstraints(
                                          maxWidth: 500,
                                        ),
                                        child: textWidget,
                                      ),
                                      SizedBox(height: 20),
                                      buttonWidget,
                                    ],
                                  );
                                }

                                return Row(
                                  children: [
                                    SizedBox(
                                      width: constraints.maxWidth * 0.5,
                                      child: Center(
                                        child: Container(
                                          constraints: BoxConstraints(
                                            maxWidth: 500,
                                          ),
                                          child: textWidget,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: constraints.maxWidth * 0.5,
                                      child: Center(child: buttonWidget),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 40),
                        ],
                      ),
                    ),

                    // Contact Section
                    Container(
                      width: double.infinity,
                      color: Colors.grey.shade100,
                      padding: EdgeInsets.symmetric(
                        vertical: 60,
                        horizontal: 20,
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Contact',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade900,
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            constraints: BoxConstraints(maxWidth: 600),
                            child: Text(
                              'If you have any feedback, suggestions for improvement or simply want to get to know us, do not hesitate to contact us!',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black87,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.email, color: Colors.blue.shade900),
                              SizedBox(width: 10),
                              Text(
                                'info@floatyfly.com',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.blue.shade900,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Footer
                    Footer(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildScreenshotCard(
    String imagePath,
    String title,
    String description,
  ) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            child: Image.asset(
              imagePath,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 180,
                  color: Colors.grey.shade300,
                  child: Center(
                    child: Icon(
                      Icons.image_not_supported,
                      size: 50,
                      color: Colors.grey.shade600,
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
