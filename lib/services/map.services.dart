import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MapServices {
  final String? accessToken = dotenv.env['MAP_BOX_API_KEY'];
  final String types = "place,postcode,address,poi";
  final proximity = {
    "ip": "ip",
  };

  Future<List> searchPlaces(String searchInput) async {
    try {
      final String url =
          "https://api.mapbox.com/geocoding/v5/mapbox.places/$searchInput.json?proximity=${proximity['ip']}&types=$types&access_token=$accessToken";
      var response = await http.get(Uri.parse(url));
      // print(response.body);
      var json = jsonDecode(response.body);
      // type casting
      var results = json['features'] as List;

      return results;
    } catch (err) {
      rethrow;
    }
  }
}
