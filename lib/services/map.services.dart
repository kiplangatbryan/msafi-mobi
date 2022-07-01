import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:collection';

class MapServices {
  final String key = "AIzaSyASBc-Ac9yrei1uG8iPF4DJvkQf8slxjlw";
  final String types = "geocode";

  Future<List> searchPlaces(String searchInput) async {
    try {
      final String url =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$searchInput&types=$types&key=$key";
      var response = await http.get(Uri.parse(url));
      print(response.body);
      var json = jsonDecode(response.body);
      // type casting
      var results = json['predictions'] as List;

      return results;
    } catch (err) {
      rethrow;
    }
  }
}
