//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class TrackStatistics {
  /// Returns a new [TrackStatistics] instance.
  TrackStatistics({
    required this.totalPoints,
    required this.duration,
    required this.distance,
    required this.maxAltitude,
    required this.minAltitude,
    required this.maxSpeed,
    required this.maxClimbRate,
    required this.maxSinkRate,
    this.averageSpeed,
  });

  /// Total number of track points
  int totalPoints;

  /// Flight duration in seconds
  int duration;

  /// Total distance covered in kilometers
  double distance;

  /// Maximum altitude reached in meters
  int maxAltitude;

  /// Minimum altitude in meters
  int minAltitude;

  /// Maximum ground speed in km/h
  double maxSpeed;

  /// Maximum climb rate in m/s
  double maxClimbRate;

  /// Maximum sink rate in m/s (negative value)
  double maxSinkRate;

  /// Average ground speed in km/h
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? averageSpeed;

  @override
  bool operator ==(Object other) => identical(this, other) || other is TrackStatistics &&
    other.totalPoints == totalPoints &&
    other.duration == duration &&
    other.distance == distance &&
    other.maxAltitude == maxAltitude &&
    other.minAltitude == minAltitude &&
    other.maxSpeed == maxSpeed &&
    other.maxClimbRate == maxClimbRate &&
    other.maxSinkRate == maxSinkRate &&
    other.averageSpeed == averageSpeed;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (totalPoints.hashCode) +
    (duration.hashCode) +
    (distance.hashCode) +
    (maxAltitude.hashCode) +
    (minAltitude.hashCode) +
    (maxSpeed.hashCode) +
    (maxClimbRate.hashCode) +
    (maxSinkRate.hashCode) +
    (averageSpeed == null ? 0 : averageSpeed!.hashCode);

  @override
  String toString() => 'TrackStatistics[totalPoints=$totalPoints, duration=$duration, distance=$distance, maxAltitude=$maxAltitude, minAltitude=$minAltitude, maxSpeed=$maxSpeed, maxClimbRate=$maxClimbRate, maxSinkRate=$maxSinkRate, averageSpeed=$averageSpeed]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'totalPoints'] = this.totalPoints;
      json[r'duration'] = this.duration;
      json[r'distance'] = this.distance;
      json[r'maxAltitude'] = this.maxAltitude;
      json[r'minAltitude'] = this.minAltitude;
      json[r'maxSpeed'] = this.maxSpeed;
      json[r'maxClimbRate'] = this.maxClimbRate;
      json[r'maxSinkRate'] = this.maxSinkRate;
    if (this.averageSpeed != null) {
      json[r'averageSpeed'] = this.averageSpeed;
    } else {
      json[r'averageSpeed'] = null;
    }
    return json;
  }

  /// Returns a new [TrackStatistics] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static TrackStatistics? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "TrackStatistics[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "TrackStatistics[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return TrackStatistics(
        totalPoints: mapValueOfType<int>(json, r'totalPoints')!,
        duration: mapValueOfType<int>(json, r'duration')!,
        distance: mapValueOfType<double>(json, r'distance')!,
        maxAltitude: mapValueOfType<int>(json, r'maxAltitude')!,
        minAltitude: mapValueOfType<int>(json, r'minAltitude')!,
        maxSpeed: mapValueOfType<double>(json, r'maxSpeed')!,
        maxClimbRate: mapValueOfType<double>(json, r'maxClimbRate')!,
        maxSinkRate: mapValueOfType<double>(json, r'maxSinkRate')!,
        averageSpeed: mapValueOfType<double>(json, r'averageSpeed'),
      );
    }
    return null;
  }

  static List<TrackStatistics> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <TrackStatistics>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TrackStatistics.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, TrackStatistics> mapFromJson(dynamic json) {
    final map = <String, TrackStatistics>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = TrackStatistics.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of TrackStatistics-objects as value to a dart map
  static Map<String, List<TrackStatistics>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<TrackStatistics>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = TrackStatistics.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'totalPoints',
    'duration',
    'distance',
    'maxAltitude',
    'minAltitude',
    'maxSpeed',
    'maxClimbRate',
    'maxSinkRate',
  };
}

