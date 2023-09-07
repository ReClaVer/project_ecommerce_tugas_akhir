import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project_ecommerce_tugas_akhir/page/auth/login.dart';
import 'package:project_ecommerce_tugas_akhir/page/dashboard/dashboard.dart';

import 'asset.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen();

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    startSplashScreen();
  }

  startSplashScreen() async {
    var duration = const Duration(seconds: 5);
    return Timer(duration, () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
        return Dashboard();
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Asset.colorBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(width: 3, color: Asset.colorBorder)),
              child: Image.asset(
                'assets/icons/bag.png',
                height: 170,
                width: 170,
              ),
            ),
            Text(
              'E-commerce',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Asset.colorWhiteText,
              ),
            )
          ],
        ),
      ),
    );
  }
}
