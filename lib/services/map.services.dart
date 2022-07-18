import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MapServices {
  final String? accessToken = dotenv.env['MAP_BOX_API_KEY'];
  final String types =
      "neighborhood,locality,place,district,postcode,address,poi";
  final proximity = {
    "ip": "ip",
  };

  Future<dynamic> searchPlaces(String searchInput) async {
    try {
      final String url =
          "https://api.mapbox.com/geocoding/v5/mapbox.places/$searchInput.json?proximity=${proximity['ip']}&types=$types&access_token=$accessToken";
      var response = await http.get(Uri.parse(url)).timeout(
            const Duration(seconds: 10),
          );
      // print(response.body);
      var json = jsonDecode(response.body);
      // type casting
      var results = json['features'] as List;
      print(results);

      return results;
    } on SocketException {
      return 2;
    } on TimeoutException {
      return 4;
    } on Error {
      return 5;
    }
  }

  Future<dynamic> searchPlace(String searchText) async {
    try {
      final String url =
          "https://api.mapbox.com/geocoding/v5/mapbox.places/$searchText.json?access_token=$accessToken";
      var response = await http.get(Uri.parse(url));
      // print(response.body);
      var json = jsonDecode(response.body);
      // type casting
      var results = json['features'] as List;
      print(results);

      return results[0];
    } on SocketException {
      return 2;
    } on TimeoutException catch (e) {
      return 4;
    } on Error catch (e) {
      return 5;
    }
  }
}
