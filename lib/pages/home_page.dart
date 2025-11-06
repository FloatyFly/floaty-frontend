import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:floaty/main.dart';
import 'package:floaty/widgets/ui_components.dart';
import 'package:floaty/pages/login_page.dart';
import 'package:floaty/config/constants.dart';
import 'package:floaty/models/model.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../config/theme.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void>? _imageLoadingFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Precache images to avoid layout shift
    if (_imageLoadingFuture == null) {
      _imageLoadingFuture = Future.wait([
        precacheImage(AssetImage('assets/images/floaty_laptop_phone.png'), context),
        precacheImage(AssetImage('assets/images/floaty_statistics.png'), context),
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final shadColors = getShadThemeData().colorScheme;

    return Consumer<AppState>(
      builder: (context, appState, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: FutureBuilder<void>(
            future: _imageLoadingFuture,
            builder: (context, snapshot) {
              // Show loading indicator while images are loading
              if (snapshot.connectionState != ConnectionState.done) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFC0FF58),
                  ),
                );
              }

              // Once images are loaded, show the content
              return SingleChildScrollView(
                child: Stack(
              children: [
                // Background gradient that scrolls with content
                Positioned(
                  top: 100,
                  left: MediaQuery.of(context).size.width * 0.5 - 400,
                  child: Container(
                    width: 800,
                    height: 800,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Color(0xFFC0FF58).withOpacity(0.6), // Stronger lime green center
                          Color(0xFFC0FF58).withOpacity(0.3),
                          Color(0xFFC0FF58).withOpacity(0.0), // Fade to transparent
                        ],
                        stops: [0.0, 0.4, 1.0],
                      ),
                    ),
                  ),
                ),
                // Content
                Column(
                  children: [
                    // Show header only for logged in users
                    if (appState.isLoggedIn)
                      Header(),

                    // Show hero section for both logged in and logged out users
                    Container(
                      height: 500,
                      width: double.infinity,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Large heading with "simple" in blue
                            Container(
                              constraints: BoxConstraints(maxWidth: 900),
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 64,
                                    fontWeight: FontWeight.w600,
                                    color: shadColors.foreground,
                                    height: 1.1,
                                  ),
                                  children: [
                                    TextSpan(text: 'The '),
                                    TextSpan(
                                      text: 'simple',
                                      style: TextStyle(
                                        color: Color(0xFF2B7DE9), // Bright blue
                                      ),
                                    ),
                                    TextSpan(text: ' paragliding flight log'),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 24),
                            // Description text
                            Container(
                              constraints: BoxConstraints(maxWidth: 700),
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                'Track your flights, analyze your progress, and improve your flying with detailed statistics.',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: shadColors.foreground,
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 40),
                            // Buttons - Login and Register for non-logged in, View Flights for logged in
                            if (!appState.isLoggedIn)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  FloatyButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, LOGIN_ROUTE);
                                    },
                                    text: 'Login',
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 32,
                                      vertical: 16,
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  FloatyButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, REGISTER_ROUTE);
                                    },
                                    text: 'Register',
                                    backgroundColor: Colors.grey.shade100,
                                    foregroundColor: Colors.black,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 32,
                                      vertical: 16,
                                    ),
                                  ),
                                ],
                              )
                            else
                              FloatyButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, FLIGHTS_ROUTE);
                                },
                                text: 'View Flights',
                                icon: Icon(Icons.arrow_forward, size: 20),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 16,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                    // App Screenshots Section - transparent to show background gradient
                    Container(
                      width: double.infinity,
                      color: Colors.transparent, // Transparent to let gradient show through
                      padding: EdgeInsets.symmetric(
                        vertical: 60,
                        horizontal: 20,
                      ),
                      child: Column(
                        children: [
                          // First screenshot
                          Container(
                            constraints: BoxConstraints(maxWidth: 1200),
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
                                color: shadColors.border,
                                thickness: 1,
                              ),
                            ),
                            SizedBox(height: 40),
                            // Text section
                            Container(
                              constraints: BoxConstraints(maxWidth: 800),
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: [
                                  Text(
                                    'Track your progress with meaningful insights',
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w600,
                                      color: shadColors.foreground,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    'Get detailed statistics about your flights and airtime. Monthly and yearly summaries help you understand your flying patterns. Make informed decisions about your training based on actual flight data.',
                                    style: TextStyle(
                                      fontSize: 20,
                                      height: 1.5,
                                      color: shadColors.foreground,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 40),
                            // Statistics screenshot
                            LayoutBuilder(
                              builder: (context, constraints) {
                                final isMobile = constraints.maxWidth < 700;
                                return Container(
                                  constraints: BoxConstraints(
                                    maxWidth: isMobile ? double.infinity : 650,
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
                                color: shadColors.border,
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Buy me a coffee Section
                    Container(
                      width: double.infinity,
                      color: Colors.transparent, // Transparent to let gradient show through
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
                                      color: shadColors.foreground,
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

                                final buttonWidget = Container(
                                  width: 200,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Add your buy me a coffee link here
                                      // Launch URL for buy me a coffee
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF2B7DE9),
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.all(12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      elevation: 0,
                                    ).copyWith(
                                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                                      shadowColor: WidgetStateProperty.all(Colors.transparent),
                                    ),
                                    child: Image.asset(
                                      'assets/images/coffee-cup.png',
                                      height: 35,
                                      fit: BoxFit.contain,
                                    ),
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
                      color: Colors.white, // White background instead of muted
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
                              color: shadColors.foreground, // Use foreground color
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            constraints: BoxConstraints(maxWidth: 600),
                            child: Text(
                              'If you have any feedback, suggestions for improvement or simply want to get to know us, do not hesitate to contact us!',
                              style: TextStyle(
                                fontSize: 18,
                                color: shadColors.foreground.withOpacity(0.8),
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.email, color: Color(0xFF2B7DE9)), // Blue email icon
                              SizedBox(width: 10),
                              Text(
                                'info@floatyfly.com',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xFF2B7DE9), // Blue email text
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
              ],
            ),
              );
            },
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
