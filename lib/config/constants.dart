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

// Map tile layer options for better performance
final mapTileOptions = TileLayer(
  maxZoom: 17,
  minZoom: 0,
  tileSize: 256,
  keepBuffer: 2,
);
