// lib/models/event.dart

class Event {
  final int id;
  final String name;
  final String description;
  final String venue; // Venue name as a String
  final DateTime startTime;
  final DateTime endTime;
  final int duration;

  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.venue, // It's just a name now, not a venue object
    required this.startTime,
    required this.endTime,
    required this.duration,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as int,
      name: json['name'] ?? 'Unnamed Event',
      description: json['description'] ?? 'No description',
      venue: json['venue'] ?? 'Unknown Venue', // Venue is a string
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      duration: json['duration'] ?? 0,
    );
  }
}
