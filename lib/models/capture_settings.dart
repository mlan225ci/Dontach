class CaptureSettings {
  const CaptureSettings({this.enabled = true});

  final bool enabled;

  CaptureSettings copyWith({bool? enabled}) {
    return CaptureSettings(enabled: enabled ?? this.enabled);
  }

  Map<String, dynamic> toJson() => {'enabled': enabled};

  factory CaptureSettings.fromJson(Map<String, dynamic> json) {
    return CaptureSettings(enabled: json['enabled'] as bool? ?? true);
  }
}
