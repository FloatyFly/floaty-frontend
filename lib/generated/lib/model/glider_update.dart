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
    this.size,
    this.certificationClass,
    this.gradation,
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

  /// Manufacturer size designation, as printed by the manufacturer. Not normalised across manufacturers.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? size;

  /// EN 926-2 / LTF certification class. NONE means genuinely uncertified; CCC is the CIVL competition class, which is also not EN-certified. Absent means not recorded.
  GliderUpdateCertificationClassEnum? certificationClass;

  /// Optional informal refinement of the certification class, e.g. Low B. Community vocabulary, not manufacturer data.
  GliderUpdateGradationEnum? gradation;

  @override
  bool operator ==(Object other) => identical(this, other) || other is GliderUpdate &&
    other.manufacturer == manufacturer &&
    other.model == model &&
    other.size == size &&
    other.certificationClass == certificationClass &&
    other.gradation == gradation;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (manufacturer == null ? 0 : manufacturer!.hashCode) +
    (model == null ? 0 : model!.hashCode) +
    (size == null ? 0 : size!.hashCode) +
    (certificationClass == null ? 0 : certificationClass!.hashCode) +
    (gradation == null ? 0 : gradation!.hashCode);

  @override
  String toString() => 'GliderUpdate[manufacturer=$manufacturer, model=$model, size=$size, certificationClass=$certificationClass, gradation=$gradation]';

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
          assert(json.containsKey(key), 'Required key "GliderUpdate[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "GliderUpdate[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return GliderUpdate(
        manufacturer: mapValueOfType<String>(json, r'manufacturer'),
        model: mapValueOfType<String>(json, r'model'),
        size: mapValueOfType<String>(json, r'size'),
        certificationClass: GliderUpdateCertificationClassEnum.fromJson(json[r'certificationClass']),
        gradation: GliderUpdateGradationEnum.fromJson(json[r'gradation']),
      );
    }
    return null;
  }

  static List<GliderUpdate> listFromJson(dynamic json, {bool growable = false,}) {
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
  static Map<String, List<GliderUpdate>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<GliderUpdate>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = GliderUpdate.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

/// EN 926-2 / LTF certification class. NONE means genuinely uncertified; CCC is the CIVL competition class, which is also not EN-certified. Absent means not recorded.
class GliderUpdateCertificationClassEnum {
  /// Instantiate a new enum with the provided [value].
  const GliderUpdateCertificationClassEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const A = GliderUpdateCertificationClassEnum._(r'A');
  static const B = GliderUpdateCertificationClassEnum._(r'B');
  static const C = GliderUpdateCertificationClassEnum._(r'C');
  static const D = GliderUpdateCertificationClassEnum._(r'D');
  static const NONE = GliderUpdateCertificationClassEnum._(r'NONE');
  static const CCC = GliderUpdateCertificationClassEnum._(r'CCC');

  /// List of all possible values in this [enum][GliderUpdateCertificationClassEnum].
  static const values = <GliderUpdateCertificationClassEnum>[
    A,
    B,
    C,
    D,
    NONE,
    CCC,
  ];

  static GliderUpdateCertificationClassEnum? fromJson(dynamic value) => GliderUpdateCertificationClassEnumTypeTransformer().decode(value);

  static List<GliderUpdateCertificationClassEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <GliderUpdateCertificationClassEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = GliderUpdateCertificationClassEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [GliderUpdateCertificationClassEnum] to String,
/// and [decode] dynamic data back to [GliderUpdateCertificationClassEnum].
class GliderUpdateCertificationClassEnumTypeTransformer {
  factory GliderUpdateCertificationClassEnumTypeTransformer() => _instance ??= const GliderUpdateCertificationClassEnumTypeTransformer._();

  const GliderUpdateCertificationClassEnumTypeTransformer._();

  String encode(GliderUpdateCertificationClassEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a GliderUpdateCertificationClassEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  GliderUpdateCertificationClassEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'A': return GliderUpdateCertificationClassEnum.A;
        case r'B': return GliderUpdateCertificationClassEnum.B;
        case r'C': return GliderUpdateCertificationClassEnum.C;
        case r'D': return GliderUpdateCertificationClassEnum.D;
        case r'NONE': return GliderUpdateCertificationClassEnum.NONE;
        case r'CCC': return GliderUpdateCertificationClassEnum.CCC;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [GliderUpdateCertificationClassEnumTypeTransformer] instance.
  static GliderUpdateCertificationClassEnumTypeTransformer? _instance;
}


/// Optional informal refinement of the certification class, e.g. Low B. Community vocabulary, not manufacturer data.
class GliderUpdateGradationEnum {
  /// Instantiate a new enum with the provided [value].
  const GliderUpdateGradationEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const LOW = GliderUpdateGradationEnum._(r'LOW');
  static const MID = GliderUpdateGradationEnum._(r'MID');
  static const HIGH = GliderUpdateGradationEnum._(r'HIGH');

  /// List of all possible values in this [enum][GliderUpdateGradationEnum].
  static const values = <GliderUpdateGradationEnum>[
    LOW,
    MID,
    HIGH,
  ];

  static GliderUpdateGradationEnum? fromJson(dynamic value) => GliderUpdateGradationEnumTypeTransformer().decode(value);

  static List<GliderUpdateGradationEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <GliderUpdateGradationEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = GliderUpdateGradationEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [GliderUpdateGradationEnum] to String,
/// and [decode] dynamic data back to [GliderUpdateGradationEnum].
class GliderUpdateGradationEnumTypeTransformer {
  factory GliderUpdateGradationEnumTypeTransformer() => _instance ??= const GliderUpdateGradationEnumTypeTransformer._();

  const GliderUpdateGradationEnumTypeTransformer._();

  String encode(GliderUpdateGradationEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a GliderUpdateGradationEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  GliderUpdateGradationEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'LOW': return GliderUpdateGradationEnum.LOW;
        case r'MID': return GliderUpdateGradationEnum.MID;
        case r'HIGH': return GliderUpdateGradationEnum.HIGH;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [GliderUpdateGradationEnumTypeTransformer] instance.
  static GliderUpdateGradationEnumTypeTransformer? _instance;
}


