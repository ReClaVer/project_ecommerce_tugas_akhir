import 'dart:convert';

import 'package:project_ecommerce_tugas_akhir/controller/c_user.dart';
import 'package:project_ecommerce_tugas_akhir/model/apparel.dart';
import 'package:project_ecommerce_tugas_akhir/model/wishlist.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../config/api.dart';
import '../../config/asset.dart';
import '../detail_apparel.dart';

class FragmentWishlist extends StatefulWidget {
  @override
  State<FragmentWishlist> createState() => _FragmentWishlistState();
}

class _FragmentWishlistState extends State<FragmentWishlist> {
  final _cUser = Get.put(CUser());

  Future<List<Wishlist>> getAll() async {
    List<Wishlist> listWishlist = [];
    try {
      var response = await http.post(Uri.parse(Api.getWishlist), body: {
        'id_user': _cUser.user.idUser.toString(),
      });
      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        if (responseBody['success']) {
          (responseBody['data'] as List).forEach((element) {
            listWishlist.add(Wishlist.fromJson(element));
          });
        }
      }
    } catch (e) {
      print(e);
    }
    return listWishlist;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 8, 8),
          child: Text(
            'Wishlist',
            style: TextStyle(
                color: Asset.colorTextTile,
                fontWeight: FontWeight.bold,
                fontSize: 30),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Hope all of this can purchased',
            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        buildAll(),
      ]),
    );
  }

  Widget buildAll() {
    return FutureBuilder(
        future: getAll(),
        builder: (context, AsyncSnapshot<List<Wishlist>> snapshot) {
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
            return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  Wishlist wishlist = snapshot.data![index];
                  Apparel apparel = Apparel(
                      idApparel: wishlist.idApparel,
                      image: wishlist.image,
                      name: wishlist.name,
                      price: wishlist.price,
                      rating: wishlist.rating,
                      sizes: wishlist.sizes,
                      description: wishlist.description,);
                  return GestureDetector(
                    onTap: () => Get.to(DetailApparel(
                      apparel: apparel,
                    ))!
                        .then((value) => setState(
                              () {},
                            )),
                    child: Container(
                      margin: EdgeInsets.fromLTRB(
                        16,
                        index == 0 ? 16 : 8,
                        16,
                        index == snapshot.data!.length - 1 ? 16 : 8,
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
                              placeholder: const AssetImage(Asset.imageBox),
                              image: NetworkImage(apparel.image),
                              imageErrorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Icon(Icons.broken_image),
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
                                    apparel.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  // Text(
                                  //   '${apparel.tags!.join(', ')}',
                                  //   maxLines: 2,
                                  //   overflow: TextOverflow.ellipsis,
                                  //   style: const TextStyle(
                                  //     fontSize: 14,
                                  //     color: Asset.colorPrimary,
                                  //   ),
                                  // ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    'Rp. ${apparel.price}',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        color: Asset.colorPrimary,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.navigate_next,
                          ),
                          const SizedBox(
                            width: 16,
                          )
                        ],
                      ),
                    ),
                  );
                });
          } else {
            return const Center(child: Text('Empty'));
          }
        });
  }
}
