enum ProtectionMode {
  table,
  pocket;

  String storageKey() => name;

  static ProtectionMode fromKey(String? key) {
    return ProtectionMode.values.firstWhere(
      (mode) => mode.name == key,
      orElse: () => ProtectionMode.table,
    );
  }
}

enum SensitivityLevel {
  low,
  medium,
  high;

  double rotationThreshold(ProtectionMode mode) {
    if (mode == ProtectionMode.pocket) return double.infinity;

    switch (this) {
      case SensitivityLevel.low:
        return 3.5;
      case SensitivityLevel.medium:
        return 2.5;
      case SensitivityLevel.high:
        return 1.8;
    }
  }

  /// Table mode: immediate pickup angle. Pocket mode: unused (see extractionAngle).
  double angleThreshold(ProtectionMode mode) {
    if (mode == ProtectionMode.pocket) return extractionAngle(mode);

    switch (this) {
      case SensitivityLevel.low:
        return 35.0;
      case SensitivityLevel.medium:
        return 25.0;
      case SensitivityLevel.high:
        return 18.0;
    }
  }

  /// Max angle wobble allowed while walking in pocket/bag.
  double walkingTolerance(ProtectionMode mode) {
    if (mode == ProtectionMode.table) return 0.0;

    switch (this) {
      case SensitivityLevel.low:
        return 42.0;
      case SensitivityLevel.medium:
        return 38.0;
      case SensitivityLevel.high:
        return 34.0;
    }
  }

  /// Angle that indicates phone has left pocket orientation (must be sustained).
  double extractionAngle(ProtectionMode mode) {
    if (mode == ProtectionMode.table) return angleThreshold(mode);

    switch (this) {
      case SensitivityLevel.low:
        return 68.0;
      case SensitivityLevel.medium:
        return 62.0;
      case SensitivityLevel.high:
        return 56.0;
    }
  }

  /// Minimum orientation shift required alongside a snatch peak.
  double snatchAngleMin(ProtectionMode mode) {
    if (mode == ProtectionMode.table) return double.infinity;

    switch (this) {
      case SensitivityLevel.low:
        return 48.0;
      case SensitivityLevel.medium:
        return 44.0;
      case SensitivityLevel.high:
        return 40.0;
    }
  }

  /// Violent pull threshold (m/s²). Walking stays well below this.
  double snatchThreshold(ProtectionMode mode) {
    if (mode == ProtectionMode.table) return double.infinity;

    switch (this) {
      case SensitivityLevel.low:
        return 8.5;
      case SensitivityLevel.medium:
        return 7.0;
      case SensitivityLevel.high:
        return 6.0;
    }
  }

  Duration sustainDuration(ProtectionMode mode) {
    if (mode == ProtectionMode.table) return Duration.zero;

    switch (this) {
      case SensitivityLevel.low:
        return const Duration(milliseconds: 1400);
      case SensitivityLevel.medium:
        return const Duration(milliseconds: 1200);
      case SensitivityLevel.high:
        return const Duration(milliseconds: 1000);
    }
  }

  /// Ignore triggers right after arming so the user can walk away.
  Duration walkingGrace(ProtectionMode mode) {
    if (mode == ProtectionMode.table) return Duration.zero;

    switch (this) {
      case SensitivityLevel.low:
        return const Duration(seconds: 5);
      case SensitivityLevel.medium:
        return const Duration(seconds: 4);
      case SensitivityLevel.high:
        return const Duration(seconds: 3);
    }
  }

  String storageKey() => name;

  static SensitivityLevel fromKey(String? key) {
    return SensitivityLevel.values.firstWhere(
      (level) => level.name == key,
      orElse: () => SensitivityLevel.medium,
    );
  }
}

class SensitivitySettings {
  const SensitivitySettings({
    this.level = SensitivityLevel.medium,
    this.mode = ProtectionMode.table,
  });

  final SensitivityLevel level;
  final ProtectionMode mode;

  SensitivitySettings copyWith({
    SensitivityLevel? level,
    ProtectionMode? mode,
  }) {
    return SensitivitySettings(
      level: level ?? this.level,
      mode: mode ?? this.mode,
    );
  }

  Map<String, dynamic> toJson() => {
        'level': level.storageKey(),
        'mode': mode.storageKey(),
      };

  factory SensitivitySettings.fromJson(Map<String, dynamic> json) {
    return SensitivitySettings(
      level: SensitivityLevel.fromKey(json['level'] as String?),
      mode: ProtectionMode.fromKey(json['mode'] as String?),
    );
  }
}
