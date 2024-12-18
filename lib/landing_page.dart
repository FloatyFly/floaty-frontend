import 'package:floaty/ui_components.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(  // Listen for changes in AppState
      builder: (context, appState, child) {
        return Stack(
          children: [
            const FloatyBackgroundWidget(),
            Positioned(
              left: 50,
              right: 0,
              top: MediaQuery.of(context).size.height * 0.3, // Adjust this value for desired height
              child: Text(
                'FLOATY',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 80.0,
                  color: Colors.white.withOpacity(0.7),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'ModernFont',
                ),
              ),
            ),
            Positioned(
              left: 50,
              right: 0,
              top: MediaQuery.of(context).size.height * 0.42, // Adjust this value for desired height
              child: Text(
                'Simple paragliding logbook',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white.withOpacity(0.7),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'ModernFont',
                ),
              ),
            ),
            // Show Login and Register buttons only if the user is NOT logged in
            if (!appState.isLoggedIn) ...[
              // Login Button
              Positioned(
                left: 50,
                right: 50,
                bottom: 100,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrangeAccent),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              // Register Button
              Positioned(
                left: 50,
                right: 50,
                bottom: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.brown),
                  ),
                  child: Text('Register'),
                ),
              ),
            ],
            // Show a "Welcome Back" message and a logout button if the user is logged in
            if (appState.isLoggedIn) ...[
              Positioned(
                left: 50,
                right: 0,
                bottom: 100,
                child: Text(
                  'Welcome back, ${appState.currentUser?.name ?? "User"}!',
                  style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.white.withOpacity(0.7),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'ModernFont',
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
