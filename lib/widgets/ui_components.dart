import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/constants.dart';
import '../main.dart';

class FloatyBackgroundWidget extends StatelessWidget {
  const FloatyBackgroundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Image
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/background.jpg"),
              fit: BoxFit.cover,
              alignment: Alignment(0, 0.2), // Shift the image down slightly
            ),
          ),
        ),
        // Semi-transparent overlay - darker to match other pages
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black.withOpacity(0.3),
        ),
        // Dot Grid Overlay
        Positioned.fill(child: CustomPaint(painter: DotGridPainter())),
      ],
    );
  }
}

class DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double dotSpacing = 20.0; // Adjust for desired spacing between dots
    final dotPaint =
        Paint()
          ..color = Colors.white.withOpacity(0.4) // Semi-transparent white dots
          ..strokeWidth = 2.0
          ..style = PaintingStyle.fill;

    for (var i = 1.0; i < size.width; i += dotSpacing) {
      for (var j = 0.0; j < size.height; j += dotSpacing) {
        canvas.drawCircle(
          Offset(i, j),
          1.1,
          dotPaint,
        ); // Adjust radius for dot size
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// A reusable container for authentication pages (e.g., Login, Register)
class AuthContainer extends StatelessWidget {
  final String headerText;
  final Widget child;
  final bool isFlightPage; // New parameter to identify flight pages

  const AuthContainer({
    super.key,
    required this.headerText,
    required this.child,
    this.isFlightPage = false, // Default to false for backward compatibility
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth =
        screenWidth > 400.0
            ? 400.0
            : screenWidth - 32.0; // 16px margin on each side
    const containerHeight = 550.0;

    return Center(
      child: Container(
        width: containerWidth,
        height: containerHeight,
        margin: EdgeInsets.only(
          top: isFlightPage ? 100.0 : 24.0, // More top margin for flight pages
          bottom: 24.0,
          left: 16.0,
          right: 16.0,
        ),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Column(
          children: [
            // Header Box
            Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12.0),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                headerText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Child widget (e.g., LoginForm)
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32.0,
                    vertical: 16.0,
                  ),
                  child: child,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isLargeScreen = MediaQuery.of(context).size.width >= 600;

    return Container(
      height: 75.0,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Replace text with image logo
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

          // Show navigation links or menu for all users
          if (isLargeScreen)
            Row(
              children: [
                _buildNavButton(context, "Home", 0, appState.selectedIndex),
                const SizedBox(width: 16.0),
                if (appState.isLoggedIn) ...[
                  _buildNavButton(
                    context,
                    "Flights",
                    1,
                    appState.selectedIndex,
                  ),
                  const SizedBox(width: 16.0),
                  _buildNavButton(context, "Spots", 2, appState.selectedIndex),
                  const SizedBox(width: 16.0),
                  _buildNavButton(
                    context,
                    "Gliders",
                    3,
                    appState.selectedIndex,
                  ),
                  const SizedBox(width: 16.0),
                  _buildNavButton(
                    context,
                    "Statistics",
                    4,
                    appState.selectedIndex,
                  ),
                  const SizedBox(width: 16.0),
                  _buildNavButton(
                    context,
                    "Profile",
                    5,
                    appState.selectedIndex,
                  ),
                ] else ...[
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, LOGIN_ROUTE);
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.black, fontSize: 18.0),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, REGISTER_ROUTE);
                    },
                    child: Text(
                      "Register",
                      style: TextStyle(color: Colors.black, fontSize: 18.0),
                    ),
                  ),
                ],
              ],
            )
          else
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                _showMenuDialog(context, appState);
              },
            ),
        ],
      ),
    );
  }

  // Helper function to build navigation buttons
  Widget _buildNavButton(
    BuildContext context,
    String label,
    int index,
    int selectedIndex,
  ) {
    final isSelected = index == selectedIndex;
    return TextButton(
      onPressed: () {
        // Update the selected index in AppState
        Provider.of<AppState>(context, listen: false).setSelectedIndex(index);
        // Navigate to the corresponding page
        if (index == 0) {
          Navigator.pushNamed(context, HOME_ROUTE);
        } else if (index == 1) {
          Navigator.pushNamed(context, FLIGHTS_ROUTE);
        } else if (index == 2) {
          Navigator.pushNamed(context, SPOTS_ROUTE);
        } else if (index == 3) {
          Navigator.pushNamed(context, GLIDERS_ROUTE);
        } else if (index == 4) {
          Navigator.pushNamed(context, STATS_ROUTE);
        } else if (index == 5) {
          Navigator.pushNamed(context, PROFILE_ROUTE);
        }
      },
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.blue : Colors.black,
          // Blue color for selected item
          fontSize: 18.0,
          fontWeight:
              isSelected
                  ? FontWeight.bold
                  : FontWeight.normal, // Bold for selected item
        ),
      ),
    );
  }

  void _showMenuDialog(BuildContext context, AppState appState) {
    final screenWidth = MediaQuery.of(context).size.width;
    final menuWidth = screenWidth * 0.6; // 3/5 of screen width

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: ModalRoute.of(context)!.animation!,
              curve: Curves.easeOut,
            ),
          ),
          child: Align(
            alignment: Alignment.topRight,
            child: Material(
              child: Container(
                width: menuWidth,
                height: MediaQuery.of(context).size.height, // Full height
                color: Colors.white,
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          children: [
                            ListTile(
                              leading: Icon(
                                Icons.home,
                                color: Color(0xFF0078D7),
                              ),
                              title: Text(
                                "Home",
                                style: TextStyle(fontSize: 16.0),
                              ),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(context, HOME_ROUTE);
                              },
                            ),
                            if (appState.isLoggedIn) ...[
                              ListTile(
                                leading: Icon(
                                  Icons.paragliding,
                                  color: Color(0xFF0078D7),
                                ),
                                title: Text(
                                  "Flights",
                                  style: TextStyle(fontSize: 16.0),
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(context, FLIGHTS_ROUTE);
                                },
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.location_on,
                                  color: Color(0xFF0078D7),
                                ),
                                title: Text(
                                  "Spots",
                                  style: TextStyle(fontSize: 16.0),
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(context, SPOTS_ROUTE);
                                },
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.airplanemode_active,
                                  color: Color(0xFF0078D7),
                                ),
                                title: Text(
                                  "Gliders",
                                  style: TextStyle(fontSize: 16.0),
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(context, GLIDERS_ROUTE);
                                },
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.bar_chart,
                                  color: Color(0xFF0078D7),
                                ),
                                title: Text(
                                  "Statistics",
                                  style: TextStyle(fontSize: 16.0),
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(context, STATS_ROUTE);
                                },
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.person,
                                  color: Color(0xFF0078D7),
                                ),
                                title: Text(
                                  "Profile",
                                  style: TextStyle(fontSize: 16.0),
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(context, PROFILE_ROUTE);
                                },
                              ),
                            ] else ...[
                              ListTile(
                                leading: Icon(
                                  Icons.login,
                                  color: Color(0xFF0078D7),
                                ),
                                title: Text(
                                  "Login",
                                  style: TextStyle(fontSize: 16.0),
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(context, LOGIN_ROUTE);
                                },
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.person_add,
                                  color: Color(0xFF0078D7),
                                ),
                                title: Text(
                                  "Register",
                                  style: TextStyle(fontSize: 16.0),
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(context, REGISTER_ROUTE);
                                },
                              ),
                            ],
                          ],
                        ),
                      ),
                      // Bottom buttons
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            // Feedback Button
                            ElevatedButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                final url = Uri.parse(
                                  'https://github.com/FloatyFly/floaty-frontend/issues',
                                );
                                if (await canLaunchUrl(url)) {
                                  await launchUrl(
                                    url,
                                    mode: LaunchMode.externalApplication,
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFFFA500),
                                foregroundColor: Colors.white,
                                minimumSize: Size(double.infinity, 40),
                                textStyle: TextStyle(fontSize: 16.0),
                              ),
                              child: Text('Feedback'),
                            ),
                            SizedBox(height: 12),
                            // Logout Button (only show if logged in)
                            if (appState.isLoggedIn)
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Provider.of<AppState>(
                                    context,
                                    listen: false,
                                  ).logout();
                                  Navigator.pushNamed(context, HOME_ROUTE);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFFF4500),
                                  foregroundColor: Colors.white,
                                  minimumSize: Size(double.infinity, 40),
                                  textStyle: TextStyle(fontSize: 16.0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.logout, size: 20),
                                    SizedBox(width: 8),
                                    Text('Logout'),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: MediaQuery.of(context).size.height * 0.10, // 10% height
      color: const Color(0xFFF8F4E3), // Cream white color
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            '© 2024 Floaty. All rights reserved.',
            style: TextStyle(fontSize: 14.0, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
