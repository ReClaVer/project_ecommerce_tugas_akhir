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
    const DetailOrder({Key? key, required this.order}) : super(key: key);

  @override
  State<DetailOrder> createState() => _DetailOrderState();
}

class _DetailOrderState extends State<DetailOrder> {
    final RxString _arrived = ''.obs;

    String get arrived => _arrived.value;

    updateArrived(String newArrived) => _arrived.value = newArrived;

    void dialogConfirmArrived () async {
      if (widget.order.arrived!='Arrived') {
    var response = await Get.dialog(AlertDialog(
        title: Text('Tanda Terima'),
        content: Text('Apakah barangmu sudah diterima?'),
        actions: [
          TextButton(onPressed: ()=>Get.back(), child: Text('Belum')),
          TextButton(onPressed: ()=>Get.back(result: 'arrived'), child: Text('Sudah')),
        ],
      ));
      if (response=='succes') {
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
        updateArrived('success');
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
                    
                    Text('Diterima',style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),),
                    const SizedBox(width: 2,),
                    Obx(() => arrived == 'arrived' ? const Icon(Icons.check_circle,color: Asset.colorPrimary,):Icon(Icons.help,color: Colors.grey,)),
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
              buildTitle('Pengiriman'),
              SizedBox(height: 8,),
              buildContent(widget.order.delivery),
              buildListShop(),
              SizedBox(height: 16,),
              buildTitle('Pembayaran'),
              SizedBox(height: 8,),
              buildContent(widget.order.payment),
              buildListShop(),
              SizedBox(height: 16,),
              buildTitle('Catatan'),
              SizedBox(height: 8,),
              buildContent(widget.order.note??''),
              buildListShop(),
              SizedBox(height: 16,),
              buildTitle('Total'),
              SizedBox(height: 8,),
              buildContent('\Rp ${widget.order.total}'),
              buildListShop(),
              SizedBox(height: 16,),
              buildTitle('Bukti Pembayaran'),
              SizedBox(height: 8,),
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  image: DecorationImage(image: NetworkImage(widget.order.image))
                ),
              ),
              // FadeInImage(
              //     width: MediaQuery.of(context).size.width * 0.7,
              //     fit: BoxFit.fitWidth,
              //     placeholder: const AssetImage(Asset.imageBox),
              //     image: NetworkImage(Api.hostImage + widget.order.image!),
              //     imageErrorBuilder: (context, error, stackTrace) {
              //       return Container(
              //         height: 50,
              //         width: 50,
              //         alignment: Alignment.center,
              //         child: const Icon(Icons.broken_image),
              //       );
              //     },
              //   ),
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
    String stringListShop = widget.order.listShop;
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
                        '\Rp'+(item['item_total'] as double).toStringAsFixed(0),
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