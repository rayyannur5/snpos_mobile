import 'dart:io';

import 'package:get/get.dart';
import 'package:snpos/app/data/providers/base_api_provider.dart';

class AttendanceProvider extends BaseApiProvider {

  Future<Response> fetchSchedule(String token) async {
    Response response = await get(
      '/attendance/schedule',
      headers: {'Authorization': 'Bearer $token'},
    );
    return createResponse(response);
  }

  Future<Response> fetchOutlets(String token) async {
    Response response = await get(
      '/attendance/outlets',
      headers: {'Authorization': 'Bearer $token'},
    );
    return createResponse(response);
  }

  Future<Response> updateUserData(String token) async {
    Response response = await get(
      '/attendance',
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    return createResponse(response);
  }

  Future<Response> sendAttendance({
    scheduleId,
    latitude,
    longitude,
    namedLocation,
    path,
    token,
    outletId,
    shiftId
  }) async {
    final imageFile = File(path); // ambil file dari path
    final fileName = imageFile.path.split('/').last; // nama file

    final form = FormData({
      'scheduleId': scheduleId,
      'latitude': latitude,
      'longitude': longitude,
      'namedLocation': namedLocation,
      'outletId': outletId,
      'shiftId': shiftId,
      'photo': MultipartFile(
        imageFile,
        filename: fileName,
      ),
    });

    Response response = await post(
      '/attendance',
      form,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    return createResponse(response);
  }

  Future<Response> sendExitAttendance({
    attendanceId,
    latitude,
    longitude,
    namedLocation,
    path,
    token,
  }) async {
    final imageFile = File(path); // ambil file dari path
    final fileName = imageFile.path.split('/').last; // nama file

    final form = FormData({
      'attendanceId': attendanceId,
      'latitude': latitude,
      'longitude': longitude,
      'namedLocation': namedLocation,
      'photo': MultipartFile(
        imageFile,
        filename: fileName,
      ),
    });

    Response response = await post(
      '/attendance/exit',
      form,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    return createResponse(response);
  }

  Future<Response> getTransactionNotDepositYet(String token) async {
    Response response = await get(
      '/attendance/summary',
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    return createResponse(response);
  }

  Future<Response> getAttendanceToday({token}) async {
    Response response = await get(
      '/attendance/today',
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    return createResponse(response);
  }

  Future<Response> deposit(String token, String remarks) async {
    Response response = await post(
      '/attendance/deposit',
      {'remarks': remarks},
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    return createResponse(response);
  }


}
