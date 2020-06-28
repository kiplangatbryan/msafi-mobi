import 'package:flutter/cupertino.dart';

class MartConfig extends ChangeNotifier {
  late final String name;
  late final String description;
  late final String address;
  final List<Map> selectedClothes = [];

  int get count => selectedClothes.length;

  List<Map> get getClothes => selectedClothes;

  void setName(String name) {
    name = name;
  }

  void setDescription(String description) {
    description = description;
  }

  void setAddress(String address) {
    address = address;
  }

  void mapSelectedItems(List<Map> selected) {
    selectedClothes.addAll(selected);
    notifyListeners();
  }
}
