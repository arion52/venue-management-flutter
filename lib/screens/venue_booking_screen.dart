import 'package:flutter/material.dart';
import '../models/venue.dart';
import '../services/venue_service.dart';
import 'dart:convert';

class VenueBookingScreen extends StatefulWidget {
  final Venue venue;

  const VenueBookingScreen({required this.venue, super.key});

  @override
  // ignore: library_private_types_in_public_api
  _VenueBookingScreenState createState() => _VenueBookingScreenState();
}

class _VenueBookingScreenState extends State<VenueBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _bookedByController = TextEditingController();
  final _bookingDurationController = TextEditingController();
  final _eventNameController = TextEditingController();
  final _eventDescriptionController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final VenueService _venueService = VenueService();

  bool _isBooking = false;

  // Date and Time picker method
  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        setState(() {
          _selectedDate = pickedDate;
          _selectedTime = pickedTime;
        });
      }
    }
  }

  // Method to combine the selected date and time into a DateTime object
  DateTime _combineDateAndTime(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book ${widget.venue.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _bookedByController,
                decoration: const InputDecoration(labelText: 'Your Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _eventNameController,
                decoration: const InputDecoration(labelText: 'Event Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the event name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _eventDescriptionController,
                decoration:
                    const InputDecoration(labelText: 'Event Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the event description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _bookingDurationController,
                decoration:
                    const InputDecoration(labelText: 'Duration (in hours)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a duration';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _selectDate,
                child: const Text('Select Booking Date and Time'),
              ),
              if (_selectedDate != null && _selectedTime != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    'Selected Date: ${_selectedDate!.toLocal()} at ${_selectedTime!.format(context)}',
                  ),
                ),
              const SizedBox(height: 16),
              _isBooking
                  ? const Center(
                      child:
                          CircularProgressIndicator()) // Show loading spinner
                  : ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _bookVenue();
                        }
                      },
                      child: const Text('Book Venue'),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  // Book Venue method with loading state and complete data submission
  Future<void> _bookVenue() async {
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a booking date and time')),
      );
      return;
    }

    setState(() {
      _isBooking = true; // Set loading state
    });

    final DateTime startDateTime =
        _combineDateAndTime(_selectedDate!, _selectedTime!);

    try {
      await _venueService.bookVenue(
        widget.venue.id,
        _bookedByController.text, // Person booking the venue
        DateTime.now(), // Current timestamp as 'booked_at'
        int.parse(_bookingDurationController.text), // Duration of booking
        _eventNameController.text, // Event name
        _eventDescriptionController.text, // Event description
        startDateTime, // Combined start date and time
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Venue booked successfully!')),
      );
      Navigator.pop(context); // Close the booking screen
    } catch (e) {
      String errorMessage = e.toString();

      try {
        // print("hi in try");
        // print("Error message before parsing: $errorMessage");

        // Remove any "Exception: " prefix if it exists
        if (errorMessage.startsWith("Exception: ")) {
          errorMessage = errorMessage.replaceFirst("Exception: ", "");
        }

        // Now, check if it starts with '{' and ends with '}' to confirm JSON format
        if (errorMessage.trim().startsWith("{") &&
            errorMessage.trim().endsWith("}")) {
          final errorJson = jsonDecode(errorMessage);
          // print("Parsed JSON error message: ${errorJson['error']}");
          errorMessage = errorJson['error'] ?? errorMessage;
        } else {
          print("Error message is not in JSON format.");
        }
      } catch (_) {
        // Leave the original error message if parsing fails
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } finally {
      setState(() {
        _isBooking = false; // Reset loading state
      });
    }
  }
}
