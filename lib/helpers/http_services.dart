import 'package:msafi_mobi/helpers/custom_shared_pf.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'dart:async';
import 'dart:io';

String baseUrl() {
  return "http://10.0.2.2:3000/v1";
  // return "http://192.168.43.165:3000/v1";
}

Future<String> checkAndValidateAuthToken() async {
  final res = await CustomSharedPreferences().checkOrFetchUser();
  // if (res == null) {
  //   // big issue
  //   // probably route to login
  // }
  final data = json.decode(res!);
  final token = data['tokens']['access']['token'];
  final refresh = data['tokens']['refresh'];
  final expiry = DateTime.parse(data['tokens']['access']['expires']);

  if (DateTime.now().compareTo(expiry) < 0) {
    return token;
  }
  final response = await handleRefresh(refresh, data);

  if (response is String) {
    return response;
  }
  return "NaN";
}

Future<dynamic> handleRefresh(Map refreshData, Map user) async {
  final expiry = DateTime.parse(refreshData['expires']);

  if (DateTime.now().compareTo(expiry) < 0) {
    return requestTokenUsingRefreshToken(refreshData['token'], user);
  }
  return await Future.delayed(const Duration(seconds: 1), () => 5);
}

Future<dynamic> requestTokenUsingRefreshToken(String token, Map user) async {
  var url = Uri.parse('${baseUrl()}/auth/refresh-tokens');

  try {
    // send data to server
    final response = await http.post(url, body: {
      "refreshToken": token,
    }).timeout(
      const Duration(seconds: 10),
    );

    final data = json.decode(response.body);

    if (response.statusCode == 200) {
      final body = user;

      body['tokens'] = data;
      final userMap = json.encode(body);
      await CustomSharedPreferences().storeUser(userMap);

      return data['access']['token'];
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
