import 'package:get/get.dart';
import 'package:snpos/app/modules/main_nav/children/attendance/controllers/attendance_controller.dart';
import 'package:snpos/app/modules/main_nav/children/attendance/providers/attendance_provider.dart';
import 'package:snpos/app/modules/main_nav/children/home/controllers/home_controller.dart';
import 'package:snpos/app/modules/main_nav/children/home/providers/home_provider.dart';
import 'package:snpos/app/modules/main_nav/children/profile/controllers/profile_controller.dart';
import 'package:snpos/app/modules/main_nav/children/profile/providers/profile_provider.dart';

import '../controllers/main_nav_controller.dart';

class MainNavBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainNavController>(
      () => MainNavController(),
    );
    Get.lazyPut<HomeProvider>(() => HomeProvider());
    Get.lazyPut<HomeController>(() => HomeController(Get.find()));

    Get.lazyPut<AttendanceProvider>(() => AttendanceProvider());
    Get.lazyPut<AttendanceController>(() => AttendanceController(Get.find()));

    Get.lazyPut<ProfileProvider>(() => ProfileProvider());
    Get.lazyPut<ProfileController>(() => ProfileController(Get.find()));
  }
}
