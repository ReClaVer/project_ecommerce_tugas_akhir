import 'package:project_ecommerce_tugas_akhir/event/event_pref.dart';
import 'package:project_ecommerce_tugas_akhir/model/user.dart';
import 'package:get/get.dart';

class CUser extends GetxController {
  final Rx<User> _user = User(0, '', '', '').obs;

  User get user => _user.value;

  void getUser() async {
    User? user = await EventPref.getUser();
    _user.value = user!;
  }
}
