import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project_ecommerce_tugas_akhir/config/asset.dart';
import 'package:http/http.dart' as http;
import 'package:project_ecommerce_tugas_akhir/controller/c_history.dart';
import 'package:project_ecommerce_tugas_akhir/page/order/detail_order.dart';

import '../../config/api.dart';
import '../../controller/c_user.dart';
import '../../model/order.dart';

class History extends StatefulWidget {
  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final _cUser = Get.put(CUser());

  final _cHistory = Get.put(CHistory());

  Future<List<Order>> getOrder() async {
    List<Order> listOrder = [];
    try {
      var response = await http.post(Uri.parse(Api.getHistory), body: {
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
    _cHistory.setList(listOrder);
    return listOrder;
  }

  void deleteHistory(int idOrder, String image) async {
    try {
      var response = await http.post(Uri.parse(Api.deleteOrder), body: {
        'id_cart': idOrder.toString(),
        'image': image, 
      });
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['success']) {
          print('delete id : $idOrder success');
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    _cHistory.selectedClear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0 ,
        title: const Text('Hostory'),
        backgroundColor: Asset.colorPrimary,
        actions: [
          GetBuilder(
            init: CHistory(),
            builder:(_) => _cHistory.selected.length > 0 ? IconButton(onPressed: () async {
              var response = await Get.dialog(AlertDialog(
                title: Text('Delete'),
                content: Text('You sure to delete selected history?'),
                actions: [
                  TextButton(onPressed: ()=> Get.back(), child: Text('No')),
                  TextButton(onPressed: ()=> Get.back(result: 'yes'), child: Text('No')),
                ],
              ));
              if (response=='yes') {
                _cHistory.list.forEach((order) {
                  if (_cHistory.selected.contains(order.idOrder)) {
                    deleteHistory(order.idOrder, order.image);
                  }
                });
                _cHistory.selectedClear();
              }
              setState(() {
                
              });
            }, icon: Icon(Icons.delete_forever)) : SizedBox())
        ],
      ),
      body: FutureBuilder(
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
                  
                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                leading: GetBuilder(
                  init: CHistory(),
                  builder: (controller) {
                    return IconButton(onPressed: () {
                      if (_cHistory.selected.contains(order.idOrder)) {
                        _cHistory.deleteSelected(order.idOrder);
                      } else {
                        _cHistory.addSelected(order.idOrder);
                      }
                    }, icon: Icon(
                      _cHistory.selected.contains(order.idOrder) ? Icons.check_box : Icons.check_box_outline_blank,
                      color:_cHistory.selected.contains(order.idOrder) ? Asset.colorPrimary : Colors.grey,
                    ));
                  },
                ),
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
        }),
    );
  }
}