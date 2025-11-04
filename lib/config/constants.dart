import 'config.dart';
import 'package:flutter_map/flutter_map.dart';

var backendUrl = Config.backendUrl;

const HOME_ROUTE = '/home';
const LOGIN_ROUTE = '/login';
const REGISTER_ROUTE = '/register';
const FORGOT_PASSWORD_ROUTE = '/forgot-password';
const PROFILE_ROUTE = '/profile';
const FLIGHTS_ROUTE = '/flights';
const ADD_FLIGHT_ROUTE = '/add-flight';
const ADD_SPOT_ROUTE = '/add-spot';
const EDIT_SPOT_ROUTE = '/edit-spot';
const ADD_GLIDER_ROUTE = '/add-glider';
const EDIT_GLIDER_ROUTE = '/edit-glider';
const EMAIL_VERIFICATION_ROUTE = '/verify-email';
const STATS_ROUTE = '/stats';
const SPOTS_ROUTE = '/spots';
const GLIDERS_ROUTE = '/gliders';

// Map tile URL - using OpenTopoMap which shows terrain and is CORS-friendly
const mapTileUrl = 'https://tile.opentopomap.org/{z}/{x}/{y}.png';

// Fallback tile URLs for redundancy
const List<String> mapTileFallbacks = [
  'https://a.tile.opentopomap.org/{z}/{x}/{y}.png',
  'https://b.tile.opentopomap.org/{z}/{x}/{y}.png',
  'https://c.tile.opentopomap.org/{z}/{x}/{y}.png',
];

// Map tile configuration constants
const double mapMaxZoom = 17.0;
const double mapMinZoom = 0.0;
const double mapTileSize = 256.0;
const int mapKeepBuffer = 4; // Keeps tiles in memory for smooth panning
const int mapPanBuffer = 2; // Pre-loads tiles around viewport
const int mapMaxNativeZoom = 17; // OpenTopoMap max zoom level
const bool mapRetinaMode = false; // Disable retina to reduce tile requests
const Duration mapTileFadeDuration = Duration(milliseconds: 200);

// Reusable tile display configuration
final TileDisplay mapTileDisplay = TileDisplay.fadeIn(
  duration: mapTileFadeDuration,
);

// Reusable error callback for debugging
void mapErrorTileCallback(dynamic tile, Object error, StackTrace? stackTrace) {
  print('Map tile load error: $error');
}
