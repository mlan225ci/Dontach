import 'package:flutter_test/flutter_test.dart';
import 'package:dontach/models/sensitivity_settings.dart';

void main() {
  test('SensitivityLevel low uses higher thresholds in table mode', () {
    expect(
      SensitivityLevel.low.rotationThreshold(ProtectionMode.table),
      greaterThan(SensitivityLevel.high.rotationThreshold(ProtectionMode.table)),
    );
    expect(
      SensitivityLevel.low.angleThreshold(ProtectionMode.table),
      greaterThan(SensitivityLevel.high.angleThreshold(ProtectionMode.table)),
    );
  });

  test('Pocket mode tolerates walking and only extracts on large angle', () {
    expect(
      SensitivityLevel.medium.walkingTolerance(ProtectionMode.pocket),
      greaterThan(30.0),
    );
    expect(
      SensitivityLevel.medium.extractionAngle(ProtectionMode.pocket),
      greaterThan(SensitivityLevel.medium.walkingTolerance(ProtectionMode.pocket)),
    );
    expect(
      SensitivityLevel.medium.snatchThreshold(ProtectionMode.pocket),
      greaterThan(5.0),
    );
    expect(
      SensitivityLevel.medium.walkingGrace(ProtectionMode.pocket),
      greaterThan(Duration.zero),
    );
  });

  test('SensitivitySettings round-trips through json with pocket mode', () {
    const settings = SensitivitySettings(
      level: SensitivityLevel.high,
      mode: ProtectionMode.pocket,
    );
    final restored = SensitivitySettings.fromJson(settings.toJson());
    expect(restored.level, SensitivityLevel.high);
    expect(restored.mode, ProtectionMode.pocket);
  });
}
