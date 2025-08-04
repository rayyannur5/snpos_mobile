import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:snpos/app/routes/app_pages.dart';

class TransactionSuccessController extends GetxController {

  var topPosition = (100.0).obs;
  var showCheckIcon = false.obs;

  late final List products;
  late final int total;
  late final int paid;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration(milliseconds: 300), () {
      topPosition.value = 0; // animasi masuk
    });

    final args = Get.arguments as Map;
    products = args['products'];
    total = args['total'];
    paid = args['paid'];

  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void triggerCheckAnimation() {
    showCheckIcon.value = true;
  }

}
