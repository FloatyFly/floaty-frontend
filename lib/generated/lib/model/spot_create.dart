//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class SpotCreate {
  /// Returns a new [SpotCreate] instance.
  SpotCreate({
    required this.name,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.altitude,
    this.description,
  });

  /// Name of the paragliding spot.
  String name;

  /// Type of the paragliding spot.
  SpotCreateTypeEnum type;

  /// Latitude coordinate of the spot.
  double latitude;

  /// Longitude coordinate of the spot.
  double longitude;

  /// Height above sea level in meters.
  int altitude;

  /// Detailed description of the spot including conditions, access instructions, etc.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? description;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpotCreate &&
          other.name == name &&
          other.type == type &&
          other.latitude == latitude &&
          other.longitude == longitude &&
          other.altitude == altitude &&
          other.description == description;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (name.hashCode) +
      (type.hashCode) +
      (latitude.hashCode) +
      (longitude.hashCode) +
      (altitude.hashCode) +
      (description == null ? 0 : description!.hashCode);

  @override
  String toString() =>
      'SpotCreate[name=$name, type=$type, latitude=$latitude, longitude=$longitude, altitude=$altitude, description=$description]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'name'] = this.name;
    json[r'type'] = this.type;
    json[r'latitude'] = this.latitude;
    json[r'longitude'] = this.longitude;
    json[r'altitude'] = this.altitude;
    if (this.description != null) {
      json[r'description'] = this.description;
    } else {
      json[r'description'] = null;
    }
    return json;
  }

  /// Returns a new [SpotCreate] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static SpotCreate? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "SpotCreate[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "SpotCreate[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return SpotCreate(
        name: mapValueOfType<String>(json, r'name')!,
        type: SpotCreateTypeEnum.fromJson(json[r'type'])!,
        latitude: mapValueOfType<double>(json, r'latitude')!,
        longitude: mapValueOfType<double>(json, r'longitude')!,
        altitude: mapValueOfType<int>(json, r'altitude')!,
        description: mapValueOfType<String>(json, r'description'),
      );
    }
    return null;
  }

  static List<SpotCreate> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <SpotCreate>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SpotCreate.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, SpotCreate> mapFromJson(dynamic json) {
    final map = <String, SpotCreate>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = SpotCreate.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of SpotCreate-objects as value to a dart map
  static Map<String, List<SpotCreate>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<SpotCreate>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = SpotCreate.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'name',
    'type',
    'latitude',
    'longitude',
    'altitude',
  };
}

/// Type of the paragliding spot.
class SpotCreateTypeEnum {
  /// Instantiate a new enum with the provided [value].
  const SpotCreateTypeEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const LAUNCH_SITE = SpotCreateTypeEnum._(r'LAUNCH_SITE');
  static const LANDING_SITE = SpotCreateTypeEnum._(r'LANDING_SITE');
  static const LAUNCH_AND_LANDING_SITE =
      SpotCreateTypeEnum._(r'LAUNCH_AND_LANDING_SITE');

  /// List of all possible values in this [enum][SpotCreateTypeEnum].
  static const values = <SpotCreateTypeEnum>[
    LAUNCH_SITE,
    LANDING_SITE,
    LAUNCH_AND_LANDING_SITE,
  ];

  static SpotCreateTypeEnum? fromJson(dynamic value) =>
      SpotCreateTypeEnumTypeTransformer().decode(value);

  static List<SpotCreateTypeEnum> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <SpotCreateTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SpotCreateTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [SpotCreateTypeEnum] to String,
/// and [decode] dynamic data back to [SpotCreateTypeEnum].
class SpotCreateTypeEnumTypeTransformer {
  factory SpotCreateTypeEnumTypeTransformer() =>
      _instance ??= const SpotCreateTypeEnumTypeTransformer._();

  const SpotCreateTypeEnumTypeTransformer._();

  String encode(SpotCreateTypeEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a SpotCreateTypeEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  SpotCreateTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'LAUNCH_SITE':
          return SpotCreateTypeEnum.LAUNCH_SITE;
        case r'LANDING_SITE':
          return SpotCreateTypeEnum.LANDING_SITE;
        case r'LAUNCH_AND_LANDING_SITE':
          return SpotCreateTypeEnum.LAUNCH_AND_LANDING_SITE;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [SpotCreateTypeEnumTypeTransformer] instance.
  static SpotCreateTypeEnumTypeTransformer? _instance;
}
