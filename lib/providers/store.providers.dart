import 'package:flutter/cupertino.dart';

class Store extends ChangeNotifier {
  List allStore = [];

  void saveStores(List stores) {
    allStore = stores;
    notifyListeners();
  }
}
