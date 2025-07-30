import 'package:get/get.dart';
import 'package:snpos/app/routes/app_pages.dart';

class MainNavController extends GetxController {

  var currentIndex = 0.obs;

  final tabs = [
    Routes.HOME,
    Routes.ATTENDANCE,
    Routes.PROFILE,
  ];

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void changeTab(int index) {
    currentIndex.value = index;
  }

  void updateIndexFromRoute(String route) {
    final index = tabs.indexOf(route);
    if (index != -1) currentIndex.value = index;
  }

}
