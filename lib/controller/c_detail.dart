import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class CDetailApparel extends GetxController {
  final RxBool _isWishlist = false.obs;
  final RxInt _quantity = 1.obs;
  final RxInt _size = 0.obs;
  final RxInt _color = 0.obs;

  bool get isWishlist => _isWishlist.value;
  int get quantity => _quantity.value;
  int get size => _size.value;
  int get color => _color.value;

  setIsWishlist(bool newIsWhislist) => _isWishlist.value = newIsWhislist;
  setQuantity(int newQuantity) => _quantity.value = newQuantity;
  setSize(int newSize) => _size.value = newSize;
  setColor(int newColor) => _color.value = newColor;
}
