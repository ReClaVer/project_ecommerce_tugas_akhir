import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:project_ecommerce_tugas_akhir/page/dashboard/dashboard.dart';

import '../../config/asset.dart';

class TransactionSuccess extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Transaksi\nSukses',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Asset.colorTextTile,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
              SizedBox(
                height: 30,
              ),
              Material(
                elevation: 8,
                color: Asset.colorPrimary,
                borderRadius: BorderRadius.circular(30),
                child: InkWell(
                  onTap: () => Get.offAll(Dashboard()),
                  borderRadius: BorderRadius.circular(30),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    child: Text(
                      'Home',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
