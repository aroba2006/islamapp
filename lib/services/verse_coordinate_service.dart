// lib/services/verse_coordinate_service.dart

import 'dart:convert';
import 'package:flutter/services.dart';

class VerseCoordinateService {
  // A cache to store loaded coordinates
  static final Map<int, List<Map<String, dynamic>>> _coordinateCache = {};

  /// Loads and returns the coordinates for a specific Mushaf page.
  /// Coordinates are the [X, Y] start and end points of a verse on the image.
  static Future<List<Map<String, dynamic>>> getCoordinatesForPage(int pageNumber) async {
    // 1. Return cache if already loaded
    if (_coordinateCache.containsKey(pageNumber)) {
      return _coordinateCache[pageNumber]!;
    }

    // 2. Load the JSON file from assets
    try {
      // We will store coords in assets/json/coords_page_1.json, etc.
      final String jsonString = await rootBundle.loadString('assets/json/coords_page_$pageNumber.json');
      final List<dynamic> jsonData = jsonDecode(jsonString);
      
      // Parse and cache
      final List<Map<String, dynamic>> coordinates = List<Map<String, dynamic>>.from(jsonData);
      _coordinateCache[pageNumber] = coordinates;
      return coordinates;
    } catch (e) {
      // If file doesn't exist, return empty list
      print("Coordinates not found for page $pageNumber");
      return [];
    }
  }
}