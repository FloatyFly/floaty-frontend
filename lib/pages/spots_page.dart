import 'package:flutter/material.dart';
import 'package:floaty/widgets/ui_components.dart';
import 'package:floaty/models/model.dart';
import 'package:floaty/config/constants.dart';
import 'package:floaty/services/spots_service.dart';
import 'package:floaty/services/flight_service.dart';
import 'package:floaty_client/api.dart' as api;
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../config/CookieAuth.dart';
import '../config/theme.dart';

class SpotsPage extends StatefulWidget {
  final FloatyUser? user;

  const SpotsPage({required this.user});

  @override
  _SpotsPageState createState() => _SpotsPageState();
}

class _SpotsPageState extends State<SpotsPage> {
  late Future<List<api.Spot>> futureSpots;
  late Future<List<Flight>> futureFlights;
  int? _hoveredSpotId;

  @override
  void initState() {
    super.initState();
    futureSpots = _fetchSpots();
    futureFlights = _fetchFlights();
  }

  CookieAuth _getCookieAuth() {
    return CookieAuth();
  }

  Future<List<api.Spot>> _fetchSpots() {
    return fetchSpots(widget.user!.id, _getCookieAuth());
  }

  Future<List<Flight>> _fetchFlights() {
    return fetchFlights(widget.user!.id, _getCookieAuth());
  }

  Future<void> _deleteSpot(int spotId) async {
    try {
      final apiClient = api.ApiClient(
        basePath: backendUrl,
        authentication: _getCookieAuth(),
      );
      final spotsApi = api.SpotsApi(apiClient);
      await spotsApi.deleteSpotById(spotId);

      // Refresh the list after deletion
      setState(() {
        futureSpots = _fetchSpots();
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error deleting spot: $e')));
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
                                    ADD_SPOT_ROUTE,
                                  ).then((_) {
                                    setState(() {
                                      futureSpots = _fetchSpots();
                                    });
                                  });
                                },
                                icon: Icon(Icons.add, size: 18),
                                label: Text('Add Spot'),
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
                          child: FutureBuilder<List<api.Spot>>(
                            future: futureSpots,
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
                                    'Error loading spots: ${snapshot.error}',
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
                                          Icons.location_on,
                                          size: 24,
                                          color: shadColors.primary,
                                        ),
                                        SizedBox(width: 8),
                                        Flexible(
                                          child: Text(
                                            'No spots found. Add your first spot!',
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

                              final spots = snapshot.data!;
                              final launchSpots =
                                  spots
                                      .where(
                                        (spot) =>
                                            spot.type ==
                                                api.SpotTypeEnum.LAUNCH_SITE ||
                                            spot.type ==
                                                api
                                                    .SpotTypeEnum
                                                    .LAUNCH_AND_LANDING_SITE,
                                      )
                                      .toList();
                              final landingSpots =
                                  spots
                                      .where(
                                        (spot) =>
                                            spot.type ==
                                                api.SpotTypeEnum.LANDING_SITE ||
                                            spot.type ==
                                                api
                                                    .SpotTypeEnum
                                                    .LAUNCH_AND_LANDING_SITE,
                                      )
                                      .toList();

                              if (isMobile) {
                                return SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildSpotSection(
                                        context,
                                        'Launch Sites',
                                        launchSpots,
                                        true,
                                      ),
                                      SizedBox(height: 24),
                                      _buildSpotSection(
                                        context,
                                        'Landing Sites',
                                        landingSpots,
                                        false,
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return SingleChildScrollView(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: _buildSpotSection(
                                          context,
                                          'Launch Sites',
                                          launchSpots,
                                          true,
                                        ),
                                      ),
                                      SizedBox(width: 24),
                                      Expanded(
                                        child: _buildSpotSection(
                                          context,
                                          'Landing Sites',
                                          landingSpots,
                                          false,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
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

  Widget _buildSpotSection(
    BuildContext context,
    String title,
    List<api.Spot> spots,
    bool isLaunch,
  ) {
    final shadColors = getShadThemeData().colorScheme;
    final linkColor = Color(0xFF2B7DE9);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (spots.isEmpty)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'No ${isLaunch ? 'launch' : 'landing'} sites found',
              style: TextStyle(fontSize: 16, color: shadColors.mutedForeground),
            ),
          )
        else
          FutureBuilder<List<Flight>>(
            future: futureFlights,
            builder: (context, flightsSnapshot) {
              if (!flightsSnapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(color: shadColors.primary),
                );
              }

              final flights = flightsSnapshot.data!;
              final spotUsage = <int, int>{};

              // Calculate usage for each spot
              for (final flight in flights) {
                if (isLaunch) {
                  spotUsage[flight.launchSpotId] =
                      (spotUsage[flight.launchSpotId] ?? 0) + 1;
                } else {
                  spotUsage[flight.landingSpotId] =
                      (spotUsage[flight.landingSpotId] ?? 0) + 1;
                }
              }

              // Sort spots by usage count
              spots.sort((a, b) {
                final aUsage = spotUsage[a.spotId] ?? 0;
                final bUsage = spotUsage[b.spotId] ?? 0;
                return bUsage.compareTo(aUsage); // Descending order
              });

              return Column(
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
                          flex: 1,
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: shadColors.foreground,
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  isLaunch ? 'Launches' : 'Landings',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: shadColors.mutedForeground,
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  'Altitude',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: shadColors.mutedForeground,
                                  ),
                                ),
                              ),
                            ],
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
                  // Spots list
                  ...spots.map((spot) {
                    final usage = spotUsage[spot.spotId] ?? 0;
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 12.0,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: StatefulBuilder(
                                    builder: (context, setState) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            EDIT_SPOT_ROUTE,
                                            arguments: spot,
                                          ).then((_) {
                                            setState(() {
                                              futureSpots = _fetchSpots();
                                            });
                                          });
                                        },
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: MouseRegion(
                                            onEnter: (_) {
                                              setState(() {
                                                _hoveredSpotId = spot.spotId;
                                              });
                                            },
                                            onExit: (_) {
                                              setState(() {
                                                _hoveredSpotId = null;
                                              });
                                            },
                                            child: Text(
                                              spot.name,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: linkColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        usage.toString(),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: shadColors.foreground,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        '${spot.altitude}m',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: shadColors.foreground,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          color: shadColors.border,
                          height: 1,
                          thickness: 1,
                        ),
                      ],
                    );
                  }),
                ],
              );
            },
          ),
      ],
    );
  }
}
