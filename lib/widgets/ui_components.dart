import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map/flutter_map.dart';

import '../config/constants.dart';
import '../main.dart';
import '../services/auth_service.dart';

class FloatyBackgroundWidget extends StatelessWidget {
  const FloatyBackgroundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        // Base white background
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
        ),

        // Centered lime green glow at top third
        Positioned(
          top: screenHeight * 0.15, // Top third area
          left: screenWidth * 0.5 - 400, // Centered
          child: Container(
            width: 800,
            height: 800,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Color(0xFFC0FF58).withOpacity(0.6), // Stronger lime green center
                  Color(0xFFC0FF58).withOpacity(0.3),
                  Color(0xFFC0FF58).withOpacity(0.0), // Fade to transparent/white
                ],
                stops: [0.0, 0.4, 1.0],
              ),
            ),
          ),
        ),

        // Subtle dot grid overlay
        Positioned.fill(
          child: CustomPaint(painter: DotGridPainter()),
        ),
      ],
    );
  }
}

class DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double dotSpacing = 30.0; // Larger spacing for subtlety
    final dotPaint = Paint()
      ..color = Colors.grey.withOpacity(0.15) // Very subtle gray dots
      ..strokeWidth = 1.0
      ..style = PaintingStyle.fill;

    for (var i = 1.0; i < size.width; i += dotSpacing) {
      for (var j = 0.0; j < size.height; j += dotSpacing) {
        canvas.drawCircle(
          Offset(i, j),
          0.8, // Smaller dots
          dotPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// A reusable container for authentication pages (e.g., Login, Register)
class AuthContainer extends StatelessWidget {
  final String headerText;
  final Widget child;
  final bool isFlightPage; // New parameter to identify flight pages

  const AuthContainer({
    super.key,
    required this.headerText,
    required this.child,
    this.isFlightPage = false, // Default to false for backward compatibility
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth =
        screenWidth > 400.0
            ? 400.0
            : screenWidth - 32.0; // 16px margin on each side
    const containerHeight = 550.0;

    return Center(
      child: Container(
        width: containerWidth,
        height: containerHeight,
        margin: EdgeInsets.only(
          top: isFlightPage ? 100.0 : 24.0, // More top margin for flight pages
          bottom: 24.0,
          left: 16.0,
          right: 16.0,
        ),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Column(
          children: [
            // Header Box
            Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12.0),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                headerText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Child widget (e.g., LoginForm)
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32.0,
                    vertical: 16.0,
                  ),
                  child: child,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isLargeScreen = MediaQuery.of(context).size.width >= 800;
    final screenWidth = MediaQuery.of(context).size.width;

    // For large screens, show floating pill navbar
    if (isLargeScreen) {
      return Container(
        height: 80.0, // Flatter - reduced from 100.0
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0), // Reduced from 20.0
            child: Container(
              constraints: BoxConstraints(maxWidth: 1200),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(50.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      offset: Offset(0, 0),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0), // Reduced from 12.0
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo (white for black background)
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, HOME_ROUTE);
                      },
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Image.asset(
                          "assets/logo_white.png",
                          height: 40.0,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(width: 32.0),
                    // Navigation links
                    _buildNavButton(context, "Home", 0, appState.selectedIndex),
                    const SizedBox(width: 24.0),
                    if (appState.isLoggedIn) ...[
                      _buildNavButton(context, "Flights", 1, appState.selectedIndex),
                      const SizedBox(width: 24.0),
                      _buildNavButton(context, "Spots", 2, appState.selectedIndex),
                      const SizedBox(width: 24.0),
                      _buildNavButton(context, "Gliders", 3, appState.selectedIndex),
                      const SizedBox(width: 24.0),
                      _buildNavButton(context, "Statistics", 4, appState.selectedIndex),
                      const SizedBox(width: 24.0),
                      _buildNavButton(context, "Profile", 5, appState.selectedIndex),
                    ] else ...[
                      _buildNavButton(context, "Login", -1, appState.selectedIndex, route: LOGIN_ROUTE),
                      const SizedBox(width: 24.0),
                      _buildNavButton(context, "Register", -2, appState.selectedIndex, route: REGISTER_ROUTE),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    // Mobile: Show traditional header with hamburger menu (black logo on white)
    return Container(
      height: 75.0,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, HOME_ROUTE);
            },
            child: Image.asset(
              "assets/logo_black.png",
              height: 55.0,
              fit: BoxFit.contain,
            ),
          ),
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

  // Helper function to build navigation buttons
  Widget _buildNavButton(
    BuildContext context,
    String label,
    int index,
    int selectedIndex, {
    String? route,
  }) {
    final isSelected = index == selectedIndex;
    final isLargeScreen = MediaQuery.of(context).size.width >= 800;

    return _NavButton(
      label: label,
      isSelected: isSelected,
      isLargeScreen: isLargeScreen,
      onPressed: () {
        // Update the selected index in AppState
        if (index >= 0) {
          Provider.of<AppState>(context, listen: false).setSelectedIndex(index);
        }
        // Navigate to the corresponding page
        if (route != null) {
          Navigator.pushNamed(context, route);
        } else if (index == 0) {
          Navigator.pushNamed(context, HOME_ROUTE);
        } else if (index == 1) {
          Navigator.pushNamed(context, FLIGHTS_ROUTE);
        } else if (index == 2) {
          Navigator.pushNamed(context, SPOTS_ROUTE);
        } else if (index == 3) {
          Navigator.pushNamed(context, GLIDERS_ROUTE);
        } else if (index == 4) {
          Navigator.pushNamed(context, STATS_ROUTE);
        } else if (index == 5) {
          Navigator.pushNamed(context, PROFILE_ROUTE);
        }
      },
    );
  }
}

class _NavButton extends StatefulWidget {
  final String label;
  final bool isSelected;
  final bool isLargeScreen;
  final VoidCallback onPressed;

  const _NavButton({
    required this.label,
    required this.isSelected,
    required this.isLargeScreen,
    required this.onPressed,
  });

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: TextButton(
        onPressed: widget.onPressed,
        child: Text(
          widget.label,
          style: TextStyle(
            color: widget.isLargeScreen
                ? (widget.isSelected || _isHovering ? Color(0xFFC0FF58) : Colors.white) // Lime green for selected or hover
                : (widget.isSelected ? Color(0xFFC0FF58) : Colors.black), // Lime green for mobile selected
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// Extension on Header class for the menu dialog
extension _HeaderMenuDialog on Header {
  void _showMenuDialog(BuildContext context, AppState appState) {
    final screenWidth = MediaQuery.of(context).size.width;
    final menuWidth = screenWidth * 0.75; // Slightly wider for better UX

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: ModalRoute.of(context)!.animation!,
              curve: Curves.easeOut,
            ),
          ),
          child: Align(
            alignment: Alignment.topRight,
            child: Material(
              child: Container(
                width: menuWidth,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(-2, 0),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with close button
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey.shade200,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Menu',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.close, color: Colors.black87),
                              onPressed: () => Navigator.pop(context),
                              splashRadius: 20,
                            ),
                          ],
                        ),
                      ),
                      // Navigation items
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          children: [
                            _buildMenuItem(
                              context,
                              icon: Icons.home_outlined,
                              label: "Home",
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(context, HOME_ROUTE);
                              },
                            ),
                            if (appState.isLoggedIn) ...[
                              _buildMenuItem(
                                context,
                                icon: Icons.paragliding_outlined,
                                label: "Flights",
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(context, FLIGHTS_ROUTE);
                                },
                              ),
                              _buildMenuItem(
                                context,
                                icon: Icons.location_on_outlined,
                                label: "Spots",
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(context, SPOTS_ROUTE);
                                },
                              ),
                              _buildMenuItem(
                                context,
                                icon: Icons.airplanemode_active_outlined,
                                label: "Gliders",
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(context, GLIDERS_ROUTE);
                                },
                              ),
                              _buildMenuItem(
                                context,
                                icon: Icons.bar_chart_outlined,
                                label: "Statistics",
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(context, STATS_ROUTE);
                                },
                              ),
                              _buildMenuItem(
                                context,
                                icon: Icons.person_outline,
                                label: "Profile",
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(context, PROFILE_ROUTE);
                                },
                              ),
                            ] else ...[
                              _buildMenuItem(
                                context,
                                icon: Icons.login_outlined,
                                label: "Login",
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(context, LOGIN_ROUTE);
                                },
                              ),
                              _buildMenuItem(
                                context,
                                icon: Icons.person_add_outlined,
                                label: "Register",
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(context, REGISTER_ROUTE);
                                },
                              ),
                            ],
                          ],
                        ),
                      ),
                      // Bottom section with buttons
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: Colors.grey.shade200,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Column(
                          children: [
                            // Feedback Button
                            FloatyButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                final url = Uri.parse(
                                  'https://github.com/FloatyFly/floaty-frontend/issues',
                                );
                                if (await canLaunchUrl(url)) {
                                  await launchUrl(
                                    url,
                                    mode: LaunchMode.externalApplication,
                                  );
                                }
                              },
                              text: 'Feedback',
                              width: double.infinity,
                            ),
                            SizedBox(height: 12),
                            // Logout Button (only show if logged in)
                            if (appState.isLoggedIn)
                              FloatyButton(
                                onPressed: () async {
                                  print('Logout button pressed');
                                  Navigator.pop(context);

                                  // Call backend logout API to invalidate session
                                  print('Calling logout API');
                                  try {
                                    await logout();
                                    print('Logout API call completed successfully');
                                  } catch (e) {
                                    print('Logout API error: $e');
                                  }

                                  // Clear client-side state
                                  print('Clearing client-side state');
                                  Provider.of<AppState>(
                                    context,
                                    listen: false,
                                  ).logout();

                                  Navigator.pushNamed(context, HOME_ROUTE);
                                },
                                text: 'Logout',
                                backgroundColor: Colors.red,
                                icon: Icon(Icons.logout, size: 20),
                                width: double.infinity,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.black87,
              size: 24,
            ),
            SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Reusable button with consistent styling across the app
/// Features: hard black shadow, no hover effects, rounded corners
class FloatyButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color backgroundColor;
  final Color foregroundColor;
  final EdgeInsets? padding;
  final double? width;
  final double? height;
  final Widget? icon;
  final bool enabled;

  const FloatyButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.backgroundColor = const Color(0xFF2B7DE9), // Default blue
    this.foregroundColor = Colors.white,
    this.padding,
    this.width,
    this.height,
    this.icon,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        boxShadow: enabled
            ? [
                BoxShadow(
                  color: Colors.black,
                  offset: Offset(-4, 4),
                  blurRadius: 0,
                  spreadRadius: 0,
                ),
              ]
            : [],
      ),
      child: icon != null
          ? ElevatedButton.icon(
              onPressed: enabled ? onPressed : null,
              icon: icon!,
              label: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: _buttonStyle(),
            )
          : ElevatedButton(
              onPressed: enabled ? onPressed : null,
              style: _buttonStyle(),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      disabledBackgroundColor: backgroundColor.withOpacity(0.6),
      disabledForegroundColor: foregroundColor.withOpacity(0.6),
      padding: padding ??
          EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 16,
          ),
      minimumSize: Size(width ?? 0, height ?? 48),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      elevation: 0,
      shadowColor: Colors.transparent,
    ).copyWith(
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      shadowColor: WidgetStateProperty.all(Colors.transparent),
      elevation: WidgetStateProperty.all(0),
    );
  }
}

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0, // Thinner - fixed height instead of percentage
      color: Colors.black, // Black background
      child: Center(
        child: Text(
          '© 2024 Floaty. All rights reserved.',
          style: TextStyle(fontSize: 14.0, color: Colors.white), // White text
        ),
      ),
    );
  }
}

/// A reusable map widget with zoom controls (+/-) buttons
/// Disables scroll wheel zoom to prevent page scroll conflicts
class MapWithZoomControls extends StatelessWidget {
  final MapController mapController;
  final MapOptions options;
  final List<Widget> children;

  const MapWithZoomControls({
    super.key,
    required this.mapController,
    required this.options,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    // Ensure scroll wheel is disabled in the options
    final disabledScrollOptions = MapOptions(
      initialCenter: options.initialCenter,
      initialZoom: options.initialZoom,
      initialCameraFit: options.initialCameraFit,
      initialRotation: options.initialRotation,
      onTap: (tapPosition, latLng) {
        // Call original onTap if provided
        if (options.onTap != null) {
          options.onTap!(tapPosition, latLng);
        }
      },
      onSecondaryTap: (tapPosition, latLng) {
        // Double-tap to zoom in
        final currentZoom = mapController.camera.zoom;
        final newZoom = (currentZoom + 1).clamp(1.0, 18.0);
        mapController.move(latLng, newZoom);
      },
      onLongPress: options.onLongPress,
      onPositionChanged: options.onPositionChanged,
      onMapReady: options.onMapReady,
      interactionOptions: const InteractionOptions(
        enableScrollWheel: false,
        enableMultiFingerGestureRace: false,
        flags:
            InteractiveFlag.drag |
            InteractiveFlag.flingAnimation |
            InteractiveFlag.pinchMove |
            InteractiveFlag.pinchZoom |
            InteractiveFlag.doubleTapZoom,
      ),
      cameraConstraint: options.cameraConstraint,
      backgroundColor: options.backgroundColor,
    );

    return Stack(
      children: [
        FlutterMap(
          mapController: mapController,
          options: disabledScrollOptions,
          children: children,
        ),
        // Zoom control buttons
        Positioned(
          top: 12,
          right: 12,
          child: Column(
            children: [
              // Zoom in button
              Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                elevation: 2,
                child: InkWell(
                  onTap: () {
                    final currentZoom = mapController.camera.zoom;
                    final newZoom = (currentZoom + 1).clamp(1.0, 18.0);
                    mapController.move(
                      mapController.camera.center,
                      newZoom,
                    );
                  },
                  child: Container(
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.add,
                      size: 20,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
              // Zoom out button
              Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                elevation: 2,
                child: InkWell(
                  onTap: () {
                    final currentZoom = mapController.camera.zoom;
                    final newZoom = (currentZoom - 1).clamp(1.0, 18.0);
                    mapController.move(
                      mapController.camera.center,
                      newZoom,
                    );
                  },
                  child: Container(
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.remove,
                      size: 20,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
