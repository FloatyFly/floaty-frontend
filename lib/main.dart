import 'package:firebase_auth/firebase_auth.dart';
import 'package:floaty/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'flights_screen.dart';
import 'landing_page.dart';
import 'login_page.dart';

void main() async {
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions
        .currentPlatform, // This uses the generated options
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Floaty',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),
      home: MyHomePage(), //
    );
  }
}

class MyAppState extends ChangeNotifier {
  bool _isLoggedIn = false;
  User? _currentUser;

  int _selectedIndex = 0; // Default to the LandingPage if logged in

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;
  int get selectedIndex => _selectedIndex;

  void setUser(User? user) {
    _currentUser = user;
    notifyListeners();
  }

  void login(User user) {
    _currentUser = user;
    _isLoggedIn = true;
    _selectedIndex = 0; // Navigate to LandingPage after login
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    _isLoggedIn = false;
    _selectedIndex = 2; // Navigate to LoginPage after logout
    notifyListeners();
  }

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MyAppState>(
      builder: (context, appState, child) {
        Widget page;
        if (!appState.isLoggedIn) {
          page = LoginPage();
        } else {
          switch (appState.selectedIndex) {
            case 0:
              page = LandingPage();
              break;
            case 1:
              page = FlightsScreen(user: appState.currentUser);
              break;
            case 2:
              page = ProfilePage(user: appState.currentUser);
              break;
            default:
              page = LandingPage(); // Default to LandingPage if unsure
              break;
          }
        }

        return Scaffold(
          body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              if (constraints.maxWidth < 600) {
                return Column(
                  children: [
                    Expanded(child: page),
                    BottomNavigationBar(
                      items: const <BottomNavigationBarItem>[
                        BottomNavigationBarItem(
                            icon: Icon(Icons.home), label: 'Home'),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.paragliding_sharp),
                            label: 'Flights'),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.person_sharp), label: 'Profile'),
                      ],
                      currentIndex: appState.selectedIndex,
                      onTap: (index) {
                        if (appState.isLoggedIn) {
                          appState.setSelectedIndex(index);
                        }
                      },
                    ),
                  ],
                );
              } else {
                return Row(
                  children: [
                    NavigationRail(
                      selectedIndex: appState.selectedIndex,
                      onDestinationSelected: (index) {
                        if (appState.isLoggedIn) {
                          appState.setSelectedIndex(index);
                        }
                      },
                      destinations: [
                        NavigationRailDestination(
                            icon: Icon(Icons.home), label: Text('Home')),
                        NavigationRailDestination(
                            icon: Icon(Icons.paragliding_sharp),
                            label: Text('Flights')),
                        NavigationRailDestination(
                            icon: Icon(Icons.person), label: Text('Profile')),
                      ],
                    ),
                    Expanded(child: page),
                  ],
                );
              }
            },
          ),
        );
      },
    );
  }
}
