import 'package:cookie_jar/cookie_jar.dart';
import 'package:floaty/widgets/ui_components.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:floaty_client/api.dart' as api;
import '../services/flight_service.dart';
import '../services/spots_service.dart';
import '../services/gliders_service.dart';
import 'edit_flight_page.dart';
import '../config/CookieAuth.dart';
import '../main.dart';
import '../models/model.dart';
import '../config/constants.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';

class StatsPage extends StatefulWidget {
  final FloatyUser? user;
  const StatsPage({required this.user});

  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  late Future<List<Flight>> futureFlights;
  late Future<List<api.Spot>> futureSpots;
  late Future<List<api.Glider>> futureGliders;
  late FloatyUser _currentUser;
  late MapController _mapController;
  bool _useCancellableProvider = true;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _currentUser = Provider.of<AppState>(context, listen: false).currentUser!;
    futureFlights = _fetchFlights();
    futureSpots = _fetchSpots();
    futureGliders = _fetchGliders();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  CookieAuth _getCookieAuth() {
    CookieJar cookieJar = Provider.of<CookieJar>(context, listen: false);
    return CookieAuth(cookieJar);
  }

  Future<List<Flight>> _fetchFlights() {
    return fetchFlights(_currentUser.id, _getCookieAuth());
  }

  Future<List<api.Spot>> _fetchSpots() {
    return fetchSpots(_currentUser.id, _getCookieAuth());
  }

  Future<List<api.Glider>> _fetchGliders() {
    return fetchGliders(_getCookieAuth());
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
                              : BorderRadius.vertical(top: Radius.circular(6)),
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
                    child: _buildContent(isMobile, containerWidth),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContent(bool isMobile, double containerWidth) {
    return FutureBuilder<List<Flight>>(
      future: futureFlights,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<Flight> flights = snapshot.data ?? [];
          int totalFlights = flights.length;
          double totalAirtime = flights.fold(
            0,
            (prev, flight) => prev + (flight.duration / 60),
          );

          List<Flight> topFlights = List.from(flights)
            ..sort((a, b) => b.duration.compareTo(a.duration));
          topFlights = topFlights.take(5).toList();

          return SingleChildScrollView(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStatBox(
                        'Total Flights',
                        '$totalFlights',
                        isMobile
                            ? (containerWidth / 2 - 16)
                            : (containerWidth / 2 - 48),
                      ),
                      SizedBox(width: isMobile ? 8 : 24),
                      _buildStatBox(
                        'Total Airtime',
                        '${totalAirtime.toStringAsFixed(0)} hours',
                        isMobile
                            ? (containerWidth / 2 - 16)
                            : (containerWidth / 2 - 48),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                if (flights.isEmpty)
                  Center(
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
                            Icons.lightbulb,
                            size: 24,
                            color: Color(0xFF0078D7),
                          ),
                          SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              "Add flights to get statistical analysis",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else ...[
                  _buildFlightTrendChart(flights, containerWidth),
                  SizedBox(height: 20),
                  _buildAirtimeEvolutionChart(flights, containerWidth),
                  SizedBox(height: 20),
                  _buildMonthlyFlightsChart(flights, containerWidth),
                  SizedBox(height: 20),
                  _buildMonthlyAirtimeChart(flights, containerWidth),
                  SizedBox(height: 20),
                  _buildYearlySummaryBox(flights, containerWidth, isMobile),
                  SizedBox(height: 24),
                  // Map Widget
                  Container(
                    height: 400, // Double the height of the add spots map
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: FutureBuilder<List<api.Spot>>(
                        future: futureSpots,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          }

                          final spots = snapshot.data!;

                          // Calculate spot usage statistics
                          Map<int, int> spotUsage = {};
                          for (final flight in flights) {
                            spotUsage[flight.launchSpotId] =
                                (spotUsage[flight.launchSpotId] ?? 0) + 1;
                            spotUsage[flight.landingSpotId] =
                                (spotUsage[flight.landingSpotId] ?? 0) + 1;
                          }

                          // Find max usage across all spots
                          final maxUsage = spotUsage.values.fold(
                            0,
                            (max, usage) => usage > max ? usage : max,
                          );
                          const minUsage =
                              1; // Minimum size for spots with one usage

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

                          // Calculate bounds to fit all spots
                          LatLngBounds? bounds;
                          if (spots.isNotEmpty) {
                            bounds = LatLngBounds.fromPoints(
                              spots
                                  .map(
                                    (spot) =>
                                        LatLng(spot.latitude, spot.longitude),
                                  )
                                  .toList(),
                            );
                          }

                          return FlutterMap(
                            mapController: _mapController,
                            options: MapOptions(
                              initialCenter: LatLng(
                                46.8182,
                                8.2275,
                              ), // Switzerland center
                              initialZoom: 8,
                              onMapReady: () {
                                if (bounds != null) {
                                  _mapController.fitBounds(
                                    bounds,
                                    options: const FitBoundsOptions(
                                      padding: EdgeInsets.all(50),
                                    ),
                                  );
                                }
                              },
                              interactionOptions: const InteractionOptions(
                                enableScrollWheel: true,
                                enableMultiFingerGestureRace: false,
                                flags:
                                    InteractiveFlag.all &
                                    ~InteractiveFlag.rotate,
                              ),
                            ),
                            children: [
                              TileLayer(
                                urlTemplate: mapTileUrl,
                                maxZoom: mapTileOptions.maxZoom,
                                minZoom: mapTileOptions.minZoom,
                                tileSize: mapTileOptions.tileSize,
                                keepBuffer: mapTileOptions.keepBuffer,
                                tileProvider:
                                    _useCancellableProvider
                                        ? CancellableNetworkTileProvider()
                                        : null,
                              ),
                              MarkerLayer(
                                markers: [
                                  ...launchSpots.map((spot) {
                                    final usage = spotUsage[spot.spotId] ?? 0;
                                    final size =
                                        20 +
                                        (usage - minUsage) *
                                            (40.0 / (maxUsage - minUsage));
                                    return Marker(
                                      point: LatLng(
                                        spot.latitude,
                                        spot.longitude,
                                      ),
                                      width: size,
                                      height: size,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.green.withOpacity(0.3),
                                          border: Border.all(
                                            color: Colors.green,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                  ...landingSpots.map((spot) {
                                    final usage = spotUsage[spot.spotId] ?? 0;
                                    final size =
                                        20 +
                                        (usage - minUsage) *
                                            (40.0 / (maxUsage - minUsage));
                                    return Marker(
                                      point: LatLng(
                                        spot.latitude,
                                        spot.longitude,
                                      ),
                                      width: size,
                                      height: size,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.red.withOpacity(0.3),
                                          border: Border.all(
                                            color: Colors.red,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  _buildTopFlightsList(topFlights, containerWidth, isMobile),
                  SizedBox(height: 20),
                ],
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildTopFlightsList(
    List<Flight> flights,
    double width,
    bool isMobile,
  ) {
    return FutureBuilder<List<api.Spot>>(
      future: futureSpots,
      builder: (context, spotsSnapshot) {
        if (!spotsSnapshot.hasData) {
          return Container(
            width: width,
            padding: EdgeInsets.all(isMobile ? 8 : 20),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        return FutureBuilder<List<api.Glider>>(
          future: futureGliders,
          builder: (context, glidersSnapshot) {
            if (!glidersSnapshot.hasData) {
              return Container(
                width: width,
                padding: EdgeInsets.all(isMobile ? 8 : 20),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final spots = spotsSnapshot.data!;
            final gliders = glidersSnapshot.data!;

            String getSpotName(int spotId) {
              final spot = spots.firstWhere(
                (spot) => spot.spotId == spotId,
                orElse:
                    () => api.Spot(
                      spotId: spotId,
                      name: 'Unknown Spot',
                      type: api.SpotTypeEnum.LAUNCH_SITE,
                      latitude: 0,
                      longitude: 0,
                      altitude: 0,
                    ),
              );
              return spot.name;
            }

            String getGliderName(int gliderId) {
              final glider = gliders.firstWhere(
                (glider) => glider.id == gliderId,
                orElse:
                    () => api.Glider(
                      id: gliderId,
                      manufacturer: 'Unknown',
                      model: 'Unknown',
                    ),
              );
              return '${glider.manufacturer} ${glider.model}';
            }

            return Container(
              width: width,
              padding: EdgeInsets.all(isMobile ? 8 : 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Top 5 Longest Flights',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: flights.length,
                    separatorBuilder: (context, index) {
                      return Divider(
                        color: Colors.grey.withOpacity(0.3),
                        height: 1,
                        thickness: 1,
                      );
                    },
                    itemBuilder: (context, index) {
                      final flight = flights[index];
                      final flightNumber = "${index + 1}";

                      return GestureDetector(
                        onTap: () => _navigateToEditFlight(context, flight),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: isMobile ? 8 : 16,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Flight number + date
                              SizedBox(
                                width: 90,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      flightNumber,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Text(
                                      DateFormat(
                                        'dd.MM.yyyy',
                                      ).format(DateTime.parse(flight.dateTime)),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Title and description
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 24.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${getSpotName(flight.launchSpotId)} - ${getSpotName(flight.landingSpotId)}",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF0078D7),
                                        ),
                                      ),
                                      if (flight.description.isNotEmpty) ...[
                                        SizedBox(height: 4),
                                        Text(
                                          flight.description,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                              // Glider name and duration
                              SizedBox(
                                width: 120,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      getGliderName(flight.gliderId),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.access_time,
                                          size: 15,
                                          color: Colors.black54,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          "${flight.duration ~/ 60}:${(flight.duration % 60).toString().padLeft(2, '0')}",
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
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _navigateToEditFlight(BuildContext context, Flight flight) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditFlightPage(flight: flight)),
    );

    if (result == true) {
      setState(() {
        futureFlights = _fetchFlights();
      });
    }
  }
}

Widget _buildFlightTrendChart(List<Flight> flights, double width) {
  if (flights.isEmpty) {
    return Container(
      width: width,
      height: 200,
      alignment: Alignment.center,
      child: Text('No flight data available'),
    );
  }

  // Create a map for all months between the first and last flight
  DateTime firstFlightDate = DateTime.parse(
    flights.map((f) => f.dateTime).reduce((a, b) => a.compareTo(b) < 0 ? a : b),
  );
  DateTime lastFlightDate = DateTime.parse(
    flights.map((f) => f.dateTime).reduce((a, b) => a.compareTo(b) > 0 ? a : b),
  );

  Map<String, int> flightsPerMonth = {};

  // Initialize all months with zero flights
  DateTime current = DateTime(firstFlightDate.year, firstFlightDate.month, 1);
  while (current.isBefore(
    DateTime(lastFlightDate.year, lastFlightDate.month + 1, 1),
  )) {
    String monthKey =
        "${current.year}-${current.month.toString().padLeft(2, '0')}";
    flightsPerMonth[monthKey] = 0;
    current = DateTime(
      current.year + (current.month == 12 ? 1 : 0),
      current.month == 12 ? 1 : current.month + 1,
      1,
    );
  }

  // Fill in actual flight counts
  for (var flight in flights) {
    DateTime date = DateTime.parse(flight.dateTime);
    String monthKey = "${date.year}-${date.month.toString().padLeft(2, '0')}";
    flightsPerMonth[monthKey] = (flightsPerMonth[monthKey] ?? 0) + 1;
  }

  List<String> sortedMonths = flightsPerMonth.keys.toList()..sort();
  List<FlSpot> spots = [];
  int cumulativeCount = 0;

  for (int i = 0; i < sortedMonths.length; i++) {
    cumulativeCount += flightsPerMonth[sortedMonths[i]]!;
    // Add two spots for each month to create step function effect
    if (i > 0) {
      spots.add(FlSpot(i.toDouble(), spots.last.y)); // Horizontal line
    }
    spots.add(
      FlSpot(i.toDouble(), cumulativeCount.toDouble()),
    ); // Vertical line
  }

  // Calculate label interval based on time range
  int totalMonths = sortedMonths.length;
  int labelInterval = 1;
  if (totalMonths > 96) {
    labelInterval = 12; // Show yearly labels
  } else if (totalMonths > 48) {
    labelInterval = 6; // Show labels every 6 months
  } else if (totalMonths > 24) {
    labelInterval = 3; // Show labels every 3 months
  }

  return Container(
    width: width,
    height: 250,
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.8),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey, width: 1),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Flights',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Expanded(
          child: LineChart(
            LineChartData(
              minY: 0, // Start y-axis at 0
              gridData: FlGridData(
                show: false,
                drawHorizontalLine: false,
                drawVerticalLine: false,
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    interval: (cumulativeCount > 4) ? cumulativeCount / 4 : 1,
                    getTitlesWidget: (value, meta) {
                      if (value == 0 || value % 1 == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            value.toInt().toString(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 45, // Increased space for tilted labels
                    interval: labelInterval.toDouble(),
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index >= 0 &&
                          index < sortedMonths.length &&
                          index % labelInterval == 0) {
                        String monthYear = sortedMonths[index];
                        List<String> parts = monthYear.split('-');
                        String year = parts[0];
                        int month = int.parse(parts[1]);
                        String monthName = _getMonthName(month);
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Transform.rotate(
                            angle:
                                -34 *
                                3.14159 /
                                180, // -34 degrees in radians (upward tilt)
                            alignment: Alignment.center,
                            child: Text(
                              '$monthName $year',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: false,
                  barWidth: 3,
                  isStepLineChart: true, // Use step line chart
                  belowBarData: BarAreaData(
                    show: true,
                    color: Colors.blue.withOpacity(0.3),
                    applyCutOffY: true,
                    cutOffY: 0,
                  ),
                  color: Colors.blue,
                  dotData: FlDotData(show: false),
                ),
              ],
              lineTouchData: LineTouchData(
                enabled: true,
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (List<LineBarSpot> touchedSpots) {
                    if (touchedSpots.isNotEmpty) {
                      final int index = touchedSpots.first.x.toInt();
                      if (index < sortedMonths.length) {
                        String monthYear = sortedMonths[index];
                        List<String> parts = monthYear.split('-');
                        String year = parts[0];
                        int month = int.parse(parts[1]);
                        String monthName = _getMonthName(month);
                        int flightsThisMonth = flightsPerMonth[monthYear] ?? 0;
                        return [
                          LineTooltipItem(
                            "$monthName $year: $cumulativeCount total, $flightsThisMonth this month",
                            TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ];
                      }
                    }
                    return [];
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildAirtimeEvolutionChart(List<Flight> flights, double width) {
  if (flights.isEmpty) {
    return Container(
      width: width,
      height: 200,
      alignment: Alignment.center,
      child: Text('No flight data available'),
    );
  }

  // Create a map for all months between the first and last flight
  DateTime firstFlightDate = DateTime.parse(
    flights.map((f) => f.dateTime).reduce((a, b) => a.compareTo(b) < 0 ? a : b),
  );
  DateTime lastFlightDate = DateTime.parse(
    flights.map((f) => f.dateTime).reduce((a, b) => a.compareTo(b) > 0 ? a : b),
  );

  Map<String, double> airtimePerMonth = {};

  // Initialize all months with zero airtime
  DateTime current = DateTime(firstFlightDate.year, firstFlightDate.month, 1);
  while (current.isBefore(
    DateTime(lastFlightDate.year, lastFlightDate.month + 1, 1),
  )) {
    String monthKey =
        "${current.year}-${current.month.toString().padLeft(2, '0')}";
    airtimePerMonth[monthKey] = 0;
    current = DateTime(
      current.year + (current.month == 12 ? 1 : 0),
      current.month == 12 ? 1 : current.month + 1,
      1,
    );
  }

  // Fill in actual airtime
  for (var flight in flights) {
    DateTime date = DateTime.parse(flight.dateTime);
    String monthKey = "${date.year}-${date.month.toString().padLeft(2, '0')}";
    // Add flight duration in hours
    airtimePerMonth[monthKey] =
        (airtimePerMonth[monthKey] ?? 0) + (flight.duration / 60);
  }

  List<String> sortedDates = airtimePerMonth.keys.toList()..sort();
  List<FlSpot> spots = [];
  double cumulativeAirtime = 0;

  for (int i = 0; i < sortedDates.length; i++) {
    cumulativeAirtime += airtimePerMonth[sortedDates[i]]!;
    // Add two spots for each month to create step function effect
    if (i > 0) {
      spots.add(FlSpot(i.toDouble(), spots.last.y)); // Horizontal line
    }
    spots.add(FlSpot(i.toDouble(), cumulativeAirtime)); // Vertical line
  }

  // Calculate label interval based on time range
  int totalMonths = sortedDates.length;
  int labelInterval = 1;
  if (totalMonths > 96) {
    labelInterval = 12; // Show yearly labels
  } else if (totalMonths > 48) {
    labelInterval = 6; // Show labels every 6 months
  } else if (totalMonths > 24) {
    labelInterval = 3; // Show labels every 3 months
  }

  return Container(
    width: width,
    height: 250,
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.8),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey, width: 1),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Airtime',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Expanded(
          child: LineChart(
            LineChartData(
              minY: 0, // Start y-axis at 0
              gridData: FlGridData(
                show: false,
                drawHorizontalLine: false,
                drawVerticalLine: false,
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    interval:
                        (cumulativeAirtime > 4) ? cumulativeAirtime / 4 : 1,
                    getTitlesWidget: (value, meta) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          '${value.toInt()} h',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 45, // Increased space for tilted labels
                    interval: labelInterval.toDouble(),
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index >= 0 &&
                          index < sortedDates.length &&
                          index % labelInterval == 0) {
                        String monthYear = sortedDates[index];
                        List<String> parts = monthYear.split('-');
                        String year = parts[0];
                        int month = int.parse(parts[1]);
                        String monthName = _getMonthName(month);
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Transform.rotate(
                            angle:
                                -34 *
                                3.14159 /
                                180, // -34 degrees in radians (upward tilt)
                            alignment: Alignment.center,
                            child: Text(
                              '$monthName $year',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: false,
                  barWidth: 3,
                  isStepLineChart: true, // Use step line chart
                  belowBarData: BarAreaData(
                    show: true,
                    color: Colors.orange.withOpacity(0.3),
                    applyCutOffY: true,
                    cutOffY: 0,
                  ),
                  color: Colors.orange,
                  dotData: FlDotData(show: false),
                ),
              ],
              lineTouchData: LineTouchData(
                enabled: true,
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (List<LineBarSpot> touchedSpots) {
                    if (touchedSpots.isNotEmpty) {
                      final int index = touchedSpots.first.x.toInt();
                      if (index < sortedDates.length) {
                        String monthYear = sortedDates[index];
                        List<String> parts = monthYear.split('-');
                        String year = parts[0];
                        int month = int.parse(parts[1]);
                        String monthName = _getMonthName(month);
                        double airtimeThisMonth =
                            airtimePerMonth[monthYear] ?? 0;
                        return [
                          LineTooltipItem(
                            "$monthName $year: ${cumulativeAirtime.toStringAsFixed(1)} hours total, ${airtimeThisMonth.toStringAsFixed(1)} this month",
                            TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ];
                      }
                    }
                    return [];
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

String _getMonthName(int month) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return months[month - 1];
}

Widget _buildStatBox(String title, String value, double width) {
  return Container(
    width: width,
    padding: EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey, width: 1),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 1,
          blurRadius: 2,
          offset: Offset(0, 1),
        ),
      ],
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Text(
          value,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

Widget _buildMonthlyFlightsChart(List<Flight> flights, double width) {
  if (flights.isEmpty) {
    return Container(
      width: width,
      height: 200,
      alignment: Alignment.center,
      child: Text('No flight data available'),
    );
  }

  // Group flights by month and year
  Map<int, Map<int, int>> flightsByMonthAndYear = {};
  Map<int, int> totalsByMonth = {};
  Set<int> years = {};

  // Initialize maps for all months
  for (int month = 1; month <= 12; month++) {
    flightsByMonthAndYear[month] = {};
    totalsByMonth[month] = 0;
  }

  // Populate the data
  for (var flight in flights) {
    DateTime date = DateTime.parse(flight.dateTime);
    int month = date.month;
    int year = date.year;

    years.add(year);
    flightsByMonthAndYear[month]![year] =
        (flightsByMonthAndYear[month]![year] ?? 0) + 1;
    totalsByMonth[month] = (totalsByMonth[month] ?? 0) + 1;
  }

  // Sort years for consistent color assignment
  List<int> sortedYears = years.toList()..sort();

  // Modern color palette with orange touch
  Map<int, Color> yearColors = {};
  List<Color> colorPalette = [
    Color(0xFFFF7E50), // Coral orange
    Color(0xFF57A0D3), // Steel blue
    Color(0xFF7EB77F), // Sage green
    Color(0xFFFDB147), // Amber
    Color(0xFFDA70D6), // Orchid
    Color(0xFF20B2AA), // Light sea green
    Color(0xFFE9967A), // Dark salmon
    Color(0xFF9370DB), // Medium purple
    Color(0xFF3CB371), // Medium sea green
  ];

  for (int i = 0; i < sortedYears.length; i++) {
    yearColors[sortedYears[i]] = colorPalette[i % colorPalette.length];
  }

  return Container(
    width: width,
    height: 300,
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.8),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey, width: 1),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Monthly Flights',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),

        // Legend
        SizedBox(
          height: 30,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  sortedYears.map((year) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: yearColors[year],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(
                            '$year',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
            ),
          ),
        ),

        SizedBox(height: 5),

        // Chart with total counts
        Expanded(
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY:
                  (totalsByMonth.values.isEmpty
                      ? 0
                      : totalsByMonth.values.reduce((a, b) => a > b ? a : b) *
                          1.2),
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    int month = groupIndex + 1;
                    int total = totalsByMonth[month] ?? 0;
                    return BarTooltipItem(
                      'Total: $total',
                      TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value >= 0 && value < 12) {
                        int month = value.toInt() + 1;
                        String monthName = _getMonthName(month);

                        // Always show all months with no tilt
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            monthName,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }
                      return Container();
                    },
                    reservedSize: 32, // Reduced space since no tilting
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      if (value % 1 == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            value.toInt().toString(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }
                      return Container();
                    },
                    interval:
                        totalsByMonth.values.isEmpty
                            ? 1
                            : ((totalsByMonth.values.reduce(
                                          (a, b) => a > b ? a : b,
                                        ) /
                                        2)
                                    .ceil())
                                .toDouble(),
                  ),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: FlGridData(
                show: false,
                drawHorizontalLine: false,
                drawVerticalLine: false,
              ),
              borderData: FlBorderData(show: false),
              barGroups: List.generate(12, (monthIndex) {
                int month = monthIndex + 1;
                List<BarChartRodStackItem> rodStackItems = [];
                double stackHeight = 0;

                for (var year in sortedYears) {
                  int count = flightsByMonthAndYear[month]![year] ?? 0;
                  if (count > 0) {
                    rodStackItems.add(
                      BarChartRodStackItem(
                        stackHeight,
                        stackHeight + count,
                        yearColors[year]!,
                      ),
                    );
                    stackHeight += count;
                  }
                }

                return BarChartGroupData(
                  x: monthIndex,
                  barRods: [
                    BarChartRodData(
                      toY: stackHeight,
                      rodStackItems: rodStackItems,
                      width: 15,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(4),
                      ),
                    ),
                  ],
                  showingTooltipIndicators: [],
                );
              }),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildMonthlyAirtimeChart(List<Flight> flights, double width) {
  if (flights.isEmpty) {
    return Container(
      width: width,
      height: 200,
      alignment: Alignment.center,
      child: Text('No flight data available'),
    );
  }

  // Group airtime by month and year
  Map<int, Map<int, double>> airtimeByMonthAndYear = {};
  Map<int, double> totalsByMonth = {};
  Set<int> years = {};

  // Initialize maps for all months
  for (int month = 1; month <= 12; month++) {
    airtimeByMonthAndYear[month] = {};
    totalsByMonth[month] = 0;
  }

  // Populate the data - tracking airtime duration instead of flight count
  for (var flight in flights) {
    DateTime date = DateTime.parse(flight.dateTime);
    int month = date.month;
    int year = date.year;
    double flightDuration = flight.duration / 60; // Convert to hours

    years.add(year);
    airtimeByMonthAndYear[month]![year] =
        (airtimeByMonthAndYear[month]![year] ?? 0) + flightDuration;
    totalsByMonth[month] = (totalsByMonth[month] ?? 0) + flightDuration;
  }

  // Sort years for consistent color assignment
  List<int> sortedYears = years.toList()..sort();

  // Modern color palette with orange touch
  Map<int, Color> yearColors = {};
  List<Color> colorPalette = [
    Color(0xFFFF7E50), // Coral orange
    Color(0xFF57A0D3), // Steel blue
    Color(0xFF7EB77F), // Sage green
    Color(0xFFFDB147), // Amber
    Color(0xFFDA70D6), // Orchid
    Color(0xFF20B2AA), // Light sea green
    Color(0xFFE9967A), // Dark salmon
    Color(0xFF9370DB), // Medium purple
    Color(0xFF3CB371), // Medium sea green
  ];

  for (int i = 0; i < sortedYears.length; i++) {
    yearColors[sortedYears[i]] = colorPalette[i % colorPalette.length];
  }

  return Container(
    width: width,
    height: 300,
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.8),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey, width: 1),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Monthly Airtime',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),

        // Legend
        SizedBox(
          height: 30,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  sortedYears.map((year) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: yearColors[year],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(
                            '$year',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
            ),
          ),
        ),

        SizedBox(height: 5),

        // Chart with total airtime
        Expanded(
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY:
                  (totalsByMonth.values.isEmpty
                      ? 0
                      : totalsByMonth.values.reduce((a, b) => a > b ? a : b) *
                          1.2),
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    int month = groupIndex + 1;
                    double total = totalsByMonth[month] ?? 0;
                    return BarTooltipItem(
                      'Total: ${total.toStringAsFixed(1)} h',
                      TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value >= 0 && value < 12) {
                        int month = value.toInt() + 1;
                        String monthName = _getMonthName(month);

                        // Always show all months with no tilt
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            monthName,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }
                      return Container();
                    },
                    reservedSize: 32, // Reduced space since no tilting
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 50,
                    getTitlesWidget: (value, meta) {
                      // Show hours on y-axis, round to nearest whole number
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          '${value.toInt()} h',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                    interval:
                        totalsByMonth.values.isEmpty
                            ? 1
                            : ((totalsByMonth.values.reduce(
                                          (a, b) => a > b ? a : b,
                                        ) /
                                        2)
                                    .ceil())
                                .toDouble(),
                  ),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: FlGridData(
                show: false,
                drawHorizontalLine: false,
                drawVerticalLine: false,
              ),
              borderData: FlBorderData(show: false),
              barGroups: List.generate(12, (monthIndex) {
                int month = monthIndex + 1;
                List<BarChartRodStackItem> rodStackItems = [];
                double stackHeight = 0;

                for (var year in sortedYears) {
                  double duration = airtimeByMonthAndYear[month]![year] ?? 0;
                  if (duration > 0) {
                    rodStackItems.add(
                      BarChartRodStackItem(
                        stackHeight,
                        stackHeight + duration,
                        yearColors[year]!,
                      ),
                    );
                    stackHeight += duration;
                  }
                }

                return BarChartGroupData(
                  x: monthIndex,
                  barRods: [
                    BarChartRodData(
                      toY: stackHeight,
                      rodStackItems: rodStackItems,
                      width: 15,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(4),
                      ),
                    ),
                  ],
                  showingTooltipIndicators: [],
                );
              }),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildYearlySummaryBox(
  List<Flight> flights,
  double width,
  bool isMobile,
) {
  if (flights.isEmpty) {
    return Container(
      width: width,
      height: 200,
      alignment: Alignment.center,
      child: Text('No flight data available'),
    );
  }

  // Organize flights by year
  Map<String, List<Flight>> flightsByYear = {};
  for (var flight in flights) {
    String year = DateTime.parse(flight.dateTime).year.toString();
    flightsByYear.putIfAbsent(year, () => []).add(flight);
  }

  // Get yearly statistics
  List<Map<String, dynamic>> yearlyStats = [];
  for (var year in flightsByYear.keys) {
    var yearFlights = flightsByYear[year]!;
    double totalAirtime = yearFlights.fold(
      0,
      (prev, flight) => prev + (flight.duration / 60),
    );

    yearlyStats.add({
      'year': year,
      'flightCount': yearFlights.length,
      'airtime': totalAirtime,
    });
  }

  // Sort by year (newest first)
  yearlyStats.sort((a, b) => b['year'].compareTo(a['year']));

  return Container(
    width: width,
    padding: EdgeInsets.all(isMobile ? 8 : 20),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.8),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey, width: 1),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Yearly Summary',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        // Table rows
        ...yearlyStats.map((stats) {
          return Padding(
            padding: EdgeInsets.symmetric(
              vertical: 8,
              horizontal: isMobile ? 8 : 40,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: isMobile ? 60 : 130,
                  child: Text(
                    stats['year'],
                    style: TextStyle(
                      fontSize: isMobile ? 12 : 14,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: isMobile ? 4 : 10),
                Expanded(
                  flex: 4,
                  child: Text(
                    '${stats['flightCount']} flights',
                    style: TextStyle(
                      fontSize: isMobile ? 14 : 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey[900],
                    ),
                  ),
                ),
                SizedBox(width: isMobile ? 4 : 10),
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.access_time,
                        size: isMobile ? 12 : 15,
                        color: Colors.black54,
                      ),
                      SizedBox(width: 2),
                      Text(
                        '${stats['airtime'].toStringAsFixed(1)} h',
                        style: TextStyle(
                          fontSize: isMobile ? 12 : 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    ),
  );
}
