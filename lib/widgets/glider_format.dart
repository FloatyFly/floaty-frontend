import 'package:floaty_client/api.dart' as api;

/// Human-readable name for a glider: "Skywalk Cumeo2 (95)".
///
/// Size used to be part of the model string; now that it is its own field the parenthesised
/// form is rebuilt here so the display stays familiar. Gliders without a recorded size simply
/// omit the parentheses.
String gliderDisplayName(api.Glider glider) {
  final base = '${glider.manufacturer} ${glider.model}';
  final size = glider.size;
  if (size == null || size.isEmpty) {
    return base;
  }
  return '$base ($size)';
}

/// The certification as a pilot would say it: "Low B", "B", "None", "None (CCC)".
/// Returns null when no class is recorded, so callers can omit the field entirely.
String? certificationDisplay(api.Glider glider) {
  final certificationClass = glider.certificationClass;
  if (certificationClass == null) {
    return null;
  }

  final className = switch (certificationClass.value) {
    'NONE' => 'None',
    'CCC' => 'None (CCC)',
    final value => value,
  };

  final gradation = glider.gradation;
  if (gradation == null) {
    return className;
  }

  // "Low B" reads naturally; "Low None (CCC)" does not, so only letter classes get a prefix.
  if (certificationClass.value == 'NONE' || certificationClass.value == 'CCC') {
    return className;
  }

  final gradationName = switch (gradation.value) {
    'LOW' => 'Low',
    'MID' => 'Mid',
    'HIGH' => 'High',
    final value => value,
  };
  return '$gradationName $className';
}

// The generator emits a separate enum class per schema (Glider / GliderCreate / GliderUpdate),
// so values have to be bridged by their string value when moving between them. The form state
// holds the Glider* variants; these convert to the create/update ones at the call site.

api.GliderCreateCertificationClassEnum? toCreateCertificationClass(
    api.GliderCertificationClassEnum? value) {
  return value == null
      ? null
      : api.GliderCreateCertificationClassEnum.fromJson(value.value);
}

api.GliderCreateGradationEnum? toCreateGradation(api.GliderGradationEnum? value) {
  return value == null ? null : api.GliderCreateGradationEnum.fromJson(value.value);
}

api.GliderUpdateCertificationClassEnum? toUpdateCertificationClass(
    api.GliderCertificationClassEnum? value) {
  return value == null
      ? null
      : api.GliderUpdateCertificationClassEnum.fromJson(value.value);
}

api.GliderUpdateGradationEnum? toUpdateGradation(api.GliderGradationEnum? value) {
  return value == null ? null : api.GliderUpdateGradationEnum.fromJson(value.value);
}
