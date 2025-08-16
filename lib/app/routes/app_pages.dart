import 'package:get/get.dart';
import 'package:snpos/app/modules/main_nav/children/profile/children/overtime_application/bindings/overtime_application_binding.dart';
import 'package:snpos/app/modules/main_nav/children/profile/children/overtime_application/views/overtime_application_view.dart';

import '../modules/camera_picker/bindings/camera_picker_binding.dart';
import '../modules/camera_picker/views/camera_picker_view.dart';
import '../modules/detail_absensi/bindings/detail_absensi_binding.dart';
import '../modules/detail_absensi/views/detail_absensi_view.dart';
import '../modules/landing/bindings/landing_binding.dart';
import '../modules/landing/views/landing_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/main_nav/bindings/main_nav_binding.dart';
import '../modules/main_nav/children/attendance/bindings/attendance_binding.dart';
import '../modules/main_nav/children/attendance/children/attendance_camera/bindings/attendance_camera_binding.dart';
import '../modules/main_nav/children/attendance/children/attendance_camera/views/attendance_camera_view.dart';
import '../modules/main_nav/children/attendance/children/attendance_transaction/bindings/attendance_transaction_binding.dart';
import '../modules/main_nav/children/attendance/children/attendance_transaction/views/attendance_transaction_view.dart';
import '../modules/main_nav/children/attendance/children/create_deposit/bindings/create_deposit_binding.dart';
import '../modules/main_nav/children/attendance/children/create_deposit/views/create_deposit_view.dart';
import '../modules/main_nav/children/attendance/views/attendance_view.dart';
import '../modules/main_nav/children/home/bindings/home_binding.dart';
import '../modules/main_nav/children/home/children/transaction_success/bindings/transaction_success_binding.dart';
import '../modules/main_nav/children/home/children/transaction_success/views/transaction_success_view.dart';
import '../modules/main_nav/children/home/views/home_view.dart';
import '../modules/main_nav/children/profile/bindings/profile_binding.dart';
import '../modules/main_nav/children/profile/children/attendance_report/bindings/attendance_report_binding.dart';
import '../modules/main_nav/children/profile/children/attendance_report/views/attendance_report_view.dart';
import '../modules/main_nav/children/profile/children/change_password/bindings/change_password_binding.dart';
import '../modules/main_nav/children/profile/children/change_password/views/change_password_view.dart';
import '../modules/main_nav/children/profile/children/deposit_report/bindings/deposit_report_binding.dart';
import '../modules/main_nav/children/profile/children/deposit_report/views/deposit_report_view.dart';
import '../modules/main_nav/children/profile/children/sales_report/bindings/sales_report_binding.dart';
import '../modules/main_nav/children/profile/children/sales_report/views/sales_report_view.dart';
import '../modules/main_nav/children/profile/children/schedule_information/bindings/schedule_information_binding.dart';
import '../modules/main_nav/children/profile/children/schedule_information/views/schedule_information_view.dart';
import '../modules/main_nav/children/profile/views/profile_view.dart';
import '../modules/main_nav/views/main_nav_view.dart';

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
              ]),
          GetPage(
            name: _Paths.ATTENDANCE,
            page: () => const AttendanceView(),
            binding: AttendanceBinding(),
            children: [
              GetPage(
                name: _Paths.ATTENDANCE_CAMERA,
                page: () => const AttendanceCameraView(),
                binding: AttendanceCameraBinding(),
              ),
              GetPage(
                name: _Paths.ATTENDANCE_TRANSACTION,
                page: () => const AttendanceTransactionView(),
                binding: AttendanceTransactionBinding(),
              ),
              GetPage(
                name: _Paths.CREATE_DEPOSIT,
                page: () => const CreateDepositView(),
                binding: CreateDepositBinding(),
              ),
            ],
          ),
          GetPage(
              name: _Paths.PROFILE,
              page: () => const ProfileView(),
              binding: ProfileBinding(),
              children: [
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
                  name: _Paths.SCHEDULE_INFORMATION,
                  page: () => const ScheduleInformationView(),
                  binding: ScheduleInformationBinding(),
                ),
                GetPage(
                  name: _Paths.CHANGE_PASSWORD,
                  page: () => const ChangePasswordView(),
                  binding: ChangePasswordBinding(),
                ),
                GetPage(
                  name: _Paths.OVERTIME_APPLICATION,
                  page: () => const OvertimeApplicationView(),
                  binding: OvertimeApplicationBinding(),
                ),
              ]),
        ]),
    GetPage(
      name: _Paths.CAMERA_PICKER,
      page: () => const CameraPickerView(),
      binding: CameraPickerBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_ABSENSI,
      page: () => const DetailAbsensiView(),
      binding: DetailAbsensiBinding(),
    ),

  ];
}
