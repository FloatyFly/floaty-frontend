import 'package:flutter/material.dart';
import 'package:floaty/pages/edit_spot_page.dart';
import 'package:floaty_client/api.dart' as api;
import 'package:floaty/config/constants.dart';
import 'package:floaty/pages/add_glider_page.dart';
import 'package:floaty/pages/edit_glider_page.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case EDIT_SPOT_ROUTE:
        final spot = settings.arguments as api.Spot;
        return MaterialPageRoute(
          builder: (context) => EditSpotPage(spot: spot),
        );
      case ADD_GLIDER_ROUTE:
        return MaterialPageRoute(builder: (context) => AddGliderPage());
      case EDIT_GLIDER_ROUTE:
        final glider = settings.arguments as api.Glider;
        return MaterialPageRoute(
          builder: (context) => EditGliderPage(glider: glider),
        );
      default:
        return MaterialPageRoute(
          builder:
              (context) => Scaffold(
                body: Center(
                  child: Text('No route defined for ${settings.name}'),
                ),
              ),
        );
    }
  }
}
