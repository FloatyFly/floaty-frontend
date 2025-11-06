import 'package:flutter/material.dart';
import 'package:floaty/widgets/ui_components.dart';
import 'package:floaty/models/model.dart';
import 'package:floaty/config/constants.dart';
import 'package:floaty/services/gliders_service.dart';
import 'package:floaty/services/flight_service.dart';
import 'package:floaty_client/api.dart' as api;
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../config/CookieAuth.dart';
import '../config/theme.dart';

class GlidersPage extends StatefulWidget {
  final FloatyUser? user;

  const GlidersPage({required this.user});

  @override
  _GlidersPageState createState() => _GlidersPageState();
}

class _GlidersPageState extends State<GlidersPage> {
  late Future<List<api.Glider>> futureGliders;
  late Future<List<Flight>> futureFlights;
  int? _hoveredGliderId;

  @override
  void initState() {
    super.initState();
    futureGliders = _fetchGliders();
    futureFlights = _fetchFlights();
  }

  CookieAuth _getCookieAuth() {
    return CookieAuth();
  }

  Future<List<api.Glider>> _fetchGliders() {
    return fetchGliders(_getCookieAuth());
  }

  Future<List<Flight>> _fetchFlights() {
    return fetchFlights(widget.user!.id, _getCookieAuth());
  }

  String _formatDuration(int minutes) {
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    if (hours > 0) {
      return '$hours:${remainingMinutes.toString().padLeft(2, '0')}';
    }
    return '$remainingMinutes min';
  }

  Future<void> _deleteGlider(int gliderId) async {
    try {
      final apiClient = api.ApiClient(
        basePath: backendUrl,
        authentication: _getCookieAuth(),
      );
      final glidersApi = api.GlidersApi(apiClient);
      await glidersApi.deleteGliderById(gliderId);

      // Refresh the list after deletion
      setState(() {
        futureGliders = _fetchGliders();
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error deleting glider: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 700;
    final containerWidth = isMobile ? screenWidth : screenWidth * 2 / 3;
    final shadColors = getShadThemeData().colorScheme;
    final linkColor = Color(0xFF2B7DE9); // Brighter blue (Add Flight button color)

    return Scaffold(
      backgroundColor: shadColors.background,
      body: Stack(
        children: [
          if (!isMobile) const FloatyBackgroundWidget(),
          if (isMobile) Container(color: shadColors.background),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black,
                                    offset: Offset(-4, 4),
                                    blurRadius: 0,
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    ADD_GLIDER_ROUTE,
                                  ).then((_) => setState(() {}));
                                },
                                icon: Icon(Icons.add, size: 18),
                                label: Text('Add Glider'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: linkColor,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Expanded(
                          child: FutureBuilder<List<api.Glider>>(
                            future: futureGliders,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: shadColors.primary,
                                  ),
                                );
                              }

                              if (snapshot.hasError) {
                                return Center(
                                  child: Text(
                                    'Error loading gliders: ${snapshot.error}',
                                    style: TextStyle(color: shadColors.destructive),
                                  ),
                                );
                              }

                              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context).size.height * 0.33,
                                      left: 16,
                                      right: 16,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.paragliding,
                                          size: 24,
                                          color: shadColors.primary,
                                        ),
                                        SizedBox(width: 8),
                                        Flexible(
                                          child: Text(
                                            'No gliders found. Add your first glider!',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: shadColors.foreground,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }

                              final gliders = snapshot.data!;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Header row
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                      vertical: 12.0,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            'Model',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: shadColors.foreground,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 24),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            'Manufacturer',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: shadColors.mutedForeground,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 24),
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            'Air Time',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: shadColors.mutedForeground,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 24),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            'Flights',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: shadColors.mutedForeground,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Header separator
                                  Divider(
                                    color: shadColors.border,
                                    height: 1,
                                    thickness: 1,
                                  ),
                                  // Gliders list
                                  Expanded(
                                    child: FutureBuilder<List<Flight>>(
                                      future: futureFlights,
                                      builder: (context, flightsSnapshot) {
                                        if (!flightsSnapshot.hasData) {
                                          return Center(
                                            child: CircularProgressIndicator(
                                              color: shadColors.primary,
                                            ),
                                          );
                                        }

                                        final flights = flightsSnapshot.data!;
                                        final gliderAirTime = <int, int>{};
                                        final gliderFlightCount = <int, int>{};

                                        // Calculate air time and flight count for each glider
                                        for (final flight in flights) {
                                          gliderAirTime[flight.gliderId] =
                                              (gliderAirTime[flight.gliderId] ??
                                                  0) +
                                              flight.duration;
                                          gliderFlightCount[flight.gliderId] =
                                              (gliderFlightCount[flight
                                                      .gliderId] ??
                                                  0) +
                                              1;
                                        }

                                        return ListView.separated(
                                          itemCount: gliders.length,
                                          separatorBuilder: (context, index) {
                                            return Divider(
                                              color: shadColors.border,
                                              height: 1,
                                              thickness: 1,
                                            );
                                          },
                                          itemBuilder: (context, index) {
                                            final glider = gliders[index];
                                            final airTime =
                                                gliderAirTime[glider.id] ?? 0;

                                            return MouseRegion(
                                              onEnter:
                                                  (_) => setState(
                                                    () =>
                                                        _hoveredGliderId =
                                                            glider.id,
                                                  ),
                                              onExit:
                                                  (_) => setState(
                                                    () =>
                                                        _hoveredGliderId = null,
                                                  ),
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.pushNamed(
                                                    context,
                                                    EDIT_GLIDER_ROUTE,
                                                    arguments: glider,
                                                  ).then((_) {
                                                    setState(() {
                                                      futureGliders =
                                                          _fetchGliders();
                                                    });
                                                  });
                                                },
                                                child: SizedBox(
                                                  width: double.infinity,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 16.0,
                                                          vertical: 12.0,
                                                        ),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 2,
                                                          child: Text(
                                                            glider.model,
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: linkColor,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 24),
                                                        Expanded(
                                                          flex: 2,
                                                          child: Text(
                                                            glider.manufacturer,
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  shadColors
                                                                      .foreground,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 24),
                                                        Expanded(
                                                          flex: 3,
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .access_time,
                                                                size: 15,
                                                                color:
                                                                    shadColors
                                                                        .mutedForeground,
                                                              ),
                                                              SizedBox(
                                                                width: 4,
                                                              ),
                                                              Text(
                                                                _formatDuration(
                                                                  airTime,
                                                                ),
                                                                style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color:
                                                                      shadColors
                                                                          .foreground,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(width: 24),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Text(
                                                            gliderFlightCount[glider
                                                                        .id]
                                                                    ?.toString() ??
                                                                '0',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  shadColors
                                                                      .foreground,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              );
                            },
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
