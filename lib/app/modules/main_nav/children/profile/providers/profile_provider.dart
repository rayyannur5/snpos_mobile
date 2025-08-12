import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:snpos/app/data/providers/base_api_provider.dart';

class ProfileProvider extends BaseApiProvider {

  Future<Response> logout(String token) {
    return post('/logout', {}, headers: {'Authorization': 'Bearer $token'});
  }

  Future<Response> summarySalesReport(DateTime start, DateTime end, token) async {
    return get(
      '/report/sales/summary',
      query: {'start_date': DateFormat('yyyy-MM-dd').format(start), 'end_date': DateFormat('yyyy-MM-dd').format(end)},
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  Future<Response> fetchSalesReport(DateTime start, DateTime end, String token) async {
    return get(
      '/report/sales',
      query: {'start_date': DateFormat('yyyy-MM-dd').format(start), 'end_date': DateFormat('yyyy-MM-dd').format(end)},
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  Future<Response> summaryAttendances(DateTime start, DateTime end, String token) async {
    return get(
      '/report/attendances/summary',
      query: {'start_date': DateFormat('yyyy-MM-dd').format(start), 'end_date': DateFormat('yyyy-MM-dd').format(end)},
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  Future<Response> fetchAttendances(DateTime start, DateTime end, String token) async {
    return get(
      '/report/attendances',
      query: {'start_date': DateFormat('yyyy-MM-dd').format(start), 'end_date': DateFormat('yyyy-MM-dd').format(end)},
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  Future<Response> summaryDeposits(DateTime start, DateTime end, String token) async {
    return get(
      '/report/deposit/summary',
      query: {'start_date': DateFormat('yyyy-MM-dd').format(start), 'end_date': DateFormat('yyyy-MM-dd').format(end)},
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  Future<Response> fetchDeposits(DateTime start, DateTime end, String token) async {
    return get(
      '/report/deposit',
      query: {'start_date': DateFormat('yyyy-MM-dd').format(start), 'end_date': DateFormat('yyyy-MM-dd').format(end)},
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  Future<Response> fetchSchedule(DateTime start, DateTime end, String token) async {
    return get(
      '/report/schedules',
      query: {'start_date': DateFormat('yyyy-MM-dd').format(start), 'end_date': DateFormat('yyyy-MM-dd').format(end)},
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  Future<Response> changePassword(String old_password, String new_password, String token) async {
    return post(
      '/change_password',
      {
        'old_password': old_password,
        'new_password': new_password,
      },
      headers: {'Authorization': 'Bearer $token'},
    );
  }
}
