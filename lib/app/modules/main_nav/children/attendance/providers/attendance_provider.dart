import 'dart:io';

import 'package:get/get.dart';
import 'package:snpos/app/data/providers/base_api_provider.dart';

class AttendanceProvider extends BaseApiProvider {

  Future<Response> fetchSchedule(String token) {
    return get('/attendance/schedule', headers: {'Authorization': 'Bearer $token'});
  }

  Future<Response> updateUserData(String token) => get('/attendance', headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'});

  Future<Response> sendAttendance({scheduleId, latitude, longitude, namedLocation, path, token}) async {
    final imageFile = File(path); // ambil file dari path
    final fileName = imageFile.path.split('/').last; // nama file

    final form = FormData({
      'scheduleId': scheduleId,
      'latitude': latitude,
      'longitude': longitude,
      'namedLocation': namedLocation,
      'photo': MultipartFile(
        imageFile,
        filename: fileName,
      ),
    });

    return post('/attendance',  form, headers: { 'Authorization': 'Bearer $token', 'Accept': 'application/json' } );

  }

  Future<Response> sendExitAttendance({attendanceId, latitude, longitude, namedLocation, path, token}) async {
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

    return post('/attendance/exit',  form, headers: { 'Authorization': 'Bearer $token', 'Accept': 'application/json' } );

  }

  Future<Response> getTransactionNotDepositYet (String token) async {
    return get('/attendance/summary', headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'});
  }

  Future<Response> getAttendanceToday ({token}) async {
    return get('/attendance/today', headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'});
  }

  Future<Response> deposit (String token, String remarks) async {
    return post('/attendance/deposit', { 'remarks' : remarks }, headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'});
  }

}
