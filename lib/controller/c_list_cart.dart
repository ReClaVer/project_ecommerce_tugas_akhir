import 'package:get/get.dart';
import 'package:project_ecommerce_tugas_akhir/model/cart.dart';
// import 'package:project_ecommerce_tugas_akhir/page/list_cart.dart';

class CListCart extends GetxController {
  final RxList<Cart> _list = <Cart>[].obs;
  final RxList<int> _selected = <int>[].obs;
  final RxBool _isSelectedAll = false.obs;
  final RxDouble _total = 0.0.obs;

  List<Cart> get list => _list.value;
  List<int> get selected => _selected.value;
  bool get isSelectedAll => _isSelectedAll.value;
  double get total => _total.value;

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
}
