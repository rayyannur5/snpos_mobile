import 'package:get/get.dart';
import 'package:snpos/app/data/providers/base_api_provider.dart';

class LoginProvider extends BaseApiProvider {


  Future<Response> login(String username, String password) async {
    Response response = await post(
        '/login',
        {'username': username, 'password': password},
        headers: { 'Accept': 'application/json'  },
    );

    return createResponse(response);
  }

  Future<Response> getProfile(String token) async {
    Response response = await get(
      '/profile',
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json'
      },
    );
    return createResponse(response);
  }

  Future<Response> logout(String token) async {
    Response response = await post(
      '/logout',
      {},
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    return createResponse(response);
  }
}
