import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:project_ecommerce_tugas_akhir/controller/c_order_now.dart';
import 'package:project_ecommerce_tugas_akhir/page/order/confirmation.dart';

import '../../config/asset.dart';

class OrderNow extends StatelessWidget {
  final List<Map<String, dynamic>> listShop;
  final double total;
  final List<int> listIdCart;
  OrderNow(
      {required this.listShop, required this.total, required this.listIdCart});

  final List<String> _listDelivery = ['JNE', 'JNT', 'Si Cepat'];
  final List<String> _listPayment = ['Alfamart', 'Transfer Bank', 'ApparelPay'];
  final COrderNow _cOrderNow = Get.put(COrderNow());
  var _controllerNote = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Asset.colorPrimary,
        titleSpacing: 0,
        title: Text('Order Now'),
      ),
      body: ListView(
        children: [
          buildListShop(),
          const SizedBox(
            height: 30,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Delivery',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Column(
              children: _listDelivery.map((itemDelivery) {
            return Obx(() => RadioListTile<String>(
                activeColor: Asset.colorPrimary,
                dense: true,
                title: Text(
                  itemDelivery,
                  style: TextStyle(fontSize: 16),
                ),
                value: itemDelivery,
                groupValue: _cOrderNow.delivery,
                onChanged: (value) {
                  _cOrderNow.setDelivery(value!);
                }));
          }).toList()),
          const SizedBox(
            height: 16,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Payment',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Column(
              children: _listPayment.map((itemPayment) {
            return Obx(() => RadioListTile<String>(
                activeColor: Asset.colorPrimary,
                dense: true,
                title: Text(
                  itemPayment,
                  style: TextStyle(fontSize: 16),
                ),
                value: itemPayment,
                groupValue: _cOrderNow.payment,
                onChanged: (value) {
                  _cOrderNow.setPayment(value!);
                }));
          }).toList()),
          const SizedBox(
            height: 16,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Note',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: TextField(
              controller: _controllerNote,
              decoration: InputDecoration(
                  hintText: 'Your note..',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          color: Asset.colorPrimary, width: 2))),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Material(
              color: Asset.colorPrimary,
              borderRadius: BorderRadius.circular(30),
              child: InkWell(
                onTap: () {
                  Get.to(Confirmation(
                    listIdCart: listIdCart,
                    listShop: listShop,
                    total: total,
                    delivery: _cOrderNow.delivery,
                    note: _controllerNote.text,
                    payment: _cOrderNow.payment,
                  ));
                },
                borderRadius: BorderRadius.circular(30),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  child: Row(
                    children: [
                      Text(
                        '\$ ${total.toStringAsFixed(2)}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Text(
                        'Pay Now',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      Icon(
                        Icons.navigate_next,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }

  Widget buildListShop() {
    return Column(
      children: List.generate(listShop.length, (index) {
        Map<String, dynamic> item = listShop[index];
        return Container(
          margin: EdgeInsets.fromLTRB(
            16,
            index == 0 ? 16 : 8,
            16,
            index == listShop.length - 1 ? 16 : 8,
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                    offset: Offset(0, 0), blurRadius: 6, color: Colors.black26),
              ]),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
                child: FadeInImage(
                  height: 90,
                  width: 80,
                  fit: BoxFit.cover,
                  placeholder: const AssetImage(Asset.imageBox),
                  image: NetworkImage(item['image']),
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 90,
                      width: 80,
                      alignment: Alignment.center,
                      child: const Icon(Icons.broken_image),
                    );
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['name'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        '${item['size']}, ${item['color']}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        '\$ ' +
                            (item['item_total'] as double).toStringAsFixed(2),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Asset.colorPrimary),
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                item['quantity'].toString(),
                style: const TextStyle(fontSize: 18),
              ),
              SizedBox(
                width: 16,
              )
            ],
          ),
        );
      }),
    );
  }
}
