// lib/screens/venue_booking_screen.dart

import 'package:flutter/material.dart';
import '../models/venue.dart';
import '../services/venue_service.dart';

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
  final _eventNameController = TextEditingController(); // Event name controller
  final _eventDescriptionController =
      TextEditingController(); // Event description controller
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final VenueService _venueService = VenueService();

  bool _isBooking = false; // For loading spinner during booking

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

  // Book Venue method with loading state
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

    final DateTime startDateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    try {
      await _venueService.bookVenue(
        widget.venue.id,
        _bookedByController.text,
        DateTime.now(),
        int.parse(_bookingDurationController.text),
        _eventNameController.text,
        _eventDescriptionController.text,
        startDateTime,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Venue booked successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to book venue')),
      );
    } finally {
      setState(() {
        _isBooking = false; // Reset loading state
      });
    }
  }
}
