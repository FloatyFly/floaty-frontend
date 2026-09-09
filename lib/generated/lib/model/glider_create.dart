//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class GliderCreate {
  /// Returns a new [GliderCreate] instance.
  GliderCreate({
    required this.manufacturer,
    required this.model,
    this.size,
    this.certificationClass,
    this.gradation,
  });

  /// Manufacturer of the glider.
  String manufacturer;

  /// Model name of the glider.
  String model;

  /// Manufacturer size designation, as printed by the manufacturer. Not normalised across manufacturers.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? size;

  /// EN 926-2 / LTF certification class. NONE means genuinely uncertified; CCC is the CIVL competition class, which is also not EN-certified. Absent means not recorded.
  GliderCreateCertificationClassEnum? certificationClass;

  /// Optional informal refinement of the certification class, e.g. Low B. Community vocabulary, not manufacturer data.
  GliderCreateGradationEnum? gradation;

  @override
  bool operator ==(Object other) => identical(this, other) || other is GliderCreate &&
    other.manufacturer == manufacturer &&
    other.model == model &&
    other.size == size &&
    other.certificationClass == certificationClass &&
    other.gradation == gradation;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (manufacturer.hashCode) +
    (model.hashCode) +
    (size == null ? 0 : size!.hashCode) +
    (certificationClass == null ? 0 : certificationClass!.hashCode) +
    (gradation == null ? 0 : gradation!.hashCode);

  @override
  String toString() => 'GliderCreate[manufacturer=$manufacturer, model=$model, size=$size, certificationClass=$certificationClass, gradation=$gradation]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'manufacturer'] = this.manufacturer;
      json[r'model'] = this.model;
    if (this.size != null) {
      json[r'size'] = this.size;
    } else {
      json[r'size'] = null;
    }
    if (this.certificationClass != null) {
      json[r'certificationClass'] = this.certificationClass;
    } else {
      json[r'certificationClass'] = null;
    }
    if (this.gradation != null) {
      json[r'gradation'] = this.gradation;
    } else {
      json[r'gradation'] = null;
    }
    return json;
  }

  /// Returns a new [GliderCreate] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static GliderCreate? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "GliderCreate[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "GliderCreate[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return GliderCreate(
        manufacturer: mapValueOfType<String>(json, r'manufacturer')!,
        model: mapValueOfType<String>(json, r'model')!,
        size: mapValueOfType<String>(json, r'size'),
        certificationClass: GliderCreateCertificationClassEnum.fromJson(json[r'certificationClass']),
        gradation: GliderCreateGradationEnum.fromJson(json[r'gradation']),
      );
    }
    return null;
  }

  static List<GliderCreate> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <GliderCreate>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = GliderCreate.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, GliderCreate> mapFromJson(dynamic json) {
    final map = <String, GliderCreate>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = GliderCreate.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of GliderCreate-objects as value to a dart map
  static Map<String, List<GliderCreate>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<GliderCreate>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = GliderCreate.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'manufacturer',
    'model',
  };
}

/// EN 926-2 / LTF certification class. NONE means genuinely uncertified; CCC is the CIVL competition class, which is also not EN-certified. Absent means not recorded.
class GliderCreateCertificationClassEnum {
  /// Instantiate a new enum with the provided [value].
  const GliderCreateCertificationClassEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const A = GliderCreateCertificationClassEnum._(r'A');
  static const B = GliderCreateCertificationClassEnum._(r'B');
  static const C = GliderCreateCertificationClassEnum._(r'C');
  static const D = GliderCreateCertificationClassEnum._(r'D');
  static const NONE = GliderCreateCertificationClassEnum._(r'NONE');
  static const CCC = GliderCreateCertificationClassEnum._(r'CCC');

  /// List of all possible values in this [enum][GliderCreateCertificationClassEnum].
  static const values = <GliderCreateCertificationClassEnum>[
    A,
    B,
    C,
    D,
    NONE,
    CCC,
  ];

  static GliderCreateCertificationClassEnum? fromJson(dynamic value) => GliderCreateCertificationClassEnumTypeTransformer().decode(value);

  static List<GliderCreateCertificationClassEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <GliderCreateCertificationClassEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = GliderCreateCertificationClassEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [GliderCreateCertificationClassEnum] to String,
/// and [decode] dynamic data back to [GliderCreateCertificationClassEnum].
class GliderCreateCertificationClassEnumTypeTransformer {
  factory GliderCreateCertificationClassEnumTypeTransformer() => _instance ??= const GliderCreateCertificationClassEnumTypeTransformer._();

  const GliderCreateCertificationClassEnumTypeTransformer._();

  String encode(GliderCreateCertificationClassEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a GliderCreateCertificationClassEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  GliderCreateCertificationClassEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'A': return GliderCreateCertificationClassEnum.A;
        case r'B': return GliderCreateCertificationClassEnum.B;
        case r'C': return GliderCreateCertificationClassEnum.C;
        case r'D': return GliderCreateCertificationClassEnum.D;
        case r'NONE': return GliderCreateCertificationClassEnum.NONE;
        case r'CCC': return GliderCreateCertificationClassEnum.CCC;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [GliderCreateCertificationClassEnumTypeTransformer] instance.
  static GliderCreateCertificationClassEnumTypeTransformer? _instance;
}


/// Optional informal refinement of the certification class, e.g. Low B. Community vocabulary, not manufacturer data.
class GliderCreateGradationEnum {
  /// Instantiate a new enum with the provided [value].
  const GliderCreateGradationEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const LOW = GliderCreateGradationEnum._(r'LOW');
  static const MID = GliderCreateGradationEnum._(r'MID');
  static const HIGH = GliderCreateGradationEnum._(r'HIGH');

  /// List of all possible values in this [enum][GliderCreateGradationEnum].
  static const values = <GliderCreateGradationEnum>[
    LOW,
    MID,
    HIGH,
  ];

  static GliderCreateGradationEnum? fromJson(dynamic value) => GliderCreateGradationEnumTypeTransformer().decode(value);

  static List<GliderCreateGradationEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <GliderCreateGradationEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = GliderCreateGradationEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [GliderCreateGradationEnum] to String,
/// and [decode] dynamic data back to [GliderCreateGradationEnum].
class GliderCreateGradationEnumTypeTransformer {
  factory GliderCreateGradationEnumTypeTransformer() => _instance ??= const GliderCreateGradationEnumTypeTransformer._();

  const GliderCreateGradationEnumTypeTransformer._();

  String encode(GliderCreateGradationEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a GliderCreateGradationEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  GliderCreateGradationEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'LOW': return GliderCreateGradationEnum.LOW;
        case r'MID': return GliderCreateGradationEnum.MID;
        case r'HIGH': return GliderCreateGradationEnum.HIGH;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [GliderCreateGradationEnumTypeTransformer] instance.
  static GliderCreateGradationEnumTypeTransformer? _instance;
}


