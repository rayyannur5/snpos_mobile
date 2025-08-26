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

  static const ATTENDANCE_CAMERA = ATTENDANCE + _Paths.ATTENDANCE_CAMERA;
  static const ATTENDANCE_TRANSACTION =
      ATTENDANCE + _Paths.ATTENDANCE_TRANSACTION;

  static const CREATE_DEPOSIT = ATTENDANCE + _Paths.CREATE_DEPOSIT;

  static const SALES_REPORT = PROFILE + _Paths.SALES_REPORT;
  static const ATTENDANCE_REPORT = PROFILE + _Paths.ATTENDANCE_REPORT;
  static const DEPOSIT_REPORT = PROFILE + _Paths.DEPOSIT_REPORT;
  static const SCHEDULE_INFORMATION = PROFILE + _Paths.SCHEDULE_INFORMATION;
  static const CHANGE_PASSWORD = PROFILE + _Paths.CHANGE_PASSWORD;
  static const OVERTIME_APPLICATION = PROFILE + _Paths.OVERTIME_APPLICATION;

  static const CAMERA_PICKER = _Paths.CAMERA_PICKER;
  static const DETAIL_ABSENSI = _Paths.DETAIL_ABSENSI;
  static const ITEM_REQUESTS = _Paths.ITEM_REQUESTS;

  static const MAINTENANCE = _Paths.MAINTENANCE;
  static const MAINTENANCE_REQUEST = MAINTENANCE + _Paths.MAINTENANCE_REQUEST;
  static const FORM_ITEM_REQUEST =
      _Paths.ITEM_REQUESTS + _Paths.FORM_ITEM_REQUEST;
  static const LEAVE_REQUEST = _Paths.LEAVE_REQUEST;
  static const FORM_LEAVE_REQUEST =
      _Paths.LEAVE_REQUEST + _Paths.FORM_LEAVE_REQUEST;
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
  static const TRANSACTION_SUCCESS = '/transaction-success';
  static const MAIN_NAV = '/main-nav';
  static const ATTENDANCE_CAMERA = '/attendance-camera';
  static const ATTENDANCE_TRANSACTION = '/attendance-transaction';
  static const CREATE_DEPOSIT = '/create-deposit';
  static const SCHEDULE_INFORMATION = '/schedule-information';
  static const CHANGE_PASSWORD = '/change-password';
  static const CAMERA_PICKER = '/camera-picker';
  static const DETAIL_ABSENSI = '/detail-absensi';
  static const OVERTIME_APPLICATION = '/overtime-application';
  static const MAINTENANCE_REQUEST = '/maintenance-request';
  static const MAINTENANCE = '/maintenance';
  static const ITEM_REQUESTS = '/item-requests';
  static const FORM_ITEM_REQUEST = '/form-item-request';
  static const LEAVE_REQUEST = '/absen-request';
  static const FORM_LEAVE_REQUEST = '/form-absen-request';
}
