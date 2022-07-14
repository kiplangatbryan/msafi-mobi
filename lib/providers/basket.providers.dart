import 'package:flutter/cupertino.dart';

class Basket extends ChangeNotifier {
  List cart = [];
  List basket = [];
  List tracker = [];
  double total = 0;
  late int selectedMart;
  late List pricing;

  get bucketList => cart;
  get getBasket => basket;
  get getTotal => total;

  void calculateTotal() {
    total = 0;
    for (var i = 0; i < basket.length; i++) {
      if (basket[i] > 0) {
        total += (basket[i] * pricing[i]['price']);
      }
    }
    notifyListeners();
  }

  List<Map> listOfClothes() {
    List<Map> clothes = [];

    for (var i = 0; i < basket.length; i++) {
      if (basket[i] > 0) {
        clothes.add({
          ...pricing[i],
          "count": basket[i],
        });
      }
    }

    return clothes;
  }

  void setPricing(List prices) {
    pricing = prices;
  }

  void createBucket(List items) {
    basket = items; // [ 0,0,0]
  }

  void populateTracker(List data) {
    tracker = data;
    notifyListeners();
  }

  void fillBusket(List items) {
    cart = items;
    notifyListeners();
  }

  void increament({required int index, bool isCart = false}) {
    if (isCart) {
      basket[index] = basket[index] + 1;
      calculateTotal();
    } else {
      basket[index] = basket[index] + 1;
    }
    notifyListeners();
  }

  void decreament({required int index, bool isCart = false}) {
    if (basket[index] > 0) {
      if (isCart) {
        basket[index] = basket[index] - 1;
        calculateTotal();
      } else {
        basket[index] = basket[index] - 1;
      }
    }
    notifyListeners();
  }
}
