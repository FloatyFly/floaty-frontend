import 'package:floaty/config/constants.dart';
import 'package:floaty/pages/email_verification_page.dart';
import 'package:floaty/models/model.dart';
import 'package:floaty/pages/profile_page.dart';
import 'package:floaty/pages/register_page.dart';
import 'package:floaty/pages/stats_page.dart';
import 'package:floaty/config/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/add_flight_page.dart';
import 'pages/add_spot_page.dart';
import 'pages/add_glider_page.dart';
import 'pages/forgot_password_page.dart';
import 'pages/gliders_page.dart';
import 'pages/spots_page.dart';
import 'config/router.dart' as app_router;
import 'package:web/web.dart' as web;
import 'package:floaty_client/api.dart';

import 'pages/flights_page.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Create AppState instance
  final appState = AppState();

  // Check for existing session before running the app
  await appState.checkExistingSession();

  runApp(ChangeNotifierProvider.value(value: appState, child: FloatyApp()));
}

class FloatyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Floaty',
      theme: buildThemeData(),
      initialRoute: HOME_ROUTE,
      onGenerateRoute: (settings) {
        // Use custom route builder for instant transitions
        final routes = <String, WidgetBuilder>{
          HOME_ROUTE: (context) => HomePage(),
          LOGIN_ROUTE: (context) => LoginPage(),
          PROFILE_ROUTE:
              (context) => ProfilePage(
                user: Provider.of<AppState>(context, listen: false).currentUser!,
              ),
          REGISTER_ROUTE: (context) => RegisterPage(),
          FORGOT_PASSWORD_ROUTE: (context) => ForgotPasswordPage(),
          FLIGHTS_ROUTE: (context) => FlightsPage(),
          ADD_FLIGHT_ROUTE: (context) => AddFlightPage(),
          ADD_SPOT_ROUTE: (context) => AddSpotPage(),
          EMAIL_VERIFICATION_ROUTE: (context) => EmailVerificationPage(),
          STATS_ROUTE:
              (context) =>
                  StatsPage(user: Provider.of<AppState>(context, listen: false).currentUser!),
          SPOTS_ROUTE:
              (context) =>
                  SpotsPage(user: Provider.of<AppState>(context, listen: false).currentUser!),
          GLIDERS_ROUTE:
              (context) => GlidersPage(
                user: Provider.of<AppState>(context, listen: false).currentUser!,
              ),
        };

        final builder = routes[settings.name];
        if (builder != null) {
          return app_router.NoAnimationPageRoute(builder: builder);
        }

        // Fall back to custom router for other routes
        return app_router.Router.generateRoute(settings);
      },
    );
  }
}

class AppState extends ChangeNotifier {
  bool _isUserLoggedIn = false;
  FloatyUser? _currentUser;
  bool _isSessionCheckComplete = false;

  // TODO: Make this clearer.
  int _selectedIndex = 0; // Default to the LandingPage if logged in

  FloatyUser? get currentUser => _currentUser;
  bool get isLoggedIn => _isUserLoggedIn;
  int get selectedIndex => _selectedIndex;
  bool get isSessionCheckComplete => _isSessionCheckComplete;

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
    _clearSessionCookie();
    notifyListeners();
  }

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  // Make this method public and add session check completion tracking
  Future<void> checkExistingSession() async {
    try {
      final apiClient = ApiClient(basePath: backendUrl);
      final authApi = AuthApi(apiClient);

      User? currentUser = await authApi.getCurrentUser();

      if (currentUser != null) {
        FloatyUser floatyUser = FloatyUser(
          id: currentUser.id,
          name: currentUser.name,
          email: currentUser.email,
          emailVerified: currentUser.emailVerified,
        );

        // Session is valid, restore user state
        _currentUser = floatyUser;
        _isUserLoggedIn = true;
        _selectedIndex = 1; // Set to logged-in state
        print('Session restored for user: ${currentUser.email}');
      } else {
        print('No current user found');
      }
    } catch (e) {
      // Session invalid or expired
      print('No valid session found: $e');
      // Optionally clear any stale cookies
      _clearSessionCookie();
    } finally {
      _isSessionCheckComplete = true;
      notifyListeners();
    }
  }

  void _clearSessionCookie() {
    web.document.cookie =
        "sessionToken=; expires=Thu, 01 Jan 1970 00:00:00 GMT; path=/";
  }
}
