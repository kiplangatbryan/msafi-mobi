import 'package:flutter/cupertino.dart';

class Order extends ChangeNotifier {
  List clothes = [];
  double amount = 0;
  String stationId = "";
  Map stationAdress = {};
  late DateTime expectedDate;
  late String paymentId;
  late String storeId;
  bool paid = false;
  String phone = "";

  get getAmount => amount;
  get clothesArray => clothes;

  void setClothes(List arr) {
    clothes = arr;
  }

  void setAmount(double tot) {
    amount = tot;
  }

  setExpectedData(dynamic time) {
    expectedDate = time;
  }

  setPhoneNumber(String phoneCont) {
    phone = phoneCont;
  }

  void setStation(Map address) {
    stationAdress = address;
  }

  void setPaid(bool val) {
    paid = val;
  }

  void setStore(String id) {
    storeId = id;
  }
}

class Stations extends ChangeNotifier {
  List pickUps = [];

  get getPickUps => pickUps;

  void setPickUps(List picks) {
    pickUps = picks;
  }
}
