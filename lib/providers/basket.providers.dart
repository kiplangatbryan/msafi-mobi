import 'package:flutter/cupertino.dart';

class Basket extends ChangeNotifier {
  List cart = [];
  List basket = [];
  List tracker = [];

  get bucketList => cart;
  get getBasket => basket;

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
    isCart
        ? cart[index]['count'] = cart[index]['count'] + 1
        : basket[index] = basket[index] + 1;
    notifyListeners();
  }

  void decreament(index) {
    basket[index] = basket[index] + 1;
    notifyListeners();
  }
}
