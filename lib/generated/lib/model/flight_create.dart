//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class FlightCreate {
  /// Returns a new [FlightCreate] instance.
  FlightCreate({
    required this.dateTime,
    required this.launchSpotId,
    required this.landingSpotId,
    this.duration,
    this.description,
    required this.gliderId,
  });

  /// Datetime of the flight in UTC (ISO-8601 format with Z suffix)
  DateTime dateTime;

  /// Reference to the launch spot used for this flight.
  int launchSpotId;

  /// Reference to the landing spot used for this flight.
  int landingSpotId;

  /// Duration in minutes
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? duration;

  /// Some textual description of the flight experience.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? description;

  /// Reference to the glider used for this flight.
  int gliderId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlightCreate &&
          other.dateTime == dateTime &&
          other.launchSpotId == launchSpotId &&
          other.landingSpotId == landingSpotId &&
          other.duration == duration &&
          other.description == description &&
          other.gliderId == gliderId;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (dateTime.hashCode) +
      (launchSpotId.hashCode) +
      (landingSpotId.hashCode) +
      (duration == null ? 0 : duration!.hashCode) +
      (description == null ? 0 : description!.hashCode) +
      (gliderId.hashCode);

  @override
  String toString() =>
      'FlightCreate[dateTime=$dateTime, launchSpotId=$launchSpotId, landingSpotId=$landingSpotId, duration=$duration, description=$description, gliderId=$gliderId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'dateTime'] = this.dateTime.toUtc().toIso8601String();
    json[r'launchSpotId'] = this.launchSpotId;
    json[r'landingSpotId'] = this.landingSpotId;
    if (this.duration != null) {
      json[r'duration'] = this.duration;
    } else {
      json[r'duration'] = null;
    }
    if (this.description != null) {
      json[r'description'] = this.description;
    } else {
      json[r'description'] = null;
    }
    json[r'gliderId'] = this.gliderId;
    return json;
  }

  /// Returns a new [FlightCreate] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static FlightCreate? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "FlightCreate[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "FlightCreate[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return FlightCreate(
        dateTime: mapDateTime(json, r'dateTime', r'')!,
        launchSpotId: mapValueOfType<int>(json, r'launchSpotId')!,
        landingSpotId: mapValueOfType<int>(json, r'landingSpotId')!,
        duration: mapValueOfType<int>(json, r'duration'),
        description: mapValueOfType<String>(json, r'description'),
        gliderId: mapValueOfType<int>(json, r'gliderId')!,
      );
    }
    return null;
  }

  static List<FlightCreate> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <FlightCreate>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = FlightCreate.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, FlightCreate> mapFromJson(dynamic json) {
    final map = <String, FlightCreate>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = FlightCreate.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of FlightCreate-objects as value to a dart map
  static Map<String, List<FlightCreate>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<FlightCreate>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = FlightCreate.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'dateTime',
    'launchSpotId',
    'landingSpotId',
    'gliderId',
  };
}
