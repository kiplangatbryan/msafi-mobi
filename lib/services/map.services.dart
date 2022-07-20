import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../helpers/http_services.dart';

class MapServices {
  final String? accessToken = dotenv.env['MAP_BOX_API_KEY'];
  final String types =
      "neighborhood,locality,place,district,postcode,address,poi";
  final proximity = {
    "ip": "ip",
  };

  Future<dynamic> searchPlaces(String searchInput) async {
    try {
      Response response = await httHelper().get(
          "https://api.mapbox.com/geocoding/v5/mapbox.places/$searchInput.json?proximity=${proximity['ip']}&types=$types&access_token=$accessToken");

      // print(response.body);
      var json = response.data;
      // type casting
      var results = json['features'] as List;

      return results;
    } on DioError catch (err) {
      if (err.type == DioErrorType.connectTimeout) {
        return 2;
      }
      if (err.type == DioErrorType.receiveTimeout) {
        return 4;
      }
      return 5;
    }
  }

  Future<dynamic> searchPlace(String searchText) async {
    try {
      Response response = await httHelper().get(
          "https://api.mapbox.com/geocoding/v5/mapbox.places/$searchText.json?access_token=$accessToken");

      var json = response.data;
      // type casting
      var results = json['features'] as List;

      return results[0];
    } on DioError catch (err) {
      if (err.type == DioErrorType.connectTimeout) {
        return 2;
      }
      if (err.type == DioErrorType.receiveTimeout) {
        return 4;
      }
      return 5;
    }
  }
}
