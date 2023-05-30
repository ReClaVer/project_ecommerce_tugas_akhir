import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:project_ecommerce_tugas_akhir/controller/c_list_cart.dart';
import 'package:project_ecommerce_tugas_akhir/controller/c_user.dart';

import '../config/api.dart';
import '../config/asset.dart';
import '../model/apparel.dart';
import '../model/cart.dart';

class ListCartRestore extends StatefulWidget {
  @override
  State<ListCartRestore> createState() => _ListCartRestoreState();
}

class _ListCartRestoreState extends State<ListCartRestore> {
  final _cUser = Get.put(CUser());
  final _cListCart = Get.put(CListCart());

  void getList() async {
    List<Cart> listCart = [];
    try {
      var response = await http.post(Uri.parse(Api.getCart), body: {
        'id_user': _cUser.user.idUser.toString(),
      });
      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        if (responseBody['success']) {
          (responseBody['data'] as List).forEach((element) {
            listCart.add(Cart.fromJson(element));
          });
        }
        _cListCart.setList(listCart);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Asset.colorPrimary,
        titleSpacing: 0,
        title: Text('Cart'),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.check_box_outlined)),
          IconButton(onPressed: () {}, icon: Icon(Icons.delete_forever))
        ],
      ),
      body: Obx(
        () => _cListCart.list.length > 0
            ? ListView.builder(
                itemCount: _cListCart.list.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  Cart cart = _cListCart.list[index];
                  Apparel apparel = Apparel(
                      colors: cart.colors!,
                      idApparel: cart.idApparel,
                      image: cart.image,
                      name: cart.name,
                      price: cart.price,
                      rating: cart.rating,
                      sizes: cart.sizes!,
                      description: cart.description,
                      tags: cart.tags);
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 8,
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.check_box_outline_blank)),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              margin: EdgeInsets.fromLTRB(
                                0,
                                index == 0 ? 16 : 8,
                                16,
                                index == 2 - 1 ? 16 : 8,
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                  boxShadow: const [
                                    BoxShadow(
                                        offset: Offset(0, 0),
                                        blurRadius: 6,
                                        color: Colors.black26),
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
                                      placeholder:
                                          const AssetImage(Asset.imageBox),
                                      image: NetworkImage(''),
                                      imageErrorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          height: 90,
                                          width: 90,
                                          alignment: Alignment.center,
                                          child: Icon(Icons.broken_image),
                                        );
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            cart.name,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              GestureDetector(
                                                  onTap: () {},
                                                  child: const Icon(Icons
                                                      .remove_circle_outline_outlined)),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                cart.quantity.toString(),
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Asset.colorPrimary,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              GestureDetector(
                                                  onTap: () {},
                                                  child: const Icon(Icons
                                                      .add_circle_outline_rounded)),
                                              Spacer(),
                                              Text(
                                                '\$ ${cart.price}',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    color: Asset.colorPrimary,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                width: 16,
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
            : Center(
                child: Text('Empty'),
              ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            offset: Offset(0, -3),
            color: Colors.black26,
            blurRadius: 6,
          )
        ]),
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: Row(
          children: [
            const Text(
              'Total',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            const Text(
              '\$ 42,6',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 20,
                  color: Asset.colorPrimary,
                  fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Material(
              color: Asset.colorPrimary,
              borderRadius: BorderRadius.circular(30),
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(30),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text(
                    'Order Now',
                    style: TextStyle(color: Asset.colorWhiteText, fontSize: 16),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
