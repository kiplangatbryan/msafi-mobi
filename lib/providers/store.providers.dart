import 'package:flutter/cupertino.dart';

class Store extends ChangeNotifier {
  List allStore = [];

  get count => allStore.length;
  get stores => allStore;

  void saveStores(List stores) {
    allStore = stores;
    notifyListeners();
  }
}
