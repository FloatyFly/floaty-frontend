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
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 700;
    // For mobile, use full width; for desktop use 2/3 of width
    final containerWidth = isMobile ? screenWidth : screenWidth * 2 / 3;

    return Scaffold(
      body: Stack(
        children: [
          // Only show background if not on mobile
          if (!isMobile) const FloatyBackgroundWidget(),
          // For mobile, use a white background
          if (isMobile) Container(color: Colors.white),
          Column(
            children: [
              Header(),
              SizedBox(height: 8), // Reduced gap between header and container
              Expanded(
                child: Center(
                  child: Container(
                    width: containerWidth,
                    padding: EdgeInsets.all(isMobile ? 8 : 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow:
                          isMobile
                              ? [] // No shadow on mobile
                              : [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pilot',
                            style: Theme.of(
                              context,
                            ).textTheme.headlineSmall!.copyWith(
                              color: Colors.blue.shade900,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 24.0),
                          // User Info
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 100,
                                child: Text(
                                  'Name',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyLarge!.copyWith(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  _currentUser.name ?? "Not set",
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 100,
                                child: Text(
                                  'Email',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyLarge!.copyWith(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    Text(
                                      _currentUser.email ?? "Not set",
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    if (_currentUser.emailVerified) ...[
                                      SizedBox(width: 8),
                                      Text(
                                        '(verified)',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyLarge!.copyWith(
                                          color: Colors.green,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
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
                            Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    _isSigningOut = true;
                                  });

                                  try {
                                    await logout(
                                      _currentUser.id,
                                      _getCookieAuth(),
                                    );
                                    _emptyCookieJar();

                                    setState(() {
                                      _isSigningOut = false;
                                    });
                                    // After successful logout, navigate to HomePage
                                    // Use pushReplacementNamed to replace the ProfilePage with HomePage
                                    Provider.of<AppState>(
                                      context,
                                      listen: false,
                                    ).logout();
                                    Navigator.pushReplacementNamed(
                                      context,
                                      HOME_ROUTE,
                                    );
                                  } catch (e) {
                                    // Handle error if logout fails
                                    print('Logout failed: $e');
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepOrange,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                ),
                                child: Text(
                                  'Logout',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
