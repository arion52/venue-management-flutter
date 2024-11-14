// lib/models/venue.dart

class Venue {
  final int id;
  final String name;
  final bool isBooked; // Add this field

  Venue({
    required this.id,
    required this.name,
    required this.isBooked, // Initialize this field
  });

  // Add isBooked to fromJson for JSON deserialization
  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
      id: json['id'],
      name: json['name'],
      isBooked: json['is_booked'], // Access 'is_booked' from the JSON response
    );
  }
}
