import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:project_ecommerce_tugas_akhir/event/event_pref.dart';
import 'package:project_ecommerce_tugas_akhir/model/order.dart';
import 'package:project_ecommerce_tugas_akhir/page/auth/login.dart';
import 'package:project_ecommerce_tugas_akhir/page/list_cart.dart';
import 'package:project_ecommerce_tugas_akhir/page/order/detail_order.dart';
// import '../backup/history.dart';
import 'package:project_ecommerce_tugas_akhir/page/order/transaction_success.dart';

import 'page/dashboard/dashboard.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        // home: ListCart(),
        home: FutureBuilder(
            future: EventPref.getUser(),
            builder: (context, snapshot) {
              if (snapshot.data == null) return Login();
              return Dashboard();
            })
        // home: Splashscreen(),
        // home: ListCartRestore(),
        );
  }
}
