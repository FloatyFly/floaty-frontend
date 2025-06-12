//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class IgcData {
  /// Returns a new [IgcData] instance.
  IgcData({
    required this.uploadedAt,
    required this.fileSize,
    this.fileName,
    this.checksum,
    required this.file,
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

  /// Full metadata with data, null if no IGC file exists.
  String file;

  @override
  bool operator ==(Object other) => identical(this, other) || other is IgcData &&
    other.uploadedAt == uploadedAt &&
    other.fileSize == fileSize &&
    other.fileName == fileName &&
    other.checksum == checksum &&
    other.file == file;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (uploadedAt.hashCode) +
    (fileSize.hashCode) +
    (fileName == null ? 0 : fileName!.hashCode) +
    (checksum == null ? 0 : checksum!.hashCode) +
    (file.hashCode);

  @override
  String toString() => 'IgcData[uploadedAt=$uploadedAt, fileSize=$fileSize, fileName=$fileName, checksum=$checksum, file=$file]';

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
      json[r'file'] = this.file;
    return json;
  }

  /// Returns a new [IgcData] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static IgcData? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "IgcData[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "IgcData[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return IgcData(
        uploadedAt: mapDateTime(json, r'uploadedAt', r'')!,
        fileSize: mapValueOfType<int>(json, r'fileSize')!,
        fileName: mapValueOfType<String>(json, r'fileName'),
        checksum: mapValueOfType<String>(json, r'checksum'),
        file: mapValueOfType<String>(json, r'file')!,
      );
    }
    return null;
  }

  static List<IgcData> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <IgcData>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = IgcData.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, IgcData> mapFromJson(dynamic json) {
    final map = <String, IgcData>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = IgcData.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of IgcData-objects as value to a dart map
  static Map<String, List<IgcData>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<IgcData>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = IgcData.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'uploadedAt',
    'fileSize',
    'file',
  };
}

