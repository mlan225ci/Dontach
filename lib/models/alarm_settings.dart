class AlarmSettings {
  const AlarmSettings({this.volume = 0.55});

  /// UI slider value in [0.0, 1.0].
  final double volume;

  AlarmSettings copyWith({double? volume}) {
    return AlarmSettings(volume: volume ?? this.volume);
  }

  Map<String, dynamic> toJson() => {'volume': volume};

  factory AlarmSettings.fromJson(Map<String, dynamic> json) {
    final value = (json['volume'] as num?)?.toDouble() ?? 0.55;
    return AlarmSettings(volume: value.clamp(0.0, 1.0));
  }
}
