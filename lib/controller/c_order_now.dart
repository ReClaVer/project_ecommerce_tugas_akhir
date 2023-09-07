import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class COrderNow extends GetxController {
  final RxString _delivery = 'Pihak Toko'.obs;
  final RxString _payment = 'Transfer Bank'.obs;

  String get delivery => _delivery.value;
  String get payment => _payment.value;

  setDelivery(String newDelivery) => _delivery.value = newDelivery;
  setPayment(String newPayment) => _delivery.value = newPayment;
}
