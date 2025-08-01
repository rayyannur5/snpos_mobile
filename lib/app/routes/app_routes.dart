part of 'app_pages.dart';
// DO NOT EDIT. This is code generated via package:get_cli/get_cli.dart

abstract class Routes {
  Routes._();
  static const LANDING = _Paths.LANDING;
  static const LOGIN = _Paths.LOGIN;
  static const MAIN_NAV = _Paths.MAIN_NAV;

  static const HOME = '$MAIN_NAV${_Paths.HOME}'; // '/main-nav/home'
  static const ATTENDANCE = '$MAIN_NAV${_Paths.ATTENDANCE}';
  static const PROFILE = '$MAIN_NAV${_Paths.PROFILE}';

  static const TRANSACTION_SUCCESS = '$HOME${_Paths.TRANSACTION_SUCCESS}';

  static const SALES_REPORT = _Paths.SALES_REPORT;
  static const ATTENDANCE_REPORT = _Paths.ATTENDANCE_REPORT;
  static const DEPOSIT_REPORT = _Paths.DEPOSIT_REPORT;
  static const CHECKOUT = _Paths.CHECKOUT;
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/home';
  static const LANDING = '/';
  static const LOGIN = '/login';
  static const ATTENDANCE = '/attendance';
  static const PROFILE = '/profile';
  static const SALES_REPORT = '/sales-report';
  static const ATTENDANCE_REPORT = '/attendance-report';
  static const DEPOSIT_REPORT = '/deposit-report';
  static const CHECKOUT = '/checkout';
  static const TRANSACTION_SUCCESS = '/transaction-success';
  static const MAIN_NAV = '/main-nav';
}
