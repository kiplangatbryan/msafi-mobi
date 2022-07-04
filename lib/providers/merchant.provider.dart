import 'package:flutter/material.dart';

class MerchantRoute extends ChangeNotifier {
  int currentPage = 0;

  get current => currentPage;

  void setCurrentPage(int page) {
    currentPage = page;
    notifyListeners();
  }
}
