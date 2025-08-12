import 'package:get/get.dart';

class DetailAbsensiProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = 'http://10.0.2.2:8000/api';
    httpClient.defaultContentType = 'application/json';
    httpClient.timeout = const Duration(seconds: 10);
  }

  Future<Response> detailAttendance(String token, String id) async {
    return get('/attendance/$id', headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'});
  }

}
