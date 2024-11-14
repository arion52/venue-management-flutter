// lib/screens/venue_list_screen.dart

// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import '../models/venue.dart';
import '../services/venue_service.dart';
import 'venue_booking_screen.dart'; // Screen for handling venue booking

class VenueListScreen extends StatefulWidget {
  const VenueListScreen({super.key});

  @override
  _VenueListScreenState createState() => _VenueListScreenState();
}

class _VenueListScreenState extends State<VenueListScreen> {
  final VenueService _venueService = VenueService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Venues'),
      ),
      body: FutureBuilder<List<Venue>>(
        future: _venueService.getVenues(), // Fetch the list of venues
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final venues = snapshot.data!;
            return ListView.builder(
              itemCount: venues.length,
              itemBuilder: (context, index) {
                final venue = venues[index];
                return ListTile(
                  title: Text(venue.name), // Display the venue's name
                  subtitle: venue.isBooked
                      ? const Text('Booked',
                          style: TextStyle(color: Colors.red))
                      : const Text('Available',
                          style: TextStyle(color: Colors.green)),
                  trailing: ElevatedButton(
                    onPressed: venue.isBooked
                        ? null // Disable button if the venue is booked
                        : () {
                            _navigateToBooking(
                                context, venue); // Navigate to booking screen
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          venue.isBooked ? Colors.grey : Colors.blue,
                    ),
                    child: Text(venue.isBooked ? 'Booked' : 'Book Venue'),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No venues available'));
          }
        },
      ),
    );
  }

  void _navigateToBooking(BuildContext context, Venue venue) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VenueBookingScreen(
            venue: venue), // Pass the venue to the booking screen
      ),
    );
  }
}
