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
import 'add_spot_page.dart';
import 'add_glider_page.dart';
import 'forgot_password_page.dart';
import 'gliders_page.dart';
import 'spots_page.dart';
import 'router.dart' as app_router;

import 'flights_page.dart';
import 'landing_page.dart';
import 'login_page.dart';
import 'home_page.dart';

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
        initialRoute: HOME_ROUTE,
        onGenerateRoute: app_router.Router.generateRoute,
        routes: {
          HOME_ROUTE: (context) => HomePage(),
          LOGIN_ROUTE: (context) => LoginPage(),
          PROFILE_ROUTE:
              (context) => ProfilePage(
                user: Provider.of<AppState>(context).currentUser!,
              ),
          REGISTER_ROUTE: (context) => RegisterPage(),
          FORGOT_PASSWORD_ROUTE: (context) => ForgotPasswordPage(),
          FLIGHTS_ROUTE:
              (context) => FlightsPage(
                user: Provider.of<AppState>(context).currentUser!,
              ),
          ADD_FLIGHT_ROUTE: (context) => AddFlightPage(),
          ADD_SPOT_ROUTE: (context) => AddSpotPage(),
          ADD_GLIDER_ROUTE: (context) => AddGliderPage(),
          EMAIL_VERIFICATION_ROUTE: (context) => EmailVerificationPage(),
          STATS_ROUTE:
              (context) =>
                  StatsPage(user: Provider.of<AppState>(context).currentUser!),
          SPOTS_ROUTE:
              (context) =>
                  SpotsPage(user: Provider.of<AppState>(context).currentUser!),
          GLIDERS_ROUTE:
              (context) => GlidersPage(
                user: Provider.of<AppState>(context).currentUser!,
              ),
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
    _selectedIndex = 0; // Navigate to HomePage after logout
    notifyListeners();
  }

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
