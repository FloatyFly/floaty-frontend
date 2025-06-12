//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class IgcMetadata {
  /// Returns a new [IgcMetadata] instance.
  IgcMetadata({
    required this.uploadedAt,
    required this.fileSize,
    this.fileName,
    this.checksum,
  });

  /// When the IGC file was uploaded (UTC)
  DateTime uploadedAt;

  /// Size of the IGC file in bytes
  int fileSize;

  /// Original filename of the uploaded IGC file
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? fileName;

  /// File checksum for integrity verification
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? checksum;

  @override
  bool operator ==(Object other) => identical(this, other) || other is IgcMetadata &&
    other.uploadedAt == uploadedAt &&
    other.fileSize == fileSize &&
    other.fileName == fileName &&
    other.checksum == checksum;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (uploadedAt.hashCode) +
    (fileSize.hashCode) +
    (fileName == null ? 0 : fileName!.hashCode) +
    (checksum == null ? 0 : checksum!.hashCode);

  @override
  String toString() => 'IgcMetadata[uploadedAt=$uploadedAt, fileSize=$fileSize, fileName=$fileName, checksum=$checksum]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'uploadedAt'] = this.uploadedAt.toUtc().toIso8601String();
      json[r'fileSize'] = this.fileSize;
    if (this.fileName != null) {
      json[r'fileName'] = this.fileName;
    } else {
      json[r'fileName'] = null;
    }
    if (this.checksum != null) {
      json[r'checksum'] = this.checksum;
    } else {
      json[r'checksum'] = null;
    }
    return json;
  }

  /// Returns a new [IgcMetadata] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static IgcMetadata? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "IgcMetadata[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "IgcMetadata[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return IgcMetadata(
        uploadedAt: mapDateTime(json, r'uploadedAt', r'')!,
        fileSize: mapValueOfType<int>(json, r'fileSize')!,
        fileName: mapValueOfType<String>(json, r'fileName'),
        checksum: mapValueOfType<String>(json, r'checksum'),
      );
    }
    return null;
  }

  static List<IgcMetadata> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <IgcMetadata>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = IgcMetadata.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, IgcMetadata> mapFromJson(dynamic json) {
    final map = <String, IgcMetadata>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = IgcMetadata.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of IgcMetadata-objects as value to a dart map
  static Map<String, List<IgcMetadata>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<IgcMetadata>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = IgcMetadata.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'uploadedAt',
    'fileSize',
  };
}

