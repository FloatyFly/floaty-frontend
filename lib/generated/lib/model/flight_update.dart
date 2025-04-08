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
    this.takeOff,
    this.duration,
    this.description,
  });

  /// Datetime of the flight. Format: 2024-05-12T08:59:10. Local date time.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? dateTime;

  /// Take off location
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? takeOff;

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

  @override
  bool operator ==(Object other) => identical(this, other) || other is FlightUpdate &&
    other.dateTime == dateTime &&
    other.takeOff == takeOff &&
    other.duration == duration &&
    other.description == description;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (dateTime == null ? 0 : dateTime!.hashCode) +
    (takeOff == null ? 0 : takeOff!.hashCode) +
    (duration == null ? 0 : duration!.hashCode) +
    (description == null ? 0 : description!.hashCode);

  @override
  String toString() => 'FlightUpdate[dateTime=$dateTime, takeOff=$takeOff, duration=$duration, description=$description]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.dateTime != null) {
      json[r'dateTime'] = this.dateTime;
    } else {
      json[r'dateTime'] = null;
    }
    if (this.takeOff != null) {
      json[r'takeOff'] = this.takeOff;
    } else {
      json[r'takeOff'] = null;
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
          assert(json.containsKey(key), 'Required key "FlightUpdate[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "FlightUpdate[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return FlightUpdate(
        dateTime: mapValueOfType<String>(json, r'dateTime'),
        takeOff: mapValueOfType<String>(json, r'takeOff'),
        duration: mapValueOfType<int>(json, r'duration'),
        description: mapValueOfType<String>(json, r'description'),
      );
    }
    return null;
  }

  static List<FlightUpdate> listFromJson(dynamic json, {bool growable = false,}) {
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
  static Map<String, List<FlightUpdate>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<FlightUpdate>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = FlightUpdate.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

