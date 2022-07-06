import 'package:msafi_mobi/helpers/custom_shared_pf.dart';

import 'dart:convert';

String baseUrl() {
  return "http://10.0.2.2:3000/v1";
}

Future<String> checkAndValidateAuthToken() async {
  final res = await CustomSharedPreferences().checkOrFetchUser();
  // if (res == null) {
  //   // big issue
  //   // probably route to login
  // }
  final data = json.decode(res!);

  return data['tokens']['access']['token'];
}
