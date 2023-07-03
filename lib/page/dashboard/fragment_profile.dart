import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_ecommerce_tugas_akhir/event/event_pref.dart';
import 'package:project_ecommerce_tugas_akhir/page/auth/login.dart';

import '../../config/asset.dart';
import '../../controller/c_user.dart';

class FragmentProfile extends StatelessWidget {
  final _cUser = Get.put(CUser());

  void logout() async {
    var response = await Get.dialog(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('You sure to logout?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('No')),
          TextButton(
              onPressed: () => Get.back(result: 'yes'),
              child: const Text('Yes')),
        ],
      ),
    );
    if (response == 'yes') {
      EventPref.deleteUser().then((value) {
        Get.off(Login());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(30),
      children: [
        const SizedBox(
          height: 30,
        ),
        Center(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(width: 3, color: Asset.colorAccent)),
            child: const Icon(
              Icons.account_circle,
              size: 150,
              color: Asset.colorAccent,
            ),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        buildItemProfile(Icons.person, _cUser.user.name),
        const SizedBox(
          height: 16,
        ),
        buildItemProfile(Icons.email, _cUser.user.email),
        const SizedBox(
          height: 16,
        ),
        Center(
          child: Material(
            color: Asset.colorPrimary,
            borderRadius: BorderRadius.circular(30),
            child: InkWell(
              onTap: () => logout(),
              borderRadius: BorderRadius.circular(30),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                child: Text(
                  'LOGOUT',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget buildItemProfile(IconData icon, String data) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30), color: Asset.colorAccent),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 30,
            color: Asset.colorPrimary,
          ),
          const SizedBox(
            width: 16,
          ),
          Text(
            data,
            style: const TextStyle(fontSize: 16),
          )
        ],
      ),
    );
  }
}
