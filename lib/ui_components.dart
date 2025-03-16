import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants.dart';
import 'main.dart';

class FloatyBackgroundWidget extends StatelessWidget {
  const FloatyBackgroundWidget({Key? key}) : super(key: key);

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
            ),
          ),
        ),
        // Semi-transparent overlay
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.grey.withOpacity(0.5),
        ),
        // Dot Grid Overlay
        Positioned.fill(
          child: CustomPaint(
            painter: DotGridPainter(),
          ),
        ),
      ],
    );
  }
}

class DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double dotSpacing = 20.0; // Adjust for desired spacing between dots
    final dotPaint = Paint()
      ..color = Colors.grey.withOpacity(0.4) // Semi-transparent grey
      ..strokeWidth = 2.0
      ..style = PaintingStyle.fill;

    for (var i = 1.0; i < size.width; i += dotSpacing) {
      for (var j = 0.0; j < size.height; j += dotSpacing) {
        canvas.drawCircle(Offset(i, j), 1.1, dotPaint); // Adjust radius for dot size
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

  const AuthContainer({
    Key? key,
    required this.headerText,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 400,
        height: 550,
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isLargeScreen = MediaQuery
        .of(context)
        .size
        .width >= 600;

    return Container(
      height: 75.0,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Replace text with image logo
          Image.asset(
            "assets/logo.png",
            height: 55.0,
            fit: BoxFit.contain,
          ),

          // Show navigation links or menu only when logged in
          if (appState.isLoggedIn)
            if (isLargeScreen)
              Row(
                children: [
                  _buildNavButton(
                    context,
                    "Home",
                    0,
                    appState.selectedIndex,
                  ),
                  const SizedBox(width: 16.0),
                  _buildNavButton(
                    context,
                    "Flights",
                    1,
                    appState.selectedIndex,
                  ),
                  const SizedBox(width: 16.0),
                  _buildNavButton(
                    context,
                    "Statistics",
                    2,
                    appState.selectedIndex,
                  ),
                  const SizedBox(width: 16.0),
                  _buildNavButton(
                    context,
                    "Profile",
                    3,
                    appState.selectedIndex,
                  ),
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
  Widget _buildNavButton(BuildContext context, String label, int index,
      int selectedIndex) {
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
          Navigator.pushNamed(context, STATS_ROUTE);
        } else if (index == 3) {
          Navigator.pushNamed(context, PROFILE_ROUTE);
        }
      },
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.blue : Colors.black,
          // Blue color for selected item
          fontSize: 18.0,
          fontWeight: isSelected ? FontWeight.bold : FontWeight
              .normal, // Bold for selected item
        ),
      ),
    );
  }


  void _showMenuDialog(BuildContext context, AppState appState) {
    if (!appState.isLoggedIn)
      return; // If the user is not logged in, do nothing

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("Home"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, HOME_ROUTE);
                },
              ),
              ListTile(
                title: const Text("Flights"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, FLIGHTS_ROUTE);
                },
              ),
              ListTile(
                title: const Text("Statistics"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, STATS_ROUTE);
                },
              ),
              ListTile(
                title: const Text("Profile"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, PROFILE_ROUTE);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}


class Footer extends StatelessWidget {
  const Footer({
    super.key,
  });

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
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}


