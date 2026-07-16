class IntrusionEvent {
  const IntrusionEvent({
    required this.id,
    required this.timestamp,
    this.photoCaptured = false,
  });

  final String id;
  final DateTime timestamp;
  final bool photoCaptured;

  Map<String, dynamic> toJson() => {
        'id': id,
        'timestamp': timestamp.toIso8601String(),
        'photoCaptured': photoCaptured,
      };

  factory IntrusionEvent.fromJson(Map<String, dynamic> json) {
    return IntrusionEvent(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      photoCaptured: json['photoCaptured'] as bool? ?? false,
    );
  }
}
