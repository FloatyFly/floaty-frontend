//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

library openapi.api;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:http/browser_client.dart';

part 'api_client.dart';
part 'api_helper.dart';
part 'api_exception.dart';
part 'auth/authentication.dart';
part 'auth/api_key_auth.dart';
part 'auth/oauth.dart';
part 'auth/http_basic_auth.dart';
part 'auth/http_bearer_auth.dart';

part 'api/auth_api.dart';
part 'api/flights_api.dart';
part 'api/gliders_api.dart';
part 'api/spots_api.dart';
part 'api/users_api.dart';

part 'model/auth_verify_email_email_verification_token_post400_response.dart';
part 'model/auth_verify_email_email_verification_token_post404_response.dart';
part 'model/bounding_box.dart';
part 'model/bounding_box_north_east.dart';
part 'model/bounding_box_south_west.dart';
part 'model/create_flight400_response.dart';
part 'model/create_flight404_response.dart';
part 'model/delete_glider_by_id409_response.dart';
part 'model/delete_spot_by_id409_response.dart';
part 'model/flight.dart';
part 'model/flight_create.dart';
part 'model/flight_track.dart';
part 'model/flight_update.dart';
part 'model/get_flight_igc404_response.dart';
part 'model/get_flight_track404_response.dart';
part 'model/get_glider_by_id404_response.dart';
part 'model/get_spot_by_id404_response.dart';
part 'model/glider.dart';
part 'model/glider_create.dart';
part 'model/glider_update.dart';
part 'model/igc_data.dart';
part 'model/igc_data_create.dart';
part 'model/igc_metadata.dart';
part 'model/login_request.dart';
part 'model/register_request.dart';
part 'model/reset_password_request.dart';
part 'model/spot.dart';
part 'model/spot_create.dart';
part 'model/spot_update.dart';
part 'model/track_point.dart';
part 'model/track_statistics.dart';
part 'model/update_flight_by_id400_response.dart';
part 'model/update_flight_by_id404_response.dart';
part 'model/user.dart';

/// An [ApiClient] instance that uses the default values obtained from
/// the OpenAPI specification file.
var defaultApiClient = ApiClient();

const _delimiters = {'csv': ',', 'ssv': ' ', 'tsv': '\t', 'pipes': '|'};
const _dateEpochMarker = 'epoch';
const _deepEquality = DeepCollectionEquality();
final _dateFormatter = DateFormat('yyyy-MM-dd');
final _regList = RegExp(r'^List<(.*)>$');
final _regSet = RegExp(r'^Set<(.*)>$');
final _regMap = RegExp(r'^Map<String,(.*)>$');

bool _isEpochMarker(String? pattern) =>
    pattern == _dateEpochMarker || pattern == '/$_dateEpochMarker/';
