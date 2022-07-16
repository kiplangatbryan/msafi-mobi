import 'package:flutter/material.dart';

class ExistingOrders extends ChangeNotifier {
  List orders = [];

  void populateOrders(List items) {
    orders = items;
  }
}
