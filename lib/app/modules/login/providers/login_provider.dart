import 'package:get/get.dart';

class LoginProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = 'http://10.0.2.2:8000/api';
    httpClient.defaultContentType = 'application/json';
    httpClient.timeout = const Duration(seconds: 10);
    super.onInit();
  }


  Future<Response> login(String username, String password) {
    return post(
        '/login',
        {'username': username, 'password': password},
        headers: { 'Accept': 'application/json'  },
    );
  }

  Future<Response> getProfile(String token) {
    return get('/profile', headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json'
    });
  }

  Future<Response> logout(String token) {
    return post('/logout', {}, headers: {
      'Authorization': 'Bearer $token',
    });
  }

}
