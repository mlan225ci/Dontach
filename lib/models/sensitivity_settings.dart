enum SensitivityLevel {
  low,
  medium,
  high;

  double get rotationThreshold {
    switch (this) {
      case SensitivityLevel.low:
        return 3.5;
      case SensitivityLevel.medium:
        return 2.5;
      case SensitivityLevel.high:
        return 1.8;
    }
  }

  double get angleThreshold {
    switch (this) {
      case SensitivityLevel.low:
        return 35.0;
      case SensitivityLevel.medium:
        return 25.0;
      case SensitivityLevel.high:
        return 18.0;
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
  const SensitivitySettings({this.level = SensitivityLevel.medium});

  final SensitivityLevel level;

  SensitivitySettings copyWith({SensitivityLevel? level}) {
    return SensitivitySettings(level: level ?? this.level);
  }

  Map<String, dynamic> toJson() => {'level': level.storageKey()};

  factory SensitivitySettings.fromJson(Map<String, dynamic> json) {
    return SensitivitySettings(
      level: SensitivityLevel.fromKey(json['level'] as String?),
    );
  }
}
