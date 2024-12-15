import 'package:floaty/constants.dart';
import 'package:floaty/model.dart';
import 'package:floaty/profile_page.dart';
import 'package:floaty/register_page.dart';
import 'package:floaty/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'forgot_password_page.dart';
import 'user_service.dart';

import 'flights_page.dart';
import 'landing_page.dart';
import 'login_page.dart';

void main() async {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: FloatyApp(),
    ),
  );
}

class FloatyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Floaty',
      theme: buildThemeData(),
      home: HomePage(),
      initialRoute: '/',
      routes: {
        LOGIN_ROUTE: (context) => LoginPage(),
        PROFILE_ROUTE: (context) => ProfilePage(user: null),
        REGISTER_ROUTE: (context) => RegisterPage(),
        FORGOT_PASSWORD_ROUTE: (context) => ForgotPasswordPage(),
        FLIGHTS_ROUTE: (context) => FlightsPage(user: Provider.of<AppState>(context).currentUser),
      },
    );
  }
}

class AppState extends ChangeNotifier {
  bool _isUserLoggedIn = false;
  FloatyUser? _currentUser;

  // TODO: Make this clearer.
  int _selectedIndex = 0; // Default to the LandingPage if logged in

  FloatyUser? get currentUser => _currentUser;
  bool get isLoggedIn => _isUserLoggedIn;
  int get selectedIndex => _selectedIndex;

  void setUser(FloatyUser user) {
    _currentUser = user;
    notifyListeners();
  }

  void login(FloatyUser user) {
    _currentUser = user;
    _isUserLoggedIn = true;
    _selectedIndex = 1;
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    _isUserLoggedIn = false;
    _selectedIndex = 2; // Navigate to LoginPage after logout
    notifyListeners();
  }

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        Widget page;
        if (!appState.isLoggedIn) {
          page = LandingPage();
        } else {
          switch (appState.selectedIndex) {
            case 0:
              page = LandingPage();
              break;
            case 1:
              page = FlightsPage(user: appState.currentUser);
              break;
            case 2:
              page = ProfilePage(user: appState.currentUser);
              break;
            default:
              page = LandingPage(); // Default to LandingPage if unsure
              break;
          }
        }

        bool showNavBar = page is! LandingPage || (appState.isLoggedIn);

        return Scaffold(
          body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              if (constraints.maxWidth < 600) {
                return Column(
                  children: [
                    Expanded(child: page),
                    if (showNavBar) // Conditionally render the BottomNavigationBar
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
                    if (showNavBar) // Conditionally render the NavigationRail
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
