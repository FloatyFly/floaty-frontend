import 'package:flutter/material.dart';
import 'package:floaty/pages/edit_spot_page.dart';
import 'package:floaty_client/api.dart' as api;
import 'package:floaty/config/constants.dart';
import 'package:floaty/pages/add_glider_page.dart';
import 'package:floaty/pages/edit_glider_page.dart';

// Custom page route with no transition animation for instant navigation
class NoAnimationPageRoute<T> extends MaterialPageRoute<T> {
  NoAnimationPageRoute({required WidgetBuilder builder})
      : super(builder: builder);

  @override
  Duration get transitionDuration => Duration.zero;

  @override
  Duration get reverseTransitionDuration => Duration.zero;
}

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case EDIT_SPOT_ROUTE:
        final spot = settings.arguments as api.Spot;
        return NoAnimationPageRoute(
          builder: (context) => EditSpotPage(spot: spot),
        );
      case ADD_GLIDER_ROUTE:
        return NoAnimationPageRoute(builder: (context) => AddGliderPage());
      case EDIT_GLIDER_ROUTE:
        final glider = settings.arguments as api.Glider;
        return NoAnimationPageRoute(
          builder: (context) => EditGliderPage(glider: glider),
        );
      default:
        return NoAnimationPageRoute(
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
