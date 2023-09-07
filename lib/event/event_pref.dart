import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user.dart';

class EventPref {
  static Future<User?> getUser() async {
    User? user;
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? stringUser = pref.getString('user');
    if (stringUser != null) {
      Map<String, dynamic> mapUser = jsonDecode(stringUser);
      user = User.fromJson(mapUser);
      var idUser = mapUser['id_user'];
      print(idUser);
    }
    return user;
  }

  static Future<void> saveUser(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String stringUser = jsonEncode(user.toJson());
    await pref.setString('user', stringUser);
  }

  static Future<void> deleteUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.remove('user');
  }
}
