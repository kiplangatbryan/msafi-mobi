import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../helpers/http_services.dart';

class MartConfig extends ChangeNotifier {
  late String bsname;
  late String description;
  late String address;
  List<Map> locations = [
    {
      "name": "West Side",
      "stationImg": "/blank/choli.png",
      "long": "1.000245",
      "lat": "2.546467",
    }
  ];
  late List pricing;
  String storeImg = "/blank/choli.png";
  List<Map> selectedClothes = [];

// getters
  int get count => selectedClothes.length;
  List<Map> get getClothes => selectedClothes;
  get uname => bsname;
  get uaddress => address;
  get udescription => description;
  get ulocations => locations;
  get ustoreImg => storeImg;
  get upricing => pricing;

  void setName(String name) {
    bsname = name;
    notifyListeners();
  }

  void setDescription(String info) {
    description = info;
    notifyListeners();
  }

  void setAddress(String addr) {
    address = addr;
    notifyListeners();
  }

  // void setLocations(List loc) {
  //   locations = loc;
  //   notifyListeners();
  // }

  void setPricing(List prices) {
    pricing = prices;
    notifyListeners();
  }

  // void setStoreImg(String img) {
  //   storeImg = img;
  //   notifyListeners();
  // }

  void mapSelectedItems(List<Map> selected) {
    selectedClothes = selected;
    notifyListeners();
  }

  // push changes to server
  Future<int> createOrUpdateStore(String token) async {
    var url = Uri.parse('${baseUrl()}/store/createStore');

    final data = {
      "name": uname,
      "address": uaddress,
      "description": udescription,
      "pricing": upricing,
      "locations": ulocations,
      "storeImg": ustoreImg,
    };
    final body = json.encode(data);

    try {
      // send data to server
      final response = await http.post(url, body: body, headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "Bearer $token",
      }).timeout(
        const Duration(seconds: 5),
      );

      if (response.statusCode == 201) {
        return 0;
      } else {
        return 1;
      }
    } on SocketException {
      return 2;
    } on TimeoutException catch (e) {
      return 3;
    } on Error catch (e) {
      return 5;
    }
  }
}

class MerchantRoute extends ChangeNotifier {
  int currentPage = 0;
  bool autoFocus = false;

  get current => currentPage;
  get autoFocusState => autoFocus;

  void setCurrentPage(int page) {
    currentPage = page;
    notifyListeners();
  }

  void setAutoFocusState(bool value) {
    autoFocus = value;
    notifyListeners();
  }
}
