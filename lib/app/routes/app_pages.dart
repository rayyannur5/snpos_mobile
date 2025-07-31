import 'package:get/get.dart';
import 'package:snpos/app/modules/main_nav/children/attendance/bindings/attendance_binding.dart';
import 'package:snpos/app/modules/main_nav/children/attendance/views/attendance_view.dart';
import 'package:snpos/app/modules/main_nav/children/home/bindings/home_binding.dart';
import 'package:snpos/app/modules/main_nav/children/home/children/transaction_success/bindings/transaction_success_binding.dart';
import 'package:snpos/app/modules/main_nav/children/home/children/transaction_success/views/transaction_success_view.dart';
import 'package:snpos/app/modules/main_nav/children/home/views/home_view.dart';
import 'package:snpos/app/modules/main_nav/children/profile/bindings/profile_binding.dart';
import 'package:snpos/app/modules/main_nav/children/profile/views/profile_view.dart';

import '../modules/attendance_report/bindings/attendance_report_binding.dart';
import '../modules/attendance_report/views/attendance_report_view.dart';
import '../modules/checkout/bindings/checkout_binding.dart';
import '../modules/checkout/views/checkout_view.dart';
import '../modules/deposit_report/bindings/deposit_report_binding.dart';
import '../modules/deposit_report/views/deposit_report_view.dart';
import '../modules/landing/bindings/landing_binding.dart';
import '../modules/landing/views/landing_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/main_nav/bindings/main_nav_binding.dart';
import '../modules/main_nav/views/main_nav_view.dart';
import '../modules/sales_report/bindings/sales_report_binding.dart';
import '../modules/sales_report/views/sales_report_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LANDING;

  static final routes = [

    GetPage(
      name: _Paths.LANDING,
      page: () => const LandingView(),
      binding: LandingBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),


    GetPage(
      name: _Paths.SALES_REPORT,
      page: () => const SalesReportView(),
      binding: SalesReportBinding(),
    ),
    GetPage(
      name: _Paths.ATTENDANCE_REPORT,
      page: () => const AttendanceReportView(),
      binding: AttendanceReportBinding(),
    ),
    GetPage(
      name: _Paths.DEPOSIT_REPORT,
      page: () => const DepositReportView(),
      binding: DepositReportBinding(),
    ),
    GetPage(
      name: _Paths.CHECKOUT,
      page: () => const CheckoutView(),
      binding: CheckoutBinding(),
    ),
    GetPage(
      name: _Paths.MAIN_NAV,
      page: () => const MainNavView(),
      binding: MainNavBinding(),
      children: [
        GetPage(
          name: _Paths.HOME,
          page: () => const HomeView(),
          binding: HomeBinding(),
          children: [
            GetPage(
              name: _Paths.TRANSACTION_SUCCESS,
              page: () => const TransactionSuccessView(),
              binding: TransactionSuccessBinding(),
            ),
          ]
        ),
        GetPage(
          name: _Paths.ATTENDANCE,
          page: () => const AttendanceView(),
          binding: AttendanceBinding(),
        ),
        GetPage(
          name: _Paths.PROFILE,
          page: () => const ProfileView(),
          binding: ProfileBinding(),
        ),
      ]
    ),
  ];
}
