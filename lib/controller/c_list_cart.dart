import 'package:get/get.dart';
import 'package:project_ecommerce_tugas_akhir/model/cart.dart';
// import 'package:project_ecommerce_tugas_akhir/page/list_cart.dart';

class CListCart extends GetxController {
  final RxList<Cart> _list = <Cart>[].obs;

  // ignore: invalid_use_of_protected_member
  List<Cart> get list => _list.value;

  setList(List<Cart> newList) => _list.value = newList;
}
