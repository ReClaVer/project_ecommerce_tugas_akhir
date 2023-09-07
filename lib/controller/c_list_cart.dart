import 'dart:convert';

import 'package:get/get.dart';
import 'package:project_ecommerce_tugas_akhir/controller/c_user.dart';
import 'package:project_ecommerce_tugas_akhir/event/event_pref.dart';
import 'package:project_ecommerce_tugas_akhir/model/cart.dart';
import 'package:project_ecommerce_tugas_akhir/model/cart_data.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user.dart';

// import 'package:project_ecommerce_tugas_akhir/page/list_cart.dart';
class CListCart extends GetxController {
  final user = Get.put(CUser());
  final RxList<Cart> _list = <Cart>[].obs;
  final RxList<int> _selected = <int>[].obs;
  final RxBool _isSelectedAll = false.obs;
  final RxDouble _total = 0.0.obs;
  var dataListCart = DataCart().obs;

  // final List<int> selected = <int>[];

  List<Cart> get list => _list.value;
  List<int> get selecteda => _selected.value;
  bool get isSelectedAll => _isSelectedAll.value;
  double get total => _total.value;

  final List<int> selected = <int>[];
  final List<Map<String, dynamic>> selectedaa = <Map<String, dynamic>>[];

  
  void calculateTotalPrice() {
  _total.value = 0.0; // Reset total to 0 before calculating again
  
  for (var id in selected) {
    var cartItem = dataListCart.value.data!.firstWhere(
      (item) => int.parse(item.idCart!) == id,
      orElse: () => Data(), // Provide a default value of 'Data' if no match is found
    );
    
    if (cartItem != null) {
      _total.value +=
          double.parse(cartItem.price!) * double.parse(cartItem.quantity!);
    }
  }
}



  setList(List<Cart> newList) => _list.value = newList;
  addSelected(int newIdCart) {
    _selected.value.add(newIdCart);
    update();
  }

  deleteSelected(int newIdCart) {
    _selected.value.remove(newIdCart);
    update();
  }

  setIsSelectedAll() => _isSelectedAll.value = !_isSelectedAll.value;
  selectedClear() {
    _selected.value.clear();
    update();
  }

  setTotal(double newTotal) => _total.value = newTotal;

  Future<void> fecthListCart() async {
    var idUser = user.user.idUser; // Call getUser to get idUser
    var url = 'http://localhost/api_ecommerce/cart/get.php?id_user=$idUser';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        dataListCart.value = DataCart.fromJson(json.decode(response.body));
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      // Handle error, if any
      print('Error fetching data: $e');
    }

    void onInit() {
      fecthListCart();
      super.onInit();
    }
  }
}
