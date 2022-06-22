import 'package:flutter/cupertino.dart';

class MartConfig extends ChangeNotifier {
  late final String name;
  late final String description;
  late final String imgUrl;
  final List<Map> selectedClothes = [];

  int get count => selectedClothes.length;

  List<Map> get getClothes => selectedClothes;

  void setName(String name) {
    name = name;
  }

  void setDescription(String description) {
    description = description;
  }

  void setImgUrl(String imgUrl) {
    imgUrl = imgUrl;
  }

  void mapSelectedItems(List<Map> selected) {
    selectedClothes.addAll(selected);
    notifyListeners();
  }
}
