import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class PlacesResults extends ChangeNotifier {
  List allReturnedResults = [];

  void setResults(allPlaces) {
    allReturnedResults = allPlaces;
    notifyListeners();
  }
}

class SearchToggle extends ChangeNotifier {
  bool searchToggle = false;

  void toggleSearch() {
    searchToggle = !searchToggle;
    notifyListeners();
  }
}
