import 'package:dio/dio.dart';
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
  late String bsphone;
  List<Map> locations = [];
  late List pricing;
  late List storeImg;
  List<Map> selectedClothes = [];
  late Map payment;
  late String storeId;

// getters
  int get count => selectedClothes.length;
  List<Map> get getClothes => selectedClothes;
  get uname => bsname;
  get uaddress => address;
  get udescription => description;
  get ulocations => locations;
  get ustoreImg => storeImg;
  get upricing => pricing;
  get paymentMethod => payment;
  get id => storeId;
  get phone => bsphone;

  void setName(String name) {
    bsname = name;
    notifyListeners();
  }

  void setPhone(String name) {
    bsphone = name;
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

  void setLocations(List<Map<dynamic, dynamic>> loc) {
    locations = loc;
    notifyListeners();
  }

  void setPricing(List prices) {
    pricing = prices;
    notifyListeners();
  }

  void setStoreImg(List img) {
    storeImg = img;
    notifyListeners();
  }

  void setPayments(Map pay) {
    payment = pay;
  }

  void setStoreId(String id) {
    storeId = id;
  }

  void mapSelectedItems(List<Map> selected) {
    selectedClothes = selected;
    notifyListeners();
  }

  void populateStore(Map data) {
    setName(data['name']);
    setDescription(data['description']);
    setAddress(data['address']);
    setPricing(data['pricing']);
    setStoreImg(data['storeImg']);
    setStoreImg(data['storeImg']);
    setPayments(data['payment']);
    setStoreId(data['id']);
  }

  // push changes to server
  Future<int> createOrUpdateStore(String token) async {
    var url = Uri.parse('${baseUrl()}/store/createStore');

    final data = {
      "name": uname,
      "address": uaddress,
      "description": udescription,
      "pricing": upricing,
      "storeImg": ustoreImg,
      "phone": bsphone,
      "locations": ulocations,
    };
    final body = json.encode(data);

    final dio = Dio();
    // FormData formData = FormData.fromMap({
    //   "avatar": await MultipartFile.fromFile(
    //     imageFile.path,
    //     filename: fileName,
    //     contentType: MediaType("image", "jpeg"), //important
    //   ),
    // });

    try {
      // send data to server
      final response = await dio.post("${baseUrl()}/store/createStore",
          // data: formData,
          options: Options(headers: {"Authorization": "Bearer $token"}));

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
