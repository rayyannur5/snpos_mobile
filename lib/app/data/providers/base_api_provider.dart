import 'package:get/get.dart';

class BaseApiProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = 'https://fit-vaguely-sloth.ngrok-free.app/api';
    httpClient.defaultContentType = 'application/json';
    httpClient.timeout = const Duration(seconds: 10);

    super.onInit();
  }
}