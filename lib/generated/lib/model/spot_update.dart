//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class SpotUpdate {
  /// Returns a new [SpotUpdate] instance.
  SpotUpdate({
    this.name,
    this.type,
    this.latitude,
    this.longitude,
    this.altitude,
    this.description,
  });

  /// Name of the paragliding spot.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? name;

  /// Type of the paragliding spot.
  SpotUpdateTypeEnum? type;

  /// Latitude coordinate of the spot.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? latitude;

  /// Longitude coordinate of the spot.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? longitude;

  /// Height above sea level in meters.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? altitude;

  /// Detailed description of the spot including conditions, access instructions, etc.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? description;

  @override
  bool operator ==(Object other) => identical(this, other) || other is SpotUpdate &&
    other.name == name &&
    other.type == type &&
    other.latitude == latitude &&
    other.longitude == longitude &&
    other.altitude == altitude &&
    other.description == description;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (name == null ? 0 : name!.hashCode) +
    (type == null ? 0 : type!.hashCode) +
    (latitude == null ? 0 : latitude!.hashCode) +
    (longitude == null ? 0 : longitude!.hashCode) +
    (altitude == null ? 0 : altitude!.hashCode) +
    (description == null ? 0 : description!.hashCode);

  @override
  String toString() => 'SpotUpdate[name=$name, type=$type, latitude=$latitude, longitude=$longitude, altitude=$altitude, description=$description]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.name != null) {
      json[r'name'] = this.name;
    } else {
      json[r'name'] = null;
    }
    if (this.type != null) {
      json[r'type'] = this.type;
    } else {
      json[r'type'] = null;
    }
    if (this.latitude != null) {
      json[r'latitude'] = this.latitude;
    } else {
      json[r'latitude'] = null;
    }
    if (this.longitude != null) {
      json[r'longitude'] = this.longitude;
    } else {
      json[r'longitude'] = null;
    }
    if (this.altitude != null) {
      json[r'altitude'] = this.altitude;
    } else {
      json[r'altitude'] = null;
    }
    if (this.description != null) {
      json[r'description'] = this.description;
    } else {
      json[r'description'] = null;
    }
    return json;
  }

  /// Returns a new [SpotUpdate] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static SpotUpdate? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "SpotUpdate[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "SpotUpdate[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return SpotUpdate(
        name: mapValueOfType<String>(json, r'name'),
        type: SpotUpdateTypeEnum.fromJson(json[r'type']),
        latitude: mapValueOfType<double>(json, r'latitude'),
        longitude: mapValueOfType<double>(json, r'longitude'),
        altitude: mapValueOfType<int>(json, r'altitude'),
        description: mapValueOfType<String>(json, r'description'),
      );
    }
    return null;
  }

  static List<SpotUpdate> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <SpotUpdate>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SpotUpdate.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, SpotUpdate> mapFromJson(dynamic json) {
    final map = <String, SpotUpdate>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = SpotUpdate.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of SpotUpdate-objects as value to a dart map
  static Map<String, List<SpotUpdate>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<SpotUpdate>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = SpotUpdate.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

/// Type of the paragliding spot.
class SpotUpdateTypeEnum {
  /// Instantiate a new enum with the provided [value].
  const SpotUpdateTypeEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const LAUNCH_SITE = SpotUpdateTypeEnum._(r'LAUNCH_SITE');
  static const LANDING_SITE = SpotUpdateTypeEnum._(r'LANDING_SITE');
  static const LAUNCH_AND_LANDING_SITE = SpotUpdateTypeEnum._(r'LAUNCH_AND_LANDING_SITE');

  /// List of all possible values in this [enum][SpotUpdateTypeEnum].
  static const values = <SpotUpdateTypeEnum>[
    LAUNCH_SITE,
    LANDING_SITE,
    LAUNCH_AND_LANDING_SITE,
  ];

  static SpotUpdateTypeEnum? fromJson(dynamic value) => SpotUpdateTypeEnumTypeTransformer().decode(value);

  static List<SpotUpdateTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <SpotUpdateTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SpotUpdateTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [SpotUpdateTypeEnum] to String,
/// and [decode] dynamic data back to [SpotUpdateTypeEnum].
class SpotUpdateTypeEnumTypeTransformer {
  factory SpotUpdateTypeEnumTypeTransformer() => _instance ??= const SpotUpdateTypeEnumTypeTransformer._();

  const SpotUpdateTypeEnumTypeTransformer._();

  String encode(SpotUpdateTypeEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a SpotUpdateTypeEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  SpotUpdateTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'LAUNCH_SITE': return SpotUpdateTypeEnum.LAUNCH_SITE;
        case r'LANDING_SITE': return SpotUpdateTypeEnum.LANDING_SITE;
        case r'LAUNCH_AND_LANDING_SITE': return SpotUpdateTypeEnum.LAUNCH_AND_LANDING_SITE;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [SpotUpdateTypeEnumTypeTransformer] instance.
  static SpotUpdateTypeEnumTypeTransformer? _instance;
}


