import 'dart:io';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:snpos/app/data/providers/base_api_provider.dart';

class ProfileProvider extends BaseApiProvider {

  Future<Response> logout(String token) async {
    Response response = await post('/logout', {}, headers: {'Authorization': 'Bearer $token'});

    return createResponse(response);
  }

  Future<Response> summarySalesReport(DateTime start, DateTime end, token) async {
    Response response = await get(
      '/report/sales/summary',
      query: {'start_date': DateFormat('yyyy-MM-dd').format(start), 'end_date': DateFormat('yyyy-MM-dd').format(end)},
      headers: {'Authorization': 'Bearer $token'},
    );

    return createResponse(response);
  }

  Future<Response> fetchSalesReport(DateTime start, DateTime end, String token) async {
    Response response = await get(
      '/report/sales',
      query: {'start_date': DateFormat('yyyy-MM-dd').format(start), 'end_date': DateFormat('yyyy-MM-dd').format(end)},
      headers: {'Authorization': 'Bearer $token'},
    );

    return createResponse(response);
  }

  Future<Response> summaryAttendances(DateTime start, DateTime end, String token) async {
    Response response = await get(
      '/report/attendances/summary',
      query: {'start_date': DateFormat('yyyy-MM-dd').format(start), 'end_date': DateFormat('yyyy-MM-dd').format(end)},
      headers: {'Authorization': 'Bearer $token'},
    );

    return createResponse(response);
  }

  Future<Response> fetchAttendances(DateTime start, DateTime end, String token) async {
    Response response = await get(
      '/report/attendances',
      query: {'start_date': DateFormat('yyyy-MM-dd').format(start), 'end_date': DateFormat('yyyy-MM-dd').format(end)},
      headers: {'Authorization': 'Bearer $token'},
    );

    return createResponse(response);
  }

  Future<Response> summaryDeposits(DateTime start, DateTime end, String token) async {
    Response response = await get(
      '/report/deposit/summary',
      query: {'start_date': DateFormat('yyyy-MM-dd').format(start), 'end_date': DateFormat('yyyy-MM-dd').format(end)},
      headers: {'Authorization': 'Bearer $token'},
    );

    return createResponse(response);
  }

  Future<Response> fetchDeposits(DateTime start, DateTime end, String token) async {
    Response response = await get(
      '/report/deposit',
      query: {'start_date': DateFormat('yyyy-MM-dd').format(start), 'end_date': DateFormat('yyyy-MM-dd').format(end)},
      headers: {'Authorization': 'Bearer $token'},
    );

    return createResponse(response);
  }

  Future<Response> fetchSchedule(DateTime start, DateTime end, String token) async {
    Response response = await get(
      '/report/schedules',
      query: {'start_date': DateFormat('yyyy-MM-dd').format(start), 'end_date': DateFormat('yyyy-MM-dd').format(end)},
      headers: {'Authorization': 'Bearer $token'},
    );

    return createResponse(response);

  }

  Future<Response> changePassword(String old_password, String new_password, String token) async {
    Response response = await post(
      '/change_password',
      {
        'old_password': old_password,
        'new_password': new_password,
      },
      headers: {'Authorization': 'Bearer $token'},
    );

    return createResponse(response);
  }

  Future<Response> getOperatorsAndShift(String token) async {
    Response response = await get('/overtime/operators-and-shift', headers: {'Authorization': 'Bearer $token'});
    return createResponse(response);
  }

  Future<Response> submitOvertime(data, String token) async {

    Response response = await post(
        '/overtime/create',
        data,
        headers: {'Authorization': 'Bearer $token'},
    );
    return createResponse(response);

  }

  Future<Response> getMaintenanceRequest(String token) async {
    Response response = await get('/maintenance/items_and_outlets', headers: {'Authorization': 'Bearer $token'});
    return createResponse(response);
  }

  Future<Response> submitMaintenanceRequest(String token, int item_id, int outlet_id, String note, String? image) async {

    var form = {
      'item_id': item_id,
      'outlet_id': outlet_id,
      'note': note,
    };

    if (image != null) {
      final imageFile = File(image);
      final fileName = imageFile.path.split('/').last;
      form['image'] = MultipartFile(
        imageFile,
        filename: fileName,
      );
    }

    final data = FormData(form);

    Response response = await post(
      '/maintenance/create',
      data,
      headers: {'Authorization': 'Bearer $token'},
    );
    return createResponse(response);
  }

  Future<Response> getMaintenanceJobs(String token) async {
    Response response = await get('/maintenance/maintenance_jobs', headers: {'Authorization': 'Bearer $token'});
    return createResponse(response);
  }

  Future<Response> submitMaintenance(int id, String token) async {
    Response response = await post(
      '/maintenance/assign',
      { 'id': id },
      headers: {'Authorization': 'Bearer $token'},
    );
    return createResponse(response);
  }

}
