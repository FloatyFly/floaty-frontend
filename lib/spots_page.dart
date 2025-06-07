import 'package:flutter/material.dart';
import 'package:floaty/ui_components.dart';
import 'package:floaty/model.dart';
import 'package:floaty/constants.dart';
import 'package:floaty/spots_service.dart';
import 'package:floaty_client/api.dart' as api;
import 'package:provider/provider.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'CookieAuth.dart';

class SpotsPage extends StatefulWidget {
  final FloatyUser? user;

  const SpotsPage({required this.user});

  @override
  _SpotsPageState createState() => _SpotsPageState();
}

class _SpotsPageState extends State<SpotsPage> {
  late Future<List<api.Spot>> futureSpots;

  @override
  void initState() {
    super.initState();
    futureSpots = _fetchSpots();
  }

  CookieAuth _getCookieAuth() {
    CookieJar cookieJar = Provider.of<CookieJar>(context, listen: false);
    return CookieAuth(cookieJar);
  }

  Future<List<api.Spot>> _fetchSpots() {
    return fetchSpots(widget.user!.id, _getCookieAuth());
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
                    padding: EdgeInsets.all(isMobile ? 8 : 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          isMobile
                              ? BorderRadius.zero
                              : BorderRadius.vertical(top: Radius.circular(6)),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton.icon(
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
                                icon: Icon(Icons.add),
                                label: Text('Add Spot'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF0078D7),
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: FutureBuilder<List<api.Spot>>(
                            future: futureSpots,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              if (snapshot.hasError) {
                                return Center(
                                  child: Text(
                                    'Error loading spots: ${snapshot.error}',
                                  ),
                                );
                              }

                              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return Center(
                                  child: Text(
                                    'No spots found. Add your first spot!',
                                    style: TextStyle(fontSize: 16),
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
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        if (spots.isEmpty)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'No ${isLaunch ? 'launch' : 'landing'} sites found',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: spots.length,
            separatorBuilder: (context, index) {
              return Divider(
                color: Colors.grey.withOpacity(0.3),
                height: 1,
                thickness: 1,
              );
            },
            itemBuilder: (context, index) {
              final spot = spots[index];
              return InkWell(
                onTap: () {
                  // TODO: Navigate to edit spot page
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          spot.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0078D7),
                          ),
                        ),
                      ),
                      SizedBox(width: 24),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Altitude',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            '${spot.altitude}m',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
