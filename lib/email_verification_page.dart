import 'package:flutter/material.dart';
import 'package:floaty_client/api.dart';
import 'package:provider/provider.dart';
import 'constants.dart';
import 'main.dart';

class EmailVerificationPage extends StatefulWidget {
  final String username;

  const EmailVerificationPage({Key? key, required this.username}) : super(key: key);

  @override
  _EmailVerificationPageState createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final _formKey = GlobalKey<FormState>();
  final _tokenController = TextEditingController();
  bool _isProcessing = false;
  String? _message;
  bool _isSuccess = false;

  Future<void> _verifyEmail(String token) async {
    setState(() {
      _isProcessing = true;
      _message = null;
      _isSuccess = false;
    });

    try {
      final apiClient = ApiClient(basePath: BASE_URL);
      final authApi = AuthApi(apiClient);

      await authApi.authVerifyEmailEmailVerificationTokenPost(token);
      setState(() {
        _isProcessing = false;
        _message = "Email successfully verified. You can now continue to login.";
        _isSuccess = true;
      });
    } catch (e) {
      setState(() {
        _isProcessing = false;
        _message = "Verification failed. The token might be invalid or expired.";
        _isSuccess = false;
      });
    }
  }

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
          // Logo (aligned left)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Floaty",
                style: TextStyle(
                  color: Colors.black, // Larger and black
                  fontSize: 28.0,
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
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: appState.isLoggedIn
                ? [
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
            ]
                : [
              ListTile(
                title: const Text("Login"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, LOGIN_ROUTE);
                },
              ),
            ],
          ),
        );
      },
    );
  }

}
