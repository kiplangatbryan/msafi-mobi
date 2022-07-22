import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../helpers/custom_shared_pf.dart';

class User extends ChangeNotifier {
  Person? user;
  bool isLoggedIn = false;

// getters
  get email => user?.email;
  get name => user?.name;
  get role => user?.role;
  get status => user?.status;
  get loggedIn => isLoggedIn;

// setter
  Future<bool> createUser(Map body) async {
    // connvert to json string
    final uToken = json.encode(body);
    // persist in localstorage
    final result = await CustomSharedPreferences().createdFootPrint();
    final status = await CustomSharedPreferences().storeUser(uToken);

    if (result && status) {
      user = Person(
        email: body['user']['email'],
        id: body['user']['id'],
        name: body['user']['name'],
        status: body['user']['status'],
        role: body['user']['role'],
        imgUrl: body['user']['imgUrl'] ?? "",
      );
      isLoggedIn = true;
      notifyListeners();
      return true;
    }
    return await Future.delayed(
      const Duration(seconds: 1),
      () => false,
    );
  }
}

// class containing user
class Person {
  String role;
  String name;
  String email;
  String status;
  String id;
  String imgUrl;
  Person({
    required this.email,
    required this.id,
    required this.status,
    required this.role,
    required this.name,
    required this.imgUrl,
  });
}
