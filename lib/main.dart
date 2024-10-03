// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/main_menu_screen.dart'; // Import the main menu screen

void main() {
  runApp(const VenueBookingApp());
}

class VenueBookingApp extends StatelessWidget {
  const VenueBookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Venue Booking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainMenuScreen(), // Set MainMenuScreen as the home screen
    );
  }
}
