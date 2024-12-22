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
    // Access AppState
    final appState = Provider.of<AppState>(context);
    final isLargeScreen = MediaQuery.of(context).size.width >= 600;

    return Container(
      height: 75.0,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Floaty Logo
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Floaty",
                style: TextStyle(
                  color: Colors.black, // Changed to black
                  fontSize: 28.0, // Larger size
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2.0),
              Text(
                "Simple paragliding logbook",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14.0,
                ),
              ),
            ],
          ),

          // Show navigation links or menu only when logged in
          if (appState.isLoggedIn)
            if (isLargeScreen)
              Row(
                children: [
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, HOME_ROUTE),
                    child: const Text(
                      "Home",
                      style: TextStyle(color: Colors.black, fontSize: 18.0),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, FLIGHTS_ROUTE),
                    child: const Text(
                      "Flights",
                      style: TextStyle(color: Colors.black, fontSize: 18.0),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, PROFILE_ROUTE),
                    child: const Text(
                      "Profile",
                      style: TextStyle(color: Colors.black, fontSize: 18.0),
                    ),
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

  void _showMenuDialog(BuildContext context, AppState appState) {
    if (!appState.isLoggedIn) return; // If the user is not logged in, do nothing

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


