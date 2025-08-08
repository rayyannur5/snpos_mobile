import 'dart:io';

import 'package:get/get.dart';

class AttendanceProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = 'http://10.0.2.2:8000/api';
    httpClient.defaultContentType = 'application/json';
    httpClient.timeout = const Duration(seconds: 10);
  }

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

  Future<Response> getTransactionNotDepositYet () async {
    await Future.delayed(const Duration(seconds: 1));
    return Response(
        statusCode: 200,
        body: {
          'message': 'success',
          'data' : {
            'totalAmount' : 3000000,
            'items': [
              {
                'productId': 1,
                'productName': 'Service Rutin',
                'qty': 10,
                'price': 100000,
                'totalAmount': 1000000
              },
              {
                'productId': 2,
                'productName': 'Ganti Oli',
                'qty': 20,
                'price': 50000,
                'totalAmount': 1000000
              },
              {
                'productId': 3,
                'productName': 'Ganti Ban',
                'qty': 5,
                'price': 200000,
                'totalAmount': 1000000
              }
            ]
          },
        }
    );
  }

  Future<Response> deposit () async {
    await Future.delayed(const Duration(seconds: 1));
    return Response(
        statusCode: 200,
        body: {
          'message': 'success',
        }
    );
  }

}
