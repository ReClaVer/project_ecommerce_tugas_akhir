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
  const ListCart({Key? key}) : super(key: key);

  @override
  State<ListCart> createState() => _ListCartState();
}

class _ListCartState extends State<ListCart> {
  final _cUser = Get.put(CUser());
  final _cListCart = Get.put(CListCart());

  List<Map<String, dynamic>> getListShop() {
    List<Map<String, dynamic>> listShop = [];
    if (_cListCart.selected.isNotEmpty) {
      _cListCart.list.forEach((cart) {
        if (_cListCart.selected.contains(cart.idCart)) {
          Map<String, dynamic> item = {
            'id_apparel': cart.idApparel,
            'image': cart.image,
            'name': cart.name,
            'size': cart.size, // Ambil ukuran pertama dari daftar ukuran
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
    double total = 0.0;
    if (_cListCart.selected.isNotEmpty) {
      _cListCart.list.forEach((cart) {
        if (_cListCart.selected.contains(
            _cListCart.dataListCart.value.data![int.parse('id_cart')])) {
          double itemTotal = cart.price * cart.quantity;
          total += itemTotal;
        }
      });
    }
    _cListCart.setTotal(total);
  }

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

  void toggleSelected(int itemId) {
    if (_cListCart.selected.contains(itemId)) {
      _cListCart.selected.remove(itemId);
      _cListCart.update();
    } else {
      _cListCart.selected.add(itemId);
      _cListCart.update();
    }
  }

  Future<void> updateCart(int idCart, int newQuantity) async {
    try {
      var response = await http.post(Uri.parse(Api.updateCart), body: {
        'id_cart': idCart.toString(),
        'quantity': newQuantity.toString()
      });
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['success']) {
          await getList();
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteCart(int idCart) async {
    try {
      var response = await http.post(Uri.parse(Api.deleteCart), body: {
        'id_cart': idCart.toString(),
      });
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);

        if (responseBody['success']) {
          await _cListCart.fecthListCart();
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Asset.colorPrimary,
        titleSpacing: 0,
        title: const Padding(
          padding: EdgeInsets.only(left: 0),
          child: Text('Keranjang'),
        ),
        actions: [
          GetBuilder(
              init: CListCart(),
              builder: (_) => _cListCart.selected.length != 0
                  ? IconButton(
                      onPressed: () async {
                        var response = await Get.dialog(AlertDialog(
                          title: const Text('Hapus'),
                          content: const Text(
                              'Apakah benar menghapus produk dari keranjang?'),
                          actions: [
                            TextButton(
                                onPressed: () => Get.back(),
                                child: const Text('tidak')),
                            TextButton(
                                onPressed: () => Get.back(result: 'ya'),
                                child: const Text('ya'))
                          ],
                        ));
                        if (response == 'ya') {
                          _cListCart.selected.forEach((idCart) async {
                            deleteCart(idCart);
                            await _cListCart.fecthListCart();
                            _cListCart.update();
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
      body: RefreshIndicator(
        onRefresh: _cListCart.fecthListCart,
        child: Obx(
          (() {
            if (_cListCart.dataListCart.value.success == true) {
              if (_cListCart.dataListCart.value.data!.isEmpty) {
                return const Center(
                  child: Text('Empty'),
                );
              } else {
                return ListView.builder(
                  itemCount: _cListCart.dataListCart.value.data!.length,
                  itemBuilder: (context, index) {
                    var dataCart = _cListCart.dataListCart.value.data![index];
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              
                              setState(() {
                                toggleSelected(int.parse(dataCart.idCart!));
                                _cListCart.calculateTotalPrice();
                                print("Selected items: ${_cListCart.selected}");
                              });
                              
                            },
                            icon: _cListCart.selected
                                    .contains(int.parse(dataCart.idCart!))
                                ? const Icon(Icons.check_box)
                                : const Icon(Icons.check_box_outline_blank),
                          ),
                          Expanded(
                            child: GestureDetector(
                              //KODE PERBAIKAN
                              // onTap: () async {
                              //   if (dataCart.idApparel != null) {
                              //     // Misalkan Anda memiliki sebuah fungsi yang dapat mengambil data Apparel
                              //     // berdasarkan idApparel dari suatu sumber data, misalnya dari API atau database.
                              //     Apparel? selectedApparel =
                              //         await fetchApparelById(dataCart.idApparel);

                              //     if (selectedApparel != null) {
                              //       Get.to(DetailApparel(
                              //               apparel: selectedApparel))
                              //           ?.then((value) {
                              //         // Di sini Anda dapat melakukan apa yang perlu setelah kembali dari DetailApparel.
                              //         // Contohnya, jika Anda perlu memperbarui data cart, Anda bisa memanggil getList().
                              //         getList();
                              //       });
                              //     } else {
                              //       // Handle jika objek Apparel tidak ditemukan.
                              //       // Misalnya, Anda bisa menampilkan pesan kesalahan atau tindakan lain.
                              //       print('Produk tidak ditemukan.');
                              //     }
                              //   }
                              // },

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
                                        image: NetworkImage(dataCart.image!),
                                        imageErrorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            height: 90,
                                            width: 80,
                                            alignment: Alignment.center,
                                            child:
                                                const Icon(Icons.broken_image),
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
                                              dataCart.name!,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            // Dibagian bawah ini di hilangkan bagian ${dataCart.colors}
                                            Row(
                                              children: [
                                                Text('Ukuran : '),
                                                Text(
                                                  '${dataCart.size}',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const Text('Jumlah : '),
                                                Text(
                                                  dataCart.quantity.toString(),
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    // color: Asset.colorPrimary,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                const Spacer(),
                                                Text(
                                                  '\Rp.${dataCart.price} ',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      color: Asset.colorPrimary,
                                                      fontWeight:
                                                          FontWeight.bold),
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
                  },
                );
              }
            } else {
              return const Center(
                child: Text('Kosong'),
              );
            }
          }),
        ),
      ),
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
                          '\Rp ${_cListCart.total.toStringAsFixed(0)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 20,
                              color: Asset.colorPrimary,
                              fontWeight: FontWeight.bold),
                        )),
                    const Spacer(),
                    Material(
                      color: _cListCart.selected.isNotEmpty
                          ? Asset.colorPrimary
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(30),
                      child: InkWell(
                        onTap: _cListCart.selected.isNotEmpty
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
                            'Pesan Sekarang',
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

fetchApparelById(String? idApparel) {}
