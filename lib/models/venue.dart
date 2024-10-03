// lib/models/venue.dart

class Venue {
  final int id;
  final String name;

  Venue({
    required this.id,
    required this.name,
  });

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
      id: json['id'] as int,
      name: json['name'] ?? 'Unnamed Venue',
    );
  }
}
