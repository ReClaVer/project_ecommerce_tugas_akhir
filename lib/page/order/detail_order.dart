import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project_ecommerce_tugas_akhir/config/asset.dart';
import 'package:http/http.dart' as http;
import '../../config/api.dart';
import '../../model/order.dart';

class DetailOrder extends StatefulWidget {
     final Order order;
    DetailOrder({required this.order});

  @override
  State<DetailOrder> createState() => _DetailOrderState();
}

class _DetailOrderState extends State<DetailOrder> {
    RxString _arrived = ''.obs;

    String get arrived => _arrived.value;

    updateArrived(String newArrived) => _arrived.value = newArrived;

    void dialogConfirmArrived () async {
      if (widget.order.arrived!='Arrived') {
    var response = await Get.dialog(AlertDialog(
        title: Text('Set Arrived'),
        content: Text('Has your order arrived?'),
        actions: [
          TextButton(onPressed: ()=>Get.back(), child: Text('No')),
          TextButton(onPressed: ()=>Get.back(result: 'Yes'), child: Text('Yes')),
        ],
      ));
      if (response=='yes') {
        setArrived();
      }
    }
      
    }

    void setArrived() async {
      try {
      var response = await http.post(Uri.parse(Api.setArrived), body: {
        'id_order': widget.order.idOrder.toString(),
      });
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['success']) {
         updateArrived('Arrived');
        }
      }
    } catch (e) {
      print(e);
    }
    
  }

  @override
  void initState() {
    updateArrived(widget.order.arrived);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Asset.colorPrimary,
        titleSpacing: 0,
        title: Text(DateFormat('dd/MM/yyyy - HH:mm').format(widget.order.dateTime)),
        actions: [
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            child: InkWell(
              onTap: () => dialogConfirmArrived(),
              borderRadius: BorderRadius.circular(30),
              child: Padding(
                padding: EdgeInsets.fromLTRB(8, 8, 16, 8),
                child: Row(
                  children: [
                    
                    Text('Arrived',style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),),
                    SizedBox(width: 8,),
                    Obx(() => arrived == 'Arrived' ? Icon(Icons.check_circle,color: Asset.colorPrimary,):Icon(Icons.help,color: Colors.grey,)),
                  ],
                ),
                
                ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildListShop(),
              SizedBox(height: 16,),
              buildTitle('Delivery'),
              SizedBox(height: 8,),
              buildContent(widget.order.delivery),
              buildListShop(),
              SizedBox(height: 16,),
              buildTitle('Payment'),
              SizedBox(height: 8,),
              buildContent(widget.order.payment),
              buildListShop(),
              SizedBox(height: 16,),
              buildTitle('Note'),
              SizedBox(height: 8,),
              buildContent(widget.order.note??''),
              buildListShop(),
              SizedBox(height: 16,),
              buildTitle('Total'),
              SizedBox(height: 8,),
              buildContent('\$ ${widget.order.total}'),
              buildListShop(),
              SizedBox(height: 16,),
              buildTitle('Proof of Payment'),
              SizedBox(height: 8,),
              FadeInImage(
                  width: MediaQuery.of(context).size.width * 0.7,
                  fit: BoxFit.fitWidth,
                  placeholder: const AssetImage(Asset.imageBox),
                  image: NetworkImage(Api.hostImage + widget.order.image),
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 50,
                      width: 50,
                      alignment: Alignment.center,
                      child: const Icon(Icons.broken_image),
                    );
                  },
                ),
              SizedBox(height: 16,),
            ],
          ),
        ),
      ),
    );
  }

Widget buildTitle(String title) {
return Text(title,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),);
}

Widget buildContent(String title) {
return Text(title,style: TextStyle(fontSize: 16),);
}

  Widget buildListShop() {
    List<String> stringListShop = widget.order.listShop.split('||');
    return Column(
      children: List.generate(stringListShop.length, (index) {
        Map<String, dynamic> item = jsonDecode(stringListShop[index]);
        return Container(
          margin: EdgeInsets.fromLTRB(
            0,
            index == 0 ? 16 : 8,
            0,
            index == stringListShop.length - 1 ? 16 : 8,
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