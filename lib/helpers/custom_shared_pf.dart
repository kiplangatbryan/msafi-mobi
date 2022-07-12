import 'package:shared_preferences/shared_preferences.dart';

class CustomSharedPreferences {
  // check if a user onboarded
  Future<bool> checkOnboarding() async {
    SharedPreferences localData = await SharedPreferences.getInstance();
    var state = localData.getInt("msafi-foot");

    return state != null ? true : false;
  }

  // set a value to show user has onboarded
  Future<bool> createdFootPrint() async {
    SharedPreferences localData = await SharedPreferences.getInstance();
    return localData.setInt("msafi-foot", 1);
  }

  // store user Object
  Future<bool> storeUser(userData) async {
    SharedPreferences localData = await SharedPreferences.getInstance();
    return localData.setString("IjMjKB", userData);
  }

// fetch user Object
  Future<String?> checkOrFetchUser() async {
    SharedPreferences localData = await SharedPreferences.getInstance();
    return localData.getString("IjMjKB");
  }

  Future<bool> logout() async {
    SharedPreferences localData = await SharedPreferences.getInstance();
    return await localData.remove('IjMjKB');
  }
}
