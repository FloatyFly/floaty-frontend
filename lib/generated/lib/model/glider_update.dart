//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class GliderUpdate {
  /// Returns a new [GliderUpdate] instance.
  GliderUpdate({
    this.manufacturer,
    this.model,
  });

  /// Manufacturer of the glider.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? manufacturer;

  /// Model name of the glider.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? model;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GliderUpdate &&
          other.manufacturer == manufacturer &&
          other.model == model;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (manufacturer == null ? 0 : manufacturer!.hashCode) +
      (model == null ? 0 : model!.hashCode);

  @override
  String toString() => 'GliderUpdate[manufacturer=$manufacturer, model=$model]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.manufacturer != null) {
      json[r'manufacturer'] = this.manufacturer;
    } else {
      json[r'manufacturer'] = null;
    }
    if (this.model != null) {
      json[r'model'] = this.model;
    } else {
      json[r'model'] = null;
    }
    return json;
  }

  /// Returns a new [GliderUpdate] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static GliderUpdate? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "GliderUpdate[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "GliderUpdate[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return GliderUpdate(
        manufacturer: mapValueOfType<String>(json, r'manufacturer'),
        model: mapValueOfType<String>(json, r'model'),
      );
    }
    return null;
  }

  static List<GliderUpdate> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <GliderUpdate>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = GliderUpdate.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, GliderUpdate> mapFromJson(dynamic json) {
    final map = <String, GliderUpdate>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = GliderUpdate.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of GliderUpdate-objects as value to a dart map
  static Map<String, List<GliderUpdate>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<GliderUpdate>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = GliderUpdate.listFromJson(
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
