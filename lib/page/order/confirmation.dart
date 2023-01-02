import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:project_ecommerce_tugas_akhir/page/order/transaction_success.dart';
import 'package:project_ecommerce_tugas_akhir/widget/info_message.dart';
import 'package:project_ecommerce_tugas_akhir/controller/c_user.dart';
import 'package:project_ecommerce_tugas_akhir/model/order.dart';

import '../../config/api.dart';
import '../../config/asset.dart';

class Confirmation extends StatelessWidget {
  final List<Map<String, dynamic>> listShop;
  final double total;
  final List<int> listIdCart;
  final String delivery;
  final String payment;
  final String note;
  Confirmation(
      {super.key,
      required this.listShop,
      required this.listIdCart,
      required this.total,
      required this.delivery,
      required this.payment,
      required this.note});

  final RxList<int> _imageByte = <int>[].obs;
  final RxString _imageName = ''.obs;

  void setImage(Uint8List newImage) => _imageByte.value = newImage;
  Uint8List get imageByte => Uint8List.fromList(_imageByte);
  void setImageName(String newName) => _imageName.value = newName;
  String get imageName => _imageName.value;

  CUser _cUser = Get.put(CUser());

  void PickImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setImage(bytes);
      setImageName(path.basename(pickedFile.path));
      print(imageByte);
    }
  }

  Future<void> addOrder() async {
    String stringListShop =
        listShop.map((e) => jsonEncode(e)).toList().join('||');
    Order order = Order(
        arrived: '',
        dateTime: DateTime.now(),
        delivery: delivery,
        idOrder: 1,
        idUser: _cUser.user.idUser,
        image: imageName,
        listShop: stringListShop,
        payment: 1,
        note: note,
        total: total);

    try {
      var response = await http.post(Uri.parse(Api.addOrder),
          body: order.toJson(base64Encode(imageByte)));

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['success']) {
          Get.to(TransactionSuccess());
          listIdCart.forEach((idCart) => deleteCart(idCart));
        } else {
          infoMessage.snackbar(Get.context!, 'Failed add Order');
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void deleteCart(int idCart) async {
    try {
      var response = await http.post(Uri.parse(Api.deleteCart), body: {
        'id_cart': idCart.toString(),
      });
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        print(responseBody['success']);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Add Transfer Photo',
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
                onTap: () => PickImage(),
                borderRadius: BorderRadius.circular(30),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  child: Text(
                    'PICK IMAGE',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Obx(() => ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.3,
                    maxWidth: MediaQuery.of(context).size.width * 0.8),
                child: imageByte.length > 0
                    ? Image.memory(
                        imageByte,
                        fit: BoxFit.contain,
                      )
                    : Placeholder())),
            SizedBox(
              height: 30,
            ),
            // Container(
            //   width: MediaQuery.of(context).size.width - 70,
            //   height: 200,
            //   decoration: BoxDecoration(
            //       border: Border.all(width: 1, color: Colors.black),
            //       borderRadius: BorderRadius.circular(12)),
            // ),
            Obx(() => Material(
                  elevation: 8,
                  color:
                      imageByte.length > 0 ? Asset.colorPrimary : Colors.grey,
                  borderRadius: BorderRadius.circular(30),
                  child: InkWell(
                    onTap: imageByte.length > 0
                        ? () {
                            addOrder();
                          }
                        : null,
                    borderRadius: BorderRadius.circular(30),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      child: Text(
                        'CONFIRMATION',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
