import 'package:shared_preferences/shared_preferences.dart';

class CustomSharedPreferences {
  Future<bool> checkOnboarding() async {
    SharedPreferences localData = await SharedPreferences.getInstance();

    print(localData);

    // ignore: unused_local_variable
    var state = localData.getInt("msafi-state");

    return state != null ? true : false;
  }
}
