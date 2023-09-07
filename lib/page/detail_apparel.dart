import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:project_ecommerce_tugas_akhir/config/api.dart';
import 'package:project_ecommerce_tugas_akhir/controller/c_detail.dart';

import 'package:project_ecommerce_tugas_akhir/widget/info_message.dart';

import '../config/asset.dart';
import '../controller/c_list_cart.dart';
import '../controller/c_user.dart';
import '../model/apparel.dart';
import '../model/cart.dart';
import 'list_cart.dart';

class DetailApparel extends StatefulWidget {
  final Apparel? apparel;
  DetailApparel({this.apparel});

  @override
  State<DetailApparel> createState() => _DetailApparelState();
}

class _DetailApparelState extends State<DetailApparel> {
  final _CDetailApparel = Get.put(CDetailApparel());
  final _cUser = Get.put(CUser());
  final _cListCart = Get.put(CListCart());
  final _CUser = Get.put(CUser());

  Future<void> getList() async {
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

  void countTotal() {
    double total = 0.0;
    if (_cListCart.selected.isNotEmpty) {
      _cListCart.list.forEach((cart) {
        if (_cListCart.selected.contains(cart.idCart)) {
          double itemTotal = cart.price * cart.quantity;
          total += itemTotal;
        }
      });
    }
    _cListCart.setTotal(total);
  }

  void checkWishlist() async {
    try {
      var response = await http.post(Uri.parse(Api.checkWishlist), body: {
        'id_user': _CUser.user.idUser.toString(),
        'id_apparel': widget.apparel!.idApparel.toString()
      });

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        _CDetailApparel.setIsWishlist(responseBody['exist']);
      }
    } catch (e) {
      print(e);
    }
  }

  void addWishlist() async {
    try {
      var response = await http.post(Uri.parse(Api.addWishlist), body: {
        'id_user': _CUser.user.idUser.toString(),
        'id_apparel': widget.apparel!.idApparel.toString()
      });

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['success']) {
          checkWishlist();
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void deleteWishlist() async {
    try {
      var response = await http.post(Uri.parse(Api.deleteWishlist), body: {
        'id_user': _CUser.user.idUser.toString(),
        'id_apparel': widget.apparel!.idApparel.toString()
      });

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['success']) {
          checkWishlist();
        }
      }
    } catch (e) {
      print(e);
    }
  }

// INI ADALAH METHOD LAMA YANG ERROR
  Future<void> addCart() async {
    try {
      var response = await http.post(
        Uri.parse(Api.addCart),
        body: {
          'id_user': _CUser.user.idUser.toString(),
          'id_apparel': widget.apparel!.idApparel.toString(),
          'quantity': _CDetailApparel.quantity.toString(),
          'size': _CDetailApparel.size == 0
              ? 'S'
              : _CDetailApparel.size == 1
                  ? 'M'
                  : _CDetailApparel.size == 2
                      ? 'L'
                      : _CDetailApparel.size == 3
                          ? 'XL'
                          : 'XXL',
          'price': widget.apparel!.price.toString(),
        },
      );

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['success']) {
          // ignore: use_build_context_synchronously
          infoMessage.snackbar(context, 'Apparel has added to cart');
        } else {
          // ignore: use_build_context_synchronously
          infoMessage.snackbar(context, 'Apparel has not added to cart');
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    checkWishlist();
    _CDetailApparel.setQuantity(1);
    _CDetailApparel.setSize(0);
    _CDetailApparel.setColor(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        FadeInImage(
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
          placeholder: const AssetImage(Asset.imageBox),
          image: NetworkImage(widget.apparel!.image),
          imageErrorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Icon(Icons.broken_image),
            );
          },
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: buildInfo(),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top,
          left: 0,
          right: 0,
          child: Container(
            // color: Colors.black.withOpacity(0.1),
            child: Row(
              children: [
                IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Asset.colorPrimary,
                    )),
                const Spacer(),
                Obx(
                  () => IconButton(
                      onPressed: () {
                        if (_CDetailApparel.isWishlist) {
                          deleteWishlist();
                        } else {
                          addWishlist();
                        }
                      },
                      icon: Icon(
                          _CDetailApparel.isWishlist
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          color: Asset.colorPrimary)),
                ),
                IconButton(
                    onPressed: () async {
                      _cListCart.fecthListCart();
                      Get.to(const ListCart(),
                          arguments: _cListCart.fecthListCart());
                    },
                    icon: const Icon(Icons.shopping_cart,
                        color: Asset.colorPrimary)),
              ],
            ),
          ),
        )
      ]),
    );
  }

  Widget buildInfo() {
    return Container(
      height: MediaQuery.of(Get.context!).size.height * 0.6,
      width: MediaQuery.of(Get.context!).size.width,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, -3),
              blurRadius: 6,
              color: Colors.black12,
            )
          ]),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 16,
            ),
            Center(
              child: Container(
                height: 5,
                width: 120,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(30)),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              widget.apparel!.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        RatingBar.builder(
                          initialRating: widget.apparel!.rating,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {},
                          ignoreGestures: true,
                          itemSize: 20,
                          unratedColor: Colors.grey,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text('(${widget.apparel!.rating})')
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    // Text(
                    //   widget.apparel!.tags!.join(', '),
                    //   maxLines: 2,
                    //   overflow: TextOverflow.ellipsis,
                    //   style: const TextStyle(
                    //     fontSize: 16,
                    //   ),
                    // ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      'Rp ${widget.apparel!.price}',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 30,
                        color: Asset.colorPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )),
                Obx((() => Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {
                              _CDetailApparel.setQuantity(
                                  _CDetailApparel.quantity + 1);
                            },
                            icon: const Icon(Icons.add_circle_outline_rounded)),
                        Text(
                          _CDetailApparel.quantity.toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Asset.colorPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              if (_CDetailApparel.quantity - 1 >= 1) {
                                _CDetailApparel.setQuantity(
                                    _CDetailApparel.quantity - 1);
                              }
                            },
                            icon: const Icon(
                                Icons.remove_circle_outline_outlined))
                      ],
                    ))),
              ],
            ),
            const Text(
              'Size',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Wrap(
              spacing: 8,
              children: List.generate(widget.apparel!.sizes.length, (index) {
                return Obx(() => GestureDetector(
                      onTap: () => _CDetailApparel.setSize(index),
                      child: Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              width: 2,
                              color: _CDetailApparel.size == index
                                  ? Asset.colorPrimary
                                  : Colors.grey),
                          color: _CDetailApparel.size == index
                              ? Asset.colorAccent
                              : Colors.white,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          widget.apparel!.sizes[index],
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ));
              }),
            ),
            const SizedBox(
              height: 20,
            ),

            ////-- COLOR PAGE --////
            // const Text(
            //   'Color',
            //   style: TextStyle(
            //     fontSize: 18,
            //     color: Colors.grey,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            // const SizedBox(
            //   height: 8,
            // ),
            // Wrap(
            //   spacing: 8,
            //   children: List.generate(widget.apparel!.colors.length, (index) {
            //     return Obx(() => GestureDetector(
            //           onTap: () => _CDetailApparel.setColor(index),
            //           child: FittedBox(
            //             child: Container(
            //               decoration: BoxDecoration(
            //                 borderRadius: BorderRadius.circular(30),
            //                 border: Border.all(
            //                   width: 2,
            //                   color: _CDetailApparel.color == index
            //                       ? Asset.colorPrimary
            //                       : Colors.grey,
            //                 ),
            //                 color: _CDetailApparel.color == index
            //                     ? Asset.colorAccent
            //                     : Colors.white,
            //               ),
            //               padding: const EdgeInsets.symmetric(
            //                 horizontal: 16,
            //                 vertical: 4,
            //               ),
            //               alignment: Alignment.center,
            //               child: Text(
            //                 widget.apparel!.colors[index],
            //                 style: const TextStyle(
            //                   fontSize: 16,
            //                   color: Colors.grey,
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ));
            //   }),
            // ),

            ////-- DESKRIPSI PAGE --////
            // const SizedBox(
            //   height: 20,
            // ),
            // TextButton(
            //   onPressed: () {
            //     Navigator.push(context,
            //         MaterialPageRoute(builder: (context) => DescriptionPage()));
            //   },
            //   child: Row(
            //     children: const [
            //       Icon(
            //         Icons.description_outlined,
            //         color: Asset.colorPrimary,
            //       ),
            //       Text(
            //         "Description",
            //         style: TextStyle(
            //             color: Colors.black,
            //             fontWeight: FontWeight.w400,
            //             fontSize: 18),
            //       ),
            //     ],
            //   ),
            // ),
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              widget.apparel!.description!,
            ),
            const SizedBox(
              height: 30,
            ),
            Material(
              elevation: 2,
              color: Asset.colorPrimary,
              borderRadius: BorderRadius.circular(30),
              child: InkWell(
                onTap: () {
                  addCart();
                  print('bisa');
                },
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  child: const Text(
                    'ADD TO CART',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }

  Widget DescriptionPage() {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(12),
            child: Text(widget.apparel!.description!),
          ),
        ),
      ),
    );
  }
}
