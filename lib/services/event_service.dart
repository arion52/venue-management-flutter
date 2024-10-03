// lib/services/event_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/event.dart';

class EventService {
  static const String baseUrl = 'http://127.0.0.1:8000/api/events';

  Future<List<Event>> getEvents() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List body = jsonDecode(response.body);
      return body.map((item) => Event.fromJson(item)).toList();
    } else {
      throw Exception("Failed to load events");
    }
  }
}