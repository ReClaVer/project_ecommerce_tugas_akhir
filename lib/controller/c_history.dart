import 'package:get/get.dart';
import 'package:project_ecommerce_tugas_akhir/model/cart.dart';

import '../model/order.dart';
// import 'package:project_ecommerce_tugas_akhir/page/list_cart.dart';

class CHistory extends GetxController {
  final RxList<Order> _list = <Order>[].obs;
  final RxList<int> _selected = <int>[].obs;

  List<Order> get list => _list.value;
  List<int> get selected => _selected.value;

  setList(List<Order> newList) => _list.value = newList;
  addSelected(int newIdOrder) {
    _selected.value.add(newIdOrder);
    update();
  }

  deleteSelected(int IdOrder) {
    _selected.value.remove(IdOrder);
    update();
  }

  selectedClear() {
    _selected.value.clear();
    update();
  }

}
