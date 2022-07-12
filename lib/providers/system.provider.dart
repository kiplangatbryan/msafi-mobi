import 'package:flutter/cupertino.dart';

class AppState extends ChangeNotifier {
  String clientImageTapTag = "";
  String orderSearchTag = "";

  get clientTag => clientImageTapTag;
  get searchTag => orderSearchTag;

  void setTappedTag(String tag) {
    clientImageTapTag = tag;
    notifyListeners();
  }

  void setOrderSearchTag(String tag) {
    orderSearchTag = tag;
    notifyListeners();
  }
}
