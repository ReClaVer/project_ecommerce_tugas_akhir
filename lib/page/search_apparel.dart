import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../config/api.dart';
import '../config/asset.dart';
import '../model/apparel.dart';
import 'detail_apparel.dart';

class SearchApparel extends StatefulWidget {
  final String? searchQuery;
  SearchApparel({this.searchQuery});

  @override
  State<SearchApparel> createState() => _SearchApparelState();
}

class _SearchApparelState extends State<SearchApparel> {
  var _controllerSearch = TextEditingController();

  Future<List<Apparel>> getAll() async {
    List<Apparel> listSearch = [];
    if (_controllerSearch.text != '') {
      try {
        var response = await http.post(Uri.parse(Api.searchApparel), body: {
          'search': _controllerSearch.text,
        });
        if (response.statusCode == 200) {
          var responseBody = json.decode(response.body);
          if (responseBody['success']) {
            (responseBody['data'] as List).forEach((element) {
              listSearch.add(Apparel.fromJson(element));
            });
          }
        }
      } catch (e) {
        print(e);
      }
    }
    return listSearch;
  }

  @override
  void initState() {
    _controllerSearch.text = widget.searchQuery!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Asset.colorPrimary,
        backgroundColor: Colors.black,
        // leading: ,
        titleSpacing: 0,
        title: buildSearch(),
      ),
      body: buildAll(),
    );
  }

  Widget buildAll() {
    return FutureBuilder(
        future: getAll(),
        builder: (context, AsyncSnapshot<List<Apparel>> snapshot) {
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
                itemCount: snapshot.data!.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  Apparel apparel = snapshot.data![index];
                  return GestureDetector(
                    onTap: () => Get.to(DetaiApparel(
                      apparel: apparel,
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
                                  Text(
                                    '${apparel.tags!.join(', ')}',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Asset.colorPrimary,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    'Rp ${apparel.price}',
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

  Widget buildSearch() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
      child: TextField(
        controller: _controllerSearch,
        decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.search,
              color: Asset.colorPrimary,
            ),
            hintText: 'Search....',
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: const Icon(
                Icons.clear,
                color: Asset.colorPrimary,
              ),
            ),
            border: styleBorder(),
            enabledBorder: styleBorder(),
            focusedBorder: styleBorder(),
            disabledBorder: styleBorder(),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            fillColor: Asset.colorAccent,
            filled: true),
      ),
    );
  }

  InputBorder styleBorder() {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(width: 0, color: Asset.colorTextTile));
  }
}
