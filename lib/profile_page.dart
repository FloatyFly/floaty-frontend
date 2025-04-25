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
              SizedBox(height: 20), // Space below the header
              Expanded(
                child: Center(
                  child: Container(
                    width: containerWidth,
                    padding: EdgeInsets.all(isMobile ? 8 : 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          isMobile
                              ? BorderRadius
                                  .zero // No rounded corners on mobile
                              : BorderRadius.circular(
                                6,
                              ), // Rounded corners on all sides for desktop
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
                      padding: EdgeInsets.zero,
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
                          SizedBox(height: isMobile ? 16 : 24),
                          // User Info
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isMobile ? 8 : 0,
                              vertical: isMobile ? 12 : 0,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isMobile
                                      ? Colors.grey.shade50
                                      : Colors.transparent,
                              borderRadius: BorderRadius.circular(
                                isMobile ? 8 : 0,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: isMobile ? 80 : 100,
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
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.bodyLarge,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: isMobile ? 12 : 12),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: isMobile ? 80 : 100,
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
                                                Theme.of(
                                                  context,
                                                ).textTheme.bodyLarge,
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
                              ],
                            ),
                          ),
                          SizedBox(height: isMobile ? 16 : 32),
                          // Verify Email Button
                          if (_isSendingVerification)
                            Center(child: CircularProgressIndicator())
                          else if (!_currentUser.emailVerified)
                            Center(
                              child: ElevatedButton.icon(
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
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
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
