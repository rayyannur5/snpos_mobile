import 'package:get/get.dart';
import 'package:snpos/app/modules/main_nav/children/home/providers/home_provider.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeProvider>(() => HomeProvider());
    Get.lazyPut<HomeController>(() => HomeController(Get.find()));
  }
}
