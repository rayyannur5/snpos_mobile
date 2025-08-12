import 'package:get/get.dart';
import 'package:snpos/app/data/providers/base_api_provider.dart';

class LoginProvider extends BaseApiProvider {


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
