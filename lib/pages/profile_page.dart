import 'package:flutter/material.dart';
import 'package:floaty/widgets/ui_components.dart';
import 'package:floaty/models/model.dart';
import 'package:provider/provider.dart';
import 'package:floaty/main.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../services/auth_service.dart';
import '../config/constants.dart';
import '../config/theme.dart';

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
    super.initState();
    _currentUser = widget.user!;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 700;
    final containerWidth = isMobile ? screenWidth : screenWidth * 2 / 3;
    final shadColors = getShadThemeData().colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          if (!isMobile) const FloatyBackgroundWidget(),
          if (isMobile) Container(color: Colors.white),
          Column(
            children: [
              Header(),
              SizedBox(height: 20),
              Expanded(
                child: Center(
                  child: Container(
                    width: containerWidth,
                    padding: EdgeInsets.all(isMobile ? 16 : 24),
                    decoration: BoxDecoration(
                      color: shadColors.card,
                      borderRadius: isMobile
                          ? BorderRadius.zero
                          : BorderRadius.vertical(top: Radius.circular(12)),
                      border: isMobile
                          ? null
                          : Border.all(color: shadColors.border, width: 1),
                      boxShadow: isMobile
                          ? []
                          : [
                              BoxShadow(
                                color: shadColors.foreground.withValues(alpha: 0.05),
                                spreadRadius: 0,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // User Info
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
                                '${_currentUser.name}',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
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
                                    '${_currentUser.email}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24),
                        SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: FloatyButton(
                            onPressed: () async {
                              // Call backend logout API to invalidate session
                              try {
                                await logout();
                              } catch (e) {
                                print('Logout API error: $e');
                              }

                              // Clear client-side state
                              context.read<AppState>().logout();

                              // Navigate to home
                              Navigator.pushNamed(context, HOME_ROUTE);
                            },
                            text: 'Logout',
                            backgroundColor: Colors.red,
                            icon: Icon(Icons.logout),
                            width: 140,
                          ),
                        ),
                        // Verify Email Button
                        if (_isSendingVerification)
                          Center(child: CircularProgressIndicator())
                        else if (!_currentUser.emailVerified)
                          Center(
                            child: FloatyButton(
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
                              text: 'Verify Email',
                              backgroundColor: Colors.orange,
                              icon: Icon(Icons.email_outlined),
                            ),
                          ),
                      ],
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
