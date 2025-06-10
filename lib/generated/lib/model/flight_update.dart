//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class FlightUpdate {
  /// Returns a new [FlightUpdate] instance.
  FlightUpdate({
    this.dateTime,
    this.launchSpotId,
    this.landingSpotId,
    this.duration,
    this.description,
    this.gliderId,
  });

  /// Datetime of the flight in UTC (ISO-8601 format with Z suffix)
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? dateTime;

  /// Reference to the launch spot used for this flight.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? launchSpotId;

  /// Reference to the landing spot used for this flight.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? landingSpotId;

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
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? gliderId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlightUpdate &&
          other.dateTime == dateTime &&
          other.launchSpotId == launchSpotId &&
          other.landingSpotId == landingSpotId &&
          other.duration == duration &&
          other.description == description &&
          other.gliderId == gliderId;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (dateTime == null ? 0 : dateTime!.hashCode) +
      (launchSpotId == null ? 0 : launchSpotId!.hashCode) +
      (landingSpotId == null ? 0 : landingSpotId!.hashCode) +
      (duration == null ? 0 : duration!.hashCode) +
      (description == null ? 0 : description!.hashCode) +
      (gliderId == null ? 0 : gliderId!.hashCode);

  @override
  String toString() =>
      'FlightUpdate[dateTime=$dateTime, launchSpotId=$launchSpotId, landingSpotId=$landingSpotId, duration=$duration, description=$description, gliderId=$gliderId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.dateTime != null) {
      json[r'dateTime'] = this.dateTime!.toUtc().toIso8601String();
    } else {
      json[r'dateTime'] = null;
    }
    if (this.launchSpotId != null) {
      json[r'launchSpotId'] = this.launchSpotId;
    } else {
      json[r'launchSpotId'] = null;
    }
    if (this.landingSpotId != null) {
      json[r'landingSpotId'] = this.landingSpotId;
    } else {
      json[r'landingSpotId'] = null;
    }
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
    if (this.gliderId != null) {
      json[r'gliderId'] = this.gliderId;
    } else {
      json[r'gliderId'] = null;
    }
    return json;
  }

  /// Returns a new [FlightUpdate] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static FlightUpdate? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "FlightUpdate[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "FlightUpdate[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return FlightUpdate(
        dateTime: mapDateTime(json, r'dateTime', r''),
        launchSpotId: mapValueOfType<int>(json, r'launchSpotId'),
        landingSpotId: mapValueOfType<int>(json, r'landingSpotId'),
        duration: mapValueOfType<int>(json, r'duration'),
        description: mapValueOfType<String>(json, r'description'),
        gliderId: mapValueOfType<int>(json, r'gliderId'),
      );
    }
    return null;
  }

  static List<FlightUpdate> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <FlightUpdate>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = FlightUpdate.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, FlightUpdate> mapFromJson(dynamic json) {
    final map = <String, FlightUpdate>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = FlightUpdate.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of FlightUpdate-objects as value to a dart map
  static Map<String, List<FlightUpdate>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<FlightUpdate>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = FlightUpdate.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{};
}
