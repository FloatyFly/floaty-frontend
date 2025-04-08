import 'package:cookie_jar/cookie_jar.dart';
import 'package:floaty/constants.dart';
import 'package:floaty/email_verification_page.dart';
import 'package:floaty/model.dart';
import 'package:floaty/profile_page.dart';
import 'package:floaty/register_page.dart';
import 'package:floaty/stats_page.dart';
import 'package:floaty/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_flight_page.dart';
import 'forgot_password_page.dart';

import 'flights_page.dart';
import 'landing_page.dart';
import 'login_page.dart';

void main() async {
  runApp(
    ChangeNotifierProvider(create: (context) => AppState(), child: FloatyApp()),
  );
}

class FloatyApp extends StatelessWidget {
  final cookieJar = CookieJar();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<CookieJar>.value(value: cookieJar), // Provide CookieJar.
      ],
      child: MaterialApp(
        title: 'Floaty',
        theme: buildThemeData(),
        initialRoute: REGISTER_ROUTE,
        routes: {
          HOME_ROUTE: (context) => RegisterPage(),
          LOGIN_ROUTE: (context) => LoginPage(),
          PROFILE_ROUTE:
              (context) =>
                  ProfilePage(user: Provider.of<AppState>(context).currentUser),
          REGISTER_ROUTE: (context) => RegisterPage(),
          FORGOT_PASSWORD_ROUTE: (context) => ForgotPasswordPage(),
          FLIGHTS_ROUTE:
              (context) =>
                  FlightsPage(user: Provider.of<AppState>(context).currentUser),
          ADD_FLIGHT_ROUTE: (context) => AddFlightPage(),
          EMAIL_VERIFICATION_ROUTE: (context) => EmailVerificationPage(),
          STATS_ROUTE:
              (context) =>
                  StatsPage(user: Provider.of<AppState>(context).currentUser),
        },
      ),
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
          // Redirect to LandingPage if not logged in
          page = LandingPage();
        } else {
          // Determine which page to display based on selected index
          switch (appState.selectedIndex) {
            case 0:
              page = LandingPage();
              break;
            case 1:
              page = FlightsPage(user: appState.currentUser);
              break;
            case 2:
              page = StatsPage(user: appState.currentUser);
              break;
            case 3:
              page = ProfilePage(user: appState.currentUser);
              break;
            default:
              page = LandingPage(); // Fallback to LandingPage
              break;
          }
        }

        return Scaffold(
          body: page, // Directly display the selected page
        );
      },
    );
  }
}
