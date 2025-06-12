//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class TrackPoint {
  /// Returns a new [TrackPoint] instance.
  TrackPoint({
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    required this.altitude,
    required this.speed,
    required this.verticalRate,
  });

  /// UTC timestamp of the track point
  DateTime timestamp;

  /// Latitude in decimal degrees (WGS84)
  double latitude;

  /// Longitude in decimal degrees (WGS84)
  double longitude;

  /// Altitude in meters above sea level (GPS altitude)
  int altitude;

  /// Ground speed in km/h (calculated from GPS coordinates)
  double speed;

  /// Vertical rate in m/s (positive = climbing, negative = sinking)
  double verticalRate;

  @override
  bool operator ==(Object other) => identical(this, other) || other is TrackPoint &&
    other.timestamp == timestamp &&
    other.latitude == latitude &&
    other.longitude == longitude &&
    other.altitude == altitude &&
    other.speed == speed &&
    other.verticalRate == verticalRate;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (timestamp.hashCode) +
    (latitude.hashCode) +
    (longitude.hashCode) +
    (altitude.hashCode) +
    (speed.hashCode) +
    (verticalRate.hashCode);

  @override
  String toString() => 'TrackPoint[timestamp=$timestamp, latitude=$latitude, longitude=$longitude, altitude=$altitude, speed=$speed, verticalRate=$verticalRate]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'timestamp'] = this.timestamp.toUtc().toIso8601String();
      json[r'latitude'] = this.latitude;
      json[r'longitude'] = this.longitude;
      json[r'altitude'] = this.altitude;
      json[r'speed'] = this.speed;
      json[r'verticalRate'] = this.verticalRate;
    return json;
  }

  /// Returns a new [TrackPoint] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static TrackPoint? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "TrackPoint[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "TrackPoint[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return TrackPoint(
        timestamp: mapDateTime(json, r'timestamp', r'')!,
        latitude: mapValueOfType<double>(json, r'latitude')!,
        longitude: mapValueOfType<double>(json, r'longitude')!,
        altitude: mapValueOfType<int>(json, r'altitude')!,
        speed: mapValueOfType<double>(json, r'speed')!,
        verticalRate: mapValueOfType<double>(json, r'verticalRate')!,
      );
    }
    return null;
  }

  static List<TrackPoint> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <TrackPoint>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TrackPoint.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, TrackPoint> mapFromJson(dynamic json) {
    final map = <String, TrackPoint>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = TrackPoint.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of TrackPoint-objects as value to a dart map
  static Map<String, List<TrackPoint>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<TrackPoint>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = TrackPoint.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'timestamp',
    'latitude',
    'longitude',
    'altitude',
    'speed',
    'verticalRate',
  };
}

