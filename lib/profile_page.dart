import 'package:cookie_jar/cookie_jar.dart';
import 'package:floaty/main.dart';
import 'package:floaty/ui_components.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'CookieAuth.dart';
import 'auth_service.dart';
import 'constants.dart';
import 'login_page.dart';
import 'model.dart';
import 'package:floaty_client/api.dart' as api;

class ProfilePage extends StatefulWidget {
  final FloatyUser? user;

  const ProfilePage({required this.user});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  bool _isSendingVerification = false;
  bool _isSigningOut = false;

  late FloatyUser _currentUser;

  @override
  void initState() {
    _currentUser = widget.user!;
    super.initState();
  }

  CookieAuth _getCookieAuth() {
    CookieJar cookieJar = Provider.of<CookieJar>(context, listen: false);
    return CookieAuth(cookieJar);
  }

  void _emptyCookieJar() {
    CookieJar cookieJar = Provider.of<CookieJar>(context, listen: false);
    cookieJar.deleteAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          const FloatyBackgroundWidget(),
          Header(),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // User Info Card
                    Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pilot',
                              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                color: Colors.blue.shade900,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 16.0),
                            Text(
                              'Name: ${_currentUser.name ?? "Not set"}',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'Email: ${_currentUser.email ?? "Not set"}',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              _currentUser.emailVerified
                                  ? 'Email Verified'
                                  : 'Email Not Verified',
                              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                color: _currentUser.emailVerified
                                    ? Colors.green
                                    : Colors.red,                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 32.0),
                    // Verify Email Button
                    if (_isSendingVerification)
                      CircularProgressIndicator()
                    else if (!_currentUser.emailVerified)
                      ElevatedButton.icon(
                        onPressed: () async {
                          setState(() {
                            _isSendingVerification = true;
                          });

                          // Simulate email verification process
                          await Future.delayed(Duration(seconds: 2));

                          setState(() {
                            _isSendingVerification = false;
                          });
                        },
                        icon: Icon(Icons.email_outlined),
                        label: Text('Verify Email'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                    SizedBox(height: 16.0),
                    // Sign Out Button
                    if (_isSigningOut)
                      CircularProgressIndicator()
                    else
                      ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            _isSigningOut = true;
                          });

                          try {
                            await logout(_currentUser.id, _getCookieAuth());
                            _emptyCookieJar();

                            setState(() {
                              _isSigningOut = false;
                            });
                            // After successful logout, navigate to HomePage
                            // Use pushReplacementNamed to replace the ProfilePage with HomePage
                            Provider.of<AppState>(context,
                                listen: false)
                                .logout();
                            Navigator.pushReplacementNamed(context, HOME_ROUTE);
                          } catch (e) {
                            // Handle error if logout fails
                            print('Logout failed: $e');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                        ),
                        child: Text(
                          'Logout',
                          style: TextStyle(
                            color: Colors.black,
                            backgroundColor: Colors.deepOrange
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
