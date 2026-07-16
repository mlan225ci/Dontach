import 'package:flutter_test/flutter_test.dart';
import 'package:dontach/models/sensitivity_settings.dart';

void main() {
  test('SensitivityLevel low uses higher thresholds', () {
    expect(
      SensitivityLevel.low.rotationThreshold,
      greaterThan(SensitivityLevel.high.rotationThreshold),
    );
    expect(
      SensitivityLevel.low.angleThreshold,
      greaterThan(SensitivityLevel.high.angleThreshold),
    );
  });

  test('SensitivitySettings round-trips through json', () {
    const settings = SensitivitySettings(level: SensitivityLevel.high);
    final restored = SensitivitySettings.fromJson(settings.toJson());
    expect(restored.level, SensitivityLevel.high);
  });
}
