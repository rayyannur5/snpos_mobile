import 'dart:io';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:snpos/app/data/providers/base_api_provider.dart';

class LeaveRequestProvider extends BaseApiProvider {
  Future<Response> getRequests(token) async {
    Response response = await get('/leave/lists', headers: {'Authorization': 'Bearer $token'});
    return createResponse(response);
  }

  Future<Response> getOperators(token) async {
    Response response = await get('/leave/operators', headers: {'Authorization': 'Bearer $token'});
    return createResponse(response);
  }
  Future<Response> submitLeave({
    required int operatorId,
    required int categoryId,
    required DateTime startDate,
    required DateTime endDate,
    required String remarks,
    required String token,
    File? file,
  }) async {
    final form = FormData({
      "user_id": operatorId.toString(),
      "start_date": startDate.toIso8601String(),
      "end_date": endDate.toIso8601String(),
      "category_id": categoryId.toString(),
      "remarks": remarks,
    });

    if (file != null) {
      final ext = file.path.split(".").last;

      var box = GetStorage();
      var user = box.read('user');
      String name = 'CAP-${user['id']}-${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}.${ext}';

      form.files.add(
        MapEntry(
          "attachment",
          MultipartFile(file, filename: name),
        ),
      );
    }

    final response = await post("/leave/create", form, headers: {'Authorization': 'Bearer $token'});
    return createResponse(response);
  }

}
