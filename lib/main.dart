import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';


import 'firebase_options.dart';
import 'flights_screen.dart';
import 'landing_page.dart';
import 'login_screen.dart';

void main() async {
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // This uses the generated options
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Floaty',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int _selectedIndex = 2;

  @override
  Widget build(BuildContext context) {

      Widget page;
      switch (_selectedIndex) {
        case 0:
          page = LandingPage();
          break;
        case 1:
          page = FlightsScreen();
          break;
        case 2:
          page = LoginPage();  // Profile
          break;
        case 3:
          page = LoginPage(); //
          break;
        default:
          throw UnimplementedError('no widget for $_selectedIndex');
      }

    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth < 600) {
            // Use BottomNavigationBar for smaller screens
            return Column(
              children: [
                Expanded(child: page), // Page based on the index
                BottomNavigationBar(
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(icon: Icon(Icons.home, size: 30.0), label: 'Home'),
                    BottomNavigationBarItem(icon: Icon(Icons.paragliding_sharp, size: 30.0), label: 'Flights'),
                    BottomNavigationBarItem(icon: Icon(Icons.person_sharp, size: 30.0), label: 'Profile'),
                  ],
                  currentIndex: _selectedIndex,
                  onTap: (index) => setState(() => _selectedIndex = index),
                ),
              ],
            );
          } else {
            // Use NavigationRail for larger screens
            return Row(
              children: [
                NavigationRail(
                  destinations: const <NavigationRailDestination>[
                    NavigationRailDestination(icon: Icon(Icons.home), label: Text('Home')),
                    NavigationRailDestination(icon: Icon(Icons.paragliding_sharp), label: Text('Flights')),
                    NavigationRailDestination(icon: Icon(Icons.person), label: Text('Profile')),
                  ],
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (index) => setState(() => _selectedIndex = index),
                ),
                Expanded(child: page), // Page based on the index
              ],
            );
          }
        },
      ),
    );
  }
}




