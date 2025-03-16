import 'package:cookie_jar/cookie_jar.dart';
import 'package:floaty/ui_components.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import 'CookieAuth.dart';
import 'flight_service.dart';
import 'main.dart';
import 'model.dart';

class StatsPage extends StatefulWidget {
  final FloatyUser? user;
  const StatsPage({required this.user});

  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  late Future<List<Flight>> futureFlights;
  late FloatyUser _currentUser;

  @override
  void initState() {
    super.initState();

    bool isDebug = true;
    if (isDebug) {
      _currentUser = FloatyUser(id: 1, name: "Floater", email: "floater@test.com", emailVerified: true);
      Provider.of<AppState>(context, listen: false).setUser(_currentUser);
    } else {
      _currentUser = Provider.of<AppState>(context, listen: false).currentUser!;
    }

    futureFlights = _fetchFlights();
  }

  CookieAuth _getCookieAuth() {
    CookieJar cookieJar = Provider.of<CookieJar>(context, listen: false);
    return CookieAuth(cookieJar);
  }

  Future<List<Flight>> _fetchFlights() {
    return fetchFlights(_currentUser.id, _getCookieAuth());
  }

  @override
  Widget build(BuildContext context) {
    double containerWidth = MediaQuery.of(context).size.width * 2 / 3 - 10;

    return Scaffold(
      body: Stack(
        children: [
          const FloatyBackgroundWidget(),
          Column(
            children: [
              Header(),
              SizedBox(height: 20),
              Expanded(
                child: FutureBuilder<List<Flight>>(
                  future: futureFlights,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      List<Flight> flights = snapshot.data ?? [];
                      int totalFlights = flights.length;
                      double totalAirtime = flights.fold(0, (prev, flight) => prev + (flight.duration / 60));

                      List<Flight> topFlights = List.from(flights)..sort((a, b) => b.duration.compareTo(a.duration));
                      topFlights = topFlights.take(5).toList();

                      return Center(
                        child: Container(
                          width: containerWidth,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(top: Radius.circular(6)),
                            boxShadow: [
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
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildStatBox('Total Flights', '$totalFlights', containerWidth / 2 - 30),
                                    SizedBox(width: 20),
                                    _buildStatBox('Total Airtime', '${totalAirtime.toStringAsFixed(2)} hours', containerWidth / 2 - 30),
                                  ],
                                ),
                                SizedBox(height: 20),
                                _buildTopFlightsList(topFlights, containerWidth),
                                SizedBox(height: 20),
                                _buildFlightTrendChart(flights, containerWidth),
                                SizedBox(height: 20),
                                _buildMonthlyDistributionChart(flights, containerWidth),
                                SizedBox(height: 20),
                                _buildYearlySummaryBox(flights, containerWidth), // Add this line
                                SizedBox(height: 20),
                              ],
                            )
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
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

  Map<String, int> flightsPerMonth = {};
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
    spots.add(FlSpot(i.toDouble(), cumulativeCount.toDouble())); // Vertical line
  }

  return Container(
    width: width,
    height: 250,
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.8),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.blueGrey, width: 1),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Flight evolution', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Expanded(
          child: LineChart(
            LineChartData(
              minY: 0, // Start y-axis at 0
              gridData: FlGridData(show: true, drawVerticalLine: true),
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
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                ),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() < sortedMonths.length) {
                        String monthYear = sortedMonths[value.toInt()];
                        List<String> parts = monthYear.split('-');
                        String formattedDate = "${_getMonthName(int.parse(parts[1]))} ${parts[0]}";

                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Transform.rotate(
                            angle: -0.5, // Less rotation for better readability
                            alignment: Alignment.topRight,
                            child: Text(
                              formattedDate,
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      }
                      return Container();
                    },
                    interval: 1,
                    reservedSize: 40, // More space for x-axis labels
                  ),
                ),
              ),
              borderData: FlBorderData(show: true),
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
              lineTouchData: LineTouchData(enabled: true),
            ),
          ),
        ),
      ],
    ),
  );
}

String _getMonthName(int month) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  return months[month - 1];
}

Widget _buildStatBox(String title, String value, double width) {
  return Container(
    width: width,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.8),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.blueGrey, width: 1),
    ),
    child: Column(
      children: [
        Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Text(value, style: TextStyle(fontSize: 16)),
      ],
    ),
  );
}

Widget _buildTopFlightsList(List<Flight> flights, double width) {
  return Container(
    width: width,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.8),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.blueGrey, width: 1),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Top 5 Longest Flights', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        ...flights.map((flight) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            children: [
              SizedBox(
                width: 90, // Increased width for date column
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${flights.indexOf(flight) + 1}',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                    Text(
                      flight.dateTime.substring(0, 10).split("-").reversed.join("."),
                      style: TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.visible, // Ensure date doesn't wrap
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                flex: 5,
                child: Text(
                  flight.takeOff,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey[900]),
                ),
              ),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.access_time, size: 15, color: Colors.black54),
                      SizedBox(width: 4),
                      Text(
                        "${flight.duration ~/ 60}:${(flight.duration % 60).toString().padLeft(2, '0')}",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )),
      ],
    ),
  );
}

Widget _buildMonthlyDistributionChart(List<Flight> flights, double width) {
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
    flightsByMonthAndYear[month]![year] = (flightsByMonthAndYear[month]![year] ?? 0) + 1;
    totalsByMonth[month] = (totalsByMonth[month] ?? 0) + 1;
  }

  // Sort years for consistent color assignment
  List<int> sortedYears = years.toList()..sort();

  // Generate colors for each year
  Map<int, Color> yearColors = {};
  List<Color> colorPalette = [
    Colors.orange,
    Colors.teal,
    Colors.lightGreen,
    Colors.lightBlueAccent,
    Colors.deepOrangeAccent,
    Colors.teal,
    Colors.pink,
    Colors.amber,
    Colors.cyan,
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
      border: Border.all(color: Colors.blueGrey, width: 1),

    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Monthly Distribution', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 5),

        // Legend
        Container(
          height: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: sortedYears.map((year) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      color: yearColors[year],
                    ),
                    SizedBox(width: 4),
                    Text('$year', style: TextStyle(fontSize: 12)),
                  ],
                ),
              );
            }).toList(),
          ),
        ),

        SizedBox(height: 10),

        // Chart
        Expanded(
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: (totalsByMonth.values.isEmpty ? 0 : totalsByMonth.values.reduce((a, b) => a > b ? a : b) * 1.2),
              barTouchData: BarTouchData(enabled: true),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                      if (value >= 0 && value < 12) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            months[value.toInt()],
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        );
                      }
                      return Container();
                    },
                    reservedSize: 30,
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
                            style: TextStyle(fontSize: 10),
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                ),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              gridData: FlGridData(
                show: true,
                drawHorizontalLine: true,
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
                      BarChartRodStackItem(stackHeight, stackHeight + count, yearColors[year]!),
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
                      width: 20,
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

        // Labels with total counts
        Container(
          height: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(12, (monthIndex) {
              int month = monthIndex + 1;
              int total = totalsByMonth[month] ?? 0;
              return Text(
                total.toString(),
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              );
            }),
          ),
        ),
      ],
    ),
  );
}

Widget _buildYearlySummaryBox(List<Flight> flights, double width) {
  if (flights.isEmpty) {
    return Container(
      width: width,
      height: 100,
      alignment: Alignment.center,
      child: Text('No flight data available'),
    );
  }

  // Group flights by year
  Map<int, Map<String, dynamic>> yearStats = {};

  for (var flight in flights) {
    DateTime date = DateTime.parse(flight.dateTime);
    int year = date.year;

    if (!yearStats.containsKey(year)) {
      yearStats[year] = {
        'totalAirtime': 0.0,
        'flightCount': 0,
      };
    }

    yearStats[year]!['totalAirtime'] += flight.duration / 60; // Convert minutes to hours
    yearStats[year]!['flightCount'] += 1;
  }

  // Sort years in descending order (most recent first)
  List<int> sortedYears = yearStats.keys.toList()..sort((a, b) => b.compareTo(a));

  return Container(
    width: width,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.8),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.blueGrey, width: 1),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...sortedYears.map((year) {
          double totalHours = yearStats[year]!['totalAirtime'];
          int hours = totalHours.floor();
          int minutes = ((totalHours - hours) * 60).round();
          String airtimeFormatted = '$hours h ${minutes.toString().padLeft(2, '0')} min';

          int flightCount = yearStats[year]!['flightCount'];
          String flightCountFormatted = '$flightCount flight${flightCount != 1 ? 's' : ''}';

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              children: [
                // Year column
                SizedBox(
                  width: 60,
                  child: Text(
                    '$year',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                ),
                SizedBox(width: 10),
                // Total airtime column
                Expanded(
                  flex: 3,
                  child: Text(
                    airtimeFormatted,
                    style: TextStyle(fontSize: 16, color: Colors.blueGrey[900]),
                  ),
                ),
                // Number of flights column
                Expanded(
                  flex: 2,
                  child: Text(
                    flightCountFormatted,
                    style: TextStyle(fontSize: 16, color: Colors.blueGrey[900]),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    ),
  );
}