import 'package:shared_preferences/shared_preferences.dart';

class CustomSharedPreferences {
  Future<bool> checkOnboarding() async {
    SharedPreferences localData = await SharedPreferences.getInstance();
    // ignore: unused_local_variable
    var state = localData.getString("footprint");

    return state != null ? true : false;
  }

  Future<bool> createdFootPrint(userId) async {
    SharedPreferences localData = await SharedPreferences.getInstance();
    return localData.setString("footprint", userId);
  }
}
