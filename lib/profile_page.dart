import 'package:flutter/material.dart';
import 'package:floaty/ui_components.dart';
import 'package:floaty/model.dart';

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

    return Scaffold(
      body: Stack(
        children: [
          if (!isMobile) const FloatyBackgroundWidget(),
          if (isMobile) Container(color: Colors.white),
          Column(
            children: [
              Header(),
              SizedBox(height: 20),
              Container(
                width: containerWidth,
                padding: EdgeInsets.all(isMobile ? 8 : 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      isMobile ? BorderRadius.zero : BorderRadius.circular(6),
                  boxShadow:
                      isMobile
                          ? []
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
                  padding: EdgeInsets.all(16),
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
                          borderRadius: BorderRadius.circular(isMobile ? 8 : 0),
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
                                    _currentUser.name,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
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
                                        _currentUser.email,
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
            ],
          ),
        ],
      ),
    );
  }
}
