import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/venue.dart';

class VenueService {
  static const String baseUrl = 'http://127.0.0.1:8000/api/venues';

  // Fetch the list of venues
  Future<List<Venue>> getVenues() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List body = jsonDecode(response.body);
      return body.map((item) => Venue.fromJson(item)).toList();
    } else {
      throw Exception("Failed to load venues");
    }
  }

  // Book a venue
  Future<void> bookVenue(
    int venueId,
    String bookedBy,
    DateTime bookedAt,
    int bookingDuration,
    String eventName, // Add event name
    String eventDescription, // Add event description
    DateTime startTime, // Add start time
  ) async {
    final url = '$baseUrl/$venueId/book/';

    final response = await http.patch(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'booked_by': bookedBy,
        'booked_at': bookedAt.toIso8601String().split('.').first,
        'booking_duration': bookingDuration,
        'event_name': eventName,
        'event_description': eventDescription,
        'start_time': startTime.toIso8601String().split('.').first,
      }),
    );

    if (response.statusCode != 200) {
      // print('Response: ${response.body}');
      throw Exception(response.body);
    }
  }
}
