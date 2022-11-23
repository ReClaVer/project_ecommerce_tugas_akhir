import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';

import 'package:http/http.dart' as http;
import 'package:project_ecommerce_tugas_akhir/controller/c_list_cart.dart';
import 'package:project_ecommerce_tugas_akhir/controller/c_user.dart';
import 'package:project_ecommerce_tugas_akhir/model/apparel.dart';
import 'package:project_ecommerce_tugas_akhir/page/detail_apparel.dart';
import 'package:project_ecommerce_tugas_akhir/page/order/order_now.dart';

import '../config/api.dart';
import '../config/asset.dart';
import '../model/cart.dart';

class ListCart extends StatefulWidget {
  @override
  State<ListCart> createState() => _ListCartState();
}

class _ListCartState extends State<ListCart> {
  final _cUser = Get.put(CUser());
  final _cListCart = Get.put(CListCart());

  List<Map<String, dynamic>> getListShop() {
    List<Map<String, dynamic>> listShop = [];
    if (_cListCart.selected.length > 0) {
      _cListCart.list.forEach((cart) {
        if (_cListCart.selected.contains(cart.idCart)) {
          Map<String, dynamic> item = {
            'id_apparel': cart.idApparel,
            'image': cart.image,
            'name': cart.image,
            'color': cart.color,
            'size': cart.size,
            'quantity': cart.quantity,
            'item_total': cart.price * cart.quantity
          };
          listShop.add(item);
        }
      });
    }
    return listShop;
  }

  void countTotal() {
    _cListCart.setTotal(0.0);
    if (_cListCart.selected.length > 0) {
      _cListCart.list.forEach((cart) {
        if (_cListCart.selected.contains(cart.idCart)) {
          double itemTotal = cart.price * cart.quantity;
          _cListCart.setTotal(_cListCart.total + itemTotal);
        }
      });
    }
  }

  void getList() async {
    List<Cart> listCart = [];
    try {
      var response = await http.post(Uri.parse(Api.getCart), body: {
        'id_user': _cUser.user.idUser.toString(),
      });
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
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
    countTotal();
  }

  void updateCart(int idCart, int newQuantity) async {
    List<Cart> listCart = [];
    try {
      var response = await http.post(Uri.parse(Api.updateCart), body: {
        'id_cart': idCart.toString(),
        'quantity': newQuantity.toString()
      });
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['success']) {
          getList();
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void deleteCart(int idCart) async {
    List<Cart> listCart = [];
    try {
      var response = await http.post(Uri.parse(Api.deleteCart), body: {
        'id_cart': idCart.toString(),
      });
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['success']) {
          getList();
        }
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
        title: const Text('Cart'),
        actions: [
          Obx(
            () => IconButton(
                onPressed: () {
                  _cListCart.setIsSelectedAll();
                  _cListCart.selected.clear();

                  if (_cListCart.isSelectedAll) {
                    _cListCart.list.forEach((e) {
                      _cListCart.addSelected(e.idCart);
                    });
                  }
                  countTotal();
                },
                icon: Icon(
                  _cListCart.isSelectedAll
                      ? Icons.check_box
                      : Icons.check_box_outline_blank_rounded,
                )),
          ),
          GetBuilder(
              init: CListCart(),
              builder: (_) => _cListCart.selected.length > 0
                  ? IconButton(
                      onPressed: () async {
                        var response = await Get.dialog(AlertDialog(
                          title: const Text('Delete'),
                          content:
                              const Text('You sure to delete selected cart?'),
                          actions: [
                            TextButton(
                                onPressed: () => Get.back(),
                                child: const Text('no')),
                            TextButton(
                                onPressed: () => Get.back(result: 'yes'),
                                child: const Text('yes'))
                          ],
                        ));
                        if (response == 'yes') {
                          _cListCart.selected.forEach((idCart) {
                            deleteCart(idCart);
                          });
                        }
                        countTotal();
                      },
                      icon: const Icon(
                        Icons.delete_forever,
                      ))
                  : const SizedBox())
        ],
      ),
      body: Obx(() => _cListCart.list.length > 0
          ? ListView.builder(
              // itemCount: 10,
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
                  tags: cart.tags,
                );
                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      GetBuilder(
                          init: CListCart(),
                          builder: (_) {
                            return IconButton(
                                onPressed: () {
                                  if (_cListCart.selected
                                      .contains(cart.idCart)) {
                                    _cListCart.deleteSelected(cart.idCart);
                                  } else {
                                    _cListCart.addSelected(cart.idCart);
                                  }
                                  countTotal();
                                },
                                icon: Icon(
                                    _cListCart.selected.contains(cart.idCart)
                                        ? Icons.check_box
                                        : Icons.check_box_outline_blank));
                          }),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Get.to(DetaiApparel(
                            apparel: apparel,
                          ))!
                              .then((value) => getList()),
                          child: Container(
                            margin: EdgeInsets.fromLTRB(
                              0,
                              index == 0 ? 16 : 8,
                              16,
                              index == _cListCart.list.length - 1 ? 16 : 8,
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
                                    image: NetworkImage(cart.image),
                                    imageErrorBuilder:
                                        (context, error, stackTrace) {
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          cart.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 8,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          '${cart.color}, ${cart.size}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 8,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                                onTap: () {
                                                  if (cart.quantity - 1 >= 1) {
                                                    updateCart(cart.idCart,
                                                        cart.quantity - 1);
                                                  }
                                                },
                                                child: const Icon(
                                                  Icons
                                                      .remove_circle_outline_outlined,
                                                  size: 30,
                                                )),
                                            const SizedBox(
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
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            GestureDetector(
                                                onTap: () {
                                                  updateCart(cart.idCart,
                                                      cart.quantity + 1);
                                                },
                                                child: const Icon(
                                                  Icons
                                                      .add_circle_outline_rounded,
                                                  size: 30,
                                                )),
                                            const Spacer(),
                                            Text(
                                              '\Rp ${cart.price} ',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  color: Asset.colorPrimary,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(
                                              width: 16,
                                            )
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
              })
          : Center(
              child: Text('empty'),
            )),
      bottomNavigationBar: GetBuilder(
          init: CListCart(),
          builder: (_) => Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0, -3),
                          color: Colors.black26,
                          blurRadius: 6)
                    ]),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    const Text(
                      'Total: ',
                      style: TextStyle(
                          fontSize: 20,
                          color: Asset.colorPrimary,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Obx(() => Text(
                          '\Rp ' + _cListCart.total.toStringAsFixed(2),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 20,
                              color: Asset.colorPrimary,
                              fontWeight: FontWeight.bold),
                        )),
                    const Spacer(),
                    Material(
                      color: _cListCart.selected.length > 0
                          ? Asset.colorPrimary
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(30),
                      child: InkWell(
                        onTap: _cListCart.selected.length > 0
                            ? () => Get.to(OrderNow(
                                  listIdCart: _cListCart.selected,
                                  listShop: getListShop(),
                                  total: _cListCart.total,
                                ))
                            : null,
                        borderRadius: BorderRadius.circular(30),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          child: Text(
                            'Order Now',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )),
    );
  }
}
