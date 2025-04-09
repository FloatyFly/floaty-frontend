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

class HomePage extends StatelessWidget {
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
                      Container(
                        height: 500,
                        width: double.infinity,
                        child: Center(child: SizedBox.shrink()),
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
                          // Screenshots
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildScreenshotCard(
                                  'assets/images/flight_list.png',
                                  'Flight List',
                                  'View all your flights in a clean, organized list',
                                ),
                                SizedBox(width: 20),
                                _buildScreenshotCard(
                                  'assets/images/flight_stats.png',
                                  'Flight Statistics',
                                  'Analyze your flying patterns with detailed statistics',
                                ),
                                SizedBox(width: 20),
                                _buildScreenshotCard(
                                  'assets/images/mobile.png',
                                  'Mobile First',
                                  'Access your flight data anywhere, anytime',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // About Section
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
                            'About Floaty',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade900,
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            constraints: BoxConstraints(maxWidth: 800),
                            child: Text(
                              'Floaty is a flight tracking application designed for pilots and aviation enthusiasts. '
                              'Our mission is to provide a simple, intuitive platform for recording and analyzing flight data. '
                              'Whether you\'re a student pilot or an experienced aviator, Floaty helps you keep track of your flying journey.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
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
