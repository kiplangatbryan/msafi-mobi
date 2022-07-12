import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';

import '../helpers/http_services.dart';

class StoreService {
  Future<dynamic> search(String text, String token) async {
    // parse url
    final url = Uri.parse('${baseUrl()}/store/search?q=$text');

    // define request headers
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
    try {
      // send search request
      final response = await http.get(url, headers: headers).timeout(
            const Duration(seconds: 10),
          );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        print(data);
      } else {
        // reauthenticate using refresh token
        return 5;
      }
    } on SocketException {
      return 1;
      // retry
    } on TimeoutException catch (e) {
      // retry
      return 2;
    } on Error catch (e) {
      // finish
      return 5;
    }
  }
}
