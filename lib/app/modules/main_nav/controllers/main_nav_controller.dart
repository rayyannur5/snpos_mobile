import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:snpos/app/modules/main_nav/children/attendance/views/attendance_view.dart';
import 'package:snpos/app/modules/main_nav/children/dashboard/views/dashboard_view.dart';
import 'package:snpos/app/modules/main_nav/children/home/views/home_view.dart';
import 'package:snpos/app/modules/main_nav/children/profile/views/profile_view.dart';
import 'package:snpos/app/routes/app_pages.dart';

class MainNavController extends GetxController {

  var currentIndex = 0.obs;

  final box = GetStorage();

  late final tabs;
  late final menus;

  @override
  void onInit() {
    super.onInit();

    var user = box.read('user');

    if([6,7].contains(user['level'])) {
      tabs = [
        Routes.HOME,
        Routes.ATTENDANCE,
        Routes.PROFILE,
      ];

      menus = [
        HomeView(),
        AttendanceView(),
        ProfileView(),
      ];
    } else {
      tabs = [
        Routes.DASHBOARD,
        Routes.ATTENDANCE,
        Routes.PROFILE,
      ];

      menus = [
        DashboardView(),
        AttendanceView(),
        ProfileView(),
      ];
    }


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
