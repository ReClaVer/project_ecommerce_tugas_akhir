import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project_ecommerce_tugas_akhir/controller/c_user.dart';
import 'package:http/http.dart' as http;
import 'package:project_ecommerce_tugas_akhir/page/order/history.dart';

import '../../config/api.dart';
import '../../config/asset.dart';
import '../../model/order.dart';
import '../order/detail_order.dart';

class FragmentOrder extends StatefulWidget {
  @override
  State<FragmentOrder> createState() => _FragmentOrderState();
}

class _FragmentOrderState extends State<FragmentOrder> {
  final _cUser = Get.put(CUser());

  Future<List<Order>> getOrder() async {
    List<Order> listOrder = [];
    try {
      var response = await http.post(Uri.parse(Api.getOrder), body: {
        'id_user': _cUser.user.idUser.toString(),
      });
      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        if (responseBody['success']) {
          (responseBody['data'] as List).forEach((element) {
            listOrder.add(Order.fromJson(element));
          });
        }
      }
    } catch (e) {
      print(e);
    }
    return listOrder;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 8, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Order',
                  style: TextStyle(
                      color: Asset.colorTextTile,
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                ),
                IconButton(
                    onPressed: () => Get.to(History()),
                    icon: const Icon(
                      Icons.history,
                      color: Asset.colorTextTile,
                    )),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Transaction you do',
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
            ),
          ),
          Expanded(child:buildListOrder() )
    ]);
  }

   Widget buildListOrder() {
    return FutureBuilder(
        future: getOrder(),
        builder: (context, AsyncSnapshot<List<Order>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data == null) {
            return const Center(
              child: Text('Empty'),
            );
          }
          if (snapshot.data!.length > 0) {
            List<Order> listOrder = snapshot.data!;
            return ListView.separated(
            padding: EdgeInsets.all(16),
            separatorBuilder: (context, index) {
              return Divider(height: 1,thickness: 1);
            },
            itemCount: listOrder.length,
            itemBuilder: (context, index) {
              Order order = listOrder[index];
              return ListTile(
                onTap: () => Get.to(DetailOrder(order: order))!.then((value) => setState(() {})),
                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                title: Text('\$ ${order.total}',style: TextStyle(fontSize: 16,color: Asset.colorPrimary,fontWeight: FontWeight.bold),),
                trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                  children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(DateFormat('dd/MM/yy').format(order.dateTime)),
                      SizedBox(height: 4,),
                      Text(DateFormat('HH:mm').format(order.dateTime))
                    ],
                  ),
                  Icon(Icons.navigate_next,color: Asset.colorPrimary,)
                ],),
              );
            });
          } else {
            return const Center(child: Text('Empty'));
          }
        });
  }
}
